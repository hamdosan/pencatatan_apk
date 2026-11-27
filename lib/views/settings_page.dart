import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/locale_controller.dart';
import '../l10n/l10n.dart';
import 'widgets/glass.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleController>();

    return AppBackground(
      ambient: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(tr('navSettings'))),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<AppLanguage>(
                    initialValue: locale.language,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: tr('language'),
                      prefixIcon: const Icon(Icons.translate),
                    ),
                    items: [
                      for (final l in AppLanguage.values)
                        DropdownMenuItem(value: l, child: Text(l.nativeName)),
                    ],
                    onChanged: (l) {
                      if (l != null) locale.setLanguage(l);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr('languageHint'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
