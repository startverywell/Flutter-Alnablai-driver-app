// ignore_for_file: avoid_print

import 'dart:io';

import 'package:alnabali_driver/src/features/profile/edit_profile_validators.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/profile/profile_controllers.dart';
import 'package:alnabali_driver/src/features/profile/profile_textfield.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with EidtProfileValidators {
  final _node = FocusScopeNode();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _birthday = TextEditingController();
  final _address = TextEditingController();

  String _avatarImg = 'assets/images/user_avatar.png';
  String _nameEn = 'unknown';
  File? _image;

  Future<void> pickImage() async {
    final controller = ref.read(editProfileCtrProvider.notifier);
    Widget cancelButton = TextButton(
      child: Text(AppLocalizations.of(context).updated),
      onPressed: () {
        updateImage();
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(AppLocalizations.of(context).removed),
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          _image = null;
          _avatarImg = '';
        });
        controller.deleteImage();
      },
    );
    Widget endButton = TextButton(
      child: Text(AppLocalizations.of(context).canceled),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context).image_title),
      content: Text(AppLocalizations.of(context).update_image),
      actions: [
        cancelButton,
        continueButton,
        endButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> updateImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final File image = File(pickedFile.path);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(homeAccountCtrProvider.notifier).doGetProfile();
    // edit controllers must be initialized only once!
    var profile = ref.read(editProfileCtrProvider.notifier).currProfile;
    if (profile != null) {
      _name.text = profile.nameEN;
      _phone.text = profile.phone;
      _birthday.text = profile.birthday;
      _address.text = profile.address;
      _avatarImg = profile.profileImage;
      _nameEn = profile.nameEN;
    }
  }

  @override
  void dispose() {
    // TextEditingControllers should be always disposed.
    _node.dispose();
    _name.dispose();
    _phone.dispose();
    _birthday.dispose();
    _address.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final name = _name.text;
    final phone = _phone.text;
    final birth = _birthday.text;
    final address = _address.text;
    String? inputError;

    inputError = usernameErrorText(name, context);
    if (inputError != null) {
      showToastMessage(inputError);
      return;
    }
    inputError = phoneErrorText(phone, context);
    if (inputError != null) {
      showToastMessage(inputError);
      return;
    }
    inputError = birthErrorText(birth, context);
    if (inputError != null) {
      showToastMessage(inputError);
      return;
    }
    inputError = addressErrorText(address, context);
    if (inputError != null) {
      showToastMessage(inputError);
      return;
    }

    final controller = ref.read(editProfileCtrProvider.notifier);
    if (_image != null) {
      _avatarImg = (await controller.doUploadfile(_image!))!;
    }
    controller.doEditProfile(name, phone, birth, address).then((value) {
      if (value == true) {
        showToastMessage(AppLocalizations.of(context).updatedProfileSuccess);
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(editProfileCtrProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(editProfileCtrProvider);
    final profile = state.value;
    print('==========================================');

    final spacer = Flexible(child: SizedBox(height: 20.h));

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: kBgDecoration,
          child: ProgressHUD(
            inAsyncCall: state.isLoading,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 150.h),
                  child: Text(
                    AppLocalizations.of(context).editProfile,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 48.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 140.h),
                        child: SizedBox.expand(
                          child: CustomPaint(painter: AccountBgPainter()),
                        ),
                      ),
                      SizedBox(
                        child: FocusScope(
                          node: _node,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await ref
                                  .read(homeAccountCtrProvider.notifier)
                                  .doGetProfile();
                              var profile = ref
                                  .read(editProfileCtrProvider.notifier)
                                  .currProfile;
                              if (profile != null) {
                                _name.text = profile.nameEN;
                                _phone.text = profile.phone;
                                _birthday.text = profile.birthday;
                                _address.text = profile.address;
                                _avatarImg = profile.profileImage;
                                setState(() {
                                  _nameEn:
                                  profile.nameEN;
                                });
                                _nameEn = profile.nameEN;
                              }
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(child: SizedBox(height: 160.h)),
                                  GestureDetector(
                                    onTap: () {
                                      pickImage();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: kColorAvatarBorder,
                                            width: 1.0),
                                      ),
                                      child: _image == null
                                          ? CircleAvatar(
                                              radius: 165.h,
                                              backgroundColor: Colors.white,
                                              backgroundImage:
                                                  AssetImage(_avatarImg),
                                              // foregroundImage: profile != null
                                              //     ? NetworkImage(profile.profileImage)
                                              //     : null,
                                              foregroundImage:
                                                  NetworkImage(_avatarImg),
                                              onForegroundImageError:
                                                  (exception, stackTrace) {
                                                print(
                                                    'onForegroundImageError: $exception');
                                              },
                                            )
                                          : CircleAvatar(
                                              radius: 165.h,
                                              backgroundColor: Colors.white,
                                              backgroundImage:
                                                  FileImage(File(_image!.path)),
                                            ),
                                    ),
                                  ),
                                  Flexible(child: SizedBox(height: 30.h)),
                                  Text(
                                    profile?.nameEN ?? _nameEn,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 42.sp,
                                      color: kColorPrimaryBlue,
                                    ),
                                  ),
                                  Flexible(child: SizedBox(height: 160.h)),
                                  ProfileTextField(
                                    txtFieldType: ProfileTextFieldType.name,
                                    controller: _name,
                                    onEditComplete: () {
                                      if (usernameErrorText(
                                              _name.text, context) ==
                                          null) {
                                        _node.nextFocus();
                                      }
                                    },
                                  ),
                                  spacer,
                                  ProfileTextField(
                                    txtFieldType: ProfileTextFieldType.phone,
                                    controller: _phone,
                                    onEditComplete: () {
                                      if (phoneErrorText(
                                              _phone.text, context) ==
                                          null) {
                                        _node.nextFocus();
                                      }
                                    },
                                  ),
                                  spacer,
                                  ProfileTextField(
                                    txtFieldType:
                                        ProfileTextFieldType.dateOfBirth,
                                    controller: _birthday,
                                    onEditComplete: () {
                                      if (birthErrorText(
                                              _birthday.text, context) ==
                                          null) {
                                        _node.nextFocus();
                                      }
                                    },
                                  ),
                                  spacer,
                                  ProfileTextField(
                                    txtFieldType: ProfileTextFieldType.address,
                                    controller: _address,
                                    onEditComplete: () {
                                      _submit();
                                    },
                                  ),
                                  Flexible(child: SizedBox(height: 140.h)),
                                  SizedBox(
                                    width: 700.w,
                                    height: 120.h,
                                    child: ElevatedButton(
                                      onPressed: _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kColorPrimaryBlue,
                                        shape: const StadiumBorder(),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).save,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 42.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 100.h),
        child: SizedBox(
          height: 138.h,
          child: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
