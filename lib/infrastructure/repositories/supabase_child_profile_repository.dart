import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/child_profile.dart';
import '../../domain/repositories/child_profile_repository.dart';

class SupabaseChildProfileRepository implements ChildProfileRepository {
  SupabaseChildProfileRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _table = 'child_profiles';

  @override
  Future<List<ChildProfile>> fetchByOwnerUserId(String ownerUserId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('owner_user_id', ownerUserId)
        .order('created_at', ascending: true);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_mapChildProfile)
        .toList();
  }

  @override
  Future<ChildProfile?> findById(String id) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return _mapChildProfile(response);
  }

  @override
  Future<ChildProfile> save(ChildProfile profile) async {
    final response = await _client
        .from(_table)
        .upsert(<String, dynamic>{
          'id': profile.id,
          'owner_user_id': profile.ownerUserId,
          'nickname': profile.nickname,
          'traits_memo': profile.traitsMemo,
          'created_at': profile.createdAt.toIso8601String(),
          'updated_at': profile.updatedAt.toIso8601String(),
        }, onConflict: 'id')
        .select()
        .single();

    return _mapChildProfile(response);
  }

  ChildProfile _mapChildProfile(Map<String, dynamic> data) {
    return ChildProfile(
      id: data['id'] as String,
      ownerUserId: data['owner_user_id'] as String,
      nickname: data['nickname'] as String? ?? '',
      traitsMemo: data['traits_memo'] as String? ?? '',
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }
}
