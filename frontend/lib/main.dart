import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'app/data/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await GetStorage.init();
  } catch (e) {
    debugPrint('GetStorage initialization note: $e');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const CreditSeaApp());
}

class CreditSeaApp extends StatelessWidget {
  const CreditSeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CreditSea',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
