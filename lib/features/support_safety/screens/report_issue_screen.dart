// lib/features/support_safety/screens/report_issue_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/support_cubit.dart';
import '../models/support_ticket.dart';
import '../../../shared/image_helper.dart';

// lib/features/support_safety/screens/faq_screen.dart
// lib/features/support_safety/screens/ticket_status_screen.dart

class ReportIssueScreen extends StatefulWidget {
  final String? itemId;

  const ReportIssueScreen({super.key, this.itemId});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageCtrl = TextEditingController();
  String _selectedCategory = 'scam';
  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  File? _pickedImageFile;

  static const List<String> categories = [
    'scam',
    'dangerous_item',
    'harassment',
    'other',
  ];

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImageHelper.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await ImageHelper.getImageBytes(picked);
      setState(() {
        _pickedImage = picked;
        _pickedImageBytes = bytes;
        if (!kIsWeb) {
          _pickedImageFile = File(picked.path);
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    final userId = authState.userEmail ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';

    context.read<SupportCubit>().createTicket(
          userId: userId,
          itemId: widget.itemId,
          category: _selectedCategory,
          message: _messageCtrl.text.trim(),
          imageUrl: kIsWeb ? null : _pickedImage?.path,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Обращение создано! Мы рассмотрим его в ближайшее время.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сообщить о проблеме'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Категория проблемы *',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: categories.map((cat) {
                  const labels = {
                    'scam': 'Мошенничество',
                    'dangerous_item': 'Опасный предмет',
                    'harassment': 'Оскорбление/Харассмент',
                    'other': 'Другое',
                  };
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(labels[cat] ?? cat),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedCategory = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Выберите категорию';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Описание проблемы *',
                  border: OutlineInputBorder(),
                  hintText: 'Опишите проблему подробно...',
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите описание проблемы';
                  }
                  if (value.trim().length < 10) {
                    return 'Описание должно содержать минимум 10 символов';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Скриншот/Фото (опционально)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _pickedImage != null
                  ? Stack(
                      children: [
                        ImageHelper.buildImageWidget(
                          imageFile: _pickedImageFile,
                          imageBytes: _pickedImageBytes,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => setState(() {
                              _pickedImage = null;
                              _pickedImageBytes = null;
                              _pickedImageFile = null;
                            }),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, size: 48, color: Colors.grey),
                      ),
                    ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Прикрепить фото'),
              ),
              const SizedBox(height: 24),
              const Card(
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Мы рассмотрим ваше обращение в течение 24 часов',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Отправить обращение'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Часто задаваемые вопросы'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          if (state.faqList.isEmpty) {
            return const Center(
              child: Text('FAQ загружается...'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.faqList.length,
            itemBuilder: (context, index) {
              final faq = state.faqList[index];
              return _buildFAQCard(faq);
            },
          );
        },
      ),
    );
  }

  Widget _buildFAQCard(FAQItem faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.help_outline, color: Colors.blue),
        ),
        title: Text(
          faq.question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: faq.category != 'general'
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Chip(
                  label: Text(_getCategoryLabel(faq.category)),
                  labelStyle: const TextStyle(fontSize: 10),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq.answer,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(String category) {
    const labels = {
      'general': 'Общее',
      'safety': 'Безопасность',
      'eco': 'Экология',
    };
    return labels[category] ?? category;
  }
}

class TicketStatusScreen extends StatelessWidget {
  const TicketStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final userId = authState.userEmail ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои обращения'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (status) {
              // Фильтрация по статусу
              // В реальном приложении здесь будет фильтрация
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Все')),
              const PopupMenuItem(value: 'open', child: Text('Открытые')),
              const PopupMenuItem(value: 'in_progress', child: Text('В работе')),
              const PopupMenuItem(value: 'resolved', child: Text('Решённые')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          // Фильтруем тикеты текущего пользователя
          final userTickets = state.tickets
              .where((ticket) => ticket.userId == userId)
              .toList();

          if (userTickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'У вас пока нет обращений',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Создать обращение'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: userTickets.length,
            itemBuilder: (context, index) {
              final ticket = userTickets[index];
              return _buildTicketCard(context, ticket);
            },
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, SupportTicket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ExpansionTile(
        leading: _buildStatusIcon(ticket.status),
        title: Text(
          _getCategoryLabel(ticket.category),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _formatDate(ticket.createdAt),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: _buildStatusChip(ticket.status),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Описание:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ticket.message,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Статус: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildStatusChip(ticket.status),
                  ],
                ),
                if (ticket.itemId != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Связано с объявлением',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'open':
        return const Icon(Icons.fiber_new, color: Colors.blue);
      case 'in_progress':
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
      case 'resolved':
        return const Icon(Icons.check_circle, color: Colors.green);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'open':
        color = Colors.blue;
        label = 'Открыт';
        break;
      case 'in_progress':
        color = Colors.orange;
        label = 'В работе';
        break;
      case 'resolved':
        color = Colors.green;
        label = 'Решён';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _getCategoryLabel(String category) {
    const labels = {
      'scam': 'Мошенничество',
      'dangerous_item': 'Опасный предмет',
      'harassment': 'Оскорбление/Харассмент',
      'other': 'Другое',
    };
    return labels[category] ?? category;
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
