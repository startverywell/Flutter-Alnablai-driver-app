import 'dart:developer' as developer;
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip_busline.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/widgets/gradient_button.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/progress_hud.dart';

typedef TripCardCallback = void Function(
    Trip info, TripStatus targetStatus, String? extra);

class TripCard extends StatefulWidget {
  const TripCard({
    Key? key,
    required this.info,
    required this.onYesNo,
    this.showDetail = false,
  }) : super(key: key);

  final Trip info;
  final TripCardCallback onYesNo;
  final bool showDetail;

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  String avatar = "";

  String _getStatusImgPath(TripStatus status) {
    return 'assets/images/trip_status${status.index}.png';
  }

  Widget _buildCompanyRow() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kColorAvatarBorder, width: 1.0),
          ),
          child: CircleAvatar(
            radius: 60.h,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(avatar),
            onBackgroundImageError: (exception, stackTrace) {
              setState(() {
                avatar =
                    "http://167.86.102.230/alnabali/public/images/admin/client_default.png";
              });
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.info.clientName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 32.sp,
                    color: kColorPrimaryGrey,
                  ),
                ),
                Text(
                  widget.info.tripName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 26.sp,
                    color: getStatusColor(widget.info.status),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).busNo,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 24.sp,
                color: kColorPrimaryBlue,
              ),
            ),
            Text(
              widget.info.busNo,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 34.sp,
                color: kColorPrimaryBlue,
              ),
            ),
            Text(
              AppLocalizations.of(context).passengers,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 24.sp,
                color: kColorPrimaryBlue,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 38.w,
                  child: Image.asset('assets/images/passengers.png'),
                ),
                SizedBox(width: 8.w),
                Text(
                  widget.info.busSizeId.toString(),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 34.sp,
                    color: kColorPrimaryBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRejectResonRow() {
    if (widget.info.status !=
        TripStatus.rejected /*|| widget.info.rejectReason.isEmpty*/) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.w, bottom: 4.h),
          child: Text(
            AppLocalizations.of(context).reasonForRejection,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 32.sp,
              color: kColorPrimaryBlue,
            ),
          ),
        ),
        Text(
          'reject reason...', // TODO: info.rejectReason,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 30.sp,
            color: kColorSecondaryGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.w, bottom: 4.h),
          child: Text(
            AppLocalizations.of(context).details,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 32.sp,
              color: kColorPrimaryBlue,
            ),
          ),
        ),
        Text(
          widget.info.details,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 30.sp,
            color: kColorPrimaryGrey,
          ),
        ),
        _buildRejectResonRow(),
      ],
    );
  }

  Widget _buildButtonsRow() {
    if (widget.info.status == TripStatus.pending ||
        widget.info.status == TripStatus.accepted ||
        widget.info.status == TripStatus.started) {
      final btnW = 280.w;
      final btnH = 84.h;

      // as default, suppose status is pending
      String yesTitle = AppLocalizations.of(context).accept;
      String noTitle = AppLocalizations.of(context).reject;
      if (widget.info.status == TripStatus.accepted) {
        yesTitle = AppLocalizations.of(context).start;
      } else if (widget.info.status == TripStatus.started) {
        yesTitle = AppLocalizations.of(context).finish;
        noTitle = AppLocalizations.of(context).navigation;
      }

      return SizedBox(
        height: btnH + 80.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: btnW,
              height: btnH,
              child: ElevatedButton(
                onPressed: () {
                  showConfirmDialog(
                    context,
                    widget.info.clientName,
                    widget.info.tripName,
                    widget.info.trip_id,
                    widget.info.status,
                  ).then((value) {
                    if (value == true) {
                      TripStatus targetStatus = TripStatus.all;
                      if (widget.info.status == TripStatus.pending) {
                        targetStatus = TripStatus.accepted;
                      } else if (widget.info.status == TripStatus.accepted) {
                        targetStatus = TripStatus.started;
                      } else if (widget.info.status == TripStatus.started) {
                        targetStatus = TripStatus.finished;
                      } else {
                        developer.log('TripCard: unknown state change...');
                        return;
                      }
                      widget.onYesNo(widget.info, targetStatus, null);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorPrimaryBlue,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  yesTitle,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 26.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GradientButton(
              width: btnW,
              height: btnH,
              onPressed: () {
                if (widget.info.status == TripStatus.started) {
                  context.replaceNamed(
                    AppRoute.tripNavigation.name,
                    params: {'tripId': widget.info.id},
                  );
                } else {
                  showRejectDialog(
                    context,
                    widget.info.clientName,
                    widget.info.tripName,
                    widget.info.trip_id,
                  ).then((value) {
                    if (value != null) {
                      widget.onYesNo(widget.info, TripStatus.rejected, value);
                    }
                  });
                }
              },
              title: noTitle,
            ),
          ],
        ),
      );
    } else {
      return SizedBox(height: 40.h);
    }
  }

  Widget _buildCardContents() {
    List<String> kStatusTitles = [
      AppLocalizations.of(context).none,
      AppLocalizations.of(context).pending,
      AppLocalizations.of(context).accepted,
      AppLocalizations.of(context).rejected,
      AppLocalizations.of(context).started,
      AppLocalizations.of(context).canceled,
      AppLocalizations.of(context).finished,
      AppLocalizations.of(context).fake,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 410.w,
              child: Image.asset(_getStatusImgPath(widget.info.status)),
            ),
            Text(
              kStatusTitles[widget.info.status.index],
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 40.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Text(
            '${AppLocalizations.of(context).trip} # ${widget.info.trip_id.toString()}',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 36.sp,
              color: getStatusColor(widget.info.status),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Column(
            children: [
              _buildCompanyRow(),
              SizedBox(height: 8.h),
              TripBusLine(info: widget.info),
              widget.showDetail ? _buildDetailRow() : const SizedBox(),
              _buildButtonsRow(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    avatar = widget.info.clientAvatar;
    if (avatar == "http://167.86.102.230/alnabali/public/uploads/image/") {
      avatar =
          "http://167.86.102.230/alnabali/public/images/admin/client_default.png";
    }

    return GestureDetector(
      onTap: () {
        if (widget.showDetail) {
          // here is in trip-detail-screen.
          if (widget.info.status == TripStatus.accepted ||
              widget.info.status == TripStatus.started) {
            context.replaceNamed(
              AppRoute.tripNavigation.name,
              params: {'tripId': widget.info.id},
            );
          }
        } else {
          // here is in trip-list-view.
          print(widget.info.id);
          context.pushNamed(
            AppRoute.tripDetail.name,
            params: {'tripId': widget.info.id},
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 40.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.all(Radius.circular(40.w)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildCardContents(),
      ),
    );
  }
}
