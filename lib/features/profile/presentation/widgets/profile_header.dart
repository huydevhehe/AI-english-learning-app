import 'package:flutter/material.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          profile.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(profile.email),
        if (profile.username != null)
          Text("@${profile.username}", style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
