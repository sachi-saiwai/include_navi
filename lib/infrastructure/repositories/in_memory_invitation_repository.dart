import '../../domain/models/invitation.dart';
import '../../domain/repositories/invitation_repository.dart';

class InMemoryInvitationRepository implements InvitationRepository {
  final Map<String, Invitation> _store = <String, Invitation>{};

  @override
  Future<List<Invitation>> fetchByChildId(String childId) async {
    final items = _store.values
        .where((invitation) => invitation.childId == childId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<Invitation> save(Invitation invitation) async {
    _store[invitation.id] = invitation;
    return invitation;
  }
}
