import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";
import 'package:registrador_de_desejos/pages/widgets/app_desires_bottom_navigation_bar.dart';

class DesiresStatistics extends StatefulWidget{

  @override
  _DesiresStatistics createState() => _DesiresStatistics();
}


class _DesiresStatistics extends State<DesiresStatistics>{

  double convertToIntSize(double size){
    return (size / 2 );
  }
  
  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Estatísticas de desejos")
      ),
      body:
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
                                value: 25,
                                color: Color.fromRGBO(255, 255, 0, 1),
                                radius: 120
                              ),
                              PieChartSectionData(
                                  value: 25,
                                  color: Color.fromRGBO(46, 184, 46, 1),
                                  radius: 120
                              ),
                              PieChartSectionData(
                                  value: 25,
                                  color: Color.fromRGBO(255,0,0,1),
                                  radius: 120
                              ),
                              PieChartSectionData(
                                  value: 25,
                                  color: Color.fromRGBO(0,102,0,1),
                                  radius: 120
                              ),
                            ]
                          ),
                         // Optional

                        ),
                  ),
                 
                ],
              ),
            ),
          ),

      bottomNavigationBar: AppDesiresBottomNavigationBar(),
    );
  }
}