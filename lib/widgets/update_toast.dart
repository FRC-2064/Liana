import 'package:flutter/material.dart';
import 'package:liana/services/updater/update.dart';
import 'package:liana/services/updater/update_info.dart';
import 'package:liana/utils/liana_colors.dart';

/// [Widget] displayed when an [Update] is available
/// on the github.
class UpdateToast extends StatelessWidget {
  final UpdateInfo updateInfo;
  final VoidCallback onDismiss;
  final Update updateService;

  const UpdateToast({
    super.key,
    required this.updateInfo,
    required this.onDismiss,
    required this.updateService,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LianaColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: LianaColors.statusSelected,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.update,
                  color: LianaColors.statusSelected,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Update Available',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: LianaColors.headerText,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: LianaColors.buttonText,
                  ),
                  onPressed: onDismiss,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Version ${updateInfo.version} is now available!',
              style: TextStyle(
                fontSize: 16,
                color: LianaColors.buttonText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onDismiss,
                  child: Text(
                    'Later',
                    style: TextStyle(
                      color: LianaColors.buttonText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final success = await updateService.downloadAndInstall(
                      updateInfo.donwloadURL,
                    );
                    if (success) {
                      onDismiss();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LianaColors.statusSelected,
                    foregroundColor: LianaColors.background,
                  ),
                  child: const Text('Download Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateToastManager {
  static OverlayEntry? _currentToast;

  static void showUpdateToast(
    BuildContext context,
    UpdateInfo updateInfo,
    Update updateService,
  ) {
    removeToast();

    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        top: 16,
        right: 16,
        width: 400,
        child: UpdateToast(
          updateInfo: updateInfo,
          updateService: updateService,
          onDismiss: removeToast,
        ),
      ),
    );

    Overlay.of(context).insert(_currentToast!);
  }

  static void removeToast() {
    _currentToast?.remove();
    _currentToast = null;
  }
}
