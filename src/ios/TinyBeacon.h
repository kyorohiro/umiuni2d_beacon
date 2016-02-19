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
{
    NSString* mUuid;
    int nullRangingCount;
    int mMajor;
    int mMinor;
}
@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSNumber *rssi;
@property (nonatomic, strong) NSNumber *found;
@property (nonatomic, strong) NSNumber *isMonitoring;
@property (nonatomic, strong) NSNumber *isRanging;
@property (nonatomic, strong) NSNumber *inRegion;
@property (nonatomic, strong) NSNumber *proximity;
+ (int)NUMBER_NULL;
- (id)initWithUUID:(NSString*)uuid major:(int)major minor:(int)minor;
- (id)initWithBeaconRegion:(CLBeaconRegion*) regision;
- (id)free;
- (BOOL) isEqual:(id)other;

- (int) getNullRangingCount;
- (void) addNullRangingCount;
- (void) clearNullRangingCount;
- (NSString*) getUUID;
- (int) getMajor;
- (int) getMinor;
@end

@interface TinyBeacinInfoList : NSObject
@property (nonatomic, strong) NSMutableArray *beaconInfos;
- (id) init;
- (TinyBeaconInfo*) putTinyBeaconInfoFromBeaconRegion: (CLBeaconRegion*) region;
- (TinyBeaconInfo*) putTinyBeaconInfo:(NSString*) uuid major:(int)major minor:(int)minor;
- (TinyBeaconInfo*) getTinyBeaconInfoFromBeaconRegion: (CLBeaconRegion*) region;
- (TinyBeaconInfo*) getTinyBeaconInfoFromBeaconFromUUID: (NSString*) uuid major:(int)major minor:(int)minor;
- (NSString*) getFoundBeaconInfo;
- (void) clearFoundBeaconInfo;
@end

@protocol TinyBeaconDelegate <NSObject>
-(void) onOKRequestPermissions:(NSString*) id;
-(void) onFailedReqiestPermissions:(NSString*) id message:(NSString*) meesage;
@end

@interface TinyBeacon : NSObject <CLLocationManagerDelegate>
@property (weak, nonatomic) NSString* delegateId;
@property (weak, nonatomic) id <TinyBeaconDelegate> delegate;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) TinyBeacinInfoList *beaconInfos;
- (id)init;
- (void)startLescan:(NSString*)arg;
- (void)stopLescan;
- (void)requestPermissions:(id <TinyBeaconDelegate>) callback callbackId:(NSString*)callbackId;
- (NSString*)getFoundBeacon;
- (void)clearFoundBeacon;
@end

@interface TinyBeaconPlugin : CDVPlugin <CLLocationManagerDelegate, TinyBeaconDelegate>
@property (nonatomic, strong) TinyBeacon* beacon;
- (void)startLescan:(CDVInvokedUrlCommand*) command;
- (void)stopLescan:(CDVInvokedUrlCommand*) command;
- (void)requestPermissions:(CDVInvokedUrlCommand*) command;
- (void)getFoundBeacon:(CDVInvokedUrlCommand*) command;
- (void)clearFoundBeacon:(CDVInvokedUrlCommand*) command;
@end

#endif /* TinyBeacon_h */
