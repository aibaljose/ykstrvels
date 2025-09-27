import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ykstravels/theme.dart'; // For AppColors

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/images/animations/Travel.json', // Confirm this path matches your file
        width: 120,
        height: 120,
        fit: BoxFit.contain,
        repeat: true,
        onLoaded: (composition) {
          print('✅ Lottie loaded successfully: ${composition.duration} seconds');
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Lottie parse error: $error');
          print('Stack trace: $stackTrace');
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: AppColors.error, size: 50),
              const SizedBox(height: 8),
              Text(
                'Animation error: ${error.toString().substring(0, 100)}...',
                style: const TextStyle(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}