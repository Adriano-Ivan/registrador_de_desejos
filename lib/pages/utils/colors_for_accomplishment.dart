

import 'package:flutter/material.dart';

final MaterialStateProperty<Color?> doneColor =
MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.amber;
    }
    return null;
  },
);

final MaterialStateProperty<Color?> undoneColor =
MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {

    if (states.contains(MaterialState.selected)) {
      return Colors.amber.withOpacity(0.54);
    }

    if (states.contains(MaterialState.disabled)) {
      return Colors.grey.shade400;
    }

    return null;
  },
);