library umiuni2d_beacon_cordova;

import 'dart:async';
import 'dart:convert';
import 'tinycordova.dart';
import 'tinybeacon.dart';

class TinyBeaconCordova extends TinyBeacon {
  TinyCordova cordova = new TinyCordova();

  //
  //
  // android only : empty beacons is scan all beacon.
  startLescan(List<TinyBeaconScanInfo> beacons, {flag: TinyBeaconScanFlag.NORMAL}) async {
    Map args = {};
    switch (flag) {
      case TinyBeaconScanFlag.LOW:
        args["power"] = "low";
        break;
      case TinyBeaconScanFlag.HIGH:
        args["power"] = "high";
        break;
      case TinyBeaconScanFlag.NORMAL:
      default:
        args["power"] = "normal";
        break;
    }
    List beaconArgs = [];
    for (TinyBeaconScanInfo s in beacons) {
      beaconArgs.add(s.toMap());
    }
    args["beacons"] = beaconArgs;
    return await cordova.exec("TinyBeacon", "startLescan", [JSON.encode(args)]);
  }

  stopLescan() async {
    return await cordova.exec("TinyBeacon", "stopLescan", []);
  }

  requestPermissions({TinyBeaconRequestFlag flag: TinyBeaconRequestFlag.WHEN_IN_USE}) async {
    String flagForCordova;
    if (flag == TinyBeaconRequestFlag.WHEN_IN_USE) {
      flagForCordova = "when_in_use";
    } else {
      flagForCordova = "always";
    }
    return await cordova.exec("TinyBeacon", "requestPermissions", [flagForCordova]);
  }

  Future<TinyBeaconFoundResult> getFoundBeacon() async {
    String source = await cordova.exec("TinyBeacon", "getFoundBeacon", []);
    return new TinyBeaconFoundInfoCordova(source);
  }

  clearFoundedBeacon() async {
    return await cordova.exec("TinyBeacon", "clearFoundedBeacon", []);
  }
}

class TinyBeaconFoundInfoCordova extends TinyBeaconFoundResult {
  String source;
  bool isDecode = false;

  int _mTimePerSec = 0;
  List<TinyBeaconFoundBeacon> _mBeacons = [];

  TinyBeaconFoundInfoCordova(this.source) {}

  int get timePerSec {
    _decode();
    return _mTimePerSec;
  }

  List<TinyBeaconFoundBeacon> get beacons {
    _decode();
    return _mBeacons;
  }

  _decode() {
    if (isDecode == true) {
      return;
    } else {
      //print("########## ${source}");
      //
      Map root = JSON.decode(source);
      _mTimePerSec = root["time"];
      List<Map> beacons = root["founded"];
      for (Map b in beacons) {
        _mBeacons.add(new TinyBeaconFoundBeacon()
          ..uuid = b["uuid"]
          ..major = b["major"]
          ..minor = b["minor"]
          ..proximity = b["proximity"]
          ..accuracy = b["accuracy"]
          ..timeSec = b["time"]
          ..rssi = b["rssi"]);
      }
      isDecode = true;
    }
  }
}
