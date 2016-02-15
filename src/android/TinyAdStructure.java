package info.kyorohiro.tinybeacon;

import java.nio.ByteBuffer;
import java.util.LinkedList;
import java.util.List;


/**
 * Created by kyorohiro on 2016/02/11.
 */
public class TinyAdStructure {

    static java.util.List<TinyAdStructure> parse(byte[] packet) {
        List<TinyAdStructure> ret = new LinkedList<TinyAdStructure>();
        int index = 0;
        while(index<packet.length) {
            if(packet[index] == 0) {
                break;
            }
            TinyAdStructure st = new TinyAdStructure(packet, index);
            ret.add(st);
            index += st.mDataLength + 1;
        }
        return ret;
    }


    private int mDataLength;
    private int mAdType;
    private byte[] mOut;

    TinyAdStructure(byte[] packet, int index) {
        mDataLength = 0xff & packet[index];
        mAdType = 0xff & packet[index+1];
        mOut = new byte[mDataLength -1];
        System.arraycopy(packet,index+2, mOut, 0, mOut.length);
    }

    public int getDataLength() {
        return mDataLength;
    }
    public int getAdType() {
        return mAdType;
    }
    public byte[] getContent() {
        return mOut;
    }

    @Override
    public boolean equals(Object o) {
        if(o == null  || !(o instanceof TinyAdStructure)) {
            return false;
        }
        //
        TinyAdStructure t = (TinyAdStructure)o;
        if(mDataLength != t.mDataLength || mAdType != t.mAdType) {
            return false;
        }
        //
        for(int i=0;i<mOut.length;i++) {
            if(mOut[i] != t.mOut[i]) {
                return false;
            }
        }
        return true;
    }

    @Override
    public int hashCode() {
        int h = 1;
        h = h*31 + mDataLength;
        h = h*31 + mAdType;
        for(int i=0;i<mOut.length;i++) {
            h = h * 31 + mOut[i];
        }
        return h;
    }

    public static int ADTYPE_FLAGS = 0x01;
    public static int ADTYPE_SERVICE_UUID_16BIT_MORE = 0x03;
    public static int ADTYPE_SERVICE_UUID_16BIT_COMP = 0x03;
    public static int ADTYPE_SERVICE_UUID_32BIT_MORE = 0x04;
    public static int ADTYPE_SERVICE_UUID_32BIT_COMP = 0x05;
    public static int ADTYPE_SERVICE_UUID_128BIT_MORE = 0x06;
    public static int ADTYPE_SERVICE_UUID_128BIT_COMP = 0x07;
    public static int ADTYPE_LOCALNAME_SHORT = 0x08;
    public static int ADTYPE_LOCALNAME_COMP = 0x09;
    public static int ADTYPE_MANUFACTURE_SPECIFIC = 0xFF;


    //
    // TODO create iBeacon class & functionry method
    //
    boolean isiBeacon() {
        if(getAdType() != ADTYPE_MANUFACTURE_SPECIFIC) {
            return false;
        }
        //
        if(getDataLength() != 0x1A) {
            return false;
        }
        byte[] cont = getContent();
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
    double distance(double rssi) {
        return Math.pow(10.0, (getCalibratedRSSIAsiBeacon()-rssi)/20.0 );
    }

    int getIdentifierAsiBeacon_00() {
        return 0xff & getContent()[2];
    }

    int getIdentifierAsiBeacon_01() {
        return 0xff & getContent()[3];
    }

    byte[] getUUIDAsiBeacon() {
        byte[] cont = getContent();
        byte[] ret = new byte[16];
        System.arraycopy(cont,4,ret,0,ret.length);
        return ret;
    }

    int getMinorAsiBeacon() {
        byte[] cont = getContent();
        return ByteBuffer.wrap(cont,20,2).getShort();
    }

    int getMajorAsiBeacon() {
        byte[] cont = getContent();
        return ByteBuffer.wrap(cont,22,2).getShort();
    }

    int getCalibratedRSSIAsiBeacon() {
        return getContent()[24];
    }

    String getUUIDHexStringAsiBeacon() {
        byte[] cont = getUUIDAsiBeacon();
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
