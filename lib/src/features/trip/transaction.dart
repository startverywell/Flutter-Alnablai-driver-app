import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@immutable
class Transaction {
  const Transaction({
    required this.id,
    required this.tripId,
    required this.newStatus,
    required this.updateDate,
  });

  final String id;
  final String tripId;
  final TripStatus newStatus;
  final DateTime updateDate;

  String getUpdateTimeStr() {
    return DateFormat('hh:mm:ss a').format(updateDate);
  }

  factory Transaction.fromMap(Map<String, dynamic> data) {
    var status =
        kStatusMapper[data['new_status'].toString()] ?? TripStatus.pending;

    return Transaction(
      id: data['trip_id'].toString(),
      tripId: data['f_trip_id'].toString(),
      newStatus: status,
      updateDate: DateTime.parse('${data['updated_at']}'),
    );
  }
}

typedef TransactionList = List<Transaction>;
