library umiuni2d_beacon;

import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;

enum TinyBeaconRequestFlag {
  WHEN_IN_USE, //= "foreground_only";
  ALWAYS, //_REQUEST = "background"
}

enum TinyBeaconScanFlag { LOW, NORMAL, HIGH }

enum TinyBeaconProximity { NONE, IMMEDIATE, NEAR, FAR, UNKNOWN }

/**
 *
 *
 */
class TinyBeaconFoundBeacon {
  String uuid;
  int major;
  int minor;
  TinyBeaconProximity proximity;
  double accuracy;
  int rssi;
  int timeSec;

  TinyBeaconFoundBeacon(this.uuid, this.major, this.minor, this.rssi, this.proximity, this.accuracy, this.timeSec) {}

  @override
  String toString() {
    return "uuid:${uuid}, major:${major}, minor:${minor}, proximity:${proximity}, accuracy:${accuracy}, rssi:${rssi}, time:${timeSec}";
  }

  int get lazyHashCode {
    int result = 17;
    result = 37 * result + uuid.hashCode;
    result = 37 * result + major.hashCode;
    result = 37 * result + minor.hashCode;
    return result;
  }

  int get hashCode {
    int result = lazyHashCode;
    result = 37 * result + proximity.hashCode;
    result = 37 * result + accuracy.hashCode;
    result = 37 * result + rssi.hashCode;
    result = 37 * result + timeSec.hashCode;
    return result;
  }

  bool lazyEqual(o) {
    if (!(o is TinyBeaconFoundBeacon)) {
      return false;
    }
    TinyBeaconFoundBeacon p = o;
    return (uuid == p.uuid && major == p.major && minor == p.minor);
  }

  bool operator ==(o) {
    if (false == lazyEqual(o)) {
      return false;
    }
    TinyBeaconFoundBeacon p = o;
    return (proximity == p.proximity && accuracy == p.accuracy && rssi == p.rssi && timeSec == p.timeSec);
  }
}

/**
 *
 *
 */
abstract class TinyBeaconFoundResult {
  int get timePerSec;
  List<TinyBeaconFoundBeacon> get beacons;

  @override
  String toString() {
    StringBuffer buffer = new StringBuffer();
    buffer.write("time: ${timePerSec}\n");
    for (TinyBeaconFoundBeacon b in beacons) {
      buffer.write("::beacon: ${b}\n");
    }
    return buffer.toString();
  }
}

/**
 *
 *
 */
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

/**
 *
 *
 */
abstract class TinyBeacon {
  //
  // android only : empty beacons is scan all beacon.
  startLescan(List<TinyBeaconScanInfo> beacons, {flag: TinyBeaconScanFlag.NORMAL});
  stopLescan();
  requestPermissions({TinyBeaconRequestFlag flag: TinyBeaconRequestFlag.WHEN_IN_USE});
  Future<TinyBeaconFoundResult> getFoundBeacon();
  clearFoundedBeacon();

  //
  static int toIntFromTinyBeaconProximity(TinyBeaconProximity proximity) {
    switch (proximity) {
      case TinyBeaconProximity.NONE:
        return 0;
      case TinyBeaconProximity.IMMEDIATE:
        return 1;
      case TinyBeaconProximity.NEAR:
        return 2;
      case TinyBeaconProximity.FAR:
        return 3;
      case TinyBeaconProximity.UNKNOWN:
        return 4;
    }
    return 0;
  }

  static TinyBeaconProximity toTinyBeaconProximityFromInt(int proximity) {
    switch (proximity) {
      case 0:
        return TinyBeaconProximity.NONE;
      case 1:
        return TinyBeaconProximity.IMMEDIATE;
      case 2:
        return TinyBeaconProximity.NEAR;
      case 3:
        return TinyBeaconProximity.FAR;
      case 4:
        return TinyBeaconProximity.UNKNOWN;
    }
    return TinyBeaconProximity.NONE;
  }

  static String toStringFromTinyBeaconProximity(TinyBeaconProximity proximity) {
    switch (proximity) {
      case TinyBeaconProximity.NONE:
        return "none";
      case TinyBeaconProximity.IMMEDIATE:
        return "immediate";
      case TinyBeaconProximity.NEAR:
        return "near";
      case TinyBeaconProximity.FAR:
        return "far";
      case TinyBeaconProximity.UNKNOWN:
        return "unknown";
    }
    return "none";
  }

  static TinyBeaconProximity toTinyBeaconProximityFromString(String proximity) {
    switch (proximity) {
      case "none":
        return TinyBeaconProximity.NONE;
      case "immediate":
        return TinyBeaconProximity.IMMEDIATE;
      case "near":
        return TinyBeaconProximity.NEAR;
      case "far":
        return TinyBeaconProximity.FAR;
      case "unknown":
        return TinyBeaconProximity.UNKNOWN;
    }
    return TinyBeaconProximity.NONE;
  }
}

/**
 *
 *
 */
class TinyBeaconUuid {
  static math.Random _random = new math.Random();

  static String createUuid() {
    return s4() + s4() + "-" + s4() + "-" + s4() + "-" + s4() + "-" + s4() + s4() + s4();
  }

  static String normalizeUUIDString(String uuid) {
    if (uuid.contains("-")) {
      return uuid;
    } else {
      return "${uuid.substring(0,8)}-${uuid.substring(8,12)}" + "-${uuid.substring(12,16)}-${uuid.substring(16,20)}" + "-${uuid.substring(20)}".toLowerCase();
    }
  }

  static String s4() {
    return (_random.nextInt(0xFFFF) + 0x10000).toRadixString(16).substring(0, 4);
  }

  static List<String> _v = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"];
  static String toStringFromBytes(Uint8List uuidBytes, {int start: 0}) {
    StringBuffer buffer = new StringBuffer();
    for (int i = 0; i < 16; i++) {
      int v = uuidBytes[i + start];
      buffer.write(_v[0xf & (v >> 4)]);
      buffer.write(_v[0xf & (v >> 0)]);
    }
    return normalizeUUIDString(buffer.toString());
  }

  static Uint8List toBytesFromUUID(String normalizedUUID) {
    Uint8List buffer = new Uint8List(16);
    int i = 0;
    List<int> codeUnits = normalizedUUID.codeUnits;
    for (int j = 0; j < codeUnits.length;) {
      int v1 =-1;
      int v2 = -1;
      int datam = codeUnits[j++];
      if (48 <= datam && datam <=57 ) {
        v1 = datam - 48;
      } else if (65 <= datam && datam <=70) {
        v1 = datam - 65 + 10;
      } else if (97 <= datam && datam <= 102) {
        v1 = datam - 97 + 10;
      }
      if(v1 < 0) {
        continue;
      }
      datam = codeUnits[j++];
      if (48 <= datam && datam <=57 ) {
        v2 = datam - 48;
      } else if (65 <= datam && datam <=70) {
        v2 = datam - 65 + 10;
      } else if (97 <= datam && datam <= 102) {
        v2 = datam - 97 + 10;
      }
      buffer[i++] = v1 << 4 | v2;
    }
    return buffer;
  }
}
