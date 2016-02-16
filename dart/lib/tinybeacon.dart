library tinybeacon;

import 'dart:js' as js;
import 'dart:async';
import 'dart:html' as html;

class TinyCordova {
  Future<String> exec(String service, String action, List args) {
    Completer completer = new Completer();
    try {
      print("##----B001-----");
      html.window;
      js.JsObject root = js.context;

      if (false == root.hasProperty("cordova")) {
        throw "not found cordova";
      }
      js.JsObject cordova= root["cordova"];
      print("##----B002-----");

      cordova.callMethod("exec", [
        (a) {
          print("##----B002a-----");
          completer.complete(a);
        },
        (b) {
          print("##----B002b-----${b}");
          completer.completeError(b);
          print("##----B002ba-----${b}");
        },
        service,
        action,
        new js.JsObject.jsify(args)
      ]);
    } catch (e) {
      print("##----B003-----");
      completer.completeError(e);
    }
    return completer.future;
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
    print("##----A001-----");
/*
    js.JsObject a = new js.JsObject(js.context["cordova"]["plugins"]["TinyBeacon"]);
    Completer c = new Completer();
    a.callMethod("requestPermissions",[
      (){c.complete("");},
      (){c.completeError("");}]);
    return await c.future;
*/
    return await cordova.exec( "TinyBeacon", "requestPermissions", []);
  }

  Future<String> getFoundBeacon() async {
    return await cordova.exec("TinyBeacon", "getFoundBeacon", []);
  }

  clearFoundedBeacon() async {
    return await cordova.exec("TinyBeacon", "clearFoundedBeacon", []);
  }
}
