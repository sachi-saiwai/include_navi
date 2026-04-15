import '../application/app_controller.dart';
import '../domain/repositories/child_profile_repository.dart';
import '../domain/repositories/invitation_repository.dart';
import '../domain/repositories/record_repository.dart';
import '../domain/services/auth_gateway.dart';
import '../domain/services/pdf_export_service.dart';
import '../infrastructure/adapters/basic_pdf_export_service.dart';
import '../infrastructure/adapters/supabase_google_auth_gateway.dart';
import '../infrastructure/repositories/in_memory_child_profile_repository.dart';
import '../infrastructure/repositories/in_memory_invitation_repository.dart';
import '../infrastructure/repositories/in_memory_record_repository.dart';

class AppDependencies {
  AppDependencies({
    required this.authGateway,
    required this.childProfileRepository,
    required this.recordRepository,
    required this.invitationRepository,
    required this.pdfExportService,
  });

  final AuthGateway authGateway;
  final ChildProfileRepository childProfileRepository;
  final RecordRepository recordRepository;
  final InvitationRepository invitationRepository;
  final PdfExportService pdfExportService;

  factory AppDependencies.build() {
    return AppDependencies(
      authGateway: SupabaseGoogleAuthGateway(),
      childProfileRepository: InMemoryChildProfileRepository(),
      recordRepository: InMemoryRecordRepository(),
      invitationRepository: InMemoryInvitationRepository(),
      pdfExportService: BasicPdfExportService(),
    );
  }

  AppController createController() {
    return AppController(
      authGateway: authGateway,
      childProfileRepository: childProfileRepository,
      recordRepository: recordRepository,
      invitationRepository: invitationRepository,
      pdfExportService: pdfExportService,
    );
  }
}
