
var TinyBeacon = function() {
    this.startLescan = function() {
	cordova.exec(
		     function(a) {console.log("##xxx## " + a)},
		     function() {},
		     "TinyBeacon","startLescan",[]);
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
}

module.exports.tinybeacon = TinyBeacon;

