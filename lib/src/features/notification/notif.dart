import 'package:intl/intl.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Notification Model
// * ---------------------------------------------------------------------------

class Notif {
  const Notif(
      {required this.id,
      required this.tripId,
      required this.tripName,
      required this.clientName,
      required this.orgName,
      required this.destName,
      required this.message,
      required this.driverName,
      required this.status,
      required this.notifyDate,
      required this.notifyTime,
      required this.clientAvatar,
      required this.dispTripId,
      required this.readAt});

  final String id;
  final String tripId;
  final String tripName;
  final String clientName;
  final String orgName;
  final String destName;
  final String message;
  final DateTime notifyDate;
  final String driverName;
  final TripStatus status;
  final String clientAvatar;
  final String dispTripId;
  final String readAt;
  final String notifyTime;

  String getNotifTitle() => '#$dispTripId';
  String getNotifyTimeText() => DateFormat('hh:mm a').format(notifyDate);

  factory Notif.fromMap(Map<String, dynamic> data) {
    var status = kStatusMapper[data['status']] ?? TripStatus.pending;
    String time = data['updated_at'];
    time = time.split("T")[1];
    time = time.substring(0, 5);
    return Notif(
        id: data['id'].toString(),
        tripId: data['daily_trip_id'].toString(),
        tripName: data['trip_name'],
        clientName: data['client_name'],
        orgName: data['origin_name'],
        destName: data['destination_name'],
        message: data['message'],
        notifyDate: DateFormat('yyyy-MM-dd').parse('${data['created_at']}'),
        driverName: data['driver_name'].toString(),
        status: status,
        clientAvatar: data['client_avatar'],
        dispTripId: data['disp_trip_id'],
        notifyTime: time,
        readAt: data['read_at'] ?? '');
  }

  @override
  String toString() => 'Notification(id: $id, tripId: $tripId, '
      'status: $status, message: $message, date: $notifyDate, driverName: $driverName)';
}

typedef NotifList = List<Notif>;
