//
//  EventKitModel+Actions.h
//  TimeTracking
//
//  Created by Manfred Linzner on 2014-05-24.
//  Copyright (c) 2014 --. All rights reserved.
//

#import "EventKitModel.h"

@interface EventKitModel (Actions)

- (void)startEvent;
- (void)stopEvent;
- (void)pauseEvent; //@todo

- (BOOL)timerRunning;
- (NSString *)eventInfo;

@end
