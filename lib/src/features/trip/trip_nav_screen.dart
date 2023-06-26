import 'dart:developer' as developer;
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip_controller.dart';
import 'package:alnabali_driver/src/features/trip/trip_nav_dialogs.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TripNavScreen extends ConsumerStatefulWidget {
  const TripNavScreen({
    super.key,
    required this.tripId,
  });

  final String tripId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<TripNavScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late Trip trip;
  late DriverLocation _location;

  LocationData? currLocation;

  //List<LatLng> polylineCoordinates = [];
  final Set<Polyline> _polylines = <Polyline>{};

  BitmapDescriptor originIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  Timer? _updateTimer;

  Future<Polyline> _getRoutePolyline({
    required LatLng start,
    required LatLng finish,
    required Color color,
    required String id,
    int width = 6,
    bool isDash = false,
  }) async {
    // Generates every polyline between start and finish
    final polylinePoints = PolylinePoints();
    // Holds each polyline coordinate as Lat and Lng pairs
    final List<LatLng> polylineCoordinates = [];
    final startPoint = PointLatLng(start.latitude, start.longitude);
    final finishPoint = PointLatLng(finish.latitude, finish.longitude);

    final result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyAVPD5PbpuYRB2m6OzcC3NtgNTh7Q0B-QA',
      startPoint,
      finishPoint,
    );
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    }
    final polyline = Polyline(
      polylineId: PolylineId(id),
      color: color,
      points: polylineCoordinates,
      width: width,
      patterns: isDash ? [PatternItem.dash(100.w), PatternItem.gap(100.w)] : [],
    );
    return polyline;
  }

  Future<void> _getBusPolyline() async {
    final firsPolyline = await _getRoutePolyline(
      start: _location.orgLocation,
      finish: _location.destLocation,
      color: getStatusColor(trip.status),
      id: 'busLine',
    );
    _polylines.add(firsPolyline);
  }

  Future<void> _getAcceptPolyline() async {
    if (currLocation == null) return;

    if (trip.status == TripStatus.accepted) {
      final secondPolyline = await _getRoutePolyline(
        start: LatLng(currLocation!.latitude!, currLocation!.longitude!),
        finish: _location.orgLocation,
        color: Colors.blue,
        id: 'acceptLine',
        width: 4,
        isDash: true,
      );

      _polylines.removeWhere(
          (element) => element.polylineId == const PolylineId('acceptLine'));
      _polylines.add(secondPolyline);
    }

    //setState(() => _polylines = polylines);
  }

  void _getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        if (mounted == false) {
          return false;
        }
        //currentLocation = location;
        setState(() {
          currLocation = location;
        });
      },
    );

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) async {
        if (mounted == false) {
          return;
        }

        final zoom = await googleMapController.getZoomLevel();
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: zoom,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {
          currLocation = newLoc;
          _getAcceptPolyline();
          //developer.log('onLocation = $currentLocation');
        });
      },
    );
  }

  void _setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, //(size: Size(98.w, 98.h)),
      "assets/images/route_src.png",
    ).then(
      (icon) {
        originIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, //(size: Size(77.w, 103.h)),
      "assets/images/route_dest.png",
    ).then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, //(size: Size(180.w, 181.h)),
      "assets/images/route_bus.png",
    ).then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    trip =
        ref.read(tripControllerProvider.notifier).getTripInfo(widget.tripId)!;

    _location = const DriverLocation(
        orgLocation: LatLng(9.0764785, 7.3985741),
        destLocation: LatLng(9.098668, 7.382104));
    // ref.read(localtionCtrProvider.notifier).getDriverLocation();

    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //developer.log('Location Update: ${timer.tick}');
      if (currLocation != null) {
        final tripCtr = ref.read(localtionCtrProvider.notifier);
        tripCtr.doUpdateLocation(
            currLocation!.latitude!, currLocation!.longitude!, widget.tripId);
      }
    });
  }

  // * return distance in KM
  double _calcDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _onCurrMarkerTap() {
    double dist = 0;
    if (trip.status == TripStatus.accepted) {
      dist = _calcDistance(
        currLocation!.latitude!,
        currLocation!.longitude!,
        _location.orgLocation.latitude,
        _location.orgLocation.longitude,
      );
      if (dist > 0.2) {
        showNavStatusDialog(context, trip, false);
        return;
      }
    } else if (trip.status == TripStatus.started) {
      dist = _calcDistance(
        currLocation!.latitude!,
        currLocation!.longitude!,
        _location.destLocation.latitude,
        _location.destLocation.longitude,
      );
      if (dist > 0.2) {
        showNavStatusDialog(context, trip, true);
        return;
      }
    }

    showNavDialog(
      context,
      trip,
      (targetStatus, extra) {
        // ? this code duplicated with TripsListView...
        successCallback(value) {
          if (value == true) {
            showOkayDialog(
              context,
              trip,
              targetStatus,
            ).then(
              (value) {
                if (targetStatus == TripStatus.rejected ||
                    targetStatus == TripStatus.finished) {
                  context.pop(); // go back.
                }
              },
            );
          }

          // * rebuild screen for trip update.
          setState(() {
            trip = ref
                .read(tripControllerProvider.notifier)
                .getTripInfo(widget.tripId)!;
            developer.log('TRIP CHANGE $trip');
          });
        }

        ref
            .read(tripControllerProvider.notifier)
            .doChangeTrip(trip, targetStatus, extra)
            .then(successCallback);
      },
    );
  }

  @override
  void dispose() {
    if (_updateTimer != null) {
      _updateTimer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripControllerProvider);

    // _location = ref.read(localtionCtrProvider.notifier).currLocation!;
    _getBusPolyline();
    _getCurrentLocation();
    _setCustomMarkerIcon();

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: kBgDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 130.h, bottom: 60.h),
                child: Text(
                  '${AppLocalizations.of(context).trip} # ${trip.trip_id}',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 50.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: currLocation == null
                    ? const Center(child: CircularProgressIndicator())
                    : ProgressHUD(
                        inAsyncCall: state.isLoading,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currLocation!.latitude!,
                                currLocation!.longitude!),
                            zoom: 13.5,
                          ),
                          mapToolbarEnabled: false,
                          markers: {
                            Marker(
                              markerId: const MarkerId("source"),
                              position: _location.orgLocation,
                              icon: originIcon,
                            ),
                            Marker(
                              markerId: const MarkerId("destination"),
                              position: _location.destLocation,
                              icon: destinationIcon,
                            ),
                            Marker(
                              markerId: const MarkerId("currentLocation"),
                              anchor: const Offset(0.5, 0.5),
                              position: LatLng(currLocation!.latitude!,
                                  currLocation!.longitude!),
                              icon: currentLocationIcon,
                              onTap: _onCurrMarkerTap,
                            ),
                          },
                          polylines: _polylines,
                          // {
                          //   Polyline(
                          //     polylineId: const PolylineId("route"),
                          //     points: polylineCoordinates,
                          //     color: getStatusColor(info.status),
                          //     width: 6,
                          //   ),
                          // },
                          onMapCreated: (mapController) {
                            _controller.complete(mapController);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 95.h),
        child: SizedBox(
          height: 138.h,
          child: IconButton(
            onPressed: () {
              context.replaceNamed(
                AppRoute.tripDetail.name,
                params: {'tripId': widget.tripId},
              );
              // print(widget.tripId);
              // context.pop();
            },
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
