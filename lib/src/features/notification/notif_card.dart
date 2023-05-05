import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/notification/notif.dart';
import 'package:go_router/go_router.dart';

class NotifCard extends StatelessWidget {
  const NotifCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);

  final Notif info;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.w);
    const textColor = Color(0xFF333333);
    String avatar = info.clientAvatar;
    if (avatar == "http://167.86.102.230/alnabali/public/uploads/image/") {
      avatar =
          "http://167.86.102.230/alnabali/public/images/admin/client_default.png";
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80.w, vertical: 4.h),
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          GestureDetector(
            onTap: () async {
              await DioClient.doReadAt(info.id.toString());
              // ignore: use_build_context_synchronously
              context.pushNamed(
                AppRoute.tripDetail.name,
                params: {'tripId': info.tripId},
              );
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 1),
                    blurRadius: 4.0,
                  )
                ],
                borderRadius: borderRadius,
              ),
              child: Material(
                borderRadius: borderRadius,
                child: InkWell(
                  borderRadius: borderRadius,
                  // onTap: await DioClient.doReadAt(info.tripId),
                  onTap: null, //onPressed,
                  //splashColor: kColorPrimaryBlue.withOpacity(0.1),
                  //splashFactory: InkSplash.splashFactory,
                  child: Container(
                    height: 200.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 50.h,
                              backgroundColor: Colors.transparent,
                              onBackgroundImageError: (exception, stackTrace) {
                                avatar =
                                    "http://167.86.102.230/alnabali/public/images/admin/client_default.png";
                              },
                              backgroundImage: NetworkImage(avatar),
                            ),
                            Text(
                              info.getNotifTitle(),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 28.sp,
                                color: getStatusColor(info.status),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 50.w),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info.tripName,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 40.sp,
                                  color: info.readAt == ''
                                      ? textColor
                                      : Colors.grey,
                                  // color: textColor,
                                ),
                              ),
                              Text(
                                // getNotifyText(info.status, context),
                                info.message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 38.sp,
                                  color: info.readAt == ''
                                      ? textColor
                                      : Colors.grey,
                                  // color: textColor,
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              info.getNotifyTimeText(),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 28.sp,
                color: kColorPrimaryGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
