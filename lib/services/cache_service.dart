import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

/// Membersihkan cache aplikasi (folder sementara + cache gambar di memori).
/// Data pengeluaran (database) dan pengaturan tidak ikut terhapus.
class CacheService {
  CacheService._();

  /// Ukuran folder cache dalam byte.
  static Future<int> size() async {
    final dir = await getTemporaryDirectory();
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final f in dir.list(recursive: true, followLinks: false)) {
      if (f is File) {
        try {
          total += await f.length();
        } catch (_) {}
      }
    }
    return total;
  }

  /// Hapus isi folder cache. Mengembalikan jumlah byte yang dibebaskan.
  static Future<int> clear() async {
    final freed = await size();
    final dir = await getTemporaryDirectory();
    if (await dir.exists()) {
      await for (final e in dir.list(followLinks: false)) {
        try {
          await e.delete(recursive: true);
        } catch (_) {
          // File sedang dipakai: lewati.
        }
      }
    }
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
    return freed;
  }

  static String format(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
