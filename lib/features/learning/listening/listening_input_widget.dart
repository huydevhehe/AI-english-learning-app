import 'package:flutter/material.dart';

class ListeningInputWidget extends StatefulWidget {
  final Function(String) onSubmit;

  const ListeningInputWidget({
    super.key,
    required this.onSubmit,
  });

  @override
  State<ListeningInputWidget> createState() => _ListeningInputWidgetState();
}

class _ListeningInputWidgetState extends State<ListeningInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TextField(
          controller: _controller,

          // ✅ CHỮ NHẬP KHÔNG BỊ CHÌM
          style: theme.textTheme.bodyLarge,

          decoration: InputDecoration(
            hintText: 'Nhập từ còn thiếu',

            // ✅ HINT RÕ TRONG DARK MODE
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),

            filled: true,

            // ✅ KHÔNG HARD CODE MÀU
            fillColor: theme.cardColor,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: theme.dividerColor,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            onPressed: () {
              widget.onSubmit(_controller.text);
            },
            child: Text(
              'Kiểm tra',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
