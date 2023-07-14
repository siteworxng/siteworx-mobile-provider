import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/service_address_response.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common.dart';

class ServiceAddressesComponent extends StatefulWidget {
  final AddressResponse data;
  final Function(bool? value)? onStatusUpdate;
  final Function() onDelete;
  final Function() onEdit;

  ServiceAddressesComponent(this.data, {this.onStatusUpdate, required this.onDelete, required this.onEdit});

  @override
  ServiceAddressesComponentState createState() => ServiceAddressesComponentState();
}

class ServiceAddressesComponentState extends State<ServiceAddressesComponent> {
  bool isStatusUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isStatusUpdate = widget.data.status == 1 ? true : false;
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 0),
      margin: EdgeInsets.only(bottom: 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.data.address.validate(), style: boldTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 4).expand(),
              Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: isStatusUpdate,
                  onChanged: (value) {
                    ifNotTester(context, () {
                      isStatusUpdate = value;
                      setState(() {});
                      widget.onStatusUpdate!.call(value);
                    });
                  },
                ).paddingLeft(16),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: widget.onEdit,
                style: ButtonStyle(visualDensity: VisualDensity.compact),
                child: Text(languages.lblEdit, style: secondaryTextStyle()),
              ),
              16.width,
              TextButton(
                onPressed: widget.onDelete,
                style: ButtonStyle(visualDensity: VisualDensity.compact),
                child: Text(languages.lblDelete, style: secondaryTextStyle()),
              ),
            ],
          )
        ],
      ),
    );
  }
}
