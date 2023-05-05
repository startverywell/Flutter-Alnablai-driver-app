import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/notification/notif_repository.dart';
import 'package:alnabali_driver/src/features/notification/notif.dart';

class HomeNotificationsController extends StateNotifier<AsyncValue<NotifList>> {
  HomeNotificationsController({required this.notifRepo})
      : super(const AsyncData([]));

  final NotifRepository notifRepo;

  Future<void> doFetchNotifs() async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doFetchNotifs());

    if (mounted) {
      state = newState;
    }
  }
}

final homeNotificationsCtrProvider = StateNotifierProvider.autoDispose<
    HomeNotificationsController, AsyncValue<NotifList>>((ref) {
  return HomeNotificationsController(
      notifRepo: ref.watch(notificationRepositoryProvider));
});
