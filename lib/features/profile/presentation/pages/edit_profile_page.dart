import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/profile_entity.dart';
import '../state/profile_notifier.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameCtrl;
  late TextEditingController usernameCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.profile.name);
    usernameCtrl = TextEditingController(text: widget.profile.username ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<ProfileNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final updated = ProfileEntity(
                  uid: widget.profile.uid,
                  name: nameCtrl.text,
                  email: widget.profile.email,
                  avatarUrl: widget.profile.avatarUrl,
                  username: usernameCtrl.text,
                );

                await notifier.updateProfile(updated);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
