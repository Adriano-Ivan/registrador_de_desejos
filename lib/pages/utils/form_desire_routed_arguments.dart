
import 'package:registrador_de_desejos/data/models/desire.dart';

class FormDesireRoutedArguments {
  final bool isToEdit;
  final Desire? desire;

  FormDesireRoutedArguments({required this.isToEdit,required this.desire});
}