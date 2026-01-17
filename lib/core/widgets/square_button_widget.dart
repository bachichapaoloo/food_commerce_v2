import 'package:flutter/material.dart';

class BigSquareButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double size;
  final VoidCallback onTap;
  final bool isSelected;
  final Color borderColor;

  const BigSquareButton({
    super.key,
    required this.title,
    this.icon,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.size = 120,
    required this.onTap,
    this.isSelected = false,
    this.borderColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected ? borderColor.withOpacity(0.2) : backgroundColor,
          border: Border.all(color: isSelected ? borderColor : Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: 40, color: isSelected ? borderColor : textColor),
            if (icon != null) SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? borderColor : textColor),
            ),
          ],
        ),
      ),
    );
  }
}
