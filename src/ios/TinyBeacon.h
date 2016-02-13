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
							    - (void)startLescan:(CDVInvokedUrlCommand*) command;
							    - (void)stopLescan:(CDVInvokedUrlCommand*) command;
							    - (void)requestPermissions:(CDVInvokedUrlCommand*) command;
							    - (void)getFoundBeacon:(CDVInvokedUrlCommand*) command;
							    - (void)clearFoundedBeacon:(CDVInvokedUrlCommand*) command;
@end
#endif /* TinyBeacon_h */
