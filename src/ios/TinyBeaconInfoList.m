//
//  TinyBeaconInfoList.m
//  HelloCordova
//
//  Created by kiyohiro kawamura on 2016/02/14.
//
//

#import <Foundation/Foundation.h>
#import "TinyBeacon.h"

@implementation TinyBeacinInfoList
- (id) init {
    self.beaconInfos = [[NSMutableArray alloc] init];
    return self;
}

- (TinyBeaconInfo*) getTinyBeaconInfoFromBeaconRegion: (CLBeaconRegion*) region {
    NSLog(@"#A#B#C# %d", region.major.intValue);
    for(TinyBeaconInfo *i in self.beaconInfos) {
        if([i.region isEqual:region] == YES) {
            return i;
        }
    }
    return nil;
}

- (TinyBeaconInfo*) getTinyBeaconInfoFromBeaconFromUUID: (NSString*) uuid major:(int)major minor:(int)minor {
    for(TinyBeaconInfo *i in self.beaconInfos) {
        if([[i getUUID] isEqual:uuid] == NO) {
            continue;
        }
        if([i getMajor] != major) {
            continue;
        }
        if([i getMinor] != minor) {
            continue;
        }
        return i;
    }
    return nil;
}

- (TinyBeaconInfo*) putTinyBeaconInfo:(NSString*) uuid major:(int)major minor:(int)minor {
    TinyBeaconInfo *info =[self getTinyBeaconInfoFromBeaconFromUUID:uuid major:major minor:minor];
    if(info == nil) {
        info =[[TinyBeaconInfo alloc] initWithUUID:uuid major:major minor:minor];
        [self.beaconInfos addObject:info];
    }
    return info;
}

- (TinyBeaconInfo*) putTinyBeaconInfoFromBeaconRegion: (CLBeaconRegion*) region {
    TinyBeaconInfo *info = [self getTinyBeaconInfoFromBeaconRegion:(CLBeaconRegion*)region];
    if(info == nil){
        info = [[TinyBeaconInfo alloc] initWithBeaconRegion:(CLBeaconRegion*)region];
        [self.beaconInfos addObject:info];
    }
    return info;
}

- (NSString*) getFoundBeaconInfo {
    NSMutableDictionary *root = [@{} mutableCopy];
    NSMutableArray *beacons = [@[] mutableCopy];
    for(TinyBeaconInfo* info in self.beaconInfos) {
        if([info getFound ] != YES) {
            continue;
        }
        NSString *uuid = [[[info region] proximityUUID] UUIDString];
        NSObject *major = [NSNull null];
        NSObject *minor = [NSNull null];
        NSObject *proximity = [info getProximityString];
        NSObject *rssi = [NSNumber numberWithInteger:[info getRssi]];
        NSObject *time = [NSNumber numberWithLong:[info getTime]];

        if([info getMajor] != [TinyBeaconInfo NUMBER_NULL]) {
            major =[NSNumber numberWithInt:[info getMajor]];
        }
        if([info getMinor] != [TinyBeaconInfo NUMBER_NULL]) {
            minor =[NSNumber numberWithInt:[info getMinor]];
        }
        NSDictionary *b = @{
          @"uuid":uuid,
          @"major":major, @"minor":minor,
          @"proximity":proximity, @"rssi" : rssi, @"time":time};
        [beacons addObject:b];
    }
    root [@"beacons"] = beacons;
    int timestamp = [[NSDate date] timeIntervalSince1970];
    root [@"time"] = [NSNumber numberWithInt:timestamp];
  
    //
    NSData*data=[NSJSONSerialization dataWithJSONObject:root options:2 error:nil];
    NSString*jsonstr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonstr;
}

- (void) clearFoundBeaconInfo {
    [self.beaconInfos removeAllObjects];
}
@end
