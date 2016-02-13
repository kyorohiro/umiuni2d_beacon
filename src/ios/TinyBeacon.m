//
//  TinyBeacon.m
//  HelloCordova
//
//  Created by kiyohiro kawamura on 2016/02/13.
//
//

#import <Foundation/Foundation.h>
#import "TinyBeacon.h"

@implementation TinyBeaconInfo
- (id)initWithUUID:(NSString*)uuid {
    NSUUID * uuidObj = [[NSUUID alloc] initWithUUIDString:uuid];
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuidObj identifier:@"xxx"];
    self.rssi = @0;
    self.time = @0L;
    self.found = @NO;
    self.isRanging = @NO;
    self.isMonitoring = @NO;
    return self;
}

- (id)initWithBeaconRegion:(CLBeaconRegion*) regision {
    self.region = regision;
    self.rssi = @0;
    self.time = @0L;
    self.found = @NO;
    self.isRanging = @NO;
    self.isMonitoring = @NO;
    return self;
}

- (id)free {
    return [self free];
}

- (BOOL) isEqual:(id)other {
    if(other == self) {
        return YES;
    } else if (NO == [other isKindOfClass:[self class]]) {
        return NO;
    }
    TinyBeaconInfo *otherObj = (TinyBeaconInfo*)other;
    if(NO == [self.region.proximityUUID isEqual:otherObj.region.proximityUUID]) {
        return NO;
    }
    if(self.region.major!= nil && [self.region.major isEqual:otherObj.region.major]) {
        return NO;
    } else if(self.region.major == nil && otherObj.region.major != nil){
        return NO;
    }
    
    if(self.region.minor!= nil && [self.region.minor isEqual:otherObj.region.minor]) {
        return NO;
    } else if(self.region.minor == nil && otherObj.region.minor != nil){
        return NO;
    }
    
    return YES;
}
@end


@implementation  TinyBeacon

- (void)pluginInitialize
{
    NSLog(@"###### init");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.beaconInfos = [[NSMutableArray alloc] init];
}


- (TinyBeaconInfo*) getTinyBeaconInfoFromBeaconRegion: (CLBeaconRegion*) region {
    for(TinyBeaconInfo *i in self.beaconInfos) {
        if([i.region isEqual:region] == YES) {
            return i;
        }
    }
    return nil;
}

- (TinyBeaconInfo*) getTinyBeaconInfoFromBeaconFromUUID: (NSString*) uuid major:(NSNumber*)major minor:(NSNumber*)minor {
    for(TinyBeaconInfo *i in self.beaconInfos) {
        if([[i.region.proximityUUID UUIDString] isEqual:uuid] == NO) {
            continue;
        }
        if([[i.region major] intValue] != [major intValue]) {
            continue;
        }
        if([[i.region minor] intValue] != [minor intValue]) {
            continue;
        }
        return i;
    }
    return nil;
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
        TinyBeaconInfo *info = [self getTinyBeaconInfoFromBeaconRegion:(CLBeaconRegion*)region];
        if(info == nil){
            info = [[TinyBeaconInfo alloc] initWithBeaconRegion:(CLBeaconRegion*)region];
            [self.beaconInfos addObject:info];
        }
        //
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
        TinyBeaconInfo *info = [self getTinyBeaconInfoFromBeaconRegion:(CLBeaconRegion*)region];
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
        TinyBeaconInfo *info =[self getTinyBeaconInfoFromBeaconFromUUID:(NSString*)[d objectForKey:@"uuid"]
                                                                  major:nil
                                                                  minor:nil];
        if(info == nil) {
            info =[[TinyBeaconInfo alloc] initWithUUID:[d objectForKey:@"uuid"]];
            [self.beaconInfos addObject:info];
        }

        info.isMonitoring = @YES;
        [self.locationManager startMonitoringForRegion:info.region];
        //
        NSLog(@"----------SSSS=----%@",[d objectForKey:@"uuid"]);
    }
}

- (void)stopLescan:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### stopLescan");
    
    for (TinyBeaconInfo *info in self.beaconInfos) {
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
    NSLog(@"###### getFoundBeacon");
}

- (void)clearFoundedBeacon:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### clearFoundedBeacon");
}



@end
