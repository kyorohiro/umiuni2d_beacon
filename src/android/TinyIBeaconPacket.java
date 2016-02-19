package info.kyorohiro.tinybeacon;

import java.nio.ByteBuffer;

/**
 * Created by kyorohiro on 2016/02/16.
 */
public class TinyIBeaconPacket {
    static final int PROXIMITY_NONE = 0;
    static final int PROXIMITY_IMMEDIATE = 1;
    static final int PROXIMITY_NEAR = 2;
    static final int PROXIMITY_FAR = 3;
    static final int PROXIMITY_UNKNOWN = 4;

    static int getProximity(TinyAdPacket packet, double rssi, int currentState) {
        double d = distance(packet, rssi);
        if(d < 0.25) {
            return PROXIMITY_IMMEDIATE;
        }
        if(currentState == PROXIMITY_IMMEDIATE || currentState == PROXIMITY_NEAR) {
            if(d < 1.95) {
                return PROXIMITY_NEAR;
            } else {
                return PROXIMITY_FAR;
            }
        } else {
            if(d < 1.25) {
                return PROXIMITY_NEAR;
            } else {
                return PROXIMITY_FAR;
            }
        }
    }

    //
    // TODO create iBeacon class & functionry method
    //
    static boolean isIBeacon(TinyAdPacket packet) {
        if(packet.getAdType() != TinyAdPacket.ADTYPE_MANUFACTURE_SPECIFIC) {
            return false;
        }
        //
        if(packet.getDataLength() != 0x1A) {
            return false;
        }
        byte[] cont = packet.getContent();
        //
        // 004c is apple
        if(!(cont[0] == 0x4C && cont[1] == 0x00)) {
            return false;
        }
        return true;
    }

    //
    // RSSI = Power - 20  log10(100cm);
    // -(RSSI - Power)/20 =  log10(d);
    // 10 ^(Power -RSSI)/20 = d : d is per 100cm
    //
    // DISTANCE = 10 ^ ((POWER-RSSI)/20)
    // RSSI     = POWER - 20*log10(D) : about d --> {100cm --> 1 , 50cm -->0.5, 200cm --> 2}
    //
    // 50cm  a+6
    // 100cm a
    // 200cm a-6
    // 400cm a-12
    static double distance(TinyAdPacket packet, double rssi) {
        return Math.pow(10.0, (getCalibratedRSSIAsIBeacon(packet)-rssi)/20.0 );
    }

    static int getIdentifierAsIBeacon_00(TinyAdPacket packet) {
        return 0xff & packet.getContent()[2];
    }

    static int getIdentifierAsIBeacon_01(TinyAdPacket packet) {
        return 0xff & packet.getContent()[3];
    }

    static byte[] getUUIDAsIBeacon(TinyAdPacket packet) {
        byte[] cont = packet.getContent();
        byte[] ret = new byte[16];
        System.arraycopy(cont,4,ret,0,ret.length);
        return ret;
    }

    static int getMinorAsIBeacon(TinyAdPacket packet) {
        byte[] cont = packet.getContent();
        return ByteBuffer.wrap(cont,20,2).getShort();
    }

    static int getMajorAsIBeacon(TinyAdPacket packet) {
        byte[] cont = packet.getContent();
        return ByteBuffer.wrap(cont,22,2).getShort();
    }

    static int getCalibratedRSSIAsIBeacon(TinyAdPacket packet) {
        return packet.getContent()[24];
    }

    static String getUUIDHexStringAsIBeacon(TinyAdPacket packet) {
        byte[] cont = getUUIDAsIBeacon(packet);
        StringBuilder builder = new StringBuilder();
        for(byte c : cont) {
            if(0xF < (c&0xff)) {
                builder.append(Integer.toHexString(0xff&c));
            } else {
                builder.append("0");
                builder.append(Integer.toHexString(0xff&c));
            }
        }
        return builder.toString();
    }
}
