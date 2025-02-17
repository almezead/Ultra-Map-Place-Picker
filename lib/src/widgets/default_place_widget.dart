import 'package:flutter/material.dart';
import 'package:ultra_map_place_picker/src/enums.dart';
import 'package:ultra_map_place_picker/src/models/ultra_circle_model.dart';
import 'package:ultra_map_place_picker/src/models/pick_result_model.dart';
import 'package:ultra_map_place_picker/src/widgets/floating_card.dart';
import 'package:ultra_map_place_picker/src/widgets/map_loading_indicator.dart';
import 'package:ultra_map_place_picker/src/widgets/selection_details.dart' as selection_details;

class DefaultPlaceWidget extends StatelessWidget {
  final PickResultModel? data;
  final SearchingState state;
  final UltraCircleModel? pickArea;
  final String? outsideOfPickAreaText;
  final String? selectedText;
  final ValueChanged<PickResultModel>? onPlacePicked;

  const DefaultPlaceWidget(
      {super.key,
      required this.data,
      required this.state,
      required this.pickArea,
      required this.outsideOfPickAreaText,
      required this.selectedText,
      required this.onPlacePicked});

  @override
  Widget build(BuildContext context) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.1,
      leftPosition: MediaQuery.of(context).size.width * 0.15,
      rightPosition: MediaQuery.of(context).size.width * 0.15,
      width: MediaQuery.of(context).size.width * 0.7,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.searching
          ? const MapLoadingIndicator()
          : selection_details.SelectionDetails(
              result: data!,
              pickArea: pickArea,
              outsideOfPickAreaText: outsideOfPickAreaText,
              onPlacePicked: onPlacePicked,
              selectText: selectedText,
            ),
    );
  }
}
