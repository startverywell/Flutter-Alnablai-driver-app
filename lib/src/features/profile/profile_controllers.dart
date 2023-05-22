import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/features/profile/supervisor.dart';
import 'package:alnabali_driver/src/features/profile/profile_repository.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

// * ---------------------------------------------------------------------------
// * HomeAccountController
// * ---------------------------------------------------------------------------

class HomeAccountController extends StateNotifier<AsyncValue<Profile?>> {
  HomeAccountController({required this.profileRepo})
      : super(const AsyncData(null));

  final ProfileRepository profileRepo;
  Profile? get currProfile => profileRepo.currProfile;

  Future<void> doGetProfile() async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => profileRepo.doGetProfile());
    if (mounted) {
      state = newState;
    }
  }

  Future<void> doLogout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => profileRepo.doLogout());
  }
}

final homeAccountCtrProvider = StateNotifierProvider.autoDispose<
    HomeAccountController, AsyncValue<Profile?>>((ref) {
  return HomeAccountController(
      profileRepo: ref.watch(profileRepositoryProvider));
});

final langCodeProvider = StateProvider<String>((ref) => 'en');
// final langCodeProvider = StateProvider<String>((ref) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   // Return a Future<String>
//   String? boolValue = prefs.getString('lang');
//   print(boolValue);
//   return boolValue ?? 'en';
// }).future.then((value) => value!); // Convert the Future<String> to a String using .then() method

// getLangValue() async {
//   final langCode = context.read(langCodeProvider).state;
//   return langCode;
// }

// getLangValue() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //Return bool
//   String? boolValue = prefs.getString('lang');
//   print(boolValue);
//   return boolValue ?? 'en';
// }

// final langCodeProvider = StateProvider<String>((ref) {
//   final prefs = SharedPreferences.getInstance();
//   // Try to get the language code from the preferences. If it's not available, return a default value.
//   final langCode = prefs.getString('lang') ?? 'en';
//   return langCode;
// });

// * ---------------------------------------------------------------------------
// * ChangePasswordController
// * ---------------------------------------------------------------------------

class ChangePasswordController extends StateNotifier<AsyncValue<Profile?>> {
  ChangePasswordController({required this.profileRepo})
      : super(const AsyncData(null));

  final ProfileRepository profileRepo;

  Future<bool> doChangePassword(String currPwd, String newPwd) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => profileRepo.doChangePassword(currPwd, newPwd));

    if (mounted) {
      state = newState;
    }

    return newState.hasValue;
  }
}

final changePwdCtrProvider = StateNotifierProvider.autoDispose<
    ChangePasswordController, AsyncValue<Profile?>>((ref) {
  return ChangePasswordController(
      profileRepo: ref.watch(profileRepositoryProvider));
});

// * ---------------------------------------------------------------------------
// * EditProfileController
// * ---------------------------------------------------------------------------

class EditProfileController extends StateNotifier<AsyncValue<Profile?>> {
  EditProfileController({required this.profileRepo})
      : super(const AsyncData(null));

  final ProfileRepository profileRepo;
  Profile? get currProfile => profileRepo.currProfile;

  Future<bool> doEditProfile(
      String name, String phone, String birthday, String address) async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(
        () => profileRepo.doEditProfile(name, phone, birthday, address));
    if (mounted) {
      state = newState;
    }

    return newState.hasValue;
  }

  Future<String?> doUploadfile(File image) async {
    state = const AsyncValue.loading();
    final nState =
        await AsyncValue.guard(() => profileRepo.doUploadfile(image));

    return nState.value;
  }

  Future<AsyncValue<bool?>> deleteImage() async {
    final nState = await AsyncValue.guard(() => profileRepo.deleteImage());

    return nState;
  }

  // Future
}

final editProfileCtrProvider = StateNotifierProvider.autoDispose<
    EditProfileController, AsyncValue<Profile?>>((ref) {
  return EditProfileController(
      profileRepo: ref.watch(profileRepositoryProvider));
});

// * ---------------------------------------------------------------------------
// * SuperVisorController
// * ---------------------------------------------------------------------------

class SuperVisorController extends StateNotifier<AsyncValue<SuperVisorList>> {
  SuperVisorController({required this.profileRepo})
      : super(const AsyncData([]));

  final ProfileRepository profileRepo;

  Future<void> doFetchSuperVisors() async {
    state = const AsyncValue.loading();
    final newState =
        await AsyncValue.guard(() => profileRepo.doFetchSuperVisors());

    if (mounted) {
      state = newState;
    }
  }
}

final superVisorCtrProvider = StateNotifierProvider.autoDispose<
    SuperVisorController, AsyncValue<SuperVisorList>>((ref) {
  return SuperVisorController(
      profileRepo: ref.watch(profileRepositoryProvider));
});
