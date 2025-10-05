import 'package:flutter/material.dart';
import 'package:todo/core/Theme/colors.dart';
import 'package:todo/core/Theme/text_styles.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.label, required this.onTap});
  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 120,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [primaryClr.withOpacity(0.9), primaryClr],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryClr.withOpacity(0.3), // ظل خفيف وناعم
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: bodyStyle.copyWith(
            color: Colors.white, 
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
