import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:ultra_map_place_picker/src/models/location_model.dart';

class UltraCircleModel {
  /// Unique identifier for the circle
  final String circleId;

  /// Center location of the circle
  final LocationModel center;

  /// Fill color of the circle
  final Color? fillColor;

  /// Radius of the circle in meters
  final double? radius;

  /// Stroke color of the circle's border
  final Color? strokeColor;

  /// Stroke width of the circle's border in pixels
  final int? strokeWidth;

  /// Visibility of the circle
  final bool? visible;

  /// Z-index of the circle, used for layering
  final int? zIndex;

  /// Callback function to be invoked when the circle is tapped
  final VoidCallback? onTap;
  UltraCircleModel(
      {required this.circleId,
      this.fillColor,
      required this.center,
      this.radius,
      this.strokeColor,
      this.strokeWidth,
      this.visible,
      this.zIndex,
      this.onTap});

  gm.Circle get toGoogleCircle => gm.Circle(
        circleId: gm.CircleId(circleId),
        center: gm.LatLng(center.latitude, center.longitude),
        strokeWidth: strokeWidth ?? 1,
        visible: visible ?? true,
        consumeTapEvents: onTap != null,
        onTap: onTap,
        zIndex: zIndex ?? 0,
        radius: radius ?? 0,
        strokeColor: strokeColor ?? Colors.black,
        fillColor: fillColor ?? Colors.transparent,
      );
}
