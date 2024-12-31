import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

enum PinState { preparing, idle, dragging }

enum SearchingState { idle, searching }

enum UltraMapType {
  normal(googleMapType: gm.MapType.normal),
  satellite(
      googleMapType: gm.MapType.satellite),
  terrain(googleMapType: gm.MapType.terrain),
  hybrid(googleMapType: gm.MapType.hybrid);

  final gm.MapType googleMapType;
  const UltraMapType(
      {required this.googleMapType});
}

enum UltraJointType {
  mitered(
      googleJointType: gm.JointType.mitered),
  bevel(
      googleJointType: gm.JointType.bevel),
  round(
      googleJointType: gm.JointType.round),
  ;

  final gm.JointType googleJointType;
  const UltraJointType(
      {required this.googleJointType});
}
