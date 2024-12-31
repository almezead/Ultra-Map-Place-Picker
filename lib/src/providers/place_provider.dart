import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:ultra_map_place_picker/src/models/location_model.dart';
import 'package:ultra_map_place_picker/src/controllers/ultra_map_controller.dart';
import 'package:ultra_map_place_picker/src/enums.dart';
import 'package:ultra_map_place_picker/src/models/pick_result_model.dart';

class PlaceProvider extends ChangeNotifier {
  PlaceProvider(final String apiKey, final String? proxyBaseUrl,
      final Client? httpClient, final Map<String, dynamic> apiHeaders,
      [this.mapTypes = UltraMapType.values]) {
    _mapType = mapTypes.first;
    places = GoogleMapsPlaces(
      apiKey: apiKey,
      baseUrl: proxyBaseUrl,
      httpClient: httpClient,
      apiHeaders: apiHeaders as Map<String, String>?,
    );
    geocoding = GoogleMapsGeocoding(
      apiKey: apiKey,
      baseUrl: proxyBaseUrl,
      httpClient: httpClient,
      apiHeaders: apiHeaders as Map<String, String>?,
    );
  }

  static PlaceProvider of(final BuildContext context,
          {final bool listen = true}) =>
      Provider.of<PlaceProvider>(context, listen: listen);

  late GoogleMapsPlaces places;
  late GoogleMapsGeocoding geocoding;
  String? sessionToken;
  bool isOnUpdateLocationCoolDown = false;
  LocationAccuracy? desiredAccuracy;
  bool isAutoCompleteSearching = false;

  final List<UltraMapType> mapTypes;

  Future<void> updateCurrentLocation({final bool gracefully = false}) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (gracefully) {
        return;
      }
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (gracefully) {
          return;
        }
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (gracefully) {
        return;
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition(
      locationSettings: Platform.isIOS ? AppleSettings() : AndroidSettings(),
      //desiredAccuracy: desiredAccuracy ?? LocationAccuracy.best,
    );
  }

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;
  set currentPosition(final Position? newPosition) {
    _currentPosition = newPosition;
    notifyListeners();
  }

  Timer? _debounceTimer;
  Timer? get debounceTimer => _debounceTimer;
  set debounceTimer(final Timer? timer) {
    _debounceTimer = timer;
    notifyListeners();
  }

  LocationModel? _previousCameraPosition;
  LocationModel? get prevCameraPosition => _previousCameraPosition;
  setPrevCameraPosition(final LocationModel? prePosition) {
    _previousCameraPosition = prePosition;
  }

  LocationModel? _currentCameraPosition;
  LocationModel? get cameraPosition => _currentCameraPosition;
  setCameraPosition(final LocationModel? newPosition) {
    _currentCameraPosition = newPosition;
  }

  PickResultModel? _selectedPlace;
  PickResultModel? get selectedPlace => _selectedPlace;
  set selectedPlace(final PickResultModel? result) {
    _selectedPlace = result;
    notifyListeners();
  }

  SearchingState _placeSearchingState = SearchingState.idle;
  SearchingState get placeSearchingState => _placeSearchingState;
  set placeSearchingState(final SearchingState newState) {
    _placeSearchingState = newState;
    notifyListeners();
  }

  final UltraMapController _mapController = UltraMapController();
  UltraMapController get mapController => _mapController;
  set googleController(final GoogleMapController? controller) {
    _mapController.completeGoogleController(controller);
    notifyListeners();
  }

  PinState _pinState = PinState.preparing;
  PinState get pinState => _pinState;
  set pinState(final PinState newState) {
    _pinState = newState;
    notifyListeners();
  }

  bool _isSearchBarFocused = false;
  bool get isSearchBarFocused => _isSearchBarFocused;
  set isSearchBarFocused(final bool focused) {
    _isSearchBarFocused = focused;
    notifyListeners();
  }

  late UltraMapType _mapType;
  UltraMapType get mapType => _mapType;
  setUltraMapType(final UltraMapType mapType, {final bool notify = false}) {
    _mapType = mapType;
    if (notify) {
      notifyListeners();
    }
  }

  switchUltraMapType() {
    _mapType = mapTypes[(mapTypes.indexOf(_mapType) + 1) % mapTypes.length];
    notifyListeners();
  }
}
