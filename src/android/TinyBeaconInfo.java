package info.kyorohiro.tinybeacon;

import org.json.JSONException;
import org.json.JSONObject;

//
//
//
class TinyBeaconInfo {
    int rssi;
    long time;
    TinyAdPacket packet;
    TinyBeaconInfo(TinyAdPacket _packet, int _rssi, long _time) {
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
        return packet.equals(o);
    }

    @Override
    public int hashCode() {
        return packet.hashCode();
    }
}