// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' as html;
import 'package:tinybeacon/tinybeacon.dart';

void main() {
  TinyBeacon beacon = new TinyBeacon();
  {
    html.InputElement startLescanButton = new html.InputElement(type: "button");
    startLescanButton.value = "startlescan";
    startLescanButton.onClick.listen((html.MouseEvent e) async {
      print("click startlescan");
      try {
        await beacon.startLescan();
      } catch(e) {
        print("##----C003-----${e}");
        print("failed to startLescan");
      }
    });
    html.document.body.children.add(startLescanButton);
  }
  {
    html.InputElement stopLescanButton = new html.InputElement(type: "button");
    stopLescanButton.value = "stoplescan";
    stopLescanButton.onClick.listen((html.MouseEvent e) async {
      print("click stoplescan");
      try {
        await beacon.stopLescan();
      } catch(e) {
        print("##----C003-----${e}");
        print("failed to stopLescan");
      }
    });
    html.document.body.children.add(stopLescanButton);
  }

  {
    html.InputElement stopLescanButton = new html.InputElement(type: "button");
    stopLescanButton.value = "requestPermissions";
    stopLescanButton.onClick.listen((html.MouseEvent e) async {
      print("click requestPermissions");
      try {
        await beacon.requestPermissions();
      } catch(e) {
        print("##----C003-----${e}");
      }
    });
    html.document.body.children.add(stopLescanButton);
  }

  {
    html.InputElement getFoundBeaconButton = new html.InputElement(type: "button");
    getFoundBeaconButton.value = "requestPermissions";
    getFoundBeaconButton.onClick.listen((html.MouseEvent e) async {
      print("click getFoundBeacon");
      try {
        print("${await beacon.getFoundBeacon()}");
      } catch(e) {
        print("##----C003-----${e}");
      }
    });
    html.document.body.children.add(getFoundBeaconButton);
  }
  {
    html.InputElement clearFoundBeaconButton = new html.InputElement(type: "button");
    clearFoundBeaconButton.value = "requestPermissions";
    clearFoundBeaconButton.onClick.listen((html.MouseEvent e) async {
      print("click clearFoundBeacon");
      try {
        beacon.clearFoundedBeacon();
      } catch(e) {
        print("##----C003-----${e}");
      }
    });
    html.document.body.children.add(clearFoundBeaconButton);
  }
}
