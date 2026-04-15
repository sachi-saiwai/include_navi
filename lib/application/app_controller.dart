import 'package:flutter/foundation.dart';

import '../domain/models/app_user.dart';
import '../domain/models/child_profile.dart';
import '../domain/models/invitation.dart';
import '../domain/models/pdf_export.dart';
import '../domain/models/record_entry.dart';
import '../domain/models/record_field_value.dart';
import '../domain/repositories/child_profile_repository.dart';
import '../domain/repositories/invitation_repository.dart';
import '../domain/repositories/record_repository.dart';
import '../domain/services/auth_gateway.dart';
import '../domain/services/pdf_export_service.dart';

class AppController extends ChangeNotifier {
  AppController({
    required AuthGateway authGateway,
    required ChildProfileRepository childProfileRepository,
    required RecordRepository recordRepository,
    required InvitationRepository invitationRepository,
    required PdfExportService pdfExportService,
  })  : _authGateway = authGateway,
        _childProfileRepository = childProfileRepository,
        _recordRepository = recordRepository,
        _invitationRepository = invitationRepository,
        _pdfExportService = pdfExportService;

  final AuthGateway _authGateway;
  final ChildProfileRepository _childProfileRepository;
  final RecordRepository _recordRepository;
  final InvitationRepository _invitationRepository;
  final PdfExportService _pdfExportService;

  AppUser? currentUser;
  List<ChildProfile> childProfiles = const <ChildProfile>[];
  ChildProfile? selectedChild;
  List<RecordEntry> selectedChildRecords = const <RecordEntry>[];
  List<Invitation> selectedChildInvitations = const <Invitation>[];
  PdfExport? latestPdfExport;
  bool isBusy = false;
  String? infoMessage;
  String? errorMessage;

  Future<void> bootstrap() async {
    await _runBusyTask(() async {
      currentUser = await _authGateway.restoreCurrentUser();
      await _reloadChildProfiles();
      if (selectedChild != null) {
        await _loadSelectedChildRelatedData();
      }
    }, notifyAtStart: false);
  }

  Future<void> signInWithGoogle() async {
    await _runBusyTask(() async {
      currentUser = await _authGateway.signInWithGoogle();
      await _reloadChildProfiles();
      if (currentUser?.id == 'local-demo-parent') {
        infoMessage = 'Supabase未設定のため、開発用の demo ユーザーでログインしました。';
      }
    });
  }

  Future<void> signOut() async {
    await _runBusyTask(() async {
      await _authGateway.signOut();
      currentUser = null;
      childProfiles = const <ChildProfile>[];
      selectedChild = null;
      selectedChildRecords = const <RecordEntry>[];
      selectedChildInvitations = const <Invitation>[];
      latestPdfExport = null;
      infoMessage = null;
    });
  }

  Future<void> loadChildProfiles() async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    await _runBusyTask(() async {
      await _reloadChildProfiles();
    }, notifyAtStart: false);
  }

  Future<void> selectChild(String childId) async {
    await _runBusyTask(() async {
      selectedChild = await _childProfileRepository.findById(childId);
      await _loadSelectedChildRelatedData();
    });
  }

  Future<void> saveChildProfile({
    required String nickname,
    required String traitsMemo,
    String? id,
  }) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    final now = DateTime.now();
    final child = ChildProfile(
      id: id ?? 'child-${now.microsecondsSinceEpoch}',
      ownerUserId: user.id,
      nickname: nickname,
      traitsMemo: traitsMemo,
      createdAt: id == null ? now : (await _childProfileRepository.findById(id))?.createdAt ?? now,
      updatedAt: now,
    );

    await _runBusyTask(() async {
      await _childProfileRepository.save(child);
      await _reloadChildProfiles();
      selectedChild = child;
      await _loadSelectedChildRelatedData();
      infoMessage = '子どもプロフィールを保存しました。';
    }, notifyAtStart: false);
  }

  Future<void> saveRecord({
    String? id,
    required DateTime date,
    required RecordFieldValue condition,
    required RecordFieldValue trouble,
    required RecordFieldValue trigger,
    required RecordFieldValue after,
  }) async {
    final child = selectedChild;
    if (child == null) {
      return;
    }

    final now = DateTime.now();
    final existing = id == null ? null : await _recordRepository.findById(id);
    final record = RecordEntry(
      id: id ?? 'record-${now.microsecondsSinceEpoch}',
      childId: child.id,
      date: date,
      condition: condition,
      trouble: trouble,
      trigger: trigger,
      after: after,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await _runBusyTask(() async {
      await _recordRepository.save(record);
      await _loadSelectedChildRelatedData();
      infoMessage = '記録を保存しました。';
    }, notifyAtStart: false);
  }

  Future<void> saveInvitation({
    required String invitedUserId,
  }) async {
    final child = selectedChild;
    if (child == null) {
      return;
    }

    final invitation = Invitation(
      id: 'invite-${DateTime.now().microsecondsSinceEpoch}',
      childId: child.id,
      invitedUserId: invitedUserId,
      createdAt: DateTime.now(),
    );

    await _runBusyTask(() async {
      await _invitationRepository.save(invitation);
      selectedChildInvitations = await _invitationRepository.fetchByChildId(child.id);
      infoMessage = '招待情報を保存しました。';
    }, notifyAtStart: false);
  }

  Future<void> exportPdf() async {
    final user = currentUser;
    final child = selectedChild;
    if (user == null || child == null) {
      return;
    }

    await _runBusyTask(() async {
      latestPdfExport = await _pdfExportService.exportChildRecords(
        createdBy: user,
        child: child,
        records: selectedChildRecords,
      );
      infoMessage = 'PDFデータを生成しました。保存先や共有方法は未定のため、このMVPではメモリ上に保持しています。';
    });
  }

  RecordEntry? findRecordById(String recordId) {
    for (final record in selectedChildRecords) {
      if (record.id == recordId) {
        return record;
      }
    }
    return null;
  }

  Future<void> _loadSelectedChildRelatedData() async {
    final child = selectedChild;
    if (child == null) {
      selectedChildRecords = const <RecordEntry>[];
      selectedChildInvitations = const <Invitation>[];
      return;
    }

    selectedChildRecords = await _recordRepository.fetchByChildId(child.id);
    selectedChildInvitations = await _invitationRepository.fetchByChildId(child.id);
  }

  Future<void> _reloadChildProfiles() async {
    final user = currentUser;
    if (user == null) {
      childProfiles = const <ChildProfile>[];
      selectedChild = null;
      return;
    }

    childProfiles = await _childProfileRepository.fetchByOwnerUserId(user.id);
    final currentSelectedChildId = selectedChild?.id;
    if (currentSelectedChildId == null) {
      return;
    }

    ChildProfile? nextSelectedChild;
    for (final child in childProfiles) {
      if (child.id == currentSelectedChildId) {
        nextSelectedChild = child;
        break;
      }
    }
    selectedChild = nextSelectedChild;
  }

  Future<void> _runBusyTask(
    Future<void> Function() action, {
    bool notifyAtStart = true,
  }) async {
    isBusy = true;
    errorMessage = null;
    if (notifyAtStart) {
      notifyListeners();
    }

    try {
      await action();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    infoMessage = null;
    errorMessage = null;
    notifyListeners();
  }
}
