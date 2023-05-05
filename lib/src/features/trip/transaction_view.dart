import 'package:alnabali_driver/src/features/trip/track_card.dart';
import 'package:alnabali_driver/src/features/trip/trip_controller.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/widgets/progress_hud.dart';

// * ---------------------------------------------------------------------------
// * TransactionsListView
// * ---------------------------------------------------------------------------

class TransactionView extends ConsumerStatefulWidget {
  const TransactionView({
    Key? key,
    required this.tripId,
  }) : super(key: key);

  final String tripId;

  @override
  ConsumerState<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends ConsumerState<TransactionView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(transCtrProvider.notifier).doFetchTransaction(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(transCtrProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(transCtrProvider);

    return ProgressHUD(
      inAsyncCall: state.isLoading,
      child: (state.value != null && state.value!.isNotEmpty)
          ? TrackCard(info: state.value!)
          : const SizedBox(),
    );
  }
}
