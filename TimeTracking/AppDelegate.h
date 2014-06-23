//
//  AppDelegate.h
//  TimeTracking
//
//  Created by Manfred Linzner on 2014-05-02.
//  Copyright (c) 2014 --. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconTracker.h"
#import "BeaconDefaults.h"

@class EventKitModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate, BeaconTrackerDelegate, CLLocationManagerDelegate>
{
    EventKitModel *_dataModel;
}
@property (strong, nonatomic) UIWindow *window;

@end
