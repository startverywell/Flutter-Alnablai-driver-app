import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/notification/notif.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';

import '../auth/auth_repository.dart';

class NotifRepository {
  NotifRepository({
    required this.authRepo,
  });

  final AuthRepository authRepo;

  NotifList _notifs = []; //InMemoryStore<NotifList>([]);

  Future<NotifList> doFetchNotifs() async {
    //if (_notifs.isNotEmpty) {
    //  // notifications fetched already.
    //  return _notifs;
    //}

    dynamic data = await DioClient.postNotificationAll(authRepo.uid!);
    developer.log('listFetchNotifs() returned: $data');
    developer.log('uid() returned: ${authRepo.uid.toString()}');

    final result = data['result'];
    developer.log('result() returned: $data');

    if (result is List) {
      try {
        _notifs = result.map((data) => Notif.fromMap(data)).toList();
        developer.log('doFetchNotifs() src=${_notifs.toString()}');
      } catch (e) {
        developer.log('doFetchNotifs() error=$e');
      }
      return _notifs;
    } else {
      throw UnimplementedError;
    }
  }

  Future<void> doReadAt(String notiID) async {
    await DioClient.doReadAt(notiID);
  }
}

final notificationRepositoryProvider = Provider<NotifRepository>((ref) {
  return NotifRepository(
    authRepo: ref.watch(authRepositoryProvider),
  );
});
