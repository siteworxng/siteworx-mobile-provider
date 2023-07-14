import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/main.dart';
import 'package:provider/models/service_address_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class AddServiceComponent extends StatefulWidget {
  final bool isFromService;
  final AddressResponse? addressData;

  AddServiceComponent({Key? key, this.isFromService = false, this.addressData}) : super(key: key);

  @override
  State<AddServiceComponent> createState() => _AddServiceComponentState();
}

class _AddServiceComponentState extends State<AddServiceComponent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController addressNameCont = TextEditingController();

  bool isUpdate = false;
  bool isTextChangedFromPrevious = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.addressData != null;

    if (isUpdate) {
      addressNameCont.addListener(() {
        isTextChangedFromPrevious = addressNameCont.text != widget.addressData!.address.validate();
        setState(() {});
      });
      addressNameCont.text = widget.addressData!.address.validate();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> addUpdateAddress() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map request = {
        AddAddressKey.providerId: appStore.userId,
        AddAddressKey.status: '1',
        AddAddressKey.address: addressNameCont.text.trim(),
      };

      await locationFromAddress(addressNameCont.text).then((value) {
        request.putIfAbsent(AddAddressKey.latitude, () => value.first.latitude);
        request.putIfAbsent(AddAddressKey.longitude, () => value.first.longitude);
      }).catchError((e) async {
        // toast(e.toString(), print: true);
      });
      if (!request.containsKey(AddAddressKey.latitude)) {
        appStore.setLoading(false);
        toast(languages.noServiceAccordingToCoordinates);
      } else {
        request.putIfAbsent(AddAddressKey.id, () => isUpdate ? widget.addressData!.id.validate() : "");

        await addAddresses(request).then((value) {
          appStore.setLoading(false);

          addressNameCont.clear();

          toast(value.message.validate(), print: true);
          if (widget.isFromService.validate()) {
            finish(context, true);
          } else {
            finish(context, true);
          }
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });
      }
    }
  }

  @override
  void dispose() {
    if (isUpdate) {
      addressNameCont.removeListener(() {
        //
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            backgroundColor: primaryColor,
          ),
          padding: EdgeInsets.only(left: 24, right: 8, bottom: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(languages.editAddress, style: boldTextStyle(color: white), textAlign: TextAlign.justify),
              IconButton(
                onPressed: () {
                  finish(context);
                  appStore.setLoading(false);
                },
                icon: Icon(Icons.close, size: 22, color: white),
              ),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(
                      textFieldType: TextFieldType.MULTILINE,
                      controller: addressNameCont,
                      decoration: inputDecoration(context, hint: languages.hintAddress),
                    ),
                    24.height,
                    AppButton(
                      text: isUpdate ? languages.lblUpdate : languages.hintAdd,
                      height: 40,
                      color: primaryColor,
                      enabled: isUpdate ? isTextChangedFromPrevious : true,
                      disabledColor: context.primaryColor.withOpacity(0.5),
                      textStyle: primaryTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () async {
                        ifNotTester(context, () {
                          addUpdateAddress();
                        });
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16, vertical: 24),
              ),
            ),
            Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ],
    );
  }
}
