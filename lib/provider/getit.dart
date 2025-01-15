import 'package:fyp2/navigation_service.dart';
import 'package:fyp2/view/home_screen_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerFactory(() => HomeScreenViewModel());

}
