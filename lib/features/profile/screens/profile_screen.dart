import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/profile_cubit.dart';
import '../../analytics/cubit/analytics_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsCubit>().recordScreenView('profile_screen');
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: state.avatarUrl != null
                      ? NetworkImage(state.avatarUrl!)
                      : const AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
                const SizedBox(height: 16),
                Text(
                  state.userName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(state.userEmail),
                Text(state.userPhone),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _editProfile(context, state),
                  child: const Text('Редактировать профиль'),
                ),
                const SizedBox(height: 20),
                Text('Избранное: ${state.favoriteItems.length}'),
              ],
            ),
          );
        },
      ),
    );
  }

  void _editProfile(BuildContext context, ProfileState currentState) {
    final nameController = TextEditingController(text: currentState.userName);
    final emailController = TextEditingController(text: currentState.userEmail);
    final phoneController = TextEditingController(text: currentState.userPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать профиль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Телефон'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileCubit>().updateProfile(
                nameController.text.trim(),
                emailController.text.trim(),
                phoneController.text.trim(),
              );
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}