import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final List<String> _addresses = [];
  final _controller = TextEditingController();
  final String _bannerUrl = 'https://adindex.ru/assets/seo/2022_04/facebook_303784.jpg?ts=1649751555';

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    _addresses.clear();
    _addresses.addAll(prefs.getStringList('addresses') ?? []);
    setState(() {});
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('addresses', _addresses);
  }

  void _addAddress() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _addresses.add(text));
    _controller.clear();
    _saveAddresses();
  }

  void _removeAddress(String addr) {
    setState(() => _addresses.remove(addr));
    _saveAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои адреса поиска'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
      body: Column(children: [
        CachedNetworkImage(
          imageUrl: _bannerUrl,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (c, u, p) => const Center(child: CircularProgressIndicator()),
          errorWidget: (c, u, e) => const Center(child: Icon(Icons.error, color: Colors.red)),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Введите адрес'))),
            IconButton(icon: const Icon(Icons.add), onPressed: _addAddress),
          ]),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _addresses.isEmpty
              ? const Center(child: Text('Адресов пока нет'))
              : ListView.builder(
            itemCount: _addresses.length,
            itemBuilder: (c, i) => ListTile(
              title: Text(_addresses[i]),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _removeAddress(_addresses[i])),
            ),
          ),
        ),
      ]),
    );
  }
}
