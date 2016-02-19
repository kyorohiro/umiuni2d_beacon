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

  Future<String> getFoundBeacon() async {
    return await cordova.exec("TinyBeacon", "getFoundBeacon", []);
  }

  clearFoundedBeacon() async {
    return await cordova.exec("TinyBeacon", "clearFoundedBeacon", []);
  }
}
