cordova.define("info.kyorohiro.cordova.tinybeacon.TinyBeacon", function(require, exports, module) {
               var TinyBeacon = function() {
               this.message = "xxx xxx";

               this.startLescan = function(json) {
               var args = [];
               if(json != null) {
                args = [json];
               }
               console.log("###xxx ### " +args);

               cordova.exec(
                            function(a) {console.log("##xxx## " + a)},
                            function() {},
                            "TinyBeacon","startLescan",args);
               };
               
               this.stopLescan = function() {
               cordova.exec(
                            function(a) {console.log("##xxx## " + a)},
                            function() {},
                            "TinyBeacon","stopLescan",[]);
               };
               
               this.requestPermissions = function() {
               cordova.exec(
                            function(a) {console.log("##xxx## " + a)},
                            function() {},
                            "TinyBeacon","requestPermissions",[]);
               }
               
               this.getFoundBeacon = function() {
               cordova.exec(
                            function(a) {console.log("##xxx## " + a)},
                            function() {},
                            "TinyBeacon","getFoundBeacon",[]);
               }
               this.clearFoundedBeacon = function() {
               cordova.exec(
                            function(a) {console.log("##xxx## " + a)},
                            function() {},
                            "TinyBeacon","clearFoundBeacon",[]);
               }
               }
               
               module.exports.TinyBeacon = TinyBeacon;
});
