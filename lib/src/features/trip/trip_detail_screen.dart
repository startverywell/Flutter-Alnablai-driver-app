import 'package:alnabali_driver/src/features/trip/transaction_view.dart';
import 'package:alnabali_driver/src/features/trip/trip_card.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip_controller.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  const TripDetailScreen({
    Key? key,
    required this.tripId,
  }) : super(key: key);

  final String tripId;

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen>
    with SingleTickerProviderStateMixin {
  late Trip info;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // ignore: avoid_print
    info =
        ref.read(tripControllerProvider.notifier).getTripInfo(widget.tripId)!;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: kBgDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: 80.h, bottom: 50.h),
                child: Column(
                  children: [
                    Text(
                      info.tripName,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        fontSize: 50.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${AppLocalizations.of(context).trip} # ${info.trip_id}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 44.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(90.w),
                    ),
                  ),
                  child: ProgressHUD(
                    inAsyncCall: state.isLoading,
                    child: Column(
                      children: [
                        Container(
                          height: 100.h,
                          margin: EdgeInsets.only(
                            left: 250.w,
                            right: 250.w,
                            top: 60.h,
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
                              Tab(text: AppLocalizations.of(context).details2),
                              Tab(text: AppLocalizations.of(context).tracking),
                            ],
                            onTap: (index) {},
                          ),
                        ),
                        Flexible(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 573.h,
                                    margin: EdgeInsets.only(
                                        top: 20.h, bottom: 60.h),
                                    child: Image.asset(
                                        'assets/images/trip_detail.png'),
                                  ),
                                  TripCard(
                                    info: info,
                                    onYesNo: (id, targetStatus, extra) {
                                      // ? this code duplicated with TripsListView...
                                      successCallback(value) {
                                        if (value == true) {
                                          showOkayDialog(
                                              context, info, targetStatus);
                                        }

                                        // * rebuild detail screen for card update.
                                        setState(() {
                                          info = ref
                                              .read(tripControllerProvider
                                                  .notifier)
                                              .getTripInfo(widget.tripId)!;
                                        });
                                      }

                                      ref
                                          .read(tripControllerProvider.notifier)
                                          .doChangeTrip(
                                              info, targetStatus, extra)
                                          .then(successCallback);
                                    },
                                    showDetail: true,
                                  ),
                                ],
                              ),
                              TransactionView(tripId: info.id),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 138.h,
        child: IconButton(
          onPressed: () => context.pop(),
          //iconSize: 89.h,
          icon: Image.asset('assets/images/btn_back.png'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
