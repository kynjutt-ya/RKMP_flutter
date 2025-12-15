import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'app_router.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/eco_guide/cubit/eco_guide_cubit.dart';
import 'features/eco_impact/cubit/eco_impact_cubit.dart';
import 'features/listings/cubit/listings_cubit.dart';
import 'data/database/database_helper.dart';
import 'data/datasources/listings/listings_datasource.dart';
import 'data/repositories/listings_repository_impl.dart';
import 'domain/usecases/listings/get_all_listings_usecase.dart';
import 'domain/usecases/listings/add_listing_usecase.dart';
import 'domain/usecases/listings/delete_listing_usecase.dart';
import 'domain/usecases/listings/get_listing_by_id_usecase.dart';
import 'domain/usecases/listings/get_my_listings_usecase.dart';
import 'features/profile/cubit/profile_cubit.dart';
import 'features/profile/cubit/profile_settings_cubit.dart';
import 'features/repair_upcycle/cubit/repair_cubit.dart';
import 'features/support_safety/cubit/support_cubit.dart';
import 'data/datasources/support/support_local_data_source.dart';
import 'data/repositories/support_repository_impl.dart';
import 'domain/usecases/support/create_ticket_usecase.dart';
import 'domain/usecases/support/get_all_tickets_usecase.dart';
import 'package:dio/dio.dart';
import 'data/network/dio_client.dart';
import 'data/network/interceptors/logging_interceptor.dart';
import 'data/network/interceptors/error_interceptor.dart';
import 'data/datasources/remote/nominatim/nominatim_remote_data_source.dart';
import 'data/datasources/remote/countries/countries_remote_data_source.dart';
import 'data/datasources/remote/wikipedia/wikipedia_remote_data_source.dart';
import 'data/datasources/eco_guide/eco_guide_local_data_source.dart';
import 'data/repositories/eco_guide_repository_impl.dart';
import 'data/datasources/repair/repair_local_data_source.dart';
import 'data/repositories/repair_repository_impl.dart';
import 'domain/usecases/geocoding/geocode_address_usecase.dart';
import 'domain/usecases/geocoding/search_addresses_usecase.dart';
import 'domain/usecases/geocoding/search_addresses_in_city_usecase.dart';
import 'domain/usecases/geocoding/search_addresses_by_country_usecase.dart';
import 'domain/usecases/geocoding/search_objects_by_type_usecase.dart';
import 'domain/usecases/countries/get_all_countries_usecase.dart';
import 'domain/usecases/countries/get_country_by_name_usecase.dart';
import 'domain/usecases/countries/get_countries_by_region_usecase.dart';
import 'domain/usecases/countries/get_countries_by_subregion_usecase.dart';
import 'domain/usecases/countries/get_countries_by_capital_usecase.dart';
import 'domain/usecases/wikipedia/search_wikipedia_articles_usecase.dart';
import 'domain/usecases/wikipedia/get_wikipedia_page_content_usecase.dart';
import 'domain/usecases/wikipedia/get_wikipedia_category_articles_usecase.dart';
import 'domain/usecases/wikipedia/get_wikipedia_page_links_usecase.dart';
import 'domain/usecases/wikipedia/get_wikipedia_page_images_usecase.dart';
import 'features/listings/cubit/geocoding_cubit.dart';
import 'shared/app_theme.dart';
import 'shared/bloc_observer.dart';

void main() async {
  // Инициализация Flutter для веб
  WidgetsFlutterBinding.ensureInitialized();
  
  Bloc.observer = const AppBlocObserver();

  // Инициализация databaseFactory для веб-платформы (должна быть ДО любых операций с БД)
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
    debugPrint('✅ databaseFactory установлен для веб-платформы: ${databaseFactory.runtimeType}');
  } else {
    debugPrint('📱 Мобильная платформа, используется стандартный databaseFactory');
  }

  // Инициализация базы данных для всех платформ
  try {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database; // Инициализация БД
    debugPrint('✅ База данных инициализирована успешно');
    
    // Проверка количества записей в БД
    final count = await db.rawQuery('SELECT COUNT(*) as count FROM listings');
    final listingsCount = count.first['count'] as int;
    debugPrint('📊 Количество объявлений в БД после инициализации: $listingsCount');
  } catch (e, stackTrace) {
    debugPrint('❌ Ошибка инициализации БД: $e');
    debugPrint('Stack trace: $stackTrace');
    // Не прерываем выполнение, приложение должно работать даже если БД не инициализирована
  }
  
  // Инициализация зависимостей для Clean Architecture (Listings)
  final ListingsDataSource listingsDataSource = SQLiteListingsDataSource();
  
  final listingsRepository = ListingsRepositoryImpl(listingsDataSource);
  final getAllListingsUseCase = GetAllListingsUseCase(listingsRepository);
  final addListingUseCase = AddListingUseCase(listingsRepository);
  final deleteListingUseCase = DeleteListingUseCase(listingsRepository);
  final getListingByIdUseCase = GetListingByIdUseCase(listingsRepository);
  final getMyListingsUseCase = GetMyListingsUseCase(listingsRepository);
  
  final authCubit = AuthCubit();
  
  final listingsCubit = ListingsCubit(
    getAllListingsUseCase: getAllListingsUseCase,
    addListingUseCase: addListingUseCase,
    deleteListingUseCase: deleteListingUseCase,
    getListingByIdUseCase: getListingByIdUseCase,
    getMyListingsUseCase: getMyListingsUseCase,
    authCubit: authCubit,
  );
  final profileCubit = ProfileCubit();
  final profileSettingsCubit = ProfileSettingsCubit();
  
  // Инициализация сетевых клиентов
  // Nominatim API для геокодинга (OpenStreetMap)
  // Требуется User-Agent заголовок согласно правилам использования API
  final nominatimDio = Dio(BaseOptions(
    baseUrl: 'https://nominatim.openstreetmap.org',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'User-Agent': 'NeighborsApp/1.0 (Flutter App for local marketplace)',
      'Accept': 'application/json',
    },
  ));
  nominatimDio.interceptors.add(LoggingInterceptor());
  nominatimDio.interceptors.add(ErrorInterceptor());
  final nominatimClient = DioClient.fromDio(nominatimDio);
  final nominatimDataSource = NominatimRemoteDataSourceImpl(nominatimClient);
  
  // REST Countries API для экологических данных (5 запросов)
  final countriesClient = DioClient(
    baseUrl: 'https://restcountries.com',
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );
  final countriesDataSource = CountriesRemoteDataSourceImpl(countriesClient);
  
  // Use cases для REST Countries API
  final getAllCountriesUseCase = GetAllCountriesUseCase(countriesDataSource);
  final getCountryByNameUseCase = GetCountryByNameUseCase(countriesDataSource);
  final getCountriesByRegionUseCase = GetCountriesByRegionUseCase(countriesDataSource);
  final getCountriesBySubregionUseCase = GetCountriesBySubregionUseCase(countriesDataSource);
  final getCountriesByCapitalUseCase = GetCountriesByCapitalUseCase(countriesDataSource);
  
  // Wikipedia API для экологических данных (5 запросов)
  // MediaWiki API (основной)
  final wikipediaDio = Dio(BaseOptions(
    baseUrl: 'https://ru.wikipedia.org',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'User-Agent': 'NeighborsApp/1.0 (Flutter App for local marketplace)',
      'Accept': 'application/json',
    },
  ));
  wikipediaDio.interceptors.add(LoggingInterceptor());
  wikipediaDio.interceptors.add(ErrorInterceptor());
  final wikipediaClient = DioClient.fromDio(wikipediaDio);
  
  // REST API клиент для Wikipedia (для кратких описаний)
  final wikipediaRestDio = Dio(BaseOptions(
    baseUrl: 'https://ru.wikipedia.org',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'User-Agent': 'NeighborsApp/1.0 (Flutter App for local marketplace)',
      'Accept': 'application/json',
    },
  ));
  wikipediaRestDio.interceptors.add(LoggingInterceptor());
  wikipediaRestDio.interceptors.add(ErrorInterceptor());
  final wikipediaRestClient = DioClient.fromDio(wikipediaRestDio);
  
  final wikipediaDataSource = WikipediaRemoteDataSourceImpl(
    dioClient: wikipediaClient,
    restClient: wikipediaRestClient,
  );
  
  // Инициализация зависимостей для EcoGuide с Wikipedia API
  final ecoGuideLocalDataSource = EcoGuideLocalDataSource();
  final ecoGuideRepository = EcoGuideRepositoryImpl(
    ecoGuideLocalDataSource,
    overpassDataSource: null, // Убираем Overpass
    wikipediaDataSource: wikipediaDataSource,
  );
  
  // Use cases для Wikipedia API
  final searchWikipediaArticlesUseCase = SearchWikipediaArticlesUseCase(ecoGuideRepository);
  final getWikipediaPageContentUseCase = GetWikipediaPageContentUseCase(ecoGuideRepository);
  final getWikipediaCategoryArticlesUseCase = GetWikipediaCategoryArticlesUseCase(ecoGuideRepository);
  final getWikipediaPageLinksUseCase = GetWikipediaPageLinksUseCase(ecoGuideRepository);
  final getWikipediaPageImagesUseCase = GetWikipediaPageImagesUseCase(ecoGuideRepository);
  
  final ecoGuideCubit = EcoGuideCubit(
    repository: ecoGuideRepository,
    getAllCountriesUseCase: getAllCountriesUseCase,
    getCountryByNameUseCase: getCountryByNameUseCase,
    getCountriesByRegionUseCase: getCountriesByRegionUseCase,
    getCountriesBySubregionUseCase: getCountriesBySubregionUseCase,
    getCountriesByCapitalUseCase: getCountriesByCapitalUseCase,
    searchWikipediaArticlesUseCase: searchWikipediaArticlesUseCase,
    getWikipediaPageContentUseCase: getWikipediaPageContentUseCase,
    getWikipediaCategoryArticlesUseCase: getWikipediaCategoryArticlesUseCase,
    getWikipediaPageLinksUseCase: getWikipediaPageLinksUseCase,
    getWikipediaPageImagesUseCase: getWikipediaPageImagesUseCase,
  );
  
  // Инициализация зависимостей для Repair (упрощенная версия без Overpass)
  final repairLocalDataSource = RepairLocalDataSource();
  final repairRepository = RepairRepositoryImpl(
    repairLocalDataSource,
    overpassDataSource: null, // Убираем Overpass
  );
  final repairCubit = RepairCubit(
    repository: repairRepository,
  );
  
  // Инициализация use cases для геокодинга (Nominatim API - 5 запросов)
  final geocodeAddressUseCase = GeocodeAddressUseCase(nominatimDataSource);
  final searchAddressesUseCase = SearchAddressesUseCase(nominatimDataSource);
  final searchAddressesInCityUseCase = SearchAddressesInCityUseCase(nominatimDataSource);
  final searchAddressesByCountryUseCase = SearchAddressesByCountryUseCase(nominatimDataSource);
  final searchObjectsByTypeUseCase = SearchObjectsByTypeUseCase(nominatimDataSource);
  
  // GeocodingCubit для управления геокодингом (все 5 запросов Nominatim)
  final geocodingCubit = GeocodingCubit(
    geocodeAddressUseCase: geocodeAddressUseCase,
    searchAddressesUseCase: searchAddressesUseCase,
    searchAddressesInCityUseCase: searchAddressesInCityUseCase,
    searchAddressesByCountryUseCase: searchAddressesByCountryUseCase,
    searchObjectsByTypeUseCase: searchObjectsByTypeUseCase,
  );
  
  // REST Countries API use cases будут добавлены позже
  
  final ecoImpactCubit = EcoImpactCubit();
  
  // Инициализация зависимостей для Support
  final SupportDataSource supportDataSource = SQLiteSupportDataSource();
  final supportRepository = SupportRepositoryImpl(supportDataSource);
  final createTicketUseCase = CreateTicketUseCase(supportRepository);
  final getAllTicketsUseCase = GetAllTicketsUseCase(supportRepository);
  final supportCubit = SupportCubit(
    createTicketUseCase: createTicketUseCase,
    getAllTicketsUseCase: getAllTicketsUseCase,
  );

  final appRouter = AppRouter(authCubit: authCubit);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<ListingsCubit>.value(value: listingsCubit),
        BlocProvider<GeocodingCubit>.value(value: geocodingCubit),
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