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
    TinyBeaconInfo *info =[self getTinyBeaconInfoFromBeaconFromUUID:uuid major:nil minor:nil];
    if(info == nil) {
        info =[[TinyBeaconInfo alloc] initWithUUID:uuid];
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

@end
