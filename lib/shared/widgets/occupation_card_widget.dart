import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/core/constants/app_colors_constants.dart';

class OccupationOption {
  final String title;
  final String description;
  final IconData icon;

  OccupationOption({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OccupationCardWidget extends StatelessWidget {
  final OccupationOption option;
  final bool isSelected;
  final VoidCallback ontap;

  const OccupationCardWidget({
    required this.option,
    required this.isSelected,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7F5) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppColorsConstants.primary
                : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Contenedor del icono
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColorsConstants.primary
                    : const Color(0xFFFFF7F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                option.icon,
                color: isSelected ? Colors.white : AppColorsConstants.primary,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColorsConstants.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    option.description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Indicaador check o flecha
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColorsConstants.primary, size: 20)
            else
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFFCBD5E1),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
