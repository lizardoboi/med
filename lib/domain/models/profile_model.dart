class Profile {
  final String id;
  final String name;
  final String? avatarPath; // локальный путь к изображению
  final List<String> medicineIds;

  Profile({
    required this.id,
    required this.name,
    this.avatarPath,
    this.medicineIds = const [],
  });

  Profile copyWith({
    String? name,
    String? avatarPath,
    List<String>? medicineIds,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      medicineIds: medicineIds ?? this.medicineIds,
    );
  }
}
