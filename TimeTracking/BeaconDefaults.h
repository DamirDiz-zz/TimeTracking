//
//  BeaconDefaults.h
//  iBeaconFramwork
//
//  Created by Damir Dizdarevic on 16.12.13.
//  Copyright (c) 2013 Damir Dizdarevic. All rights reserved.
//
//  Description:
//  Used to store and access Beacon configuration values like UUIDs, Minor and Major values


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconDefaults : NSObject

+ (BeaconDefaults *)sharedDefaults;

@property (nonatomic, copy, readonly) NSArray *supportedProximityUUIDs;
@property (nonatomic, copy, readonly) NSUUID *defaultProximityUUID;

@end
