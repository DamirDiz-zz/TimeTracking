//
//  BeaconDefaults.m
//  iBeaconFramwork
//
//  Created by Damir Dizdarevic on 16.12.13.
//  Copyright (c) 2013 Damir Dizdarevic. All rights reserved.
//

#import "BeaconDefaults.h"

@implementation BeaconDefaults

- (id)init
{
    self = [super init];
    if(self) {
        //@todo konfigurierbar machen in Settings
//        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"], //STANDARD UUID FOR ESTIMOTE
//                                     [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6E"]];

        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"11111111-1111-1111-1111-111111111111"], //STANDARD UUID FOR ESTIMOTE
                                     [[NSUUID alloc] initWithUUIDString:@"22222222-2222-2222-2222-222222222222"]];
}
    
    return self;
}

//Singelton Instance of the BeaconDefaults
+ (BeaconDefaults *)sharedDefaults
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (NSUUID *)defaultProximityUUID
{
    return [_supportedProximityUUIDs objectAtIndex:0];
}



@end
