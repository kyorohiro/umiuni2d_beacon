library umiuni2d_beacon_mock;

import 'dart:async';
import 'tinybeacon.dart';

class TinyBeaconMock extends TinyBeacon {
  bool isScanning = false;
  TinyBeaconFoundResultMock beaconResult = new TinyBeaconFoundResultMock();

  //
  // android only : empty beacons is scan all beacon.
  startLescan(List<TinyBeaconScanInfo> beacons, {flag: TinyBeaconScanFlag.NORMAL}) async {
    isScanning = true;
  }

  stopLescan() async {
    isScanning = false;
  }

  requestPermissions({TinyBeaconRequestFlag flag: TinyBeaconRequestFlag.WHEN_IN_USE}) async {
  }

  Future<TinyBeaconFoundResult> getFoundBeacon() async {
    return beaconResult;
  }

  clearFoundedBeacon() async {
  }

}

class TinyBeaconFoundResultMock extends TinyBeaconFoundResult {
  int timePerSec = 0;

  List<TinyBeaconFoundBeacon> beacons = [];
}
