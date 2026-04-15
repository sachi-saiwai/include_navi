import '../../domain/models/child_profile.dart';
import '../../domain/repositories/child_profile_repository.dart';

class InMemoryChildProfileRepository implements ChildProfileRepository {
  final Map<String, ChildProfile> _store = <String, ChildProfile>{};

  @override
  Future<List<ChildProfile>> fetchByOwnerUserId(String ownerUserId) async {
    final items = _store.values
        .where((profile) => profile.ownerUserId == ownerUserId)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  @override
  Future<ChildProfile?> findById(String id) async => _store[id];

  @override
  Future<ChildProfile> save(ChildProfile profile) async {
    _store[profile.id] = profile;
    return profile;
  }
}
