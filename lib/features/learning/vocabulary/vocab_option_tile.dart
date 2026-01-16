import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VocabOptionTile extends StatefulWidget {
  final String text;
  final bool isCorrect;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const VocabOptionTile({
    super.key,
    required this.text,
    required this.isCorrect,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<VocabOptionTile> createState() => _VocabOptionTileState();
}

class _VocabOptionTileState extends State<VocabOptionTile>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color border = Colors.transparent;
    IconData? icon;

    if (widget.isSelected) {
      if (widget.isCorrect) {
        bg = const Color(0xFFD9FFE7);
        border = const Color(0xFF4CD964);
        icon = Icons.check_circle;
      } else {
        bg = const Color(0xFFFFE5E5);
        border = const Color(0xFFFF3B30);
        icon = Icons.cancel;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 2),
      ),
      child: InkWell(
        onTap: widget.enabled ? _onTap : null,
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, color: border, size: 24),
            if (icon != null) const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    HapticFeedback.mediumImpact();
    widget.onTap();
  }
}
