import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 2)
class Profile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? avatarPath; // путь к изображению

  @HiveField(3)
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