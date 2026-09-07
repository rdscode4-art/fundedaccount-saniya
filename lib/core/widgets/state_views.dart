import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// "Nothing here yet" placeholder for empty lists (positions, transactions,
/// history, etc). Keeps every empty state looking the same instead of each
/// screen inventing its own blank space or one-off text.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  const EmptyState({super.key, required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.textTertiary),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

/// Full-screen "something went wrong" state with a Retry button. Used for
/// any screen whose initial load can fail — replaces the old behavior of
/// either an infinite spinner or a silent redirect.
class ErrorRetryState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorRetryState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 44, color: AppColors.textTertiary),
            const SizedBox(height: 14),
            const Text(
              'Couldn\'t load this',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
