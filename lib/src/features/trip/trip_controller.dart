// ignore_for_file: avoid_print

import 'package:alnabali_driver/src/features/trip/transaction.dart';
import 'package:alnabali_driver/src/features/trip/trips_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/features/trip/trips_repository.dart';

class TripController extends StateNotifier<AsyncValue<bool>> {
  TripController({
    required this.tripsRepo,
  }) : super(const AsyncData(false));

  final TripsRepository tripsRepo;

  Trip? getTripInfo(String tripId) {
    return tripsRepo.getTripInfo(tripId);
  }

  Future<bool?> doChangeTrip(
      Trip info, TripStatus targetStatus, String? extra) async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(
        () => tripsRepo.doChangeTrip(info, targetStatus, extra));

    if (mounted) {
      state = newState;
    }

    return newState.value;
  }

  void saveToken(String token) async {
    tripsRepo.saveToken(token);
  }

  Future<bool> saveFCMToken(String fcm_token) async {
    dynamic result = await tripsRepo.saveFCMToken(fcm_token);
    return result;
  }
}

final tripControllerProvider =
    StateNotifierProvider.autoDispose<TripController, AsyncValue<void>>((ref) {
  final tripKind = ref.watch(tripsKindProvider.state).state;
  if (tripKind == TripKind.today) {
    return TripController(tripsRepo: ref.watch(todayTripsRepoProvider));
  } else {
    return TripController(tripsRepo: ref.watch(pastTripsRepoProvider));
  }
});

// * ---------------------------------------------------------------------------

class TransListController extends StateNotifier<AsyncValue<TransactionList>> {
  TransListController({
    required this.tripsRepo,
  }) : super(const AsyncData([]));

  final TripsRepository tripsRepo;

  Future<TransactionList?> doFetchTransaction(String tripId) async {
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => tripsRepo.doFetchTransaction(tripId));

    if (mounted) {
      state = newState;
    }

    if (newState.hasError) {
      return [];
    } else {
      return newState.value;
    }
  }
}

final transCtrProvider = StateNotifierProvider.autoDispose<TransListController,
    AsyncValue<TransactionList>>((ref) {
  final tripKind = ref.watch(tripsKindProvider.state).state;
  if (tripKind == TripKind.today) {
    return TransListController(tripsRepo: ref.watch(todayTripsRepoProvider));
  } else {
    return TransListController(tripsRepo: ref.watch(pastTripsRepoProvider));
  }
});

// * ---------------------------------------------------------------------------

class LocationController extends StateNotifier<AsyncValue<DriverLocation?>> {
  LocationController({
    required this.tripsRepo,
  }) : super(const AsyncData(null));

  final TripsRepository tripsRepo;
  DriverLocation? get currLocation => tripsRepo.currLocation;
  // * get location data. (silently)
  Future<void> getDriverLocation() async {
    print('===================aaaaaaaaaaa======');
    state = const AsyncValue.loading();
    final newState =
        await AsyncValue.guard(() => tripsRepo.getDriverLocation());
    if (mounted) {
      print(newState.value);
      state = newState;
    }
  }

  // * update location request must be done at behind. (silently)
  Future<bool> doUpdateLocation(double lat, double lon, String tripId) async {
    final newState = await AsyncValue.guard(
        () => tripsRepo.doUpdateLocation(lat, lon, tripId));

    return newState.hasValue;
  }
}

final localtionCtrProvider = StateNotifierProvider.autoDispose<
    LocationController, AsyncValue<DriverLocation?>>((ref) {
  return LocationController(tripsRepo: ref.watch(pastTripsRepoProvider));
});
