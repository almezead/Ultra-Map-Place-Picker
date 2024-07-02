import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:huawei_map/huawei_map.dart' as hm;
import 'package:ultra_map_place_picker/src/models/location_model.dart';

class UltraCircleModel  {
  final String circleId;
  final LocationModel center;
  final Color? fillColor;
  final double? radius;
  final Color? strokeColor;
  final int? strokeWidth;
  final bool? visible;
  final int? zIndex;
  final VoidCallback? onTap;

  UltraCircleModel({ required this.circleId,
     this.fillColor, required this.center,  this.radius,
     this.strokeColor,  this.strokeWidth,  this.visible,
     this.zIndex,  this.onTap});



  gm.Circle get toGoogleCircle=>gm.Circle(
    circleId: gm.CircleId(circleId),
    center: gm.LatLng(center.latitude,center.longitude),
    strokeWidth: strokeWidth??1,
    visible: visible??true,
    consumeTapEvents: onTap!=null,
    onTap: onTap,
    zIndex: zIndex??0,
    radius: radius??0,
    strokeColor: strokeColor??Colors.black,
    fillColor: fillColor??Colors.transparent,
  );

  hm.Circle get toHuaweiCircle=>hm.Circle(
    circleId: hm.CircleId(circleId),
    center: hm.LatLng(center.latitude,center.longitude),
    strokeWidth: strokeWidth??1,
    visible: visible??true,
    clickable: onTap!=null,
    onClick: onTap,
    zIndex: zIndex??0,
    radius: radius??0,
    strokeColor: strokeColor??Colors.black,
    fillColor: fillColor??Colors.transparent,
  );

}