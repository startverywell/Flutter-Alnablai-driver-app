import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/features/auth/forget_mobile_screen.dart';
import 'package:alnabali_driver/src/features/auth/forget_otp_screen.dart';
import 'package:alnabali_driver/src/features/auth/forget_pwd_screen.dart';
import 'package:alnabali_driver/src/features/auth/login_screen.dart';
import 'package:alnabali_driver/src/features/profile/change_password_screen.dart';
import 'package:alnabali_driver/src/features/profile/edit_profile_screen.dart';
import 'package:alnabali_driver/src/features/trip/home_screen.dart';
import 'package:alnabali_driver/src/features/trip/trip_detail_screen.dart';
import 'package:alnabali_driver/src/features/trip/trip_nav_screen.dart';

enum AppRoute {
  login,
  forgetMobile,
  forgetOTP,
  forgetPwd,
  home,
  tripDetail,
  tripNavigation,
  editProfile,
  changePwd,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.login.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/forget_mobile',
        name: AppRoute.forgetMobile.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ForgetMobileScreen(),
        ),
      ),
      GoRoute(
        path: '/forget_otp',
        name: AppRoute.forgetOTP.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ForgetOTPScreen(),
        ),
      ),
      GoRoute(
        path: '/forget_pwd',
        name: AppRoute.forgetPwd.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ForgetPwdScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/trip_detail/:tripId',
        name: AppRoute.tripDetail.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: TripDetailScreen(tripId: state.params['tripId']!),
        ),
      ),
      GoRoute(
        path: '/navigation/:tripId',
        name: AppRoute.tripNavigation.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: TripNavScreen(tripId: state.params['tripId']!),
        ),
      ),
      GoRoute(
        path: '/edit_profile',
        name: AppRoute.editProfile.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/change_pwd',
        name: AppRoute.changePwd.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const ChangePasswordScreen(),
        ),
      ),
    ],
  );
});
