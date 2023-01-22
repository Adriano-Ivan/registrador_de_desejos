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


  @override
  Widget build(BuildContext context) {

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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text("Estatísticas de desejos"),
          bottom: TabBar(
            tabs: [
              Tab(
                text:"Porcentagem",
                icon: Icon(Icons.pie_chart),
              ),
              Tab(
                text:"Números",
                icon: Icon(Icons.bar_chart),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PieChartDesires(
                wasLoaded: wasLoaded,
                statisticPercentageStatusComparison: statisticPercentageStatusComparison),
            Text("TESTE")
          ],
        ),
        bottomNavigationBar: AppDesiresBottomNavigationBar(),
      ),
    );
  }
}

class PieChartDesires extends StatefulWidget{
  final bool wasLoaded;
  final StatisticPercentageStatusComparison? statisticPercentageStatusComparison;

  PieChartDesires({required this.wasLoaded, required this.statisticPercentageStatusComparison});

  @override
  _PieChartDesires createState() => _PieChartDesires();
}

class _PieChartDesires extends State<PieChartDesires>{

  double convertToIntSize(double size) {
    return (size / 2);
  }

  double formatPercentage(double percentage) {
    return double.parse(percentage.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;

    return widget.wasLoaded
        ? Center(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: PieChart(
                PieChartData(centerSpaceRadius: 0, sections: [
                  PieChartSectionData(
                      value: formatPercentage(
                          widget.statisticPercentageStatusComparison!
                              .numberOfPendingPercentage),
                      title:
                      "${formatPercentage(widget.statisticPercentageStatusComparison!.numberOfPendingPercentage)}%",
                      color: Color.fromRGBO(255, 255, 0, 1),
                      radius: size.width / 3),
                  PieChartSectionData(
                      value: formatPercentage(
                          widget.statisticPercentageStatusComparison!
                              .numberOfAccomplishedPercentage),
                      title:
                      "${formatPercentage(widget.statisticPercentageStatusComparison!.numberOfAccomplishedPercentage)}%",
                      color: Color.fromRGBO(46, 184, 46, 1),
                      radius: size.width / 3),
                  PieChartSectionData(
                      value: formatPercentage(
                          widget.statisticPercentageStatusComparison!
                              .numberOfNotAccomplishedUntilTargetDatePercentage),
                      title:
                      "${formatPercentage(widget.statisticPercentageStatusComparison!.numberOfNotAccomplishedUntilTargetDatePercentage)}%",
                      color: Color.fromRGBO(255, 0, 0, 1),
                      radius: size.width / 3),
                  PieChartSectionData(
                      value: formatPercentage(
                          widget.statisticPercentageStatusComparison!
                              .numberOfAccomplishedInAdvancePercentage),
                      title:
                      "${formatPercentage(widget.statisticPercentageStatusComparison!.numberOfAccomplishedInAdvancePercentage)}%",
                      titleStyle: TextStyle(
                        color: Colors.white,
                      ),
                      color: Color.fromRGBO(0, 102, 0, 1),
                      radius: size.width / 3),
                ]),
                // Optional
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
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
