import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/eco_guide/cubit/eco_guide_cubit.dart';
import 'features/eco_impact/cubit/eco_impact_cubit.dart';
import 'features/listings/cubit/listings_cubit.dart';
import 'data/datasources/listings/listings_datasource.dart';
import 'data/repositories/listings_repository_impl.dart';
import 'domain/interfaces/repositories/listings_repository.dart';
import 'domain/usecases/listings/get_all_listings_usecase.dart';
import 'domain/usecases/listings/add_listing_usecase.dart';
import 'domain/usecases/listings/delete_listing_usecase.dart';
import 'domain/usecases/listings/get_listing_by_id_usecase.dart';
import 'features/profile/cubit/profile_cubit.dart';
import 'features/profile/cubit/profile_settings_cubit.dart';
import 'features/repair_upcycle/cubit/repair_cubit.dart';
import 'features/support_safety/cubit/support_cubit.dart';
import 'shared/app_theme.dart';
import 'shared/bloc_observer.dart';

void main() {
  // Инициализация Flutter для веб
  WidgetsFlutterBinding.ensureInitialized();
  
  Bloc.observer = const AppBlocObserver();

  // Инициализация зависимостей для Clean Architecture (Listings)
  final listingsDataSource = InMemoryListingsDataSource();
  final listingsRepository = ListingsRepositoryImpl(listingsDataSource);
  final getAllListingsUseCase = GetAllListingsUseCase(listingsRepository);
  final addListingUseCase = AddListingUseCase(listingsRepository);
  final deleteListingUseCase = DeleteListingUseCase(listingsRepository);
  final getListingByIdUseCase = GetListingByIdUseCase(listingsRepository);
  
  final authCubit = AuthCubit();
  
  final listingsCubit = ListingsCubit(
    getAllListingsUseCase: getAllListingsUseCase,
    addListingUseCase: addListingUseCase,
    deleteListingUseCase: deleteListingUseCase,
    getListingByIdUseCase: getListingByIdUseCase,
    authCubit: authCubit,
  );
  final profileCubit = ProfileCubit();
  final profileSettingsCubit = ProfileSettingsCubit();
  final ecoGuideCubit = EcoGuideCubit();
  final ecoImpactCubit = EcoImpactCubit();
  final repairCubit = RepairCubit();
  final supportCubit = SupportCubit();

  final appRouter = AppRouter(authCubit: authCubit);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<ListingsCubit>.value(value: listingsCubit),
        BlocProvider<ProfileCubit>.value(value: profileCubit),
        BlocProvider<ProfileSettingsCubit>.value(value: profileSettingsCubit),
        BlocProvider<EcoGuideCubit>.value(value: ecoGuideCubit),
        BlocProvider<EcoImpactCubit>.value(value: ecoImpactCubit),
        BlocProvider<RepairCubit>.value(value: repairCubit),
        BlocProvider<SupportCubit>.value(value: supportCubit),
      ],
      child: MyApp(router: appRouter.router),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
      builder: (context, settingsState) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'От соседей — мини-маркетплейс',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
          routerConfig: router,
        );
      },
    );
  }
}