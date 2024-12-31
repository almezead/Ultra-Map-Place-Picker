import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:ultra_map_place_picker/src/models/location_model.dart';

class UltraPolygonModel {
  final String polygonId;
  final Color? fillColor;
  final bool? geodesic;
  final List<LocationModel>? points;
  final bool? visible;
  final Color? strokeColor;
  final int? strokeWidth;
  final int? zIndex;
  final VoidCallback? onClick;
  final List<List<LocationModel>>? holes;

  UltraPolygonModel({
    required this.polygonId,
    this.fillColor,
    this.geodesic,
    this.points,
    this.visible,
    this.strokeColor,
    this.strokeWidth,
    this.zIndex,
    this.onClick,
    this.holes,
  });

  gm.Polygon get toGooglePolygon => gm.Polygon(
        polygonId: gm.PolygonId(polygonId),
        fillColor: fillColor ?? Colors.black,
        geodesic: geodesic ?? false,
        points: points
                ?.map((point) => gm.LatLng(point.latitude, point.longitude))
                .toList() ??
            [],
        visible: visible ?? true,
        strokeColor: strokeColor ?? Colors.black,
        strokeWidth: strokeWidth ?? 10,
        zIndex: zIndex ?? 0,
        onTap: onClick,
        consumeTapEvents: onClick != null,
        holes: holes
                ?.map((holeList) => holeList
                    .map((hole) => gm.LatLng(hole.latitude, hole.longitude))
                    .toList())
                .toList() ??
            [],
      );
}
