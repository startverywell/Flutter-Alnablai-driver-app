import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

const List<Color> _kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class ProgressHUD extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  //final Animation<Color> valueColor;

  const ProgressHUD({
    Key? key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.0,
    this.color = Colors.white,
    //this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);

    if (inAsyncCall) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          const Center(
              child: SizedBox(
            width: 100,
            height: 100,
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: _kDefaultRainbowColors,
              strokeWidth: 2,
            ),
          )),
        ],
      );
      widgetList.add(modal);
    }

    return Stack(
      children: widgetList,
    );
  }
}
