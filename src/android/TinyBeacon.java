package info.kyorohiro.tinybeacon;


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanFilter;
import android.bluetooth.le.ScanResult;
import android.bluetooth.le.ScanSettings;
import android.content.Context;

import java.util.LinkedList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class TinyBeacon {

    private List<TinyBeaconInfo> mFoundIBeacon = new LinkedList<TinyBeaconInfo>();
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
        ScanSettings.Builder settingsBuilder = new ScanSettings.Builder();
//        settingsBuilder.setCallbackType(0xff);
        settingsBuilder.setScanMode(ScanSettings.SCAN_MODE_LOW_POWER);
        MyCallback callback = new MyCallback(this);
        final ScanFilter.Builder filterBuilder = new ScanFilter.Builder();
        {
            byte[] manData = new byte[]{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
            byte[] mask = new byte[]{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
            filterBuilder.setManufacturerData(76, manData, mask);
        }
        List l = new LinkedList(){{add(filterBuilder.build());}};
        mScanner.startScan(l,settingsBuilder.build(), callback);
        mCurrentScanCallback = callback;

    }

    public void stopLescan() {
        if(mCurrentScanCallback != null) {
            mScanner.stopScan(mCurrentScanCallback);
            mCurrentScanCallback = null;
        }
    }

    public List<TinyBeaconInfo> getFoundedBeeacon() {
        return mFoundIBeacon;
    }

    public String getFoundedBeeaconAsJSONText() throws JSONException {
        JSONObject ret = new JSONObject();
        List<JSONObject> t = new LinkedList<JSONObject>();
        for(TinyBeaconInfo e: mFoundIBeacon) {
            t.add(e.toJsonString());
        }
        ret.put("founded", new JSONArray(t));
        ret.put("time", TinyBeaconInfo.getTime());
        return ret.toString();
    }

    public void clearFoundedBeeacon() throws JSONException {
        mFoundIBeacon.clear();
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
            //android.util.Log.v("beacon", "###SA## manu:" + result.getDevice().getType());
            //android.util.Log.v("beacon", "###SA## manu:" +result.getScanRecord().getManufacturerSpecificData());
            //android.util.Log.v("beacon", "###SA## scanResult type:" + callbackType + " ,result: " + result.toString());
            long t = TinyBeaconInfo.getTime();//System.currentTimeMillis();
            List<TinyAdPacket> ad = TinyAdPacket.parse(result.getScanRecord().getBytes());
            for(TinyAdPacket a : ad){
                if(TinyIBeaconPacket.isIBeacon(a)) {
                 //   android.util.Log.v("KY", "uuid:" + TinyIBeaconPacket.getUUIDHexStringAsIBeacon(a) + ", major:" + TinyIBeaconPacket.getMajorAsIBeacon(a) + ", minor:" + TinyIBeaconPacket.getMinorAsIBeacon(a) + ",crssi:" + TinyIBeaconPacket.getCalibratedRSSIAsIBeacon(a));
                    TinyBeaconInfo i = TinyBeaconInfo.containes(mParent.mFoundIBeacon, a);
                    if(null == i) {
                        TinyBeaconInfo ex = new TinyBeaconInfo(a, result.getRssi(), t);
                        mParent.mFoundIBeacon.add(ex);
                    } else {
                        i.update(result.getRssi(), t);
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
