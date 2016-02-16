library tinybeacon;

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

class TinyBeacon {
  TinyCordova cordova = new TinyCordova();

  startLescan() async {
    return await cordova.exec("TinyBeacon", "startLescan", []);
  }

  stopLescan() async {
    return await cordova.exec("TinyBeacon", "stopLescan", []);
  }

  requestPermissions() async {
    return await cordova.exec("TinyBeacon", "requestPermissions", []);
  }

  Future<String> getFoundBeacon() async {
    return await cordova.exec("TinyBeacon", "getFoundBeacon", []);
  }

  clearFoundedBeacon() async {
    return await cordova.exec("TinyBeacon", "clearFoundedBeacon", []);
  }
}
