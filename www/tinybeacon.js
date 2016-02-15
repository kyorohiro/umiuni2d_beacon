cordova.define("info.kyorohiro.cordova.tinybeacon.TinyBeacon", function(require, exports, module) {
               var TinyBeacon = function() {
               this.message = "xxx xxx";

               this.startLescan = function(success, fail, json) {
               var args = [];
               if(json != null) {
                args = [json];
               }
               console.log("###xxx ### " +args);

               cordova.exec(
                            success,
                            fail,
                            "TinyBeacon","startLescan",args);
               };

               this.stopLescan = function(success, fail) {
               cordova.exec(
                            success,
                            fail,
                            "TinyBeacon","stopLescan",[]);
               };

               this.requestPermissions = function(success, fail) {
               cordova.exec(
                            success,
                            fail,
                            "TinyBeacon","requestPermissions",[]);
               }

               this.getFoundBeacon = function(success, fail) {
               cordova.exec(
                            success,
                            fail,
                            "TinyBeacon","getFoundBeacon",[]);
               }
               this.clearFoundedBeacon = function(success, fail) {
               cordova.exec(
                            success,
                            fail,
                            "TinyBeacon","clearFoundBeacon",[]);
               }
               }

               module.exports.TinyBeacon = TinyBeacon;
});
