import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/profile_cubit.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../../shared/image_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
    });

    return const _ProfileScreenContent();
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/listings'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/profile/settings'),
            tooltip: 'Настройки',
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            child: _buildAvatar(context, state.avatarUrl),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () => _pickAvatar(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        state.userName.isNotEmpty ? state.userName : 'Пользователь',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (state.userEmail.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.email, size: 18, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                state.userEmail,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (state.userPhone.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.phone, size: 18, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                state.userPhone,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => context.push('/profile/favorites'),
                        child: _buildStatCard(
                          context,
                          icon: Icons.favorite,
                          title: 'Избранное',
                          value: '${state.favoriteItems.length}',
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildActionCard(
                        context,
                        icon: Icons.edit,
                        title: 'Редактировать профиль',
                        subtitle: 'Изменить имя, email, телефон',
                        onTap: () => _editProfile(context, state),
                      ),
                      const SizedBox(height: 12),
                      _buildActionCard(
                        context,
                        icon: Icons.settings,
                        title: 'Настройки',
                        subtitle: 'Тема, язык, уведомления',
                        onTap: () => context.push('/profile/settings'),
                      ),
                      const SizedBox(height: 12),
                      _buildActionCard(
                        context,
                        icon: Icons.logout,
                        title: 'Выйти',
                        subtitle: 'Выйти из аккаунта',
                        color: Colors.red,
                        onTap: () => _logout(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final iconColor = color ?? Colors.blue;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context, ProfileState currentState) {
    final nameController = TextEditingController(text: currentState.userName);
    final emailController = TextEditingController(text: currentState.userEmail);
    final phoneController = TextEditingController(text: currentState.userPhone);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать профиль'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Имя *',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите имя';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите email';
                    }
                    if (!value.contains('@')) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Телефон',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    hintText: '+7 (999) 123-45-67',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<ProfileCubit>().updateProfile(
                  nameController.text.trim(),
                  emailController.text.trim(),
                  phoneController.text.trim(),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Профиль обновлён')),
                );
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String? avatarUrl) {
    final theme = Theme.of(context);
    
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: theme.colorScheme.surface,
        child: Icon(
          Icons.person,
          size: 50,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      );
    }

    if (avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://')) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: theme.colorScheme.surface,
        backgroundImage: NetworkImage(avatarUrl),
        onBackgroundImageError: (exception, stackTrace) {
        },
        child: Icon(
          Icons.person,
          size: 50,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      );
    }

    if (avatarUrl.startsWith('data:')) {
      try {
        final uri = Uri.parse(avatarUrl);
        final bytes = uri.data?.contentAsBytes();
        if (bytes != null && bytes.isNotEmpty) {
          return CircleAvatar(
            radius: 50,
            backgroundColor: theme.colorScheme.surface,
            backgroundImage: MemoryImage(bytes),
            child: Icon(
              Icons.person,
              size: 50,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error parsing data URL: $e');
      }
    }

    if (!kIsWeb) {
      try {
        final file = File(avatarUrl);
        if (file.existsSync()) {
          return CircleAvatar(
            radius: 50,
            backgroundColor: theme.colorScheme.surface,
            backgroundImage: FileImage(file),
            child: Icon(
              Icons.person,
              size: 50,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error loading file: $e');
      }
    }

    return CircleAvatar(
      radius: 50,
      backgroundColor: theme.colorScheme.surface,
      child: Icon(
        Icons.person,
        size: 50,
        color: theme.colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }

  Future<void> _pickAvatar(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Выбрать из галереи'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final picked = await ImageHelper.pickImage(source: ImageSource.gallery);
                  if (picked != null && context.mounted) {
                    // На веб используем data URL, на мобильных - путь к файлу
                    if (kIsWeb) {
                      final bytes = await ImageHelper.getImageBytes(picked);
                      if (bytes != null) {
                        // Конвертируем bytes в base64 data URL
                        final base64 = Uri.dataFromBytes(bytes, mimeType: 'image/jpeg').toString();
                        await context.read<ProfileCubit>().updateAvatar(base64);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Аватар обновлён'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    } else {
                      await context.read<ProfileCubit>().updateAvatar(picked.path);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Аватар обновлён'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  }
                } catch (e) {
                  debugPrint('Error picking avatar: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ошибка при загрузке аватара: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Сделать фото'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final picked = await ImageHelper.pickImage(source: ImageSource.camera);
                  if (picked != null && context.mounted) {
                    if (kIsWeb) {
                      final bytes = await ImageHelper.getImageBytes(picked);
                      if (bytes != null) {
                        final base64 = Uri.dataFromBytes(bytes, mimeType: 'image/jpeg').toString();
                        await context.read<ProfileCubit>().updateAvatar(base64);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Аватар обновлён'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    } else {
                      await context.read<ProfileCubit>().updateAvatar(picked.path);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Аватар обновлён'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  }
                } catch (e) {
                  debugPrint('Error picking avatar: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ошибка при загрузке аватара: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            if (context.read<ProfileCubit>().state.avatarUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Удалить аватар', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileCubit>().updateAvatar(null);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Аватар удалён')),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}