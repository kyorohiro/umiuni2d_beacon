library umiuni2d_beacon;

import 'dart:js' as js;
import 'dart:async';
import 'dart:html' as html;
import 'dart:convert';

class TinyCordova {
  Future<Object> exec(String service, String action, List args) async {
    Completer completer = new Completer();
    try {
      html.window;
      js.JsObject root = js.context;

      if (false == root.hasProperty("cordova")) {
        throw "not found cordova";
      }
      js.JsObject cordova = root["cordova"];

      cordova.callMethod("exec", [
        (a) {
          completer.complete(a);
        },
        (b) {
          completer.completeError(b);
        },
        service,
        action,
        new js.JsObject.jsify(args)
      ]);
    } catch (e) {
      completer.completeError(e);
    }
    return await completer.future;
  }
}

enum TinyBeaconRequestFlag {
  WHEN_IN_USE,//= "foreground_only";
  ALWAYS,//_REQUEST = "background"
}
enum TinyBeaconScanFlag {
  LOW,
  NORMAL,
  HIGH
}

class TinyBeaconScanInfo {
    String uuid;
    int major;
    int minor;
    TinyBeaconScanInfo(this.uuid, {this.major:null, this.minor:null}){;}
    String normalizeUUID() {
      if(uuid.contains("-")) {
        return uuid;
      } else {
        return
        "${uuid.substring(0,8)}-${uuid.substring(8,12)}"+
        "-${uuid.substring(12,16)}-${uuid.substring(16,20)}"+
        "-${uuid.substring(20)}";
      }
    }

    String toJSONString() {
      Map r = {};
      r["uuid"] = normalizeUUID();
      r["major"] = major;
      r["minor"] = minor;
      return JSON.encode(r);
    }
}

class TinyBeacon {
  TinyCordova cordova = new TinyCordova();

  //
  //
  // android only : empty beacons is scan all beacon.
  startLescan(List<TinyBeaconScanInfo> beacons,{flag:TinyBeaconScanFlag.NORMAL}) async {
    List args = [];
    args.add(flag);
    args.addAll(beacons);
    return await cordova.exec("TinyBeacon", "startLescan", args);
  }

  stopLescan() async {
    return await cordova.exec("TinyBeacon", "stopLescan", []);
  }

  requestPermissions({TinyBeaconRequestFlag flag:TinyBeaconRequestFlag.WHEN_IN_USE}) async {
    String flagForCordova;
    if(flag == TinyBeaconRequestFlag.WHEN_IN_USE) {
      flagForCordova  = "when_in_use";
    } else {
      flagForCordova  = "always";
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
