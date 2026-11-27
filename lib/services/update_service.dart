import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/update_config.dart';
import '../l10n/l10n.dart';

class AppRelease {
  const AppRelease({
    required this.version,
    required this.apkUrl,
    required this.notes,
  });

  final String version;
  final String apkUrl;
  final String notes;
}

class UpdateException implements Exception {
  const UpdateException(this.message);
  final String message;
  @override
  String toString() => message;
}

class UpdateService {
  UpdateService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  static Future<String> currentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.buildNumber.isEmpty
        ? info.version
        : '${info.version}+${info.buildNumber}';
  }

  Future<AppRelease> fetchLatest() async {
    if (!isUpdateConfigured) {
      throw UpdateException(tr('updateNoSource'));
    }
    final uri = Uri.https('api.github.com',
        '/repos/$kUpdateRepoOwner/$kUpdateRepoName/releases/latest');
    final http.Response res;
    try {
      res = await _client.get(uri, headers: {
        'Accept': 'application/vnd.github+json',
      }).timeout(const Duration(seconds: 15));
    } catch (_) {
      throw UpdateException(tr('updateNoConnection'));
    }
    if (res.statusCode == 404) {
      throw UpdateException(tr('updateNoRelease'));
    }
    if (res.statusCode != 200) {
      throw UpdateException(tr('updateHttpFailed', {'code': res.statusCode}));
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final assets = (json['assets'] as List? ?? []).cast<Map<String, dynamic>>();
    final apk = assets.where(
        (a) => (a['name'] as String? ?? '').toLowerCase().endsWith('.apk'));
    if (apk.isEmpty) {
      throw UpdateException(tr('updateNoApk'));
    }
    return AppRelease(
      version: (json['tag_name'] as String? ?? '')
          .replaceFirst(RegExp(r'^v', caseSensitive: false), ''),
      apkUrl: apk.first['browser_download_url'] as String,
      notes: (json['body'] as String? ?? '').trim(),
    );
  }

  static bool isNewer(String candidate, String current) {
    final a = _parts(candidate), b = _parts(current);
    for (var i = 0; i < 4; i++) {
      if (a[i] != b[i]) return a[i] > b[i];
    }
    return false;
  }

  static List<int> _parts(String v) {
    final plus = v.split('+');
    final nums = plus.first.split('.');
    int at(List<String> l, int i) =>
        i < l.length ? int.tryParse(l[i].trim()) ?? 0 : 0;
    return [
      at(nums, 0),
      at(nums, 1),
      at(nums, 2),
      plus.length > 1 ? int.tryParse(plus[1].trim()) ?? 0 : 0,
    ];
  }

  Stream<OtaEvent> install(AppRelease release) => OtaUpdate().execute(
        release.apkUrl,
        destinationFilename: 'expense_tracker.apk',
      );
}
