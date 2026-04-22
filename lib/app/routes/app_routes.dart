import 'package:get/get.dart';
import 'package:ipad/features/document/presentation/views/home_view.dart';
import 'package:ipad/features/document/presentation/viewmodels/document_viewmodel.dart';
import 'package:ipad/features/settings/presentation/views/settings_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';

  static final routes = [
    GetPage(
      name: home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DocumentViewModel());
      }),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsView(),
    ),
  ];
}
