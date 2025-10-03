import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/item.dart';

class AddItemScreen extends StatefulWidget {
  final String ownerName;
  const AddItemScreen({super.key, required this.ownerName});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _forExchange = false;
  File? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите заголовок')),
      );
      return;
    }

    final newItem = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      forExchange: _forExchange,
      owner: widget.ownerName,
      imagePath: _pickedImage?.path, // путь к фото из галереи
    );

    Navigator.of(context).pop(newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить объявление')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Заголовок'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // превью фото
              if (_pickedImage != null)
                Image.file(_pickedImage!, height: 150, fit: BoxFit.cover)
              else
                Image.asset('assets/placeholder.png',
                    height: 150, fit: BoxFit.cover),

              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Выбрать фото'),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Предлагаю обмен'),
                  const Spacer(),
                  Switch(
                    value: _forExchange,
                    onChanged: (v) => setState(() => _forExchange = v),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
