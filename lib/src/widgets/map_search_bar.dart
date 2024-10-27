import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:ultra_map_place_picker/src/controllers/auto_complete_search_controller.dart';
import 'package:ultra_map_place_picker/src/enums.dart';
import 'package:ultra_map_place_picker/src/providers/place_provider.dart';
import 'package:provider/provider.dart';
import 'package:ultra_map_place_picker/src/widgets/auto_complete_search.dart';
import 'package:ultra_map_place_picker/src/widgets/intro_modal.dart';

class MapSearchBar extends StatelessWidget {
  final bool showIntroModal;
  final IntroModalWidgetBuilder? introModalWidgetBuilder;
  final VoidCallback? onTapBack;
  final GlobalKey appBarKey;
  final PlaceProvider? provider;
  final AutoCompleteSearchController searchBarController;
  final num? autocompleteOffset;
  final String? hintText;
  final String? searchingText;
  final String? region;
  final bool? strictbounds;
  final List<String>? autocompleteTypes;
  final ValueChanged<String>? onAutoCompleteFailed;
  final int autoCompleteDebounceInMilliseconds;
  final num? autocompleteRadius;
  final String? autocompleteLanguage;
  final String? initialSearchString;
  final bool autocompleteOnTrailingWhitespace;
  final bool searchForInitialValue;
  final List<Component>? autocompleteComponents;
  final void Function(Prediction) onPicked;

  const MapSearchBar(
      {super.key,
      required this.showIntroModal,
      required this.introModalWidgetBuilder,
      required this.onTapBack,
      required this.appBarKey,
      required this.provider,
      required this.searchBarController,
      required this.autocompleteOffset,
      required this.hintText,
      required this.searchingText,
      required this.region,
      required this.strictbounds,
      required this.autocompleteTypes,
      required this.onAutoCompleteFailed,
      required this.autoCompleteDebounceInMilliseconds,
      required this.autocompleteRadius,
      required this.autocompleteLanguage,
      required this.initialSearchString,
      required this.autocompleteOnTrailingWhitespace,
      required this.searchForInitialValue,
      required this.autocompleteComponents,
      required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 15),
        (Navigator.of(context).canPop())
            ? Consumer<PlaceProvider>(
                builder: (final _, final providerInstance, final __) =>
                    IconButton(
                        onPressed: () {
                          if (!showIntroModal ||
                              introModalWidgetBuilder == null) {
                            provider?.debounceTimer?.cancel();
                            if (onTapBack != null) {
                              onTapBack!();
                              return;
                            }
                            Navigator.maybePop(context);
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                        ),
                        color: [UltraMapType.normal, UltraMapType.terrain]
                                .contains(provider?.mapType)
                            ? Colors.black
                            : Colors.white,
                        padding: EdgeInsets.zero))
            : Container(),
        Expanded(
          child: AutoCompleteSearch(
              appBarKey: appBarKey,
              autoCompleteSearchController: searchBarController,
              sessionToken: provider!.sessionToken,
              hintText: hintText,
              searchingText: searchingText,
              debounceMilliseconds: autoCompleteDebounceInMilliseconds,
              onPicked: onPicked,
              onSearchFailed: (final status) {
                if (onAutoCompleteFailed != null) {
                  onAutoCompleteFailed!(status);
                }
              },
              autocompleteOffset: autocompleteOffset,
              autocompleteRadius: autocompleteRadius,
              autocompleteLanguage: autocompleteLanguage,
              autocompleteComponents: autocompleteComponents,
              autocompleteTypes: autocompleteTypes,
              strictbounds: strictbounds,
              region: region,
              initialSearchString: initialSearchString,
              searchForInitialValue: searchForInitialValue,
              autocompleteOnTrailingWhitespace:
                  autocompleteOnTrailingWhitespace),
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
