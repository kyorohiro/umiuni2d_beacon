package info.kyorohiro.tinybeacon;

import android.os.Build;
import android.widget.Toast;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import android.Manifest;

/**
 * Created by kyorohiro on 2016/02/11.
 */
public class TinyBeaconCordovaPlugin extends CordovaPlugin {
    TinyBeacon beacon = new TinyBeacon();

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        android.util.Log.v("KY", "### " + action + ", " + args);
        if("requestPermissions".equals(action)) {
            android.util.Log.v("KY", "##A# ");
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                android.util.Log.v("KY", "##B# ");
                cordova.getActivity().requestPermissions(new String[]{Manifest.permission.ACCESS_COARSE_LOCATION}, 0);
                android.util.Log.v("KY", "##C# ");
            }
            callbackContext.success();
        } else if("startLescan".equals(action)) {
            android.util.Log.v("KY", "##StartLescan# ");
            beacon.startLescan(this.cordova.getActivity().getApplicationContext());
            callbackContext.success();
        } else if("stopLescan".equals(action)) {
            beacon.stopLescan();
            callbackContext.success();
        } else if("getFoundBeacon".equals(action)) {
            callbackContext.success(beacon.getFoundedBeeaconAsJSONText());
        } else if("clearFoundBeacon".equals(action)) {
            beacon.clearFoundedBeeacon();
            callbackContext.success();
        } else {
            PluginResult result = new PluginResult(PluginResult.Status.OK, "AAA");
            result.setKeepCallback(true);
            callbackContext.sendPluginResult(result);
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, "BBB"));
            callbackContext.success("test(1)");
            callbackContext.success("test(2)");
            android.widget.Toast.makeText(this.cordova.getActivity(), args.getString(0), Toast.LENGTH_LONG).show();
            callbackContext.success();
        }
        return true;
    }
}