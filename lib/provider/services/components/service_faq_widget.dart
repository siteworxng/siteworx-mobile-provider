import 'package:flutter/material.dart';
import 'package:provider/models/service_detail_response.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceFaqWidget extends StatelessWidget {
  final ServiceFaq? serviceFaq;

  const ServiceFaqWidget({Key? key, required this.serviceFaq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(serviceFaq!.title.validate(), style: primaryTextStyle()),
      tilePadding: EdgeInsets.zero,
      children: [
        ListTile(
          title: Text(serviceFaq!.description.validate(), style: secondaryTextStyle()),
          contentPadding: EdgeInsets.only(bottom: 16),
        ),
      ],
    );
  }
}
