//
//  EventKitModel.h
//  TimeTracking
//
//  Created by Manfred Linzner on 2014-05-24.
//  Copyright (c) 2014 --. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EKEventStore, EKCalendar, EKEvent;

@interface EventKitModel : NSObject
{
    EKEventStore *_eventStore;
    EKCalendar *_calendar;
    EKEvent *_activeEvent;
}

- (id)initWithCalendarName:(NSString *)calendarName;
- (NSDictionary *)historyForLastNumberOfDays:(NSInteger)numberOfDays;

@end
