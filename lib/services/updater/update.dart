import 'dart:async';
import 'dart:convert';

import 'package:liana/services/updater/update_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Class handles the update checking. functionality.
/// Always points to the latest release of 'FRC-2064/Liana' on
/// github.
class Update {
  static const String _ghRepo = 'FRC-2064/Liana';
  static const String _ghUrl =
      'https://api.github.com/repos/$_ghRepo/releases/latest';

  final Duration checkInterval;
  Timer? _updateCheckTimer;

  Update({this.checkInterval = const Duration(hours: 1)});

  void startPeriodicCheck(Function(UpdateInfo) onUpdateAvailable) {
    checkForUpdates().then((update) {
      if (update != null) {
        onUpdateAvailable(update);
      }
    });

    _updateCheckTimer = Timer.periodic(checkInterval, (_) async {
      final update = await checkForUpdates();
      if (update != null) {
        onUpdateAvailable(update);
      }
    });
  }

  void stopPeriodicCheck() {
    _updateCheckTimer?.cancel();
    _updateCheckTimer = null;
  }

  /// Get the current version and latest from
  /// github, compares. If an update is available then
  /// return the [UpdateInfo], else return nothing.
  Future<UpdateInfo?> checkForUpdates() async {
    try {
      final currentVersion = await _getCurrentVersion();
      final latestRelease = await _fetchLatestRelease();

      if (latestRelease == null) return null;

      final latestVersion = _parseVersion(latestRelease['tag_name']);
      final current = _parseVersion(currentVersion);

      if (_isNewerVersion(latestVersion, current)) {
        return UpdateInfo(
          version: latestRelease['tag_name'],
          donwloadURL: _getInstallerUrl(latestRelease),
          releaseNotes: latestRelease['body'] ?? 'No release notes available',
          htmlURL: latestRelease['html_url'],
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check the current app to see what verion
  /// it is running. This gets set by the windows-installer.iss file
  /// and the github workflow for tag releases.
  Future<String> _getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Get the releases from github using their api.
  Future<Map<String, dynamic>?> _fetchLatestRelease() async {
    try {
      final response = await http.get(
        Uri.parse(_ghUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get the install executable download URL from github.
  String _getInstallerUrl(Map<String, dynamic> release) {
    final assets = release['assets'] as List<dynamic>? ?? [];

    for (var asset in assets) {
      final name = asset['name'] as String;
      if (name.endsWith('.exe') && name.contains('Installer')) {
        return asset['browser_download_url'];
      }
    }
    return release['html_url'];
  }

  /// Convert a [version] tag into a list of ints.
  List<int> _parseVersion(String version) {
    final cleaned = version.replaceAll('v', '').split('-')[0];
    return cleaned.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }

  /// Compare two int lists [a] and [b], return true if
  /// [a] is a newer version than [b].
  bool _isNewerVersion(List<int> a, List<int> b) {
    for (int i = 0; i < 3; i++) {
      final aVal = i < a.length ? a[i] : 0;
      final bVal = i < b.length ? b[i] : 0;

      if (aVal > bVal) return true;
      if (aVal < bVal) return false;
    }
    return false;
  }

  /// fetch the installer, if there is an issue,
  /// return false if errors.
  Future<bool> downloadAndInstall(String downloadUrl) async {
    try {
      final uri = Uri.parse(downloadUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
