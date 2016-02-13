//
//  TinyBeacon.h
//  HelloCordova
//
//  Created by kiyohiro kawamura on 2016/02/13.
//
//

#ifndef TinyBeacon_h
#define TinyBeacon_h

#import <Cordova/CDV.h>
#import <CoreLocation/CoreLocation.h>

@interface TinyBeacon : CDVPlugin <CLLocationManagerDelegate>
@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *beaconInfos;
- (void)startLescan:(CDVInvokedUrlCommand*) command;
- (void)stopLescan:(CDVInvokedUrlCommand*) command;
- (void)requestPermissions:(CDVInvokedUrlCommand*) command;
- (void)getFoundBeacon:(CDVInvokedUrlCommand*) command;
- (void)clearFoundedBeacon:(CDVInvokedUrlCommand*) command;
@end


@interface TinyBeaconInfo : NSObject
@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSNumber *rssi;
@property (nonatomic, strong) NSNumber *found;
@property (nonatomic, strong) NSNumber *isMonitoring;
@property (nonatomic, strong) NSNumber *isRanging;
- (id)initWithUUID:(NSString*)uuid;
- (id)initWithBeaconRegion:(CLBeaconRegion*) regision;
- (id)free;
- (BOOL) isEqual:(id)other;
@end

#endif /* TinyBeacon_h */
