package info.kyorohiro.tinybeacon;

import java.nio.ByteBuffer;
import java.util.LinkedList;
import java.util.List;


/**
 * Created by kyorohiro on 2016/02/11.
 */
public class TinyAdPacket {

    static java.util.List<TinyAdPacket> parse(byte[] packet) {
        List<TinyAdPacket> ret = new LinkedList<TinyAdPacket>();
        int index = 0;
        while(index<packet.length) {
            if(packet[index] == 0) {
                break;
            }
            TinyAdPacket st = new TinyAdPacket(packet, index);
            ret.add(st);
            index += st.mDataLength + 1;
        }
        return ret;
    }


    private int mDataLength;
    private int mAdType;
    private byte[] mOut;

    TinyAdPacket(byte[] packet, int index) {
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
        if(o == null  || !(o instanceof TinyAdPacket)) {
            return false;
        }
        //
        TinyAdPacket t = (TinyAdPacket)o;
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

}
