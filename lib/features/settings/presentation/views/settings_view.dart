import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipad/features/settings/presentation/viewmodels/settings_viewmodel.dart';

class SettingsView extends GetView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Obx(() => ListView(
        children: [
          _buildSectionHeader(context, 'Appearance'),
          _buildThemeTile(context),
          const Divider(),
          _buildSectionHeader(context, 'Apple Pencil'),
          _buildDoubleTapTile(context),
          const Divider(),
          _buildSectionHeader(context, 'About'),
          _buildAboutTile(context),
        ],
      )),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.palette),
      title: const Text('Theme'),
      subtitle: Text(_getThemeText(controller.settings.value.themeMode)),
      onTap: () => _showThemeDialog(context),
    );
  }

  String _getThemeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeText(mode)),
              value: mode,
              groupValue: controller.settings.value.themeMode,
              onChanged: (value) {
                if (value != null) {
                  controller.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDoubleTapTile(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.touch_app),
      title: const Text('Double Tap for Eraser'),
      subtitle: const Text('Double tap with Apple Pencil to switch to eraser'),
      value: controller.settings.value.doubleTapEnabled,
      onChanged: controller.setDoubleTapEnabled,
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text('PDF Study'),
      subtitle: const Text('Version 0.0.1'),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationName: 'PDF Study',
          applicationVersion: '0.0.1',
          applicationLegalese: '© 2024 PDF Study',
        );
      },
    );
  }
}
