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
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"### didChangeAuthorizationStatus");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
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
        info.found = @YES;
        info.isRanging= @YES;
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
            info.isRanging = @NO;
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"### didRangeBeacons");
    //    NSMutableArray *a;
    //    [a containsObject:<#(nonnull id)#>]
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
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_8_0) {
        //    self.locationManager.requestWhenInUseAuthorization
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)getFoundBeacon:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### getFoundBeacon %@",[self.beaconInfos getFoundedBeaconInfo]);
}

- (void)clearFoundedBeacon:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### clearFoundedBeacon");
}



@end
