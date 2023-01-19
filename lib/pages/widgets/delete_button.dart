

import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget{
  final Function operationToExecute;

  const DeleteButton({required this.operationToExecute});

  @override
  Widget build(BuildContext context){
    return   ElevatedButton(
        onPressed: (){
          operationToExecute();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor:  Color.fromRGBO(255,0,0, 1)
        ),
        child: Text("Deletar")
    );
  }
}