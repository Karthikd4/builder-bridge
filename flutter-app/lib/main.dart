import 'dart:io' show Platform;

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/core/navigation/app_router.dart';
import 'package:builder_bridge/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set platform database factory before any DB access
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Disable runtime font fetching — use cached fonts or system fallback.
  // Eliminates first-render network stall on emulator/device.
  GoogleFonts.config.allowRuntimeFetching = false;

  // init() opens the DB and seeds missing data — runs fast on subsequent starts.
  await DatabaseHelper().init();

  runApp(const ProviderScope(child: BuilderBridgeApp()));
}

class BuilderBridgeApp extends ConsumerWidget {
  const BuilderBridgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'BuilderBridge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
