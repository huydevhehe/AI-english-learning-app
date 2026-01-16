import 'package:flutter/material.dart';

class SkipWarningBox extends StatelessWidget {
  final int skipped;
  final VoidCallback onFix;
  final VoidCallback onSkip;

  const SkipWarningBox({
    required this.skipped,
    required this.onFix,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Có $skipped câu sai định dạng.',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(onPressed: onFix, child: const Text('Sửa lại')),
              const Spacer(),
              ElevatedButton(onPressed: onSkip, child: const Text('Bỏ qua')),
            ],
          ),
        ],
      ),
    );
  }
}
