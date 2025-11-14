import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

class AppStateService {
  int totalUsers = 1542;
  int activeListings = 89;
  double appRating = 4.7;
  DateTime lastUpdate = DateTime.now();

  void updateAppStats({int? users, int? listings, double? rating}) {
    if (users != null) totalUsers = users;
    if (listings != null) activeListings = listings;
    if (rating != null) appRating = rating;
    lastUpdate = DateTime.now();
  }
}

void setupLocator() {
  locator.registerSingleton<AppStateService>(AppStateService());
}