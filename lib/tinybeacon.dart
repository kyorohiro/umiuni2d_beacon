library umiuni2d_beacon;

import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;

part 'src/uuid.dart';
part 'src/foundresult.dart';

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
abstract class TinyBeacon {
  //
  // android only : empty beacons is scan all beacon.
  startLescan(List<TinyBeaconScanInfo> beacons, {flag: TinyBeaconScanFlag.NORMAL});
  stopLescan();
  requestPermissions({TinyBeaconRequestFlag flag: TinyBeaconRequestFlag.WHEN_IN_USE});
  Future<TinyBeaconFoundResult> getFoundBeacon();
  clearFoundedBeacon();
}

class TinyBeaconUtil {
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
