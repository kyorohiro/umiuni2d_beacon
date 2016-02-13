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
  self.region = nil;
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
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
  NSLog(@"### didExitRegion %@",[[(CLBeaconRegion *)region proximityUUID] UUIDString]);
}

- (void)startLescan:(CDVInvokedUrlCommand*) command
{
  NSLog(@"###### startLescan");
  // f7826da6-4fa2-4e98-8024-bc5b71e0893e
  // 60BD537E-4E07-4F8E-8B58-FB451D985D9D
  NSUUID * uuid = [[NSUUID alloc] initWithUUIDString:@"f7826da6-4fa2-4e98-8024-bc5b71e0893e"];
  self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"xxx"];
  [self.locationManager startMonitoringForRegion:self.region];
    
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
