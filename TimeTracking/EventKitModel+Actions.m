//
//  EventKitModel+Actions.m
//  TimeTracking
//
//  Created by Manfred Linzner on 2014-05-24.
//  Copyright (c) 2014 --. All rights reserved.
//

#import "EventKitModel.h"
#import "EventKitModel+Actions.h"
#import <EventKit/EventKit.h>

@implementation EventKitModel (Actions)

- (void)startEvent
{
    if (_activeEvent != nil) {
        [self stopEvent];
    }

    _activeEvent = [EKEvent eventWithEventStore:_eventStore];
    [_activeEvent setTitle:@"TimeTracking [Running]"];
    [_activeEvent setStartDate:[NSDate date]];
    [_activeEvent setEndDate:[NSDate dateWithTimeIntervalSinceNow:1800]]; // create new Events with a timespan of 30minutes
    [_activeEvent setCalendar:_calendar];

    
    NSURL *startURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"TTSettings_startCellUrl"]];

    if(startURL && startURL.scheme && startURL.host) {
        [self makeRequestWithURL:startURL];
    }
    
    NSError *error = NULL;
    [_eventStore saveEvent:_activeEvent span:EKSpanThisEvent error:&error];
    if (error != NULL) {
        NSLog(@"startEvent:\tERROR – %@", [error localizedDescription]);
    }
}

- (void)stopEvent
{
    if (_activeEvent == nil) {
        // let's look for an event containing [Running] in title
        NSPredicate *searchPredicate = [_eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-86400] endDate:[NSDate dateWithTimeIntervalSinceNow:-86400] calendars:@[_calendar]];

        [_eventStore enumerateEventsMatchingPredicate:searchPredicate usingBlock:^(EKEvent *event, BOOL *stop) {
            if ([[event title] rangeOfString:@"[Running]"].location != NSNotFound) {
                _activeEvent = event;
            }
        }];
    }

    if (_activeEvent != nil) {
        NSError *error = NULL;

        [_activeEvent setEndDate:[NSDate date]];
        NSString *eventTitle = [_activeEvent title];
        if ([eventTitle hasSuffix:@"[Running]"]) {
           [_activeEvent setTitle:[eventTitle substringToIndex:[eventTitle length] - 9]];
        }
        
        [_eventStore saveEvent:_activeEvent span:EKSpanThisEvent error:&error];

        if (error != NULL) {
            NSLog(@"stopEvent:\tERROR – %@", [error localizedDescription]);
        } else {
            _activeEvent = nil;
            
            
            NSURL *endURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"TTSettings_endCellUrl"]];
            
            if(endURL && endURL.scheme && endURL.host) {
                [self makeRequestWithURL:endURL];
            }
        }
    } else {
        NSLog(@"stopEvent:\tUnable to stop event (no active event found).");
    }
}

- (void)pauseEvent
{
}

- (BOOL)timerRunning
{
    return _activeEvent != nil;
}

- (NSString *)eventInfo
{
    if (_activeEvent != nil) {
        NSDate *startDate = [_activeEvent startDate];
        NSDate *endDate = [NSDate date];

//        NSLog(@"Comparing:\n%@\n%@", startDate, endDate);
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

        NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;

        NSDateComponents *components = [gregorian components:unitFlags
                                                    fromDate:startDate
                                                      toDate:endDate options:0];
        NSInteger hours = [components hour];
        NSInteger minutes = [components minute];

        return [NSString stringWithFormat:@"%.2i:%.2i", hours, minutes];
    }

    return @"00:00";
}


- (id)makeRequestWithURL:(NSURL *)url
{
    NSLog(@"Sending Request with URL: %@", url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:10];

//        [request setHTTPMethod:@"POST"];
//        NSString *postString = [NSString stringWithFormat:@"phoneid=%@&uuid=%@&major=%@&minor=%@",
//                                [self getPhoneID],
//                                [beacon.proximityUUID UUIDString],
//                                beacon.major,
//                                beacon.minor];
//        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//    
    // Fetch the JSON response
    NSData *responseData;
    NSURLResponse *response;
    NSError *error;
    
    
    // Make synchronous request
    responseData = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    if(error) {
        NSLog(@"Could not request %@", [url description]);
    } else {
        NSError *jsonParsingError = nil;
        
        id responseJSON = [NSJSONSerialization JSONObjectWithData:responseData
                                                          options:0 error:&jsonParsingError];
        
        NSLog(@"Response: %@", responseJSON);
        //tu was mit der response
        return responseJSON;
    }
    
    return nil;
}


@end
