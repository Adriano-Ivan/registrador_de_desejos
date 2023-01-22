import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";
import 'package:registrador_de_desejos/data/dao/desire_dao.dart';
import 'package:registrador_de_desejos/data/models/statistic_percentage_status_comparison.dart';
import 'package:registrador_de_desejos/pages/widgets/app_desires_bottom_navigation_bar.dart';

class DesiresStatistics extends StatefulWidget {
  @override
  _DesiresStatistics createState() => _DesiresStatistics();
}

class _DesiresStatistics extends State<DesiresStatistics> {
  StatisticPercentageStatusComparison? statisticPercentageStatusComparison =
      null;
  bool wasLoaded = false;

  double convertToIntSize(double size) {
    return (size / 2);
  }

  double formatPercentage(double percentage) {
    return double.parse(percentage.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    DesireDAO()
        .returnStatisticPercentageStatusComparison()
        .then((statisticPercentageStatusComparison) {
      if (!wasLoaded || statisticPercentageStatusComparison == null) {
        setState(() {
          wasLoaded = true;
          this.statisticPercentageStatusComparison =
              statisticPercentageStatusComparison;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text("Estatísticas de desejos")),
      body: wasLoaded
          ? Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(centerSpaceRadius: 0, sections: [
                          PieChartSectionData(
                              value: formatPercentage(
                                  statisticPercentageStatusComparison!
                                      .numberOfPendingPercentage),
                              title:
                                  "${formatPercentage(statisticPercentageStatusComparison!.numberOfPendingPercentage)}%",
                              color: Color.fromRGBO(255, 255, 0, 1),
                              radius: size.width / 3),
                          PieChartSectionData(
                              value: formatPercentage(
                                  statisticPercentageStatusComparison!
                                      .numberOfAccomplishedPercentage),
                              title:
                                  "${formatPercentage(statisticPercentageStatusComparison!.numberOfAccomplishedPercentage)}%",
                              color: Color.fromRGBO(46, 184, 46, 1),
                              radius: size.width / 3),
                          PieChartSectionData(
                              value: formatPercentage(
                                  statisticPercentageStatusComparison!
                                      .numberOfNotAccomplishedUntilTargetDatePercentage),
                              title:
                                  "${formatPercentage(statisticPercentageStatusComparison!.numberOfNotAccomplishedUntilTargetDatePercentage)}%",
                              color: Color.fromRGBO(255, 0, 0, 1),
                              radius: size.width / 3),
                          PieChartSectionData(
                              value: formatPercentage(
                                  statisticPercentageStatusComparison!
                                      .numberOfAccomplishedInAdvancePercentage),
                              title:
                                  "${formatPercentage(statisticPercentageStatusComparison!.numberOfAccomplishedInAdvancePercentage)}%",
                              color: Color.fromRGBO(0, 102, 0, 1),
                              radius: size.width / 3),
                        ]),
                        // Optional
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: size.width/ 8),
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IndicatorDesireStatusPercentage(
                                  color: Color.fromRGBO(255, 255, 0, 1),
                                  text: "Desejo pendente"),
                            ],
                          ),
                          Row(
                            children: [
                              IndicatorDesireStatusPercentage(
                                  color: Color.fromRGBO(46, 184, 46, 1),
                                  text: "Desejo realizado"),
                            ],
                          ),
                          Row(
                            children: [
                              IndicatorDesireStatusPercentage(
                                  color: Color.fromRGBO(255, 0, 0, 1),
                                  text: "Desejo pendente e não realizado"),
                            ],
                          ),
                          Row(
                            children: [
                              IndicatorDesireStatusPercentage(
                                  color: Color.fromRGBO(0, 102, 0, 1),
                                  text: "Desejo realizado adiantadamente"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: AppDesiresBottomNavigationBar(),
    );
  }
}

class IndicatorDesireStatusPercentage extends StatelessWidget {
  final Color color;
  final String text;

  IndicatorDesireStatusPercentage({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(
      children: [
        Container(
          margin: EdgeInsets.all(4.0),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color,
          ),
        ),
        Container(
          margin: EdgeInsets.all(4.0),
          child: Text(text),
        )
      ],
    ));
  }
}
