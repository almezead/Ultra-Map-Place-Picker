import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:ultra_map_place_picker/src/models/location_model.dart';

class UltraMapController {
  gm.GoogleMapController? googleMapController;

  void completeGoogleController(final gm.GoogleMapController? controller) {
    googleMapController = controller;
    if (controller != null) {
      Completer().complete(googleMapController);
    }
  }


  Future<void> animateCamera(
      {required LocationModel target, required double zoomLevel}) async {
    await googleMapController
        ?.animateCamera(gm.CameraUpdate.newCameraPosition(gm.CameraPosition(
            target: gm.LatLng(
              target.latitude,
              target.longitude,
            ),
            zoom: zoomLevel)));
  }

  Future<double?> getZoomLevel() async {
    return await googleMapController?.getZoomLevel();
  }
}
