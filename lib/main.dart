// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shared/bloc_observer.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/listings/screens/home_screen.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/analytics/cubit/analytics_cubit.dart';
import 'features/listings/cubit/listings_cubit.dart';
import 'features/profile/cubit/profile_cubit.dart';
import 'features/settings/cubit/settings_cubit.dart';
import 'shared/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => AnalyticsCubit()),
        BlocProvider(create: (_) => ListingsCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'От соседей — мини-маркетплейс',
          theme: settingsState.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme,
          locale: Locale(settingsState.language),
          supportedLocales: const [
            Locale('ru', 'RU'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.isAuthenticated) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return state.isAuthenticated ? const HomeScreen() : const LoginScreen();
              },
            ),
          ),
        );
      },
    );
  }
}