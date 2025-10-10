import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final List<String> _addresses = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _addresses.addAll(prefs.getStringList('addresses') ?? []);
    });
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('addresses', _addresses);
  }

  void _addAddress() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _addresses.add(text);
    });
    _controller.clear();
    _saveAddresses();
  }

  void _removeAddress(String address) {
    setState(() {
      _addresses.remove(address);
    });
    _saveAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои адреса поиска')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                    const InputDecoration(labelText: 'Введите адрес'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addAddress,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _addresses.isEmpty
                  ? const Center(child: Text('Адресов пока нет'))
                  : ListView.builder(
                itemCount: _addresses.length,
                itemBuilder: (context, i) {
                  final addr = _addresses[i];
                  return ListTile(
                    title: Text(addr),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeAddress(addr),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
