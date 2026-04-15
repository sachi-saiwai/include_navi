class Invitation {
  const Invitation({
    required this.id,
    required this.childId,
    required this.invitedUserId,
    required this.createdAt,
  });

  final String id;
  final String childId;
  final String invitedUserId;
  final DateTime createdAt;
}
