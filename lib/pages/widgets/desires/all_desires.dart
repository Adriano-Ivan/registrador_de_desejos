
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:flutter/cupertino.dart';
import 'package:registrador_de_desejos/data/models/desire.dart';
import 'package:registrador_de_desejos/data/services/desire_dao.dart';
import 'package:registrador_de_desejos/pages/widgets/desires/desire_item.dart';

class AllDesires extends StatefulWidget{

  @override
  _AllDesires createState() => _AllDesires();
}

class _AllDesires extends State<AllDesires>{
  bool showDesires = false;

  @override
  Widget build(BuildContext context){

    return FutureBuilder(
        future: DesireDAO().findAll(),
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
                          desire: desire
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