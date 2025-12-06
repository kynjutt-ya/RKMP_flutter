import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/profile_settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Тёмная тема'),
                      subtitle: const Text('Использовать тёмную тему приложения'),
                      value: state.isDarkMode,
                      onChanged: (value) => context.read<ProfileSettingsCubit>().toggleDarkMode(value),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Язык'),
                      subtitle: Text(state.language == 'ru' ? 'Русский' : 'English'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _changeLanguage(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Уведомления'),
                      subtitle: const Text('Получать уведомления о новых объявлениях'),
                      value: state.notificationsEnabled,
                      onChanged: (value) => context.read<ProfileSettingsCubit>().toggleNotifications(value),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('История поиска'),
                      subtitle: const Text('Сохранять историю поисковых запросов'),
                      value: state.searchHistoryEnabled,
                      onChanged: (value) => context.read<ProfileSettingsCubit>().toggleSearchHistory(value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: const Text('Размер кэша'),
                  subtitle: Text('${state.cacheSizeMB} MB'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _changeCacheSize(context, state.cacheSizeMB),
                ),
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
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileSettingsCubit>().changeLanguage('ru');
              context.pop();
            },
            child: const Text('Русский'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileSettingsCubit>().changeLanguage('en');
              context.pop();
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
          onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final size = int.tryParse(controller.text) ?? 100;
              context.read<ProfileSettingsCubit>().setCacheSize(size);
              context.pop();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}