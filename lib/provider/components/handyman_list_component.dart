import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/view_all_label_component.dart';
import 'package:provider/main.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/provider/components/handyman_widget.dart';
import 'package:provider/provider/handyman_list_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class HandymanListComponent extends StatelessWidget {
  final List<UserData> list;

  HandymanListComponent({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return Offstage();

    return Container(
      color: context.cardColor,
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewAllLabel(
            label: languages.handyman,
            subLabel: languages.lblShowingOnly4Handyman,
            list: list,
            onTap: () {
              HandymanListScreen().launch(context);
            },
          ),
          16.height,
          Stack(
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  list.take(4).length,
                  (index) {
                    return HandymanWidget(
                      data: list[index],
                      width: context.width() * 0.48 - 20,
                      onUpdate: () {},
                    );
                  },
                ),
              ),
              Observer(
                builder: (context) => NoDataWidget(
                  title: languages.noHandymanYet,
                  subTitle: languages.noHandymanSubTitle,
                  imageWidget: EmptyStateWidget(),
                ).visible(!appStore.isLoading && list.validate().isEmpty),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
