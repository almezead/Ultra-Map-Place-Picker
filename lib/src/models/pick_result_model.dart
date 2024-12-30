import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:ultra_map_place_picker/src/models/location_model.dart';

class PickResultModel {
  PickResultModel({
    this.placeId,
    this.geometry,
    this.formattedAddress,
    this.types,
    this.addressComponents,
    this.adrAddress,
    this.formattedPhoneNumber,
    this.id,
    this.reference,
    this.icon,
    this.name,
    this.openingHours,
    this.photos,
    this.internationalPhoneNumber,
    this.priceLevel,
    this.rating,
    this.scope,
    this.url,
    this.vicinity,
    this.utcOffset,
    this.website,
    this.reviews,
  });

  /// The unique identifier for the place.
  final String? placeId;

  /// The geographical location and viewport of the place.
  final Geometry? geometry;

  /// The human-readable address of the place.
  final String? formattedAddress;

  /// The types of the place (e.g., restaurant, park).
  final List<String>? types;

  /// The components of the address (e.g., street, city, country).
  final List<AddressComponent>? addressComponents;

  // Below results will not be fetched if 'usePlaceDetailSearch' is set to false (Defaults to false).

  /// The address in a format suitable for embedding in HTML.
  final String? adrAddress;

  /// The formatted phone number of the place.
  final String? formattedPhoneNumber;

  /// The unique identifier for the place (deprecated in favor of `placeId`).
  final String? id;

  /// A textual identifier that uniquely identifies a place.
  final String? reference;

  /// The URL of an icon representing the place.
  final String? icon;

  /// The name of the place.
  final String? name;

  /// The opening hours of the place.
  final OpeningHoursDetail? openingHours;

  /// Photos associated with the place.
  final List<Photo>? photos;

  /// The international phone number of the place.
  final String? internationalPhoneNumber;

  /// The price level of the place (e.g., inexpensive, moderate).
  final PriceLevel? priceLevel;

  /// The rating of the place (e.g., 4.5).
  final num? rating;

  /// The scope of the place (e.g., Google, App).
  final String? scope;

  /// The URL of the place's official website.
  final String? url;

  /// A textual description of the place's location.
  final String? vicinity;

  /// The UTC offset of the place in minutes.
  final num? utcOffset;

  /// The URL of the place's website.
  final String? website;

  /// Reviews of the place.
  final List<Review>? reviews;



 
  LocationModel get toLocationModel =>
      LocationModel(geometry!.location.lat, geometry!.location.lng);

  String get formattedString {
    String result = '';
    final List<AddressComponent> toShowComponents = addressComponents
            ?.where((final component) => ![
                  'plus_code',
                  'street_number',
                  'subpremise',
                  'country'
                ].contains(component.types.first))
            .toList() ??
        [];

    final Set<String> toShowNames =
        toShowComponents.map((final component) => component.longName).toSet();
    for (int i = 0; i < toShowNames.length; i++) {
      result = '$result${toShowNames.elementAt(i)}';

      if (i < toShowNames.length - 1) {
        result += ' - ';
      }
    }

    return result;
  }
}
