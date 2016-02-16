library tinybeacon;

import 'dart:js' as js;
import 'dart:async';

class Cordova {
  Future<String> exec(String action, List<String> args) {
    Completer completer = new Completer();
    js.JsObject root = js.context;
    if(root.hasProperty("cordova")) {
      throw "not found cordova";
    };
    root.callMethod("exec",[
      (a){completer.complete(a);},
      (b){completer.completeError(b);},
      args]);
    return completer.future;
  }
}
