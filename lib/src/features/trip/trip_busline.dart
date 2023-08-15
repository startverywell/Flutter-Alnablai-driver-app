import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TripBusLine extends StatefulWidget {
  const TripBusLine({
    Key? key,
    required this.info,
  }) : super(key: key);

  final Trip info;

  @override
  State<TripBusLine> createState() => _TripBusLineState();
}

class _TripBusLineState extends State<TripBusLine> {
  bool _dateType = true;

  getDateType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _dateType = sharedPreferences.getBool("dateType") ?? true;
    });
  }

  @override
  void initState() {
    super.initState();
    getDateType();
  }

  Widget _buildTimeLineRow(BuildContext context) {
    final dateTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 26.sp,
      color: kColorSecondaryGrey,
    );
    final timeTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 22.sp,
      color: kColorPrimaryBlue,
    );

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.info.getStartDateStr(_dateType),
              style: dateTextStyle,
            ),
            Text(
              widget.info
                  .getStartTimeStr()
                  .replaceAll("AM", AppLocalizations.of(context).AM)
                  .replaceAll("PM", AppLocalizations.of(context).PM),
              style: timeTextStyle,
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.info.getEndDateStr(_dateType),
              style: dateTextStyle,
            ),
            Text(
              widget.info
                  .getEndTimeStr()
                  .replaceAll("AM", AppLocalizations.of(context).AM)
                  .replaceAll("PM", AppLocalizations.of(context).PM),
              style: timeTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBusRow() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kColorPrimaryBlue),
        ),
      ),
      child: Row(
        children: [
          Image(
            width: 150.w,
            image: const AssetImage('assets/images/bus_from.png'),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image(
                  width: 25.w,
                  image: const AssetImage('assets/images/bus_time.png'),
                ),
                const SizedBox(width: 2),
                Text(
                  widget.info.getDurationStr(),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 22.sp,
                    color: kColorPrimaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Image(
            width: 50.w,
            image: const AssetImage('assets/images/bus_to.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseRow() {
    final courseTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w700,
      fontSize: 26.sp,
      color: const Color(0xFF4C4C4C),
    );
    final cityTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 24.sp,
      color: const Color(0xFFB3B3B3),
    );

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.info.orgArea, style: courseTextStyle),
            Text(widget.info.orgCity, style: cityTextStyle),
          ],
        ),
        const Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.info.destArea, style: courseTextStyle),
            Text(widget.info.destCity, style: cityTextStyle),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.6),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20.w)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeLineRow(context),
          SizedBox(height: 10.h),
          _buildBusRow(),
          SizedBox(height: 10.h),
          _buildCourseRow(),
        ],
      ),
    );
  }
}
