//
//  TinyBeaconPlugin.m
//  HelloCordova
//
//  Created by kiyohiro kawamura on 2016/02/19.
//
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import "TinyBeacon.h"


@implementation  TinyBeaconPlugin

-(void) onOKRequestPermissions:(NSString*) callbackId {
    CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:r callbackId:callbackId];
}

-(void) onFailedReqiestPermissions:(NSString*) callbackId message:(NSString*) meesage {
     CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:meesage];
     [self.commandDelegate sendPluginResult:r callbackId:callbackId];
}

- (void)pluginInitialize
{
    NSLog(@"###### init");
    self.beacon = [[TinyBeacon alloc] init];
}

- (void)startLescan:(CDVInvokedUrlCommand*) command
{
    
    NSLog(@"###### startLescan");
    if([[command arguments] count] < 1) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
        return;
    }
    @try
    {
        [self.beacon startLescan:command.arguments[0]];
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    @catch (NSException *exception) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    
}

- (void)stopLescan:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### stopLescan");
    
    @try {
        [self.beacon stopLescan];
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    @catch (NSException *exception) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
}

//
// TODO need two pattern
- (void)requestPermissions:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### requestPermissions");
    if([command.arguments count] < 1) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
        NSLog(@"###### requestPermissions error 1");
        return;
    }

    @try {
        NSLog(@"###### requestPermissions %@", command.arguments[0]);
        [self.beacon requestPermissions:command.arguments[0] callback:self callbackId:command.callbackId];
    }
    @catch (NSException *exception) {
        NSLog(@"###### requestPermissions error 2");
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
}

- (void)getFoundBeacon:(CDVInvokedUrlCommand*) command
{
    @try {
        NSString* result =[self.beacon getFoundBeacon];
        NSLog(@"###### getFoundBeacon %@",result);
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    @catch (NSException *exception) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
}

- (void)clearFoundBeacon:(CDVInvokedUrlCommand*) command
{
    NSLog(@"###### clearFoundedBeacon");
    @try {
        [self.beacon clearFoundBeacon];
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    @catch (NSException *exception) {
        CDVPluginResult *r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
}



@end
