import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/eco_guide/screens/eco_tips_screen.dart' show EcoTipsScreen, RecyclingGuideScreen, RecyclingMapScreen;
import 'features/eco_impact/screens/impact_dashboard_screen.dart';
import 'features/eco_impact/screens/achievements_screen.dart';
import 'features/listings/models/item.dart';
import 'features/listings/screens/add_item_screen.dart';
import 'features/listings/screens/item_detail_screen.dart';
import 'features/listings/screens/listings_screen.dart';
import 'features/listings/screens/my_listings_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/settings_screen.dart';
import 'features/profile/screens/favorites_screen.dart';
import 'features/repair_upcycle/screens/repair_list_screen.dart' show RepairListScreen, RequestRepairScreen;
import 'features/support_safety/screens/report_issue_screen.dart' show ReportIssueScreen, FAQScreen, TicketStatusScreen;
import 'features/support_safety/screens/support_screen.dart' show SupportScreen;

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter({required AuthCubit authCubit}) : _authCubit = authCubit;

  final AuthCubit _authCubit;

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(_authCubit.stream),
    redirect: (context, state) {
      final loggedIn = _authCubit.state.isAuthenticated;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      if (loggedIn && loggingIn) {
        return '/listings';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/listings',
        builder: (context, state) => const ListingsScreen(),
        routes: [
          GoRoute(
            path: 'my',
            builder: (context, state) => const MyListingsScreen(),
          ),
          GoRoute(
            path: 'add',
            builder: (context, state) {
              final authState = context.read<AuthCubit>().state;
              final ownerName = authState.userName ?? 'Пользователь';
              return AddItemScreen(ownerName: ownerName);
            },
          ),
          GoRoute(
            path: 'item',
            builder: (context, state) {
              final item = state.extra as Item?;
              if (item == null) {
                return const Scaffold(
                  body: Center(
                    child: Text('Не удалось открыть объявление'),
                  ),
                );
              }
              return ItemDetailScreen(item: item);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/eco-guide',
        builder: (context, state) => const EcoTipsScreen(),
        routes: [
          GoRoute(
            path: 'recycling-guide',
            builder: (context, state) => const RecyclingGuideScreen(),
          ),
          GoRoute(
            path: 'map',
            builder: (context, state) => const RecyclingMapScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/repair',
        builder: (context, state) => const RepairListScreen(),
        routes: [
          GoRoute(
            path: 'request',
            builder: (context, state) => const RequestRepairScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/impact',
        builder: (context, state) => const ImpactDashboardScreen(),
        routes: [
          GoRoute(
            path: 'achievements',
            builder: (context, state) => const AchievementsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
        routes: [
          GoRoute(
            path: 'report',
            builder: (context, state) => const ReportIssueScreen(),
          ),
          GoRoute(
            path: 'faq',
            builder: (context, state) => const FAQScreen(),
          ),
          GoRoute(
            path: 'tickets',
            builder: (context, state) => const TicketStatusScreen(),
          ),
        ],
      ),
    ],
  );
}