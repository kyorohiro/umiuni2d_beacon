//
//  TinyBeacon.m
//  HelloCordova
//
//  Created by kiyohiro kawamura on 2016/02/13.
//
//

#import <Foundation/Foundation.h>
#import "TinyBeacon.h"

@implementation  TinyBeacon
- (void)startLescan:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### startLescan");
}

- (void)stopLescan:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### stopLescan");
}

- (void)requestPermissions:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### requestPermissions");
}

- (void)getFoundBeacon:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### getFoundBeacon");
}

- (void)clearFoundedBeacon:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### clearFoundedBeacon");
}



@end


