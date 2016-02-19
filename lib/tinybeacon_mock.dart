library umiuni2d_beacon_mock;

import 'dart:async';
import 'dart:convert';
import 'tinycordova.dart';
import 'tinybeacon.dart';

class TinyBeaconMock extends TinyBeacon {
  //
  // android only : empty beacons is scan all beacon.
  startLescan(List<TinyBeaconScanInfo> beacons, {flag: TinyBeaconScanFlag.NORMAL}) async {
  }

  stopLescan() async {
  }

  requestPermissions({TinyBeaconRequestFlag flag: TinyBeaconRequestFlag.WHEN_IN_USE}) async {
  }

  Future<TinyBeaconFoundInfo> getFoundBeacon() async {
  }

  clearFoundedBeacon() async {
  }
}
