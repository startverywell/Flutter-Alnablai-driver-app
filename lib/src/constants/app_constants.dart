import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TripKind {
  today,
  past,
}

enum TripStatus {
  all,
  pending,
  accepted,
  rejected,
  started,
  canceled,
  finished,
  fake,
}

enum BusPos {
  unknown,
  origin,
  destination,
}

const kStatusMapper = {
  '1': TripStatus.pending,
  '2': TripStatus.accepted,
  '3': TripStatus.rejected,
  '4': TripStatus.started,
  '5': TripStatus.canceled,
  '6': TripStatus.finished,
  '7': TripStatus.fake,
};

Color getStatusColor(TripStatus status) {
  const List<Color> kStatusColors = [
    Colors.black,
    Color(0xFFFBB03B),
    Color(0xFFA67C52),
    Color(0xFFED1C24),
    Color(0xFF29ABE2),
    Color(0xFFFF00FF),
    Color(0xFF39B54A),
    Color(0xFF949494),
  ];
  return kStatusColors[status.index];
}

String getTabTitleFromID(TripStatus status, BuildContext context) {
  final kTripTabTitles = [
    AppLocalizations.of(context).all,
    AppLocalizations.of(context).pending,
    AppLocalizations.of(context).accepted,
    AppLocalizations.of(context).rejected,
    AppLocalizations.of(context).started,
    AppLocalizations.of(context).canceled,
    AppLocalizations.of(context).finished,
    AppLocalizations.of(context).fake,
  ];
  return kTripTabTitles[status.index];
}

String getNotifyText(TripStatus status, BuildContext context) {
  switch (status) {
    case TripStatus.pending:
      return AppLocalizations.of(context).newPendingTrip;
    case TripStatus.accepted:
      return AppLocalizations.of(context).tripHasBeenAccepted;
    case TripStatus.rejected:
      return AppLocalizations.of(context).tripHasBeenRejected;
    case TripStatus.started:
      return AppLocalizations.of(context).tripHasBeenStarted;
    case TripStatus.finished:
      return AppLocalizations.of(context).tripHasBeenFinished;
    case TripStatus.canceled:
      return AppLocalizations.of(context).tripHasBeenCanceled;
    case TripStatus.fake:
      return AppLocalizations.of(context).tripHasBeenCanceled;
    default:
      return AppLocalizations.of(context).unknownStatus;
  }
}

String getTrackExplain(TripStatus status, BuildContext context) {
  final kTripTabTitles = [
    '',
    AppLocalizations.of(context).trackPending,
    AppLocalizations.of(context).trackAccepted,
    AppLocalizations.of(context).trackRejected,
    AppLocalizations.of(context).trackStarted,
    AppLocalizations.of(context).trackCanceled,
    AppLocalizations.of(context).trackFinished,
    AppLocalizations.of(context).trackFake,
  ];
  return kTripTabTitles[status.index];
}

String getClientImageURL(String clientName) {
  return 'http://167.86.102.230/alnabali/public/android/client/avatar/$clientName';
}
