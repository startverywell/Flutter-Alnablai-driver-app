import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/exceptions/app_exception.dart';
import 'package:alnabali_driver/src/features/auth/auth_repository.dart';
import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/features/profile/supervisor.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';

class ProfileRepository {
  ProfileRepository({required this.authRepo});

  final AuthRepository authRepo;
  //Profile? _profile;

  Profile? get currProfile => _profileState.value;

  final _profileState = InMemoryStore<Profile?>(null);
  Stream<Profile?> profileStateChanges() => _profileState.stream;

  // * -------------------------------------------------------------------------

  Future<Profile?> doGetProfile() async {
    final data = await DioClient.getProfile(authRepo.uid!);
    developer.log('doGetProfile() returned: $data');

    try {
      Profile profileData = Profile.fromMap(data);
      developer.log('doGetProfile222() returned: $profileData');
    } catch (e) {
      developer.log('doGetProfile222() error=$e');
    }
    try {
      _profileState.value = Profile.fromMap(data);
    } catch (e) {
      developer.log('doGetProfile() error=$e');
    }

    return _profileState.value;
  }

  // * -------------------------------------------------------------------------

  Future<Profile?> doChangePassword(String currPwd, String newPwd) async {
    final data = await DioClient.postChangePwd(authRepo.uid!, currPwd, newPwd);
    developer.log('doChangePassword() returned: $data');

    var result = data['result'];
    if (result == 'Changed successfully') {
      return _profileState.value;
    } else if (result == 'Invalid Driver') {
      throw const AppException.userNotFound();
    } else if (result == 'Invalid Password') {
      throw const AppException.wrongPassword();
    }

    return null;
  }

  // * -------------------------------------------------------------------------

  Future<Profile?> doEditProfile(
      String name, String phone, String birthday, String address) async {
    final data = await DioClient.postProfileEdit(
        authRepo.uid!, name, phone, birthday, address);
    developer.log('doEditProfile() returned: $data');

    var result = data['result'];
    if (result == 'Update successfully') {
      // update local profile data.
      _profileState.value =
          _profileState.value?.copyWith(name, phone, birthday, address);
      return _profileState.value;
    } else if (result == 'Invalid Driver') {
      throw const AppException.userNotFound();
    }

    return null;
  }

  Future<String?> doUploadfile(File image) async {
    final data = await DioClient.postUpload(authRepo.uid!, image);
    developer.log('doEditProfile() returned: $data');

    var result = data['result'];
    return result.toString();
    // if (result == 'success') {
    //   return true;
    // } else {
    //   throw const AppException.userNotFound();
    // }
  }

  Future<bool?> deleteImage() async {
    final data = await DioClient.deleteImage(authRepo.uid!);
    developer.log('doEditProfile() returned: $data');

    var result = data['result'];
    if (result == 'success') {
      return true;
    } else {
      throw const AppException.userNotFound();
    }
  }

  // * -------------------------------------------------------------------------

  Future<Profile?> doLogout() async {
    // clear profile and uid, later we may need to notify server...
    _profileState.value = null;
    authRepo.doLogOut();

    return null;
  }

  //%-------------------------getSuperVisor----------------------------
  SuperVisorList _visors = [];
  Future<SuperVisorList> doFetchSuperVisors() async {
    dynamic data = await DioClient.doFetchSuperVisors();
    final result = data['supervisor'];
    if (result is List) {
      try {
        _visors = result.map((data) => SuperVisor.fromMap(data)).toList();
        developer.log('doFetchNotifs() src=${_visors.toString()}');
      } catch (e) {
        developer.log('doFetchNotifs() error=$e');
      }
      return _visors;
    } else {
      throw UnimplementedError;
    }
  }
}

final profileRepositoryProvider = StateProvider<ProfileRepository>((ref) {
  return ProfileRepository(authRepo: ref.watch(authRepositoryProvider));
});

final profileStateChangesProvider = StreamProvider<Profile?>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.profileStateChanges();
});
