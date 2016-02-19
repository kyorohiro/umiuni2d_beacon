library umiuni2d_beacon;

import 'dart:js' as js;
import 'dart:async';
import 'dart:html' as html;

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
  FOREGROUND_ONLY,//= "foreground_only";
  BACKGROUND,//_REQUEST = "background"
}
class TinyBeacon {
  TinyCordova cordova = new TinyCordova();

  startLescan() async {
    return await cordova.exec("TinyBeacon", "startLescan", []);
  }

  stopLescan() async {
    return await cordova.exec("TinyBeacon", "stopLescan", []);
  }

  requestPermissions({TinyBeaconRequestFlag flag:TinyBeaconRequestFlag.FOREGROUND_ONLY}) async {
    String flag;
    if(flag == TinyBeaconRequestFlag.FOREGROUND_ONLY) {
      flag  = "foreground_only";
    } else {
      flag  = "background";
    }
    return await cordova.exec("TinyBeacon", "requestPermissions", [flag]);
  }

  Future<String> getFoundBeacon() async {
    return await cordova.exec("TinyBeacon", "getFoundBeacon", []);
  }

  clearFoundedBeacon() async {
    return await cordova.exec("TinyBeacon", "clearFoundedBeacon", []);
  }
}
