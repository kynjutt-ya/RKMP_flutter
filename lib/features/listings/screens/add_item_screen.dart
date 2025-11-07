import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/item.dart';
import 'my_listings_screen.dart';

class AddItemScreen extends StatefulWidget {
  final String ownerName;
  final List<Item> myItems;
  final Function(List<Item>) onUpdateMyItems;

  const AddItemScreen({
    super.key,
    required this.ownerName,
    required this.myItems,
    required this.onUpdateMyItems,
  });

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
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название объявления')),
      );
      return;
    }

    final newItem = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      forExchange: _forExchange,
      owner: widget.ownerName,
      imagePath: _pickedImage?.path,
    );

    final updatedItems = List<Item>.from(widget.myItems)..add(newItem);
    widget.onUpdateMyItems(updatedItems);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MyListingsScreen(
          myItems: updatedItems,
          onAdd: (item) {},
          onDelete: (id) {},
          onUpdateMyItems: widget.onUpdateMyItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить объявление'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              _pickedImage != null
                  ? Image.file(_pickedImage!, height: 150, fit: BoxFit.cover)
                  : Image.asset('assets/placeholder.png', height: 150, fit: BoxFit.cover),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Выбрать фото'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Обмен'),
                  const Spacer(),
                  Switch(
                    value: _forExchange,
                    onChanged: (v) => setState(() => _forExchange = v),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}