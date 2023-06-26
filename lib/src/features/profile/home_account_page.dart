import 'dart:developer' as developer;
import 'package:alnabali_driver/src/features/profile/profile_repository.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/profile/profile_controllers.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAccountPage extends ConsumerStatefulWidget {
  const HomeAccountPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeAccountPage> createState() => _HomeAccountPageState();
}

class _HomeAccountPageState extends ConsumerState<HomeAccountPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String version = '--';
  String buildNumber = '--';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _tabController = TabController(length: 2, vsync: this);
    setLang();

    ref.read(homeAccountCtrProvider.notifier).doGetProfile();
  }

  setLang() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final currentLang = sharedPreferences.getString("lang");
    if (currentLang == 'en') {
      _tabController.index = 0;
    } else {
      _tabController.index = 1;
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    developer.log('PackageInfo: ${info.version} ${info.buildNumber}');
    setState(() {
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  Widget _buildSummaryInfo(int index, String value, BuildContext context) {
    double iconHeight;
    String greyText;
    if (index == 0) {
      iconHeight = 77.h;
      greyText = AppLocalizations.of(context).workingHours;
    } else if (index == 1) {
      iconHeight = 57.h;
      greyText = AppLocalizations.of(context).totalDistance;
    } else {
      iconHeight = 89.h;
      greyText = AppLocalizations.of(context).totalTrips;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            height: iconHeight,
            child: Image.asset('assets/images/user_icon$index.png'),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 46.sp,
              color: kColorPrimaryBlue,
            ),
          ),
          Text(
            greyText,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 32.sp,
              color: const Color(0xFF808080),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(homeAccountCtrProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(homeAccountCtrProvider);
    final profile = ref.watch(profileStateChangesProvider).value;

    developer.log('HomeAccountPage::build() - profile=${profile?.nameEN}');

    final btnStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: kColorPrimaryBlue)),
      ),
    );
    final btnTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 44.sp,
      color: kColorPrimaryBlue,
    );
    final btnW = 620.w;
    final btnH = 80.h;

    return ProgressHUD(
      inAsyncCall: state.isLoading,
      opacity: 0,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50.h),
                  child: SizedBox.expand(
                    child: CustomPaint(painter: AccountBgPainter()),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(homeAccountCtrProvider.notifier)
                        .doGetProfile();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30.h),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: kColorAvatarBorder, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 165.h,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(profile?.profileImage ?? ""),
                            onBackgroundImageError: (exception, stackTrace) {
                              developer.log(
                                  'HomeAccountPage::build() - onBackgroundImageError() - exception=$exception, stackTrace=$stackTrace');
                            },
                          ),
                        ),
                        Flexible(child: SizedBox(height: 20.h)),
                        Text(
                          profile?.nameEN ??
                              AppLocalizations.of(context).unknown,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 45.sp,
                            color: kColorPrimaryBlue,
                          ),
                        ),
                        Flexible(child: SizedBox(height: 20.h)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildSummaryInfo(
                                0, '${profile?.workingHours ?? 0}', context),
                            _buildSummaryInfo(1,
                                '${profile?.totalDistance ?? 0} KM', context),
                            _buildSummaryInfo(
                                2, '${profile?.totalTrips ?? 0}', context),
                          ],
                        ),
                        Container(
                          height: 100.h,
                          margin: EdgeInsets.only(
                            left: 250.w,
                            right: 250.w,
                            top: 46.h,
                            bottom: 120.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                kColorPrimaryBlue,
                                Color(0xFF0083A6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: kColorPrimaryBlue,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white,
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 36.sp,
                            ),
                            tabs: [
                              Tab(text: 'English'.hardcoded),
                              Tab(text: 'عربى'.hardcoded),
                            ],
                            onTap: (index) async {
                              ref
                                  .read(langCodeProvider.notifier)
                                  .saveLang(index == 0 ? 'en' : 'ar');
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: state.isLoading
                              ? null
                              : () =>
                                  context.pushNamed(AppRoute.editProfile.name),
                          style: btnStyle,
                          child: Container(
                            alignment: Alignment.center,
                            width: btnW,
                            height: btnH,
                            child: Text(
                                AppLocalizations.of(context).editProfile2,
                                style: btnTextStyle),
                          ),
                        ),
                        Flexible(child: SizedBox(height: 10.h)),
                        TextButton(
                          onPressed: state.isLoading
                              ? null
                              : () =>
                                  context.pushNamed(AppRoute.changePwd.name),
                          style: btnStyle,
                          child: Container(
                            alignment: Alignment.center,
                            width: btnW,
                            height: btnH,
                            child: Text(AppLocalizations.of(context).changePwd2,
                                style: btnTextStyle),
                          ),
                        ),
                        Flexible(child: SizedBox(height: 10.h)),
                        TextButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context
                                  .pushNamed(AppRoute.supervisorCall.name),
                          style: btnStyle,
                          child: Container(
                            alignment: Alignment.center,
                            width: btnW,
                            height: btnH,
                            child: Text(
                                AppLocalizations.of(context).callAppSupervisor,
                                style: btnTextStyle),
                          ),
                        ),
                        Flexible(child: SizedBox(height: 90.h)),
                        TextButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  showLogoutDialog(context).then((value) {
                                    if (value != null && value == true) {
                                      ref
                                          .read(homeAccountCtrProvider.notifier)
                                          .doLogout();
                                      context.pushNamed(AppRoute.login.name);
                                    }
                                  });
                                },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kColorPrimaryBlue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: const BorderSide(
                                      color: kColorPrimaryBlue)),
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: btnW,
                            height: btnH,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 40.w),
                                  height: 53.h,
                                  child: Image.asset(
                                      'assets/images/user_icon_logout.png'),
                                ),
                                Text(
                                  AppLocalizations.of(context).logOut,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 44.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(child: SizedBox(height: 50.h)),
                        Text(
                          '${AppLocalizations.of(context).appVersion} $version.$buildNumber',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 36.sp,
                            color: kColorPrimaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
