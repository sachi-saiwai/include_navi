import '../models/invitation.dart';

abstract class InvitationRepository {
  Future<List<Invitation>> fetchByChildId(String childId);

  Future<Invitation> save(Invitation invitation);
}
