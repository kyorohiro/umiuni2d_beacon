//
//  TinyBeacon.m
//  HelloCordova
//
//  Created by kiyohiro kawamura on 2016/02/13.
//
//

#import <Foundation/Foundation.h>
#import "TinyBeacon.h"


@implementation  TinyBeacon

- (void)pluginInitialize
{
    NSLog(@"###### init");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.beaconInfos = [[TinyBeacinInfoList alloc] init];
    self.requestPermissionCallBackId = nil;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"### didChangeAuthorizationStatus");
    if(self.requestPermissionCallBackId != nil) {
        if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined) {
            CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:r callbackId:self.requestPermissionCallBackId];
        } else {
            CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:r callbackId:self.requestPermissionCallBackId];
        }
    }
    self.requestPermissionCallBackId = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"### didUpdateLocations");
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"### didEnterRegion %@",[[(CLBeaconRegion *)region proximityUUID] UUIDString]);
    
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        //
        //
        TinyBeaconInfo *info = [self.beaconInfos putTinyBeaconInfoFromBeaconRegion:(CLBeaconRegion*)region];
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
        //
        info.inRegion = @YES;
        info.isRanging= @YES;
        [info clearNullRangingCount];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"### didExitRegion %@",[[(CLBeaconRegion *)region proximityUUID] UUIDString]);
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
        //
        //
        TinyBeaconInfo *info = [self.beaconInfos getTinyBeaconInfoFromBeaconRegion:(CLBeaconRegion*)region];
        if(info != nil){
            info.inRegion = @NO;
            info.isRanging = @NO;
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"### didRangeBeacons");
    if([beacons count] == 0) {
        TinyBeaconInfo *info = [self.beaconInfos getTinyBeaconInfoFromBeaconRegion:region];
        if(info != nil) {
            [info addNullRangingCount];
            if([[info inRegion] boolValue] != YES && [[info isRanging] boolValue] == YES &&
               [info getNullRangingCount] > 5) {
                [self.locationManager stopRangingBeaconsInRegion:info.region];
            }
        }
        return;
    }
    int timestamp = [[NSDate date] timeIntervalSince1970];

    for(CLBeacon *b in beacons) {
        NSLog(@"### uuid : %@",[b proximityUUID]);
        NSLog(@"### rssi : %d",(int)[b rssi]);
        NSLog(@"### major : %d",(int)[b major]);
        NSLog(@"### minor : %d",(int)[b minor]);
        NSLog(@"### accuracy : %d",(int)[b accuracy]);
        NSLog(@"### proximity : %d",(int)[b proximity]);
        TinyBeaconInfo *info = [self.beaconInfos putTinyBeaconInfo:[[b proximityUUID] UUIDString] major:[b major] minor:[b minor]];
        info.found = @YES;
        info.rssi = [NSNumber numberWithInt:(int)[b rssi]];
        info.proximity = [NSNumber numberWithInt:(int)[b proximity]];
        info.time = [NSNumber numberWithInt:timestamp];
        [info clearNullRangingCount];
    }

}

- (void)startLescan:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### startLescan");
    if([[command arguments] count] == 0) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
        return;
    }
    
    NSData *data = [command.arguments[0] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* v = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"#C# %@", [v objectForKey:@"beacons"]);
    NSArray* beacons = [v objectForKey:@"beacons"];
    
    for(NSDictionary* d in beacons) {
        //
        NSString *uuid = (NSString*)[d objectForKey:@"uuid"];
        TinyBeaconInfo *info = [self.beaconInfos putTinyBeaconInfo:uuid major:nil minor:nil];
        info.isMonitoring = @YES;
        [self.locationManager startMonitoringForRegion:info.region];
        info.isRanging = @YES;
        [self.locationManager startRangingBeaconsInRegion:info.region];
        //
        NSLog(@"----------SSSS=----%@",[d objectForKey:@"uuid"]);
    }
}

- (void)stopLescan:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### stopLescan");
    
    for (TinyBeaconInfo *info in self.beaconInfos.beaconInfos) {
        if(YES == info.isRanging.boolValue) {
            [self.locationManager stopRangingBeaconsInRegion:info.region];
            info.isRanging = @NO;
        }
        if(YES == info.isMonitoring.boolValue) {
            [self.locationManager stopMonitoringForRegion:info.region];
            info.isMonitoring = @NO;
        }
    }
}

//
// TODO need two pattern
- (void)requestPermissions:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### requestPermissions");
    if(self.requestPermissionCallBackId != nil) {
        @try {
            CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
        }
        @catch (NSException *exception) {
        }
        @finally {
            self.requestPermissionCallBackId = nil;
        }
    }
    
    
    @try {
        if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_8_0) {
            //    self.locationManager.requestWhenInUseAuthorization
            [self.locationManager requestAlwaysAuthorization];
            self.requestPermissionCallBackId = command.callbackId;
        } else {
            CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
        }
    }
    @catch (NSException *exception) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
}

- (void)getFoundBeacon:(CDVInvokedUrlCommand*) command
{
    @try {
        NSString* result =[self.beaconInfos getFoundBeaconInfo];
        NSLog(@"###### getFoundBeacon %@",result);
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    @catch (NSException *exception) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    @finally {
    }
}

- (void)clearFoundBeacon:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### clearFoundedBeacon");
    @try {
        [self.beaconInfos clearFoundBeaconInfo];
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    @catch (NSException *exception) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    @finally {
    }
}



@end
