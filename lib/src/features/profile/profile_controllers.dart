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

final langCodeProvider = StateNotifierProvider<LangCodeNotifier, String>(
    (ref) => LangCodeNotifier());

class LangCodeNotifier extends StateNotifier<String> {
  LangCodeNotifier() : super('en');
  loadLangCode() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final langCode = sharedPrefs.getString('lang') ?? "en";
    state = langCode;
  }

  saveLang(String lang) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('lang', lang);
    state = lang;
  }
}

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
