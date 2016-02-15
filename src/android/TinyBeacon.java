package info.kyorohiro.tinybeacon;


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanResult;
import android.content.Context;

import java.util.LinkedList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class TinyBeacon {

    private List<TinyAdStructureEx> mFoundIBeacon = new LinkedList<TinyAdStructureEx>();
    private ScanCallback mCurrentScanCallback = null;
    private BluetoothManager mBluetoothManager = null;
    private BluetoothLeScanner mScanner = null;

    public void startLescan(Context context) {
        if (mCurrentScanCallback != null) {
            return;
        }
        mBluetoothManager = (BluetoothManager) context.getSystemService(Context.BLUETOOTH_SERVICE);
        BluetoothAdapter adapter = mBluetoothManager.getAdapter();
        mScanner = adapter.getBluetoothLeScanner();
        //
        MyCallback callback = new MyCallback(this);
        mScanner.startScan(callback);
        mCurrentScanCallback = callback;

    }

    public void stopLescan() {
        if(mCurrentScanCallback != null) {
            mScanner.stopScan(mCurrentScanCallback);
            mCurrentScanCallback = null;
        }
    }

    public List<TinyAdStructureEx> getFoundedBeeacon() {
        return mFoundIBeacon;
    }

    public String getFoundedBeeaconAsJSONText() throws JSONException {
        JSONObject ret = new JSONObject();
        List<JSONObject> t = new LinkedList<JSONObject>();
        for(TinyAdStructureEx e: mFoundIBeacon) {
            t.add(e.toJsonString());
        }
        ret.put("founded", new JSONArray(t));
        return ret.toString();
    }

    public void clearFoundedBeeacon() throws JSONException {
        mFoundIBeacon.clear();
    }

    //
    //
    //
    static class TinyAdStructureEx {
        int rssi;
        long time;
        TinyAdPacket packet;
        TinyAdStructureEx(TinyAdPacket _packet, int _rssi, long _time) {
            this.rssi = _rssi;
            this.time = _time;
            this.packet = _packet;
        }

        JSONObject toJsonString() throws JSONException {
            JSONObject ret = new JSONObject();
            ret.put("uuid", TinyIBeaconPacket.getUUIDHexStringAsIBeacon(packet));
            ret.put("major", TinyIBeaconPacket.getMajorAsIBeacon(packet));
            ret.put("minor", TinyIBeaconPacket.getMinorAsIBeacon(packet));
            ret.put("calrssi", TinyIBeaconPacket.getCalibratedRSSIAsIBeacon(packet));
            ret.put("rssi", rssi);
            ret.put("time", time);
            return ret;
        }

        @Override
        public boolean equals(Object o) {
            return packet.equals(0);
        }

        @Override
        public int hashCode() {
            return packet.hashCode();
        }
    }

    //
    //
    //
    static class MyCallback extends ScanCallback {
        TinyBeacon mParent = null;

        MyCallback(TinyBeacon parent) {
            mParent = parent;
        }

        @Override
        public void onScanResult(int callbackType, ScanResult result) {
            super.onScanResult(callbackType, result);
//            android.util.Log.v("beacon", "###SA## scanResult type:" + callbackType + " ,result: " + result.toString());
            long t = System.currentTimeMillis();
            List<TinyAdPacket> ad = TinyAdPacket.parse(result.getScanRecord().getBytes());
            for(TinyAdPacket a : ad){
                if(TinyIBeaconPacket.isIBeacon(a)) {
                    android.util.Log.v("KY", "uuid:" + TinyIBeaconPacket.getUUIDAsIBeacon(a) + ", major:" + TinyIBeaconPacket.getMajorAsIBeacon(a) + ", minor:" + TinyIBeaconPacket.getMinorAsIBeacon(a) + ",crssi:" + TinyIBeaconPacket.getCalibratedRSSIAsIBeacon(a));
                    if(false == mParent.mFoundIBeacon.contains(a)) {
                        TinyAdStructureEx ex = new TinyAdStructureEx(a, result.getRssi(), t);
                        mParent.mFoundIBeacon.add(ex);
                    } else {
                        int i = mParent.mFoundIBeacon.indexOf(a);
                        TinyAdStructureEx ex = mParent.mFoundIBeacon.get(i);
                        ex.rssi = result.getRssi();
                        ex.time = t;
                    }
                }
            }
        }

        @Override
        public void onBatchScanResults(List<ScanResult> results) {
            super.onBatchScanResults(results);
            StringBuilder builder = new StringBuilder();
            for (ScanResult r : results) {
                builder.append("re " + r + ",b:" + r.getScanRecord().getBytes()+", rssi:"+r.getRssi()+"\n");
            }
            android.util.Log.v("beacon", "###S## batchScanResult type:" + builder.toString());
        }

        @Override
        public void onScanFailed(int errorCode) {
            super.onScanFailed(errorCode);
            android.util.Log.v("beacon", "###S## scanFailed errorCode:" + errorCode);
        }
    }
}
