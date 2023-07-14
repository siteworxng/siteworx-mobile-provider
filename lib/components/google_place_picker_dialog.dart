import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/main.dart';
import 'package:provider/models/google_places_model.dart';
import 'package:provider/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../networks/rest_apis.dart';

class GooglePlacePickerDialog extends StatelessWidget {
  GooglePlacePickerDialog({Key? key, this.onSubmit}) : super(key: key);

  final Function(String)? onSubmit;

  final TextEditingController _typeAheadController = TextEditingController();
  final SuggestionsBoxController suggestionsBoxController = SuggestionsBoxController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      height: 400,
      decoration: boxDecorationDefault(borderRadius: radius()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TypeAheadFormField<GooglePlacesModel>(
            hideSuggestionsOnKeyboardHide: false,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: radiusOnly(bottomLeft: defaultRadius, bottomRight: defaultRadius),
              color: context.cardColor,
              elevation: 1,
            ),
            autoFlipDirection: true,
            keepSuggestionsOnLoading: true,
            loadingBuilder: (context) => LoaderWidget(),
            textFieldConfiguration: TextFieldConfiguration(
              controller: this._typeAheadController,
              maxLines: null,
              onEditingComplete: () {
                hideKeyboard(context);
                suggestionsBoxController.close();
              },
              onSubmitted: (c) {
                hideKeyboard(context);
                suggestionsBoxController.close();
              },
              decoration: inputDecoration(context, hint: languages.lblSearchFullAddress),
            ),
            suggestionsCallback: (pattern) async => await getSuggestion(pattern),
            itemBuilder: (context, suggestion) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Text(suggestion.description.validate(), style: primaryTextStyle()),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              this._typeAheadController.text = suggestion.description.validate();
              onSubmit?.call(suggestion.description.validate());

              if (onSubmit == null) finish(context, suggestion.description.validate());
            },
            hideOnEmpty: true,
            hideOnLoading: true,
            suggestionsBoxController: suggestionsBoxController,
            minCharsForSuggestions: 3,
            validator: (value) {
              if (value!.isEmpty) {
                return languages.lblPleaseSelectCity;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
