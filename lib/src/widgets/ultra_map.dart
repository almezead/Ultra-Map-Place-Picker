import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:huawei_map/huawei_map.dart' as hm;
import 'package:ultra_map_place_picker/src/models/location_model.dart';
import 'package:ultra_map_place_picker/src/controllers/ultra_map_controller.dart';
import 'package:ultra_map_place_picker/src/enums.dart';
import 'package:ultra_map_place_picker/src/models/ultra_circle_model.dart';
import 'package:ultra_map_place_picker/src/models/pick_result_model.dart';
import 'package:ultra_map_place_picker/src/models/ultra_polygon_model.dart';
import 'package:ultra_map_place_picker/src/models/ultra_polyline_model.dart';
import 'package:ultra_map_place_picker/src/providers/place_provider.dart';

class UltraMap extends StatelessWidget {
  final PlaceProvider provider;
  final LocationModel initialTarget;
  final UltraMapType mapType;
  final VoidCallback? onMoveStart;
  final void Function(UltraMapController)? onMapCreated;
  final ValueChanged<PickResultModel>? onPlacePicked;

  final int? debounceMilliseconds;

  final bool? usePinPointingSearch;

  final bool? selectInitialPosition;

  final String? language;
  final UltraCircleModel? pickArea;

  final bool? hidePlaceDetailsWhenDraggingPin;

  /// GoogleMap pass-through events:
  final Function(PlaceProvider)? onCameraMoveStarted;
  final void Function(LocationModel)? onCameraMove;
  final Function(PlaceProvider)? onCameraIdle;

  // strings
  final String? selectText;

  /// Zoom feature toggle
  final bool zoomGesturesEnabled;
  final bool zoomControlsEnabled;
  final bool isHuaweiDevice;
  final double initialZoomValue;

  /// Use never scrollable scroll-view with maximum dimensions to prevent unnecessary re-rendering.

  final Set<UltraPolygonModel> polygons;
  final Set<UltraPolylineModel> polylines;

  const UltraMap(
      {super.key,
      required this.provider,
      required this.isHuaweiDevice,
      required this.initialTarget,
      required this.mapType,
      required this.onMoveStart,
      required this.onMapCreated,
      required this.onPlacePicked,
      required this.debounceMilliseconds,
      required this.usePinPointingSearch,
      required this.selectInitialPosition,
      required this.language,
      required this.pickArea,
      required this.hidePlaceDetailsWhenDraggingPin,
      required this.onCameraMoveStarted,
      required this.onCameraMove,
      required this.onCameraIdle,
      required this.selectText,
      required this.zoomGesturesEnabled,
      required this.zoomControlsEnabled,
      required this.initialZoomValue,
      required this.polygons,
      required this.polylines});

  @override
  Widget build(BuildContext context) {
    return isHuaweiDevice
        ? hm.HuaweiMap(
            polygons: polygons.map((p) => p.toHuaweiPolygon).toSet(),
            polylines: polylines.map((p) => p.toHuaweiPolyline).toSet(),
            zoomGesturesEnabled: zoomGesturesEnabled,
            zoomControlsEnabled: false,
            // we use our own implementation that supports iOS as well, see _buildZoomButtons()
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: hm.CameraPosition(
                target:
                    hm.LatLng(initialTarget.latitude, initialTarget.longitude),
                zoom: initialZoomValue),
            mapType: mapType.huaweiMapType,
            myLocationEnabled: true,
            circles: pickArea != null && pickArea!.toHuaweiCircle.radius > 0
                ? {pickArea!.toHuaweiCircle}
                : {},
            onMapCreated: (final hm.HuaweiMapController controller) {
              provider.mapController.completeHuaweiController(controller);
              provider.setCameraPosition(null);
              provider.pinState = PinState.idle;

              // When select initialPosition set to true.
              if (selectInitialPosition!) {
                provider.setCameraPosition(initialTarget);
              }
              onMapCreated?.call(provider.mapController);
            },
            onCameraIdle: () {
              if (provider.isAutoCompleteSearching) {
                provider.isAutoCompleteSearching = false;
                provider.pinState = PinState.idle;
                provider.placeSearchingState = SearchingState.idle;
                return;
              }
              // Perform search only if the setting is to true.
              if (usePinPointingSearch!) {
                // Search current camera location only if camera has moved (dragged) before.
                if (provider.pinState == PinState.dragging) {
                  // Cancel previous timer.
                  if (provider.debounceTimer?.isActive ?? false) {
                    provider.debounceTimer!.cancel();
                  }
                  provider.debounceTimer =
                      Timer(Duration(milliseconds: debounceMilliseconds!), () {
                  });
                }
              }
              provider.pinState = PinState.idle;
              onCameraIdle?.call(provider);
            },
            onCameraMoveStarted: (_) {
              onCameraMoveStarted?.call(provider);
              provider.setPrevCameraPosition(provider.cameraPosition);
              // Cancel any other timer.
              provider.debounceTimer?.cancel();
              // Update state, dismiss keyboard and clear text.
              provider.pinState = PinState.dragging;
              // Begins the search state if the hide details is enabled
              if (hidePlaceDetailsWhenDraggingPin!) {
                provider.placeSearchingState = SearchingState.searching;
              }
              onMoveStart!();
            },
            onCameraMove: (final hm.CameraPosition position) {
              provider.setCameraPosition(
                  LocationModel(position.target.lat, position.target.lng));
              onCameraMove?.call(
                  LocationModel(position.target.lat, position.target.lng));
            },
            // gestureRecognizers make it possible to navigate the map when it's a
            // child in a scroll view e.g ListView, SingleChildScrollView...
            gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(
                () => EagerGestureRecognizer())),
          )
        : gm.GoogleMap(
            polygons: polygons.map((p) => p.toGooglePolygon).toSet(),
            polylines: polylines.map((p) => p.toGooglePolyline).toSet(),
            zoomGesturesEnabled: zoomGesturesEnabled,
            zoomControlsEnabled: false,
            // we use our own implementation that supports iOS as well, see _buildZoomButtons()
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: gm.CameraPosition(
                target:
                    gm.LatLng(initialTarget.latitude, initialTarget.longitude),
                zoom: initialZoomValue),
            mapType: mapType.googleMapType,
            myLocationEnabled: true,
            circles: pickArea != null && pickArea!.toGoogleCircle.radius > 0
                ? {pickArea!.toGoogleCircle}
                : {},
            onMapCreated: (final gm.GoogleMapController controller) {
              provider.mapController.completeGoogleController(controller);
              provider.setCameraPosition(null);
              provider.pinState = PinState.idle;

              // When select initialPosition set to true.
              if (selectInitialPosition!) {
                provider.setCameraPosition(initialTarget);
              }
              onMapCreated?.call(provider.mapController);
            },
            onCameraIdle: () {
              if (provider.isAutoCompleteSearching) {
                provider.isAutoCompleteSearching = false;
                provider.pinState = PinState.idle;
                provider.placeSearchingState = SearchingState.idle;
                return;
              }
              // Perform search only if the setting is to true.
              if (usePinPointingSearch!) {
                // Search current camera location only if camera has moved (dragged) before.
                if (provider.pinState == PinState.dragging) {
                  // Cancel previous timer.
                  if (provider.debounceTimer?.isActive ?? false) {
                    provider.debounceTimer!.cancel();
                  }
                  provider.debounceTimer =
                      Timer(Duration(milliseconds: debounceMilliseconds!), () {
                  });
                }
              }
              provider.pinState = PinState.idle;
              onCameraIdle?.call(provider);
            },
            onCameraMoveStarted: () {
              onCameraMoveStarted?.call(provider);
              provider.setPrevCameraPosition(provider.cameraPosition);
              // Cancel any other timer.
              provider.debounceTimer?.cancel();
              // Update state, dismiss keyboard and clear text.
              provider.pinState = PinState.dragging;
              // Begins the search state if the hide details is enabled
              if (hidePlaceDetailsWhenDraggingPin!) {
                provider.placeSearchingState = SearchingState.searching;
              }
              onMoveStart!();
            },
            onCameraMove: (final gm.CameraPosition position) {
              provider.setCameraPosition(LocationModel(
                  position.target.latitude, position.target.longitude));
              onCameraMove?.call(LocationModel(
                  position.target.latitude, position.target.longitude));
            },
            // gestureRecognizers make it possible to navigate the map when it's a
            // child in a scroll view e.g ListView, SingleChildScrollView...
            gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(
                () => EagerGestureRecognizer())),
          );
  }
}
