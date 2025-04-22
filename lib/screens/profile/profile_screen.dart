import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/profile_provider.dart';
import '../../../data/models/profile_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<Color> avatarColors = const [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.brown,
    Colors.teal,
  ];

  Future<void> _addProfile(BuildContext context) async {
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Новый профиль'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Имя профиля'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final profile = Provider.of<ProfileProvider>(context, listen: false)
                      .addProfile(nameController.text);
                  Provider.of<ProfileProvider>(context, listen: false)
                      .switchProfile(profile);
                  Navigator.pop(context);
                }
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }

  Color _getColorForProfile(Profile profile, List<Profile> allProfiles) {
    final index = allProfiles.indexOf(profile) % avatarColors.length;
    return avatarColors[index];
  }

  Future<void> _deleteProfile(BuildContext context, Profile profile) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Удалить профиль'),
          content: const Text('Вы уверены, что хотите удалить этот профиль?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      Provider.of<ProfileProvider>(context, listen: false).deleteProfile(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profiles = profileProvider.profiles;
    final active = profileProvider.activeProfile;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: active == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Нет активного профиля'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _addProfile(context),
                child: const Text('Создать профиль'),
              ),
            ],
          )
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor:
                        _getColorForProfile(active, profiles),
                        child: const Icon(Icons.person,
                            size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        active.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Сменить профиль',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addProfile(context),
                    ),
                  ],
                ),
                ...profiles.map((p) {
                  final isSelected = p.id == active.id;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColorForProfile(p, profiles),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(p.name),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.teal)
                        : null,
                    onTap: () => profileProvider.switchProfile(p),
                    onLongPress: () => _deleteProfile(context, p), // Удаление профиля по долгому нажатию
                  );
                }).toList(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
