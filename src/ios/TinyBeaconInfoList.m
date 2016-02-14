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

- (TinyBeaconInfo*) putTinyBeaconInfo:(NSString*) uuid major:(NSNumber*)major minor:(NSNumber*)minor {
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
        if(info.found.boolValue != YES) {
            continue;
        }
        NSString *uuid = [[[info region] proximityUUID] UUIDString];
        NSObject *major = [[info region] major];
        NSObject *minor = [[info region] minor];
        NSObject *proximity = [info proximity];
        NSObject *rssi = [info rssi];
        NSObject *time = [info time];
        if(major == nil) {
            major =[NSNull null];
        }
        if(minor == nil) {
            minor =[NSNull null];
        }
        if(proximity == nil) {
            proximity =[NSNull null];
        }
        if(rssi == nil) {
            rssi =[NSNull null];
        }
        if(time == nil) {
            time =[NSNull null];
        }
        NSDictionary *b = @{@"uuid":uuid, @"major":major, @"minor":minor, @"proximity":proximity, @"rssi" : rssi, @"time":time};
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
