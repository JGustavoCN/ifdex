import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign textAlign;
  final double? letterSpacing;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const AppText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textAlign = TextAlign.start,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    this.height,
  });

  /// Títulos e Cabeçalhos (Inter, 20px, SemiBold)
  factory AppText.headline(
    String text, {
    Key? key,
    Color? color,
    TextAlign textAlign = TextAlign.start,
  }) {
    return AppText(
      text,
      key: key,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimary,
      textAlign: textAlign,
    );
  }

  /// Corpo de texto genérico (Inter, 14px, Regular)
  factory AppText.body(
    String text, {
    Key? key,
    Color? color,
    TextAlign textAlign = TextAlign.start,
  }) {
    return AppText(
      text,
      key: key,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.textPrimary,
      textAlign: textAlign,
    );
  }

  /// Metadados, tags e labels (Inter, 12px, Medium, letterSpacing opcional)
  factory AppText.label(
    String text, {
    Key? key,
    Color? color,
    TextAlign textAlign = TextAlign.start,
    double? letterSpacing,
  }) {
    return AppText(
      text,
      key: key,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.textSecondary,
      textAlign: textAlign,
      letterSpacing: letterSpacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? AppColors.textPrimary,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }
}
