import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  final List<Profile> _profiles = [];
  Profile? _activeProfile;

  List<Profile> get profiles => _profiles;
  Profile? get activeProfile => _activeProfile;

  // Добавление нового профиля
  Profile addProfile(String name, {String? avatarPath}) {
    final newProfile = Profile(id: const Uuid().v4(), name: name, avatarPath: avatarPath);
    _profiles.add(newProfile);
    _activeProfile = newProfile; // Сразу активируем новый профиль
    notifyListeners();
    return newProfile;
  }

  // Переключение на другой профиль
  void switchProfile(Profile profile) {
    _activeProfile = profile;
    notifyListeners();
  }

  // Удаление профиля
  void deleteProfile(Profile profile) {
    _profiles.remove(profile);

    // Если удаляемый профиль был активным, делаем новый активным
    if (_activeProfile == profile) {
      _activeProfile = _profiles.isNotEmpty ? _profiles.first : null;
    }

    // Уведомляем слушателей, что состояние изменилось
    notifyListeners();
  }
}
