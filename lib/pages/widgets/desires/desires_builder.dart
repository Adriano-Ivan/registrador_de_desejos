
import 'package:flutter/material.dart';
import 'package:registrador_de_desejos/data/models/desire.dart';
import 'package:registrador_de_desejos/data/services/desire_dao.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desire_item.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desires_screen_type.dart';

class DesiresBuilder extends StatefulWidget{

  DesiresScreenType screenType;
  Function reconfigureList;

  DesiresBuilder({required this.screenType, required this.reconfigureList});

  @override
  _DesiresBuilder createState() => _DesiresBuilder();
}

class _DesiresBuilder extends State<DesiresBuilder>{

  Future<List<Desire>>? returnDesires(){
    if(widget.screenType == DesiresScreenType.allAccomplishedDesires){
      return DesireDAO().findAllAccomplishedOrNotAccomplished(1);
    } else if(widget.screenType == DesiresScreenType.allNotAccomplishedDesires){
      return DesireDAO().findAllAccomplishedOrNotAccomplished(0);
    }

    return DesireDAO().findAll();
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: returnDesires(),
        builder: (context, snapshot){
          List<Desire>? items = snapshot.data;
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    Text('Carregando'),
                  ],
                ),
              );
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    Text('Carregando'),
                  ],
                ),
              );
            case ConnectionState.active:
              return Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    Text('Carregando'),
                  ],
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasData && items != null) {
                if (items.isNotEmpty) {
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {

                        final Desire desire = items[index];

                        return DesireItem(
                            reconfigureList: widget.reconfigureList,
                            desire: desire,
                            isToResetListBecauseItemDoesNotFitInList: widget.screenType == DesiresScreenType.allNotAccomplishedDesires
                            || widget.screenType == DesiresScreenType.allAccomplishedDesires,
                        );
                      });
                }
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: const [
                        Icon(
                          Icons.error_outline,
                          size: 128,
                        ),
                        Text(
                          "Não há nenhum desejo",
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    ));
              }
          }
          return const Text('Erro desconhecido');
        }
    );
  }
}