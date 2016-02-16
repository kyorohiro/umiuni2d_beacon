// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' as html;
import 'package:tinybeacon/tinybeacon.dart';

void main() {
  TinyBeacon beacon = new TinyBeacon();
  {
    html.InputElement startLescanButton = new html.InputElement(type: "button");
    startLescanButton.value = "startlescan";
    startLescanButton.onClick.listen((html.MouseEvent e) {
      print("click startlescan");
    });
    html.document.body.children.add(startLescanButton);
  }
  {
    html.InputElement stopLescanButton = new html.InputElement(type: "button");
    stopLescanButton.value = "stoplescan";
    stopLescanButton.onClick.listen((html.MouseEvent e) {
      print("click stoplescan");
    });
    html.document.body.children.add(stopLescanButton);
  }

  {
    html.InputElement stopLescanButton = new html.InputElement(type: "button");
    stopLescanButton.value = "requestPermissions";
    stopLescanButton.onClick.listen((html.MouseEvent e) {
      print("click requestPermissions");
      try {
        beacon.requestPermissions();
      } catch(e) {
        print("failed to requestPermissions");
      }
    });
    html.document.body.children.add(stopLescanButton);
  }
}
