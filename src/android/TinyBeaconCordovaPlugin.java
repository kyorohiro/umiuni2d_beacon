package info.kyorohiro.tinybeacon;

import android.content.pm.PackageManager;
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
    public static final String REQUEST_WHEN_IN_USE = "when_in_use";
    public static final String REQUEST_ALWAYS = "always";

    TinyBeacon beacon = new TinyBeacon();
    CallbackContext callbackContextForRequestPermission = null;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        android.util.Log.v("KY", "### " + action + ", " + args);
        if("requestPermissions".equals(action)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if(cordova.hasPermission(Manifest.permission.ACCESS_COARSE_LOCATION)) {
                    callbackContext.success();
                } else {
                    if(callbackContextForRequestPermission != null) {
                        callbackContext.error("already requested");
                        return true;
                    } else {
                        try {
                            callbackContextForRequestPermission = callbackContext;
                            cordova.requestPermissions(this, 0, new String[]{Manifest.permission.ACCESS_COARSE_LOCATION});
                        } catch(Exception e) {
                            callbackContextForRequestPermission = null;
                        }
                    }
                }
            }
        } else if("startLescan".equals(action)) {
            android.util.Log.v("KY", "##StartLescan# ");
            try {
                beacon.startLescan(this.cordova.getActivity().getApplicationContext());
                callbackContext.success();
            } catch(Exception e) {
                callbackContext.error("failed");
            }
        } else if("stopLescan".equals(action)) {
            try {
                beacon.stopLescan();
                callbackContext.success();
            } catch(Exception e) {
                callbackContext.error("failed");
            }
        } else if("getFoundBeacon".equals(action)) {
            try {
                callbackContext.success(beacon.getFoundedBeeaconAsJSONText());
            } catch(Exception e) {
                callbackContext.error("failed");
            }
        } else if("clearFoundBeacon".equals(action)) {
            try {
                beacon.clearFoundedBeeacon();
                callbackContext.success();
            } catch(Exception e) {
                callbackContext.error("failed");
            }
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
    public void onRequestPermissionResult(int requestCode, String[] permissions,
                                          int[] grantResults) throws JSONException {
        if(callbackContextForRequestPermission == null) {
            return;
        }
        try {
            if (grantResults.length <= 0) {
                callbackContextForRequestPermission.error("");
            }
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                callbackContextForRequestPermission.success();
            } else {
                callbackContextForRequestPermission.error("");
            }
        } finally {
            callbackContextForRequestPermission = null;
        }
    }
}