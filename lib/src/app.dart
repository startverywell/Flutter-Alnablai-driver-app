import 'package:alnabali_driver/src/features/profile/profile_controllers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/routing/app_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlnabaliDriverApp extends ConsumerWidget {
  const AlnabaliDriverApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(langCodeProvider);

    return ScreenUtilInit(
      designSize: const Size(1125, 2436),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final goRouter = ref.watch(goRouterProvider);
        return MaterialApp.router(
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          title: 'Alnabali Driver',
          // theme: ThemeData(
          //     pageTransitionsTheme: const PageTransitionsTheme(builders: {
          //   TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          //   TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          // })),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(langCode),
        );
      },
    );
  }
}
