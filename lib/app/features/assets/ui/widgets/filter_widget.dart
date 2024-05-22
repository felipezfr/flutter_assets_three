import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onTap;
  final bool? isPressed;

  const FilterWidget({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onTap,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isPressed! ? const Color(0xFF2188FF) : const Color(0xFFD8DFE6);
    final Color borderColor =
        isPressed! ? Colors.transparent : const Color(0xFFD8DFE6);
    final Color textColor = isPressed! ? Colors.white : const Color(0xFF77818C);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              assetPath,
              color: textColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
