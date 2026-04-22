import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipad/core/services/storage_service.dart';
import 'package:ipad/core/di/dependency_injection.dart';
import 'package:ipad/app/theme/app_theme.dart';
import 'package:ipad/app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await StorageService.init();
  await DependencyInjection.init();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PDF Study',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
