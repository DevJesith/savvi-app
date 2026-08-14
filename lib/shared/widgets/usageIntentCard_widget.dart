import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsageOption {
  final String title;
  final String description;
  final IconData icon;

  UsageOption({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class UsageintentcardWidget extends StatelessWidget {
  final UsageOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const UsageintentcardWidget({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7F5) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF4929)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF4929)
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                option.icon,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              option.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              option.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: const Color(0xFF64748B),
              ),
            ),

            
          ],
        ),
        
      ),
      
    );
  }
}
