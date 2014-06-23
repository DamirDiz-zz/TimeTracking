//
//  EventKitModel.m
//  TimeTracking
//
//  Created by Manfred Linzner on 2014-05-24.
//  Copyright (c) 2014 --. All rights reserved.
//

#import "EventKitModel.h"
#import <EventKit/EventKit.h>

@implementation EventKitModel

- (NSInteger)_eventDuration:(EKEvent *)event
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit;

    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:[event startDate]
                                                  toDate:[event endDate] options:0];

    return [components minute];
}

- (NSDictionary *)historyForLastNumberOfDays:(NSInteger)numberOfDays
{
    NSMutableDictionary *output = [NSMutableDictionary dictionary];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];

    NSPredicate *searchPredicate = [_eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:(-86400 * numberOfDays)] endDate:[NSDate date] calendars:@[_calendar]];

    [_eventStore enumerateEventsMatchingPredicate:searchPredicate usingBlock:^(EKEvent *event, BOOL *stop) {
        NSString *key = [dateFormatter stringFromDate:[event startDate]];
        NSInteger value = [self _eventDuration:event];

        if (output[key] != nil) {
            NSInteger oldValue = [output[key] integerValue];
            output[key] = [NSNumber numberWithInt:(oldValue + value)];
        } else {
            output[key] = [NSNumber numberWithInt:value];
        }
    }];

    return output;
}

- (id)init
{
    return [self initWithCalendarName:@"TimeTracking"];
}

- (id)initWithCalendarName:(NSString *)calendarName
{
    self = [super init];
    if(self) {
        _activeEvent = nil;
        _eventStore = [[EKEventStore alloc] init];

        [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    NSLog(@"Calendar Access allowed!");
                    
                    
                    for (EKCalendar *cal in [_eventStore calendarsForEntityType:EKEntityTypeEvent]) {
                        if ([[cal title] isEqualToString:calendarName]) {
                            _calendar = cal;
                            break;
                        }
                    }

                    if (_calendar != nil) {
                        NSLog(@"Found corresponding Calendar, UUID is %@", [_calendar calendarIdentifier]);
                    
                        if (_activeEvent == nil) {
                            NSLog(@"Looking for Active Event");
                            // let's look for an event containing [Running] in title
                            NSPredicate *searchPredicate = [_eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-86400] endDate:[NSDate dateWithTimeIntervalSinceNow:0] calendars:@[_calendar]];
                            
                            [_eventStore enumerateEventsMatchingPredicate:searchPredicate usingBlock:^(EKEvent *event, BOOL *stop) {
                                if ([[event title] rangeOfString:@"[Running]"].location != NSNotFound) {
                                    _activeEvent = event;
                                }
                            }];
                        }
                        
                    // calendar doesn't exist, create it and save it's identifier
                    } else {
                        NSLog(@"No Calendar found!");
                        
                        
                        _calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:_eventStore];
                        [_calendar setTitle:calendarName];
                        
                        EKSource *theSource = [_eventStore defaultCalendarForNewEvents].source;
                        
                        if (theSource.sourceType == EKSourceTypeLocal || theSource.sourceType == EKSourceTypeCalDAV) {
                            _calendar.source = theSource;
                            NSLog(@"Local source available");
                        } else {
                            NSLog(@"Error: Local source not available");
                            return;
                        }

                        
                        NSError *error = nil;
                        BOOL saved = [_eventStore saveCalendar:_calendar commit:YES error:&error];
                        if (saved) {
                            NSLog(@"Calender %@ was Created!", calendarName);
                        } else {
                            NSLog(@"Not able to create Calender %@!", calendarName);
                            NSLog(@"%@!", error);
                        }
                    }

                } else {
                    NSLog(@"Calendar Access NOT allowed");
                }
            });
        }];
    }

    return self;
}

@end
