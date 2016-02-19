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

- (id)init;
{
    NSLog(@"###### init");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.beaconInfos = [[TinyBeacinInfoList alloc] init];
    self.delegate = nil;
    return self;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"### didChangeAuthorizationStatus");
    if(self.delegate != nil) {
        if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined) {
            [self.delegate onFailedReqiestPermissions:self.delegateId message:@"NG"];
        } else {
            [self.delegate onOKRequestPermissions:self.delegateId];
        }
    }
    self.delegate = nil;
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
        [info setInRegion:YES];
        [info setIsRanging:YES];
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
            if([info getInRegion] != YES && [info getIsRanging] == YES &&
               [info getNullRangingCount] > 5) {
                [self.locationManager stopRangingBeaconsInRegion:info.region];
            }
        }
        return;
    }
    int timestamp = [[NSDate date] timeIntervalSince1970];

    for(CLBeacon *b in beacons) {
        TinyBeaconInfo *info =
        [self.beaconInfos putTinyBeaconInfo:[[b proximityUUID] UUIDString] major:[[b major] intValue] minor:[[b minor] intValue]];
        info.found = @YES;
        [info setRssi:(int)[b rssi]];
        [info setProximity:(int)[b proximity]];
        [info setTime:timestamp];
        [info clearNullRangingCount];
    }

}

- (void)startLescan:(NSString*)arg
{
    NSLog(@"###### startLescan");
    if(arg == nil) {
        @throw @"NSString type";
    }
    
    NSData *data = [arg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* v = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"#C# %@", [v objectForKey:@"beacons"]);
    NSArray* beacons = [v objectForKey:@"beacons"];
    
    for(NSDictionary* d in beacons) {
        //
        NSString *uuid = (NSString*)[d objectForKey:@"uuid"];
        TinyBeaconInfo *info = [self.beaconInfos putTinyBeaconInfo:uuid major:[TinyBeaconInfo NUMBER_NULL] minor:[TinyBeaconInfo NUMBER_NULL]];
        [info setIsMonitoring:YES];
        [self.locationManager startMonitoringForRegion:info.region];
        [info setIsRanging:YES];
        [self.locationManager startRangingBeaconsInRegion:info.region];
        //
        NSLog(@"----------SSSS=----%@",[d objectForKey:@"uuid"]);
    }
    
}

- (void)stopLescan
{
    NSLog(@"###### stopLescan");
    for (TinyBeaconInfo *info in self.beaconInfos.beaconInfos) {
        if(YES == [info getIsRanging]) {
            [self.locationManager stopRangingBeaconsInRegion:info.region];
            [info setIsRanging:NO];
        }
        if(YES == [info getIsMonitoring]) {
            [self.locationManager stopMonitoringForRegion:info.region];
            [info setIsMonitoring:NO];
        }
    }
}


//
// TODO need two pattern
- (void)requestPermissions:(id <TinyBeaconDelegate>) callback callbackId:(NSString*)callbackId;
{
    NSLog(@"###### requestPermissions");
    if (self.delegate != nil) {
        @throw @"NSString type";
    }
    self.delegate = callback;
    self.delegateId = callbackId;
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_8_0) {
        //             self.locationManager.requestWhenInUseAuthorization
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (NSString*)getFoundBeacon
{
    NSLog(@"###### getFoundBeacon");
    return [self.beaconInfos getFoundBeaconInfo];
}

- (void)clearFoundBeacon
{
    NSLog(@"###### clearFoundBeacon");
    [self.beaconInfos clearFoundBeaconInfo];
}



@end
