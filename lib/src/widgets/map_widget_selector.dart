import 'package:flutter/material.dart';
import 'package:ultra_map_place_picker/src/models/location_model.dart';
import 'package:ultra_map_place_picker/src/controllers/ultra_map_controller.dart';
import 'package:ultra_map_place_picker/src/enums.dart';
import 'package:ultra_map_place_picker/src/models/ultra_circle_model.dart';
import 'package:ultra_map_place_picker/src/models/pick_result_model.dart';
import 'package:ultra_map_place_picker/src/models/ultra_polygon_model.dart';
import 'package:ultra_map_place_picker/src/models/ultra_polyline_model.dart';
import 'package:ultra_map_place_picker/src/providers/place_provider.dart';
import 'package:provider/provider.dart';
import 'package:ultra_map_place_picker/src/widgets/ultra_map.dart';

class MapWidgetSelector extends StatelessWidget {
  final LocationModel initialTarget;
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
  final double initialZoomValue;

  /// Use never scrollable scroll-view with maximum dimensions to prevent unnecessary re-rendering.

  final Set<UltraPolygonModel> polygons;
  final Set<UltraPolylineModel> polylines;

  const MapWidgetSelector(
      {super.key,
      required this.initialTarget,
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
    return Selector<PlaceProvider, UltraMapType>(
        selector: (final _, final provider) => provider.mapType,
        builder: (final _, final mapType, final __) => UltraMap(
            provider: PlaceProvider.of(context, listen: false),
            initialTarget: initialTarget,
            mapType: mapType,
            onMoveStart: onMoveStart,
            onMapCreated: onMapCreated,
            onPlacePicked: onPlacePicked,
            debounceMilliseconds: debounceMilliseconds,
            usePinPointingSearch: usePinPointingSearch,
            selectInitialPosition: selectInitialPosition,
            language: language,
            pickArea: pickArea,
            hidePlaceDetailsWhenDraggingPin: hidePlaceDetailsWhenDraggingPin,
            onCameraMoveStarted: onCameraMoveStarted,
            onCameraMove: onCameraMove,
            onCameraIdle: onCameraIdle,
            selectText: selectText,
            zoomGesturesEnabled: zoomGesturesEnabled,
            zoomControlsEnabled: zoomControlsEnabled,
            initialZoomValue: initialZoomValue,
            polygons: polygons,
            polylines: polylines));
  }
}
