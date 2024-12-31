import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:ultra_map_place_picker/src/enums.dart';
import 'package:ultra_map_place_picker/src/models/location_model.dart';

class UltraPolylineModel {
  final String polylineId;
  final Color? color;
  final bool? geodesic;
  final UltraJointType? jointType;
  final List<LocationModel> points;
  final bool? visible;
  final int? width;
  final int? zIndex;
  final VoidCallback? onClick;

  UltraPolylineModel(
      {required this.polylineId,
      this.color,
      this.geodesic,
      this.jointType,
      required this.points,
      this.visible,
      this.width,
      this.zIndex,
      this.onClick});
  gm.Polyline get toGooglePolyline => gm.Polyline(
        polylineId: gm.PolylineId(polylineId),
        consumeTapEvents: onClick != null,
        color: color ?? Colors.black,
        geodesic: geodesic ?? false,
        jointType: jointType?.googleJointType ?? gm.JointType.mitered,
        points: points
            .map((point) => gm.LatLng(point.latitude, point.longitude))
            .toList(),
        visible: visible ?? true,
        width: width ?? 1,
        zIndex: zIndex ?? 0,
        onTap: onClick,
      );


}
