cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/org.apache.cordova.console/www/console-via-logger.js",
        "id": "org.apache.cordova.console.console",
        "clobbers": [
            "console"
        ]
    },
    {
        "file": "plugins/org.apache.cordova.console/www/logger.js",
        "id": "org.apache.cordova.console.logger",
        "clobbers": [
            "cordova.logger"
        ]
    },
    {
        "file": "plugins/com.phonegap.plugins.facebookconnect/www/pg-plugin-fb-connect.js",
        "id": "com.phonegap.plugins.facebookconnect.cdv.fb",
        "merges": [
            "CDV.FB"
        ]
    },
    {
        "file": "plugins/com.phonegap.plugins.facebookconnect/www/facebook-connect-debug.js",
        "id": "com.phonegap.plugins.facebookconnect.fb",
        "merges": [
            "FB"
        ]
    }
]
});