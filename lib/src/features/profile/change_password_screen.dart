import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/profile/profile_textfield.dart';
import 'package:alnabali_driver/src/features/profile/profile_controllers.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_validators.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _node = FocusScopeNode();
  final _curr = TextEditingController();
  final _new1 = TextEditingController();
  final _new2 = TextEditingController();

  final StringValidator pwdEmptyValidator = NonEmptyStringValidator();

  @override
  void dispose() {
    // TextEditingControllers should be always disposed.
    _node.dispose();
    _curr.dispose();
    _new1.dispose();
    _new2.dispose();

    super.dispose();
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();

    final String currPwd = _curr.text;
    final String new1Pwd = _new1.text;
    final String new2Pwd = _new2.text;

    // check validations.
    if (!pwdEmptyValidator.isValid(currPwd)) {
      showToastMessage(AppLocalizations.of(context).currentPwdCantBe);
      return;
    }
    if (!pwdEmptyValidator.isValid(new1Pwd)) {
      showToastMessage(AppLocalizations.of(context).pleaseInputNewPwd);
      return;
    }
    if (!pwdEmptyValidator.isValid(new2Pwd)) {
      showToastMessage(AppLocalizations.of(context).pleaseInputConfirmPwd);
      return;
    }
    if (new1Pwd != new2Pwd) {
      showToastMessage(AppLocalizations.of(context).newPwdsDoNotMatch);
      return;
    }

    // try to change password.
    final controller = ref.read(changePwdCtrProvider.notifier);
    controller.doChangePassword(currPwd, new1Pwd).then((value) {
      if (value == true) {
        _curr.clear();
        _new1.clear();
        _new2.clear();

        showToastMessage(AppLocalizations.of(context).changedPwdSuccess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(changePwdCtrProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(changePwdCtrProvider);

    final spacer = Flexible(child: SizedBox(height: 30.h));

    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: ProgressHUD(
            inAsyncCall: state.isLoading,
            child: Container(
              decoration: kBgDecoration,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 150.h),
                    child: Text(
                      AppLocalizations.of(context).changePwd,
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
                          margin: EdgeInsets.only(top: 260.h),
                          child: SizedBox.expand(
                            child: CustomPaint(painter: AccountBgPainter()),
                          ),
                        ),
                        FocusScope(
                          node: _node,
                          child: Column(
                            children: [
                              Container(
                                height: 192.h,
                                margin: EdgeInsets.only(top: 150.h),
                                child:
                                    Image.asset('assets/images/home_icon.png'),
                              ),
                              Flexible(flex: 2, child: SizedBox(height: 420.h)),
                              ProfileTextField(
                                txtFieldType: ProfileTextFieldType.currPassword,
                                controller: _curr,
                                onEditComplete: () {
                                  if (pwdEmptyValidator.isValid(_curr.text)) {
                                    _node.nextFocus();
                                  }
                                },
                              ),
                              spacer,
                              ProfileTextField(
                                txtFieldType: ProfileTextFieldType.newPassword,
                                controller: _new1,
                                onEditComplete: () {
                                  if (pwdEmptyValidator.isValid(_new1.text)) {
                                    _node.nextFocus();
                                  }
                                },
                              ),
                              spacer,
                              ProfileTextField(
                                txtFieldType:
                                    ProfileTextFieldType.confirmPassword,
                                controller: _new2,
                                onEditComplete: () {
                                  if (pwdEmptyValidator.isValid(_new2.text)) {
                                    _submit();
                                  }
                                },
                              ),
                              Flexible(child: SizedBox(height: 220.h)),
                              SizedBox(
                                width: 700.w,
                                height: 120.h,
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
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
                              //const Expanded(child: SizedBox(height: double.infinity)),
                            ],
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
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 95.h),
        child: SizedBox(
          height: 138.h,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
