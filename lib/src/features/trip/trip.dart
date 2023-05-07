// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';

@immutable
class Trip {
  const Trip({
    required this.id,
    required this.status,
    required this.clientName,
    required this.tripName,
    required this.busNo,
    required this.busSizeId,
    required this.startDate,
    required this.endDate,
    required this.orgArea,
    required this.orgCity,
    required this.destArea,
    required this.destCity,
    required this.details,
    required this.clientAvatar,
    required this.trip_id,
    required this.tran_id,
  });

  final String id;
  final String trip_id;
  final String tran_id;
  final TripStatus status;
  final String clientName;
  final String tripName;
  final String busNo;
  final int busSizeId;
  // bus line data
  final DateTime startDate;
  final DateTime endDate;
  final String orgArea;
  final String orgCity;
  final String destArea;
  final String destCity;
  final String details;
  final String clientAvatar;

  String getTripTitleShort() => '# $id';

  String getStartDateStr() => DateFormat('E, dd/mm/yyyy').format(startDate);
  String getStartTimeStr() => DateFormat('hh:mm a').format(startDate);

  String getEndDateStr() => DateFormat('E, dd/mm/yyyy').format(endDate);
  String getEndTimeStr() => DateFormat('hh:mm a').format(endDate);

  String getDurationStr() {
    final Duration duration = endDate.difference(startDate);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

    return '${duration.inHours}:$twoDigitMinutes Min';
  }

  factory Trip.fromMap(Map<String, dynamic> data) {
    var status = kStatusMapper[data['status']] ?? TripStatus.pending;

    return Trip(
      id: data['id'].toString(),
      trip_id: data['trip_id'].toString(),
      tran_id: data['f_trip_id'].toString(),
      status: status,
      clientName: data['client_name'],
      tripName: data['trip_name'],
      busNo: data['bus_no'],
      busSizeId: data['bus_size_id'],
      startDate: DateFormat('y-m-d h:mm a')
          .parse('${data['start_date']} ${data['start_time']}'),
      endDate: DateFormat('y-m-d h:mm a')
          .parse('${data['end_date']} ${data['end_time']}'),
      orgArea: data['origin_area'],
      orgCity: data['origin_city'],
      destArea: data['destination_area'],
      destCity: data['destination_city'],
      details: data['details'] ?? '',
      clientAvatar: data['client_avatar'],
    );
  }

  Trip copyWith(TripStatus newStatus) {
    return Trip(
      id: id,
      trip_id: trip_id,
      status: newStatus,
      clientName: clientName,
      tripName: tripName,
      busNo: busNo,
      busSizeId: busSizeId,
      startDate: startDate,
      endDate: endDate,
      orgArea: orgArea,
      orgCity: orgCity,
      destArea: destArea,
      destCity: destCity,
      details: details,
      clientAvatar: clientAvatar,
      tran_id: tran_id,
    );
  }

  @override
  String toString() {
    return 'Trip(id: $id, status: $status, client: $clientName, '
        'busNo: $busNo, busSize: $busSizeId, '
        'startDate: $startDate, endDate: $endDate, '
        'org: $orgArea-$orgCity, dest: $destArea-$destCity), '
        'details: $details)';
  }
}

typedef TripList = List<Trip>;

@immutable
class DriverLocation {
  const DriverLocation({required this.orgLocation, required this.destLocation});

  final LatLng orgLocation;
  final LatLng destLocation;

  factory DriverLocation.fromMap(Map<String, dynamic> data) {
    return DriverLocation(
      orgLocation: LatLng(double.parse(data['origin_latitude']),
          double.parse(data['origin_longitude'])),
      destLocation: LatLng(double.parse(data['destination_latitude']),
          double.parse(data['destination_longitude'])),
    );
  }
}
