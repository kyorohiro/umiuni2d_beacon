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


@interface TinyBeaconInfo : NSObject
@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSNumber *rssi;
@property (nonatomic, strong) NSNumber *found;
@property (nonatomic, strong) NSNumber *isMonitoring;
@property (nonatomic, strong) NSNumber *isRanging;
@property (nonatomic, strong) NSNumber *inRegion;
@property (nonatomic, strong) NSNumber *proximity;

- (id)initWithUUID:(NSString*)uuid major:(NSNumber*)major minor:(NSNumber*)minor;
- (id)initWithBeaconRegion:(CLBeaconRegion*) regision;
- (id)free;
- (BOOL) isEqual:(id)other;
@end

@interface TinyBeacinInfoList : NSObject
@property (nonatomic, strong) NSMutableArray *beaconInfos;
- (id) init;
- (TinyBeaconInfo*) putTinyBeaconInfoFromBeaconRegion: (CLBeaconRegion*) region;
- (TinyBeaconInfo*) putTinyBeaconInfo:(NSString*) uuid major:(NSNumber*)major minor:(NSNumber*)minor;
- (TinyBeaconInfo*) getTinyBeaconInfoFromBeaconRegion: (CLBeaconRegion*) region;
- (TinyBeaconInfo*) getTinyBeaconInfoFromBeaconFromUUID: (NSString*) uuid major:(NSNumber*)major minor:(NSNumber*)minor;
- (NSString*) getFoundedBeaconInfo;
@end

@interface TinyBeacon : CDVPlugin <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) TinyBeacinInfoList *beaconInfos;
- (void)startLescan:(CDVInvokedUrlCommand*) command;
- (void)stopLescan:(CDVInvokedUrlCommand*) command;
- (void)requestPermissions:(CDVInvokedUrlCommand*) command;
- (void)getFoundBeacon:(CDVInvokedUrlCommand*) command;
- (void)clearFoundedBeacon:(CDVInvokedUrlCommand*) command;
@end


#endif /* TinyBeacon_h */
