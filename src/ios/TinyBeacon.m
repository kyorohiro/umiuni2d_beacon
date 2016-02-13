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
    self.region = nil;
    self.beaconInfos = [[NSMutableArray alloc] init];
    // self.beaconInfos con
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
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"### didExitRegion %@",[[(CLBeaconRegion *)region proximityUUID] UUIDString]);
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
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
    
    NSString *arg = command.arguments[0];
    NSLog(@"#A# %@",arg);
    {
        NSData *data = [arg dataUsingEncoding:NSUTF8StringEncoding];
        id obj = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"#B# %@",obj);
    }
    NSData *data = [arg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* v = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"#C# %@", [v objectForKey:@"beacons"]);
    NSArray* beacons = [v objectForKey:@"beacons"];
    
    for(NSDictionary* d in beacons) {
        NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:[d objectForKey:@"uuid"]];
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"xxx"];
        [self.locationManager startMonitoringForRegion:self.region];
        break;
    }
    
}

- (void)stopLescan:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### stopLescan");
    if(self.region != nil) {
        [self.locationManager stopMonitoringForRegion:self.region];
        self.region = nil;
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
