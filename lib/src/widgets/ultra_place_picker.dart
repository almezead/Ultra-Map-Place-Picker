
import 'package:flutter/material.dart';

import 'package:ultra_map_place_picker/src/models/location_model.dart';
import 'package:ultra_map_place_picker/src/controllers/ultra_map_controller.dart';
import 'package:ultra_map_place_picker/src/models/ultra_polygon_model.dart';
import 'package:ultra_map_place_picker/src/models/ultra_polyline_model.dart';
import 'package:ultra_map_place_picker/src/providers/place_provider.dart';
import 'package:ultra_map_place_picker/src/models/ultra_circle_model.dart';
import 'package:ultra_map_place_picker/src/models/pick_result_model.dart';
import 'package:ultra_map_place_picker/src/widgets/map_icons.dart';
import 'package:ultra_map_place_picker/src/widgets/map_widget_selector.dart';
import 'package:ultra_map_place_picker/src/widgets/pin_widget_selector.dart';
import 'package:ultra_map_place_picker/src/widgets/place_builder_selector.dart';
import 'package:ultra_map_place_picker/src/widgets/zoom_buttons.dart';

class UltraPlacePicker extends StatelessWidget {
  const UltraPlacePicker({
    required this.appBarKey,
    required this.isHuaweiDevice,
    required this.initialTarget,
    super.key,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.onSearchFailed,
    this.onMoveStart,
    this.onMapCreated,
    this.debounceMilliseconds,
    this.enableMapTypeButton,
    this.enableMyLocationButton,
    this.onToggleMapType,
    this.onMyLocation,
    this.onPlacePicked,
    this.usePinPointingSearch,
    this.usePlaceDetailSearch,
    this.selectInitialPosition,
    this.language,
    this.pickArea,
    this.forceSearchOnZoomChanged,
    this.hidePlaceDetailsWhenDraggingPin,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
    this.onCameraIdleInfo,
    this.selectText,
    this.outsideOfPickAreaText,
    this.zoomGesturesEnabled = true,
    this.zoomControlsEnabled = false,
    this.fullMotion = false,
    this.initialZoomValue = 15,
    this.polygons = const {},
    this.polylines = const {},
  });

  final LocationModel initialTarget;
  final GlobalKey appBarKey;

  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final PinBuilder? pinBuilder;

  final ValueChanged<String>? onSearchFailed;
  final VoidCallback? onMoveStart;
  final void Function(UltraMapController)? onMapCreated;
  final VoidCallback? onToggleMapType;
  final VoidCallback? onMyLocation;
  final ValueChanged<PickResultModel>? onPlacePicked;

  final int? debounceMilliseconds;
  final bool? enableMapTypeButton;
  final bool? enableMyLocationButton;

  final bool? usePinPointingSearch;
  final bool? usePlaceDetailSearch;
  final bool isHuaweiDevice;
  final bool? selectInitialPosition;

  final String? language;
  final UltraCircleModel? pickArea;

  final bool? forceSearchOnZoomChanged;
  final bool? hidePlaceDetailsWhenDraggingPin;

  /// GoogleMap pass-through events:
  final Function(PlaceProvider)? onCameraMoveStarted;
  final void Function(LocationModel)? onCameraMove;
  final Function(PlaceProvider)? onCameraIdle;
  final Function(PickResultModel?)? onCameraIdleInfo;

  // strings
  final String? selectText;
  final String? outsideOfPickAreaText;

  /// Zoom feature toggle
  final bool zoomGesturesEnabled;
  final bool zoomControlsEnabled;
  final double initialZoomValue;

  /// Use never scrollable scroll-view with maximum dimensions to prevent unnecessary re-rendering.
  final bool fullMotion;

  final Set<UltraPolygonModel> polygons;
  final Set<UltraPolylineModel> polylines;

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: <Widget>[
        if (fullMotion)
          SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      buildMapWidgetSelector(),
                      PinWidgetSelector(
                        pinBuilder: pinBuilder,
                      ),
                    ],
                  ))),
        if (!fullMotion) ...[
          buildMapWidgetSelector(),
          PinWidgetSelector(
            pinBuilder: pinBuilder,
          ),
        ],
        PlaceBuilderSelector(
          hidePlaceDetailsWhenDraggingPin: hidePlaceDetailsWhenDraggingPin,
          outsideOfPickAreaText: outsideOfPickAreaText,
          selectedPlaceWidgetBuilder: selectedPlaceWidgetBuilder,
          pickArea: pickArea,
          onPlacePicked: onPlacePicked,
          selectedText: selectText,
        ),
        MapIcons(
          appBarKey: appBarKey,
          enableMapTypeButton: enableMapTypeButton,
          onMyLocation: onMyLocation,
          onToggleMapType: onToggleMapType,
          enableMyLocationButton: enableMyLocationButton,
        ),
        ZoomButtons(
          zoomControlsEnabled: zoomControlsEnabled,
        )
      ],
    );
  }

  Widget buildMapWidgetSelector() => MapWidgetSelector(
      initialTarget: initialTarget,
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
      isHuaweiDevice: isHuaweiDevice,
      initialZoomValue: initialZoomValue,
      polygons: polygons,
      polylines: polylines);
}
