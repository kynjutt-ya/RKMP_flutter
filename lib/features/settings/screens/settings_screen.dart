import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/settings_cubit.dart';
import '../../analytics/cubit/analytics_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsCubit>().recordScreenView('settings_screen');
    });

    return const _SettingsScreenContent();
  }
}

class _SettingsScreenContent extends StatelessWidget {
  const _SettingsScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Тёмная тема'),
                value: state.isDarkMode,
                onChanged: (value) => context.read<SettingsCubit>().toggleDarkMode(value),
              ),
              ListTile(
                title: const Text('Язык'),
                subtitle: Text(state.language),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _changeLanguage(context),
              ),
              SwitchListTile(
                title: const Text('Уведомления'),
                value: state.notificationsEnabled,
                onChanged: (value) => context.read<SettingsCubit>().toggleNotifications(value),
              ),
              SwitchListTile(
                title: const Text('История поиска'),
                value: state.searchHistoryEnabled,
                onChanged: (value) => context.read<SettingsCubit>().toggleSearchHistory(value),
              ),
              ListTile(
                title: const Text('Размер кэша'),
                subtitle: Text('${state.cacheSizeMB} MB'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _changeCacheSize(context, state.cacheSizeMB),
              ),
            ],
          );
        },
      ),
    );
  }

  void _changeLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите язык'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsCubit>().changeLanguage('ru');
              Navigator.pop(context);
            },
            child: const Text('Русский'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsCubit>().changeLanguage('en');
              Navigator.pop(context);
            },
            child: const Text('English'),
          ),
        ],
      ),
    );
  }

  void _changeCacheSize(BuildContext context, int currentSize) {
    final controller = TextEditingController(text: currentSize.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Размер кэша (MB)'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Введите размер кэша'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final size = int.tryParse(controller.text) ?? 100;
              context.read<SettingsCubit>().setCacheSize(size);
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}