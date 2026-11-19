import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CreditSeaLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color textColor;

  const CreditSeaLogo({
    super.key,
    this.size = 40,
    this.showText = true,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo icon - Green swoosh
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.trending_up_rounded,
              color: AppColors.brandGreen,
              size: size * 0.6,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 10),
          Text(
            'CreditSea',
            style: GoogleFonts.inter(
              fontSize: size * 0.55,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ],
    );
  }
}

class CreditSeaHeader extends StatelessWidget {
  final double height;
  final Widget? child;

  const CreditSeaHeader({
    super.key,
    this.height = 200,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CreditSeaLogo(size: 36),
            if (child != null) Expanded(child: child!),
          ],
        ),
      ),
    );
  }
}
