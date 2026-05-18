import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/core/navigation/app_router.dart';
import 'package:builder_bridge/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // sqflite is native-only — skip on web
  if (!kIsWeb) {
    await DatabaseHelper().init();
  }

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
