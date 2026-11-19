import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep; // 1, 2, or 3
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.labels = const ['Register', 'Offer', 'Approval'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final stepBefore = (index ~/ 2) + 1;
            return Expanded(
              child: Container(
                height: 2,
                color: stepBefore < currentStep
                    ? AppColors.primaryBlue
                    : AppColors.border,
              ),
            );
          }

          // Step circle
          final step = (index ~/ 2) + 1;
          final isActive = step == currentStep;
          final isCompleted = step < currentStep;

          return _StepCircle(
            step: step,
            label: labels[step - 1],
            isActive: isActive,
            isCompleted: isCompleted,
          );
        }),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int step;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepCircle({
    required this.step,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color labelColor;

    if (isActive) {
      bgColor = AppColors.primaryBlue;
      textColor = Colors.white;
      labelColor = AppColors.primaryBlue;
    } else if (isCompleted) {
      bgColor = AppColors.success;
      textColor = Colors.white;
      labelColor = AppColors.success;
    } else {
      bgColor = AppColors.border;
      textColor = AppColors.textLight;
      labelColor = AppColors.textLight;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '$step',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}
