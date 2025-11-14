import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'shared/app_state.dart';
import 'service_locator.dart';
import 'app_router.dart';
import 'features/listings/models/item.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppStateService _service;

  @override
  void initState() {
    super.initState();
    _service = locator<AppStateService>();
  }

  void _addMyItem(Item item) {
    setState(() {
      _service.addItem(item);
    });
  }

  void _removeMyItem(String id) {
    setState(() {
      _service.removeItem(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState(
      allItems: _service.allItems,
      userItems: _service.userItems,
    );

    return AppStateProvider(
      state: appState,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'От соседей — мини-маркетплейс',
        theme: AppTheme.lightTheme,
        routerConfig: createAppRouter(_addMyItem, _removeMyItem),
      ),
    );
  }
}
