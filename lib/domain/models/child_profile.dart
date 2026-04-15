class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.ownerUserId,
    required this.nickname,
    required this.traitsMemo,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String ownerUserId;
  final String nickname;
  final String traitsMemo;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChildProfile copyWith({
    String? id,
    String? ownerUserId,
    String? nickname,
    String? traitsMemo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      nickname: nickname ?? this.nickname,
      traitsMemo: traitsMemo ?? this.traitsMemo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
