import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';

import '../../services/update_service.dart';
import '../../l10n/l10n.dart';

Future<bool?> showUpdateDialog(
  BuildContext context, {
  AppRelease? release,
  String? currentVersion,
}) =>
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _UpdateDialog(
        initialRelease: release,
        currentVersion: currentVersion,
      ),
    );

enum _Stage { checking, upToDate, available, downloading, installing, error }

class _UpdateDialog extends StatefulWidget {
  const _UpdateDialog({this.initialRelease, this.currentVersion});

  final AppRelease? initialRelease;
  final String? currentVersion;

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  final _service = UpdateService();
  _Stage _stage = _Stage.checking;
  String _current = '';
  AppRelease? _release;
  String? _error;
  double? _progress;
  StreamSubscription<OtaEvent>? _sub;

  bool get _isAuto => widget.initialRelease != null;

  @override
  void initState() {
    super.initState();
    if (_isAuto) {
      _release = widget.initialRelease;
      _current = widget.currentVersion ?? '';
      _stage = _Stage.available;
    } else {
      _check();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _check() async {
    setState(() {
      _stage = _Stage.checking;
      _error = null;
    });
    try {
      _current = await UpdateService.currentVersion();
      final latest = await _service.fetchLatest();
      if (!mounted) return;
      setState(() {
        _release = latest;
        _stage = UpdateService.isNewer(latest.version, _current)
            ? _Stage.available
            : _Stage.upToDate;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _stage = _Stage.error;
      });
    }
  }

  void _install() {
    setState(() {
      _stage = _Stage.downloading;
      _progress = null;
    });
    _sub = _service.install(_release!).listen(
      (event) {
        if (!mounted) return;
        setState(() {
          switch (event.status) {
            case OtaStatus.DOWNLOADING:
              final p = double.tryParse(event.value ?? '');
              _progress = p == null ? null : p / 100;
            case OtaStatus.INSTALLING:
            case OtaStatus.INSTALLATION_DONE:
              _stage = _Stage.installing;
            case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
              _error = tr('installPermission');
              _stage = _Stage.error;
            case OtaStatus.CANCELED:
              _stage = _Stage.available;
            default:
              _error = tr('updateFailed',
                  {'e': '${event.status.name} ${event.value ?? ''}'});
              _stage = _Stage.error;
          }
        });
      },
      onError: (Object e) {
        if (!mounted) return;
        setState(() {
          _error = tr('updateFailed', {'e': e});
          _stage = _Stage.error;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final busy = _stage == _Stage.checking || _stage == _Stage.downloading;

    final Widget content = switch (_stage) {
      _Stage.checking => _Busy(text: tr('checkingVersion')),
      _Stage.upToDate => Text(tr('upToDate', {'v': _current})),
      _Stage.available => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${tr('newVersion', {'v': _release!.version})}\n'
                '${tr('installedVersion', {'v': _current})}'),
            if (_release!.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(tr('changes'),
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(child: Text(_release!.notes)),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              tr('dataSafe'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      _Stage.downloading => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_progress == null
                ? tr('downloading')
                : tr('downloadingP', {'p': (_progress! * 100).round()})),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: _progress),
          ],
        ),
      _Stage.installing => Text(tr('downloadDone')),
      _Stage.error => Text(_error ?? tr('errorOccurred')),
    };

    return PopScope(
      canPop: !busy,
      child: AlertDialog(
        title: Text(tr('updateTitle')),
        content: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: content,
        ),
        // Tombol utama di atas (lebar penuh), Tutup/Nanti di bawah, di tengah.
        actions: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_stage == _Stage.error)
                  FilledButton(onPressed: _check, child: Text(tr('retry'))),
                if (_stage == _Stage.available)
                  FilledButton.icon(
                    onPressed: _install,
                    icon: const Icon(Icons.system_update),
                    label: Text(tr('update')),
                  ),
                if (_isAuto && _stage == _Stage.available)
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(tr('skipVersion')),
                  ),
                if (!busy)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      _stage == _Stage.available ? tr('later') : tr('close'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Busy extends StatelessWidget {
  const _Busy({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text)),
        ],
      );
}
