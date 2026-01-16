import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback onEdit;

  const AvatarWidget({
    super.key,
    required this.avatarUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.purple.shade100,
          backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
          child: !hasAvatar
              ? const Icon(Icons.person, size: 50, color: Colors.white)
              : null,
        ),

        // Nút chỉnh sửa avatar
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onEdit,
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.edit,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
