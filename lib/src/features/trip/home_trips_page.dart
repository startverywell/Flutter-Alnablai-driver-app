import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trips_list_controller.dart';
import 'package:alnabali_driver/src/features/trip/trips_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeTripsPage extends ConsumerStatefulWidget {
  const HomeTripsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeTripsPage> createState() => _HomeTripsPageState();
}

class _HomeTripsPageState extends ConsumerState<HomeTripsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryTabBarHMargin = 150.w;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(90.w),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 124.h,
            margin: EdgeInsets.only(
              left: primaryTabBarHMargin,
              right: primaryTabBarHMargin,
              top: 54.h,
              bottom: 34.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFB3B3B3),
              borderRadius: BorderRadius.circular(100),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: kColorPrimaryBlue,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 40.sp,
              ),
              tabs: [
                Tab(text: AppLocalizations.of(context).todayTrips),
                Tab(text: AppLocalizations.of(context).pastTrips),
              ],
              onTap: (index) {
                ref.read(tripsKindProvider.state).state =
                    TripKind.values[index];
              },
            ),
          ),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: const [
                TripsListView(kind: TripKind.today),
                TripsListView(kind: TripKind.past),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
