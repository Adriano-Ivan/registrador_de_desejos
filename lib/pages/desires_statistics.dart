import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";
import 'package:registrador_de_desejos/data/dao/desire_dao.dart';
import 'package:registrador_de_desejos/data/models/statistic_percentage_status_comparison.dart';
import 'package:registrador_de_desejos/pages/widgets/app_desires_bottom_navigation_bar.dart';

class DesiresStatistics extends StatefulWidget{

  @override
  _DesiresStatistics createState() => _DesiresStatistics();
}


class _DesiresStatistics extends State<DesiresStatistics>{

  StatisticPercentageStatusComparison? statisticPercentageStatusComparison = null;
  bool wasLoaded = false;

  double convertToIntSize(double size){
    return (size / 2 );
  }

  double formatPercentage(double percentage){
    return double.parse(percentage.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;

    DesireDAO().returnStatisticPercentageStatusComparison().then((statisticPercentageStatusComparison){
        if(!wasLoaded || statisticPercentageStatusComparison == null){
          setState((){
            wasLoaded = true;
            this.statisticPercentageStatusComparison = statisticPercentageStatusComparison;
          });
        }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Estatísticas de desejos")
      ),
      body:
          wasLoaded ?
         Center(
            child: Card(
              child: Column(
                children: [
                  Expanded(
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 0,
                            sections: [
                              PieChartSectionData(
                                value: formatPercentage(statisticPercentageStatusComparison!.numberOfPending),
                                title: "${formatPercentage(statisticPercentageStatusComparison!.numberOfPending)}%",
                                color: Color.fromRGBO(255, 255, 0, 1),
                                radius: size.width / 3
                              ),
                              PieChartSectionData(
                                  value: formatPercentage(statisticPercentageStatusComparison!.numberOfAccomplished),
                                  title: "${formatPercentage(statisticPercentageStatusComparison!.numberOfAccomplished)}%",
                                  color: Color.fromRGBO(46, 184, 46, 1),
                                  radius:  size.width / 3
                              ),
                              PieChartSectionData(
                                  value: formatPercentage(statisticPercentageStatusComparison!.numberOfNotAccomplishedUntilTargetDate),
                                  title: "${formatPercentage(statisticPercentageStatusComparison!.numberOfNotAccomplishedUntilTargetDate)}%",
                                  color: Color.fromRGBO(255,0,0,1),
                                  radius: size.width / 3
                              ),
                              PieChartSectionData(
                                  value: formatPercentage(statisticPercentageStatusComparison!.numberOfAccomplishedInAdvance),
                                  title: "${formatPercentage(statisticPercentageStatusComparison!.numberOfAccomplishedInAdvance)}%",
                                  color: Color.fromRGBO(0,102,0,1),
                                  radius:size.width / 3
                              ),
                            ]
                          ),
                         // Optional

                        ),
                  ),

                ],
              ),
            ),
          ) : Center(
            child: CircularProgressIndicator(),
          ),

      bottomNavigationBar: AppDesiresBottomNavigationBar(),
    );
  }
}