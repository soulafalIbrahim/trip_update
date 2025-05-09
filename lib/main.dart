import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';
import 'package:trip/binding/initial_bindings.dart';
import 'package:trip/core/constant/color.dart';
import 'package:trip/core/constant/routes.dart';
import 'package:trip/data/helpers/pref.dart';
import 'package:trip/routes.dart';
import 'core/localization/my_local.dart';
import 'core/services/services.dart';
import 'firebase_options.dart';
import 'view/account/change_language/change_langauge_controller/change_langauge_controller.dart';

void main() async {
  try {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase with error handling
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () =>
            throw TimeoutException('Firebase initialization timeout'),
      );
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
      // Continue without Firebase if it fails
    }

    // Initialize Hive with error handling
    try {
      await Pref.initializeHive().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Hive initialization timeout'),
      );
    } catch (e) {
      debugPrint('Hive initialization error: $e');
      // Continue without Hive if it fails
    }

    // Initialize Settings with error handling
    try {
      await Settings.init(cacheProvider: SharePreferenceCache()).timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            throw TimeoutException('Settings initialization timeout'),
      );
    } catch (e) {
      debugPrint('Settings initialization error: $e');
      // Continue without Settings if it fails
    }

    // Set error handling for the app
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Flutter error: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');
    };

    // Set up error handling for uncaught errors
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Uncaught error: $error');
      debugPrint('Stack trace: $stack');
      return true;
    };
     asyncingData();
    runApp(const MyApp());
  } catch (e, stack) {
    debugPrint('Startup error: $e');
    debugPrint('Stack trace: $stack');

    // Show error UI instead of crashing
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Error: ${e.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    main(); // Retry initialization
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ChangeLangaugeController controller = Get.put(ChangeLangaugeController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip',
      initialRoute: AppRoutes.splashScreen,
      getPages: routes,
      initialBinding: InitialBindings(),
      locale:controller.initial,
      translations: MyLocal(),
      home: Scaffold(
        backgroundColor: AppColor.dark,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColor.appColor,
          ),
        ),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
