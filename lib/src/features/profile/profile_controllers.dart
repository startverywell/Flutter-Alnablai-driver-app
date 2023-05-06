import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/features/profile/profile_repository.dart';
import 'dart:developer' as developer;

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
}

final editProfileCtrProvider = StateNotifierProvider.autoDispose<
    EditProfileController, AsyncValue<Profile?>>((ref) {
  return EditProfileController(
      profileRepo: ref.watch(profileRepositoryProvider));
});
