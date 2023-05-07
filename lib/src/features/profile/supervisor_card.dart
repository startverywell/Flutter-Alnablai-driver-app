import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLanucher;
import 'package:alnabali_driver/src/features/profile/supervisor.dart';

class SuperVisorCard extends StatelessWidget {
  const SuperVisorCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);

  final SuperVisor info;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.w);
    const textColor = Color(0xFF333333);
    String avatar = info.profileImage;
    if (avatar == "http://167.86.102.230/alnabali/public/uploads/supervisor/") {
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
              UrlLanucher.launch("tel://${info.phone}");
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
                  onTap: null, //onPressed,
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
                          ],
                        ),
                        SizedBox(width: 50.w),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info.username,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 40.sp,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                // getNotifyText(info.status, context),
                                info.phone,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 38.sp,
                                  color: textColor,
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
          ),
        ],
      ),
    );
  }
}
