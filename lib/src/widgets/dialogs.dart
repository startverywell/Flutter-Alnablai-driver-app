import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/widgets/gradient_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(40.h)));
final titlePadding = EdgeInsets.only(top: 80.h);
final contentPadding = EdgeInsets.symmetric(horizontal: 30.w, vertical: 80.h);
final actionsPadding = EdgeInsets.only(bottom: 70.h);
final yesTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
  fontSize: 26.sp,
);

final btnW = 280.w;
final btnH = 84.h;

Widget _buildDialogTitle(String companyName, String tripName) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        companyName,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 46.sp,
          color: const Color(0xFF333333),
        ),
      ),
      Text(
        tripName,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          fontSize: 38.sp,
          color: kColorPrimaryGrey,
        ),
      ),
    ],
  );
}

// * ---------------------------------------------------------------------------
// * Trip Accept/Finish Okay Dialog
// * ---------------------------------------------------------------------------

Future<void> showOkayDialog(
    BuildContext context, Trip info, TripStatus okStatus) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      String title = '';
      if (okStatus == TripStatus.accepted) {
        title = '${AppLocalizations.of(context).youHaveAccepted}${info.id}';
      } else if (okStatus == TripStatus.rejected) {
        title = '${AppLocalizations.of(context).youHaveRejected}${info.id}';
      } else if (okStatus == TripStatus.started) {
        title = '${AppLocalizations.of(context).youHaveStarted}${info.id}';
      } else if (okStatus == TripStatus.finished) {
        title = '${AppLocalizations.of(context).youHaveFinished}${info.id}';
      } else if (okStatus == TripStatus.canceled) {
        title = '${AppLocalizations.of(context).youHaveCanceled}${info.id}';
      }

      return AlertDialog(
        shape: dialogShape,
        titlePadding: titlePadding,
        title: _buildDialogTitle(info.clientName, info.tripName),
        contentPadding: contentPadding,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 60.h),
              height: 150.h,
              child: Image.asset('assets/images/icon_dialog.png'),
            ),
            SizedBox(
              width: 660.w,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 42.sp,
                  color: kColorPrimaryBlue,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: actionsPadding,
        actions: <Widget>[
          SizedBox(
            width: btnW,
            height: btnH,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryBlue,
                shape: const StadiumBorder(),
              ),
              child: Text(
                AppLocalizations.of(context).okay,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 26.sp,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// * ---------------------------------------------------------------------------
// * Trip Accept/Finish Confirm Dialog
// * ---------------------------------------------------------------------------

Future<bool?> showConfirmDialog(
  BuildContext context,
  String companyName,
  String tripName,
  String tripNo,
  TripStatus status,
) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      String title = '';
      if (status == TripStatus.pending) {
        title = '${AppLocalizations.of(context).areYouSureAccept}$tripNo?';
      } else if (status == TripStatus.accepted) {
        title = '${AppLocalizations.of(context).areYouSureAccept}$tripNo?';
      } else if (status == TripStatus.started) {
        title = '${AppLocalizations.of(context).areYouSureAccept}$tripNo?';
      }

      return AlertDialog(
        shape: dialogShape,
        titlePadding: titlePadding,
        title: _buildDialogTitle(companyName, tripName),
        contentPadding: contentPadding,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 70.h),
              height: 150.h,
              child: Image.asset('assets/images/icon_dialog.png'),
            ),
            SizedBox(
              width: 660.w,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 42.sp,
                  color: kColorPrimaryBlue,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: actionsPadding,
        buttonPadding: EdgeInsets.symmetric(horizontal: 6.w),
        actions: <Widget>[
          SizedBox(
            width: btnW,
            height: btnH,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryBlue,
                shape: const StadiumBorder(),
              ),
              child: Text(
                AppLocalizations.of(context).yes,
                style: yesTextStyle,
              ),
            ),
          ),
          GradientButton(
            width: btnW,
            height: btnH,
            onPressed: () {
              Navigator.pop(context, false);
            },
            title: AppLocalizations.of(context).no,
          ),
        ],
      );
    },
  );
}

// * ---------------------------------------------------------------------------
// * Trip Reject Dialog
// * ---------------------------------------------------------------------------

Future<String?> showRejectDialog(
  BuildContext context,
  String companyName,
  String tripName,
  String tripNo,
) async {
  final reasonCtr = TextEditingController();
  return showDialog<String>(
    context: context,
    barrierDismissible: true, // user cancel dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: dialogShape,
        titlePadding: titlePadding,
        title: _buildDialogTitle(companyName, tripName),
        contentPadding: contentPadding,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 30.h),
              height: 150.h,
              child: Image.asset('assets/images/icon_dialog.png'),
            ),
            SizedBox(
              width: 660.w,
              child: Text(
                '${AppLocalizations.of(context).youAreRejecting}$tripNo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 42.sp,
                  color: kColorPrimaryBlue,
                ),
              ),
            ),
            Text(
              AppLocalizations.of(context).pleaseFillTheReason,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 32.sp,
                color: kColorPrimaryGrey,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: TextField(
                controller: reasonCtr,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorAvatarBorder)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimaryBlue)),
                ),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 42.sp,
                  color: kColorPrimaryGrey,
                ),
                maxLines: 2,
                cursorColor: kColorPrimaryBlue,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: actionsPadding,
        actions: <Widget>[
          SizedBox(
            width: btnW,
            height: btnH,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, reasonCtr.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryBlue,
                shape: const StadiumBorder(),
              ),
              child: Text(
                AppLocalizations.of(context).reject,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 26.sp,
                ),
              ),
            ),
          ),
          GradientButton(
            width: btnW,
            height: btnH,
            onPressed: () {
              Navigator.pop(context, null);
            },
            title: AppLocalizations.of(context).no,
          ),
        ],
      );
    },
  );
}

// * ---------------------------------------------------------------------------
// * Trip Logout Dialog
// * ---------------------------------------------------------------------------

Future<bool?> showLogoutDialog(BuildContext context) {
  return showDialog<bool?>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: dialogShape,
        titlePadding: titlePadding,
        title: Align(
          child: Text(
            AppLocalizations.of(context).logOut2,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 46.sp,
              color: const Color(0xFF333333),
            ),
          ),
        ),
        contentPadding: contentPadding,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 30.h),
              height: 150.h,
              child: Image.asset('assets/images/icon_dialog.png'),
            ),
            SizedBox(
              width: 680.w,
              child: Text(
                AppLocalizations.of(context).areYouSureLogout,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 42.sp,
                  color: kColorPrimaryBlue,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: actionsPadding,
        buttonPadding: EdgeInsets.symmetric(horizontal: 4.w),
        actions: <Widget>[
          SizedBox(
            width: btnW,
            height: btnH,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryBlue,
                shape: const StadiumBorder(),
              ),
              child: Text(
                AppLocalizations.of(context).yes,
                style: yesTextStyle,
              ),
            ),
          ),
          GradientButton(
            width: btnW,
            height: btnH,
            onPressed: () {
              Navigator.pop(context, false);
            },
            title: AppLocalizations.of(context).no,
          ),
        ],
      );
    },
  );
}

// * ---------------------------------------------------------------------------
// * Show Toast Message
// * ---------------------------------------------------------------------------

void showToastMessage(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: kColorPrimaryBlue,
    textColor: Colors.white,
    fontSize: 40.sp,
  );
}
