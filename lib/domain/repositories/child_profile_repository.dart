import '../models/child_profile.dart';

abstract class ChildProfileRepository {
  Future<List<ChildProfile>> fetchByOwnerUserId(String ownerUserId);

  Future<ChildProfile?> findById(String id);

  Future<ChildProfile> save(ChildProfile profile);
}
