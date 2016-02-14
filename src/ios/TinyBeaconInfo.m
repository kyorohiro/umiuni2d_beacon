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

- (id)initWithUUID:(NSString*)uuid major:(NSNumber*)major minor:(NSNumber*)minor {
    NSUUID * uuidObj = [[NSUUID alloc] initWithUUIDString:uuid];
    if(major == nil && minor == nil) {
      self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuidObj identifier:@"xxx"];
    } else if(major != nil && minor == nil) {
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuidObj major:[major intValue] identifier:@"xxx"];
    } else {
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuidObj major:[major intValue] minor:[minor intValue] identifier:@"xxx"];
    }
    self.rssi = @0;
    self.time = @0L;
    self.found = @NO;
    self.isRanging = @NO;
    self.isMonitoring = @NO;
    self.proximity = @0;
    nullRangingCount = 0;
    return self;
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
