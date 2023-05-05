import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackCard extends StatefulWidget {
  const TrackCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final TransactionList info;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  Widget buildTrackRow(
    BuildContext context,
    TripStatus st,
    String stTime,
    Color clr,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SizedBox(
                  width: 70.w,
                  child: Image.asset('assets/images/track_bg.png', color: clr),
                ),
                SizedBox(
                  width: 24.w,
                  child: Image.asset('assets/images/track_icon.png'),
                ),
              ],
            ),
            isLast
                ? const SizedBox()
                : Dash(
                    direction: Axis.vertical,
                    length: 80.h,
                    dashColor: clr,
                  ),
          ],
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTabTitleFromID(st, context),
                  style: TextStyle(
                    color: kColorPrimaryBlue,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 30.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  getTrackExplain(st, context),
                  style: TextStyle(
                    color: kColorPrimaryGrey,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 28.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 26.h),
          child: Text(
            stTime,
            style: TextStyle(
              color: kColorPrimaryBlue,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTracks(BuildContext context) {
    TripStatus lastStatus = TripStatus.all;
    if (widget.info.isNotEmpty) {
      lastStatus = widget.info.last.newStatus;
    }
    final trackColor = getStatusColor(lastStatus);

    List<Widget> widgetList = [];
    int i = 1;
    // int j = 1;
    for (final t in widget.info) {
      // if (j <= 2) {
        print("status_status" + t.newStatus.toString());
        widgetList.add(buildTrackRow(
          context,
          t.newStatus,
          t.getUpdateTimeStr(),
          trackColor,
          i == widget.info.length,
          // i == 2,
        ));
      // }
      i++;
      // j++;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgetList,
      // children: widgetList.reversed.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80.w, vertical: 120.h),
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 80.h),
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
      child: buildTracks(context),
    );
  }
}
