import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/database/database_helper.dart';
import 'package:builder_bridge/core/theme/app_theme.dart';
import 'package:builder_bridge/features/admin/presentation/screens/admin_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web fetches fonts from Google CDN; on mobile use bundled assets only.
  GoogleFonts.config.allowRuntimeFetching = kIsWeb;

  await DatabaseHelper().init();

  runApp(const ProviderScope(child: BuilderBridgeAdminApp()));
}

class BuilderBridgeAdminApp extends StatelessWidget {
  const BuilderBridgeAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuilderBridge Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AdminShell(),
    );
  }
}
