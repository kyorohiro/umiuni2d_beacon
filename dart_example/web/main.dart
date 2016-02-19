// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' as html;
import 'package:umiuni2d_beacon/tinybeacon.dart';

void main() {
  TinyBeacon beacon = new TinyBeacon();
  {
    html.InputElement startLescanButton = new html.InputElement(type: "button");
    startLescanButton.value = "startlescan";
    startLescanButton.onClick.listen((html.MouseEvent e) async {
      print("click startlescan");
      try {
        await beacon.startLescan(
          [new TinyBeaconScanInfo("f7826da64fa24e988024bc5b71e0893e"),
          new TinyBeaconScanInfo("f7826da64fa24e988024bc5b71e0893f")]);
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
    html.InputElement requestPermissionsButton = new html.InputElement(type: "button");
    requestPermissionsButton.value = "requestPermissions_for";
    requestPermissionsButton.onClick.listen((html.MouseEvent e) async {
      print("click requestPermissions");
      try {
        await beacon.requestPermissions();
      } catch(e) {
        print("##----C003-----${e}");
      }
    });
    html.document.body.children.add(requestPermissionsButton);
  }
  {
    html.InputElement requestPermissionsButton = new html.InputElement(type: "button");
    requestPermissionsButton.value = "requestPermissions_bac";
    requestPermissionsButton.onClick.listen((html.MouseEvent e) async {
      print("click requestPermissions");
      try {
        await beacon.requestPermissions(flag: TinyBeaconRequestFlag.ALWAYS);
      } catch(e) {
        print("##----C003-----${e}");
      }
    });
    html.document.body.children.add(requestPermissionsButton);
  }
  {
    html.InputElement getFoundBeaconButton = new html.InputElement(type: "button");
    getFoundBeaconButton.value = "getFoundBeaconButton";
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
    clearFoundBeaconButton.value = "clearFoundBeaconButton";
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
