import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/invitation.dart';
import '../../domain/repositories/invitation_repository.dart';

class SupabaseInvitationRepository implements InvitationRepository {
  SupabaseInvitationRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _table = 'invitations';

  @override
  Future<List<Invitation>> fetchByChildId(String childId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('child_id', childId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_mapInvitation)
        .toList();
  }

  @override
  Future<Invitation> save(Invitation invitation) async {
    final response = await _client
        .from(_table)
        .upsert(<String, dynamic>{
          'id': invitation.id,
          'child_id': invitation.childId,
          'invited_user_id': invitation.invitedUserId,
          'created_at': invitation.createdAt.toIso8601String(),
        }, onConflict: 'id')
        .select()
        .single();

    return _mapInvitation(response);
  }

  Invitation _mapInvitation(Map<String, dynamic> data) {
    return Invitation(
      id: data['id'] as String,
      childId: data['child_id'] as String,
      invitedUserId: data['invited_user_id'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
