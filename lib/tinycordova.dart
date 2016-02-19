library umiuni2d_cordova;

import 'dart:js' as js;
import 'dart:async';

class TinyCordova {
  Future<Object> exec(String service, String action, List args) async {
    Completer completer = new Completer();
    try {
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
