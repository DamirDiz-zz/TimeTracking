//
//  AppDelegate.m
//  TimeTracking
//
//  Created by Manfred Linzner on 2014-05-02.
//  Copyright (c) 2014 --. All rights reserved.
//

#import "AppDelegate.h"
#import "EventKitModel.h"
#import "EventKitModel+Actions.h"
@import CoreLocation;


@implementation AppDelegate

//@todo

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Tu es");
    _dataModel = [[EventKitModel alloc] initWithCalendarName:@"TimeTracking"];
    [[BeaconTracker sharedBeaconTracker] startTrackingBeacons];
    [[BeaconTracker sharedBeaconTracker] addDelegate:self];
    return YES;
}

// -----------------------------------------------------------------------------
#pragma mark - BeaconTracker Delegate Implementation
// -----------------------------------------------------------------------------


- (void)beaconTrackerEnteredRegion:(CLRegion *)region
{    
    
    BOOL beacon1ranged = [[NSUserDefaults standardUserDefaults] boolForKey:@"beacon1ranged"];
    BOOL beacon2ranged = [[NSUserDefaults standardUserDefaults] boolForKey:@"beacon2ranged"];

    NSLog(@"%hhd, %hhd",beacon1ranged,beacon2ranged);
    
    if([region.identifier rangeOfString:@"11111111-1111-1111-1111-111111111111"].location != NSNotFound)
    {
        if(!beacon1ranged && !beacon2ranged)
        {
            beacon1ranged = true;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:beacon1ranged] forKey:@"beacon1ranged"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if(beacon1ranged && !beacon2ranged)
        {
        }
        else if(!beacon1ranged && beacon2ranged)
        {
            NSLog(@"Rausgekommen");
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            
//            if ([_dataModel timerRunning]) {
                notification.alertBody = @"Stop tracking your working time.";
                [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:0] forKey:@"beacon1ranged"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:0] forKey:@"beacon2ranged"];
                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
        }
    }
    else if([region.identifier rangeOfString:@"22222222-2222-2222-2222-222222222222"].location != NSNotFound)
    {
        if(!beacon1ranged && !beacon2ranged)
        {
            beacon2ranged = true;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:beacon2ranged] forKey:@"beacon2ranged"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if(beacon1ranged && !beacon2ranged)
        {
            NSLog(@"Reingekommen");
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = @"Start tracking your working time.";

//            if (![_dataModel timerRunning]) {
                [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:0] forKey:@"beacon1ranged"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:0] forKey:@"beacon2ranged"];
                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
        }
        else if(!beacon1ranged && beacon2ranged)
        {
        }
    }
}

- (void)beaconTrackerUpdated
{
}
- (void)beaconTrackerUpdatedWithBeacons:(NSDictionary *)beacons {}

- (void)beaconTrackerLeftRegion:(CLRegion *)region
{
    NSLog(@"LEFT %@", region.identifier);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //@todo
    if(application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground )
    {
        //opened from a push notification when the app was on background
    }
    

    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Title for cancel button in local notification");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alert show];
}



@end
