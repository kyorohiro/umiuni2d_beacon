package info.kyorohiro.tinybeacon;

import org.json.JSONException;
import org.json.JSONObject;

//
//
//
class TinyBeaconInfo {
    double smartRssi;
    int rssi;
    long time;
    TinyAdPacket packet;
    int proximity;

    TinyBeaconInfo(TinyAdPacket _packet, int _rssi, long _time) {
        this.rssi = _rssi;
        this.time = _time;
        this.packet = _packet;
        this.smartRssi = _rssi;
        this.proximity = TinyIBeaconPacket.getProximity(packet, smartRssi, 0);
    }

    void update(int _rssi, long _time) {
        if(_time-time > 10) {
            smartRssi = _rssi;
        } else {
            smartRssi = (3.0*smartRssi + 2.0*_rssi)/5.0;
        }
        rssi = _rssi;
        time = _time;
        proximity = TinyIBeaconPacket.getProximity(packet, smartRssi, proximity);
    }

    public static long getTime() {
        return System.currentTimeMillis()/1000;
    }

    JSONObject toJsonString() throws JSONException {
        JSONObject ret = new JSONObject();
        ret.put("uuid", TinyIBeaconPacket.getUUIDHexStringAsIBeacon(packet));
        ret.put("major", TinyIBeaconPacket.getMajorAsIBeacon(packet));
        ret.put("minor", TinyIBeaconPacket.getMinorAsIBeacon(packet));
        ret.put("calrssi", TinyIBeaconPacket.getCalibratedRSSIAsIBeacon(packet));
        ret.put("rssi", rssi);
        ret.put("time", time);
        ret.put("proximity",getProximityString());
        ret.put("accuracy", TinyIBeaconPacket.distance(packet, rssi));
        return ret;
    }

    String getProximityString() {
        switch (proximity) {
            case TinyIBeaconPacket.PROXIMITY_NONE:
                return "none";
            case TinyIBeaconPacket.PROXIMITY_IMMEDIATE:
                return "immediate";
            case TinyIBeaconPacket.PROXIMITY_NEAR:
                return "near";
            case TinyIBeaconPacket.PROXIMITY_FAR:
                return "far";
            case TinyIBeaconPacket.PROXIMITY_UNKNOWN:
                return "unknown";
        }
        return "none";
    }

    static TinyBeaconInfo containes(java.util.List<TinyBeaconInfo> list, TinyAdPacket packet) {
        for(TinyBeaconInfo i : list) {
            if(packet.equals(i.packet)) {
                return i;
            }
        }
        return null;
    }

    @Override
    public boolean equals(Object o) {
        if(o instanceof TinyBeaconInfo) {
            o = ((TinyBeaconInfo) o).packet;
        }
        return packet.equals(o);
    }

    @Override
    public int hashCode() {
        return packet.hashCode();
    }
}