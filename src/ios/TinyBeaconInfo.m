//
//  TinyBeaconInfo.m
//  HelloCordova
//
//  Created by kiyohiro kawamura on 2016/02/14.
//
//

#import <Foundation/Foundation.h>
#import "TinyBeacon.h"

@implementation TinyBeaconInfo

+ (int)NUMBER_NULL
{
    return -99999;
}

- (id)initWithUUID:(NSString*)uuid major:(int)major minor:(int)minor {
    NSUUID * uuidObj = [[NSUUID alloc] initWithUUIDString:uuid];
    mMajor = major;
    mMinor = minor;
    mUuid = uuid;
    mProximity = 0;
    mRssi = 0;
    mTime = 0L;
    mFound = NO;
    mIsRanging = NO;
    mIsMonitoring = NO;
    mAccuracy = 0.0;

    //
    if(major == [TinyBeaconInfo NUMBER_NULL] && minor == [TinyBeaconInfo NUMBER_NULL]) {
      self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuidObj identifier:@"xxx"];
    } else if(major != TinyBeaconInfo.NUMBER_NULL && minor == TinyBeaconInfo.NUMBER_NULL) {
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuidObj major:major identifier:@"xxx"];
    } else {
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuidObj major:major minor:minor identifier:@"xxx"];
    }
    //
    nullRangingCount = 0;
    return self;
}

- (double) getAccuracy {
    return mAccuracy;
}

- (void) setAccuracy:(double)v {
    mAccuracy = v;
}

- (int) getNullRangingCount {
    return nullRangingCount;
}

- (void) addNullRangingCount {
    nullRangingCount++;
}

- (void) clearNullRangingCount {
    nullRangingCount = 0;
}

- (NSString*) getProximityString {
    switch (mProximity) {
        case CLProximityImmediate:
            return @"immediate";
        case CLProximityNear:
            return @"near";
        case CLProximityFar:
            return @"far";
        case CLProximityUnknown:
            return @"unknown";
    }
    return @"none";
}

- (id)initWithBeaconRegion:(CLBeaconRegion*) regision {
    self.region = regision;
    mRssi = 0;
    mTime = 0L;
    mFound = NO;
    mIsRanging = NO;
    mIsMonitoring = NO;
    return self;
}

- (id)free {
    return [self free];
}

- (NSString*) getUUID {
    return mUuid;
}

- (int) getMajor {
    return mMinor;
}

- (int) getMinor {
    return mMinor;
}

- (int) getProximity {
    return mProximity;
}

- (bool) getFound {
    return mFound;
}
- (bool) getIsRanging
{
    return mIsRanging;
}
- (bool) getInRegion {
    return mInRegion;
}

- (bool) getIsMonitoring {
    return mIsMonitoring;
}

- (long) getTime {
    return mTime;
}

- (int) getRssi {
    return mRssi;
}

- (void) setProximity:(int) v
{
    mProximity = v;
}

- (void) setIsRanging:(bool)v
{
    mIsRanging = v;
}

- (void) setInRegion:(bool)v
{
    mInRegion = v;
}

- (void) setFound:(bool)v
{
    mFound = v;
}
- (void) setIsMonitoring:(bool)v
{
    mIsMonitoring = v;
}
- (void) setTime:(long)v
{
    mTime = v;
}

- (void) setRssi:(int)v
{
    mRssi = v;
}

- (BOOL) isEqual:(id)other {
    if(other == self) {
        return YES;
    } else if (NO == [other isKindOfClass:[self class]]) {
        return NO;
    }

    TinyBeaconInfo *otherObj = (TinyBeaconInfo*)other;
    if(NO == [[self getUUID] isEqual:[otherObj getUUID]]) {
        return NO;
    }

    if([self getMajor ]!= [otherObj getMajor]) {
        return NO;
    }

    if([self getMinor ]!= [otherObj getMinor]) {
        return NO;
    }

    return YES;
}
@end
