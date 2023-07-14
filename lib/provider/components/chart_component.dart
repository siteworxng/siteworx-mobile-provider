import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/revenue_chart_data.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: SfCartesianChart(
        title: ChartTitle(
          text: languages.lblMonthlyRevenue + ' (${getStringAsync(CURRENCY_COUNTRY_CODE)})',
          textStyle: secondaryTextStyle(),
        ),
        primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0), axisLine: AxisLine(width: 0)),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderWidth: 1.5,
          color: context.cardColor,
          textStyle: secondaryTextStyle(color: context.iconColor),
        ),
        series: <ChartSeries>[
          StackedColumnSeries<RevenueChartData, String>(
            name: languages.lblRevenue,
            enableTooltip: true,
            color: primaryColor,
            dataSource: chartData,
            yValueMapper: (RevenueChartData sales, _) => sales.revenue,
            xValueMapper: (RevenueChartData sales, _) => sales.month,
          ),
        ],
      ),
    );
  }
}
