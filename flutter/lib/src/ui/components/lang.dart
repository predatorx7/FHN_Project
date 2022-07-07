import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/l10n.dart';
import '../../di/locale.dart';

class SelectLanguage extends ConsumerWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  static show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return const SelectLanguage();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locales = LocaleController.supportedLocales();
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
        title: Text(
          context.l10n.selectLanguage,
        ),
      ),
      body: ListView.builder(
        itemCount: locales.length,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        itemBuilder: (context, i) {
          final it = locales[i];
          final isSelected = it == currentLocale;

          final name = LocaleController.languageNameFor(it);
          return ListTile(
            onTap: () async {
              ref.read(localeControllerProvider.notifier).update(it);

              Navigator.of(context, rootNavigator: true).pop();
            },
            title: Text(
              name,
              style: isSelected
                  ? const TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
