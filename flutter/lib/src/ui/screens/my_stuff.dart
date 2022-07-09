import 'package:app_boot/app_boot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magnific_ui/magnific_ui.dart';
import 'package:shopping/gen/assets.gen.dart';
import 'package:shopping/l10n/l10n.dart';
import 'package:shopping/src/commons/settings.dart';
import 'package:shopping/src/di/user.dart';

import '../../di/package_info.dart';
import '../components/lang.dart';

class MyStuffScreen extends StatelessWidget {
  const MyStuffScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void noop() {
      AppSnackbar.of(context).info('No operation available');
    }

    return ListView(
      children: [
        const ProfileCard(),
        SettingsSection(
          children: [
            OptionSection(
              onTap: () async {
                SelectLanguage.show(context);
              },
              title: Text(context.l10n.languageName),
              subtitle: Text(context.l10n.appLanguage),
              label: '',
              trailing: const Icon(
                Icons.translate_rounded,
                color: Colors.black38,
              ),
            ),
            OptionSection(
              options: (context) {
                return [
                  OptionSection(
                    onTap: noop,
                    title: Text(context.l10n.purchaseHistory),
                    label: context.l10n.purchaseHistory,
                  ),
                  OptionSection(
                    onTap: noop,
                    title: Text(context.l10n.upcomingOrders),
                    label: context.l10n.upcomingOrders,
                  ),
                ];
              },
              title: Text(context.l10n.purchases),
              label: context.l10n.purchases,
            ),
            OptionSection(
              options: (context) {
                return [
                  OptionSection(
                    onTap: noop,
                    title: Text(context.l10n.contactUs),
                    label: context.l10n.contactUs,
                  ),
                  OptionSection(
                    onTap: noop,
                    title: Text(context.l10n.faq),
                    label: context.l10n.faq,
                  ),
                ];
              },
              title: const Text('Help'),
              label: 'Help',
            ),
            OptionSection(
              options: (context) {
                return [
                  OptionSection(
                    onTap: noop,
                    title: Text(context.l10n.termsConditions),
                    label: context.l10n.termsConditions,
                  ),
                  OptionSection(
                    onTap: noop,
                    title: Text(context.l10n.privacyPolicy),
                    label: context.l10n.privacyPolicy,
                  ),
                ];
              },
              title: const Text('Legal'),
              label: 'Legal',
              keepBorder: false,
            ),
          ],
        ),
        SettingsSection(
          children: [
            OptionSection(
              onTap: noop,
              title: Text(context.l10n.logout),
              label: context.l10n.logout,
              keepBorder: false,
              textColor: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
        const AppAndDeviceInformationTile(),
      ],
    );
  }
}

class ProfileCard extends ConsumerWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final userName = ref.watch(userNameProvider) ?? 'User';
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: InkWell(
        onTap: () {
          //
        },
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, $userName!',
                      textAlign: TextAlign.start,
                      style: textTheme.titleLarge,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'EDIT PROFILE',
                          textAlign: TextAlign.start,
                          style: textTheme.caption,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.tight(const Size.square(75)),
                      child: ImageIcon2(
                        AssetImage(Assets.icons.user.path),
                        ignoreIconColor: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    Key? key,
    required this.children,
  }) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

class AppAndDeviceInformationTile extends StatelessWidget {
  const AppAndDeviceInformationTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 16.0).add(const EdgeInsets.only(
        bottom: 20.0,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer(builder: (context, ref, _) {
            final packageInfo = ref.watch(packageInfoProvider);

            return packageInfo.when<Widget>(
              data: (data) {
                return SelectableText(
                  'v${data.version} (${data.buildNumber})',
                  style: Theme.of(context).textTheme.caption,
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            );
          }),
          Tooltip(
            message: currentAppApi.url.toString(),
            triggerMode: TooltipTriggerMode.longPress,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${currentSettings.identifier.id} - ',
                  ),
                  TextSpan(
                    text: Localizations.localeOf(context).toString(),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption!.merge(
                    const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({
    Key? key,
    required this.title,
    required this.options,
  }) : super(key: key);

  final String title;
  final Iterable<Widget> options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: options.length,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemBuilder: (context, index) {
          final it = options.elementAt(index);

          return it;
        },
      ),
    );
  }
}

class OptionSection extends StatelessWidget {
  const OptionSection({
    Key? key,
    this.options,
    this.onTap,
    this.leading,
    required this.title,
    required this.label,
    this.subtitle,
    this.trailing,
    this.replaceWithNextRoute = false,
    this.textColor,
    this.keepBorder = true,
  }) : super(key: key);

  final Iterable<Widget> Function(BuildContext context)? options;
  final VoidCallback? onTap;
  final Widget title;
  final String label;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool replaceWithNextRoute;
  final Color? textColor;
  final bool keepBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        shape: !keepBorder
            ? null
            : Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
        onTap: () {
          if (onTap != null) {
            onTap?.call();
          }

          final options = this.options?.call(context);
          if (options != null && options.isNotEmpty) {
            final navigator = Navigator.of(context);
            final route = MaterialPageRoute(
              builder: (context) {
                return OptionsScreen(
                  title: label,
                  options: options,
                );
              },
            );
            if (replaceWithNextRoute) {
              navigator.pushReplacement(route);
            } else {
              navigator.push(route);
            }
          }
        },
        title: title,
        textColor: textColor,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded),
        // (options != null
        //     ? const Icon(Icons.arrow_forward_ios_rounded)
        //     : null),
      ),
    );
  }
}
