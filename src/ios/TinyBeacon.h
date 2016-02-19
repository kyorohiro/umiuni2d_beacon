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
    int mProximity;
    bool mIsRanging;
    bool mInRegion;
    bool mFound;
    bool mIsMonitoring;
    long mTime;
    int mRssi;
    double mAccuracy;
}
@property (nonatomic, strong) CLBeaconRegion *region;

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
- (NSString*) getProximityString;

- (int) getProximity;
- (void) setProximity:(int) v;
- (void) setIsRanging:(bool)v;
- (void) setInRegion:(bool)v;
- (void) setFound:(bool)v;
- (void) setIsMonitoring:(bool)v;
- (void) setTime:(long)v;
- (void) setRssi:(int)v;
- (bool) getIsRanging;
- (bool) getInRegion;
- (bool) getFound;
- (bool) getIsMonitoring;
- (long) getTime;
- (int) getRssi;
- (double) getAccuracy;
- (void) setAccuracy:(double)v;
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
{
    NSString* mDelegateId;
}
@property (weak, nonatomic) id <TinyBeaconDelegate> delegate;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) TinyBeacinInfoList *beaconInfos;
- (id)init;
- (void)startLescan:(NSString*)arg;
- (void)stopLescan;
- (void)requestPermissions:(NSString*)flag callback:(id <TinyBeaconDelegate>) callback callbackId:(NSString*)callbackId;
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
