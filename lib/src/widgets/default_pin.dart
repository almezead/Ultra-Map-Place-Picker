import 'package:flutter/material.dart';
import 'package:ultra_map_place_picker/src/enums.dart';
import 'package:ultra_map_place_picker/src/widgets/animated_pin.dart';

class DefaultPin extends StatelessWidget {
  final PinState state;
  const DefaultPin({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state == PinState.preparing) {
      return Container();
    } else if (state == PinState.idle) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/icons/location_pin.png"),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                  child: Image.asset("assets/icons/location_pin.png"), //Icon(Icons.place, size: 36, color: Colors.red)
                ),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }
}
