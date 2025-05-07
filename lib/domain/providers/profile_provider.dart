import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  late final Box<Profile> _box;
  Profile? _activeProfile;

  ProfileProvider() {
    _box = Hive.box<Profile>('profiles');
    _activeProfile = _box.values.isNotEmpty ? _box.values.first : null;
  }

  List<Profile> get profiles => _box.values.toList();
  Profile? get activeProfile => _activeProfile;

  Profile addProfile(String name, {String? avatarPath}) {
    final newProfile = Profile(id: const Uuid().v4(), name: name, avatarPath: avatarPath);
    _box.add(newProfile);
    _activeProfile = newProfile;
    notifyListeners();
    return newProfile;
  }

  void switchProfile(Profile profile) {
    _activeProfile = profile;
    notifyListeners();
  }

  void deleteProfile(Profile profile) {
    final key = _box.keys.firstWhere((k) => _box.get(k)?.id == profile.id, orElse: () => null);
    if (key != null) {
      _box.delete(key);
      if (_activeProfile?.id == profile.id) {
        _activeProfile = _box.values.isNotEmpty ? _box.values.first : null;
      }
      notifyListeners();
    }
  }
}