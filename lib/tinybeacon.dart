library umiuni2d_beacon;

import 'dart:async';

enum TinyBeaconRequestFlag {
  WHEN_IN_USE, //= "foreground_only";
  ALWAYS, //_REQUEST = "background"
}

enum TinyBeaconScanFlag { LOW, NORMAL, HIGH }

class TinyBeaconFoundBeacon {
  String uuid;
  int major;
  int minor;
  String proximity;
  double accuracy;
  int rssi;
  int timeSec;

  @override
  String toString() {
    return "uuid:${uuid}, major:${major}, minor:${minor}, proximity:${proximity}, accuracy:${accuracy}, rssi:${rssi}, time:${timeSec}";
  }
}

abstract class TinyBeaconFoundResult {
  int get timePerSec;
  List<TinyBeaconFoundBeacon> get beacons;

  @override
  String toString() {
    StringBuffer buffer = new StringBuffer();
    buffer.write("time: ${timePerSec}\n");
    for(TinyBeaconFoundBeacon b in beacons) {
      buffer.write("::beacon: ${b}\n");
    }
    return buffer.toString();
  }
}

class TinyBeaconScanInfo {
  String uuid;
  int major;
  int minor;
  TinyBeaconScanInfo(this.uuid, {this.major: null, this.minor: null}) {
    ;
  }

  String normalizeUUID() {
    if (uuid.contains("-")) {
      return uuid;
    } else {
      return "${uuid.substring(0,8)}-${uuid.substring(8,12)}" + "-${uuid.substring(12,16)}-${uuid.substring(16,20)}" + "-${uuid.substring(20)}";
    }
  }

  Map toMap() {
    Map r = {};
    r["uuid"] = normalizeUUID();
    r["major"] = major;
    r["minor"] = minor;
    return r;
  }
}

abstract class TinyBeacon {
  //
  // android only : empty beacons is scan all beacon.
  startLescan(List<TinyBeaconScanInfo> beacons, {flag: TinyBeaconScanFlag.NORMAL});
  stopLescan();
  requestPermissions({TinyBeaconRequestFlag flag: TinyBeaconRequestFlag.WHEN_IN_USE});
  Future<TinyBeaconFoundResult> getFoundBeacon();
  clearFoundedBeacon();
}
