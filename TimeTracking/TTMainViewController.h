//
//  TTMainViewController.h
//  TimeTracking
//
//  Created by Damir Dizdarevic on 29.05.14.
//  Copyright (c) 2014 --. All rights reserved.
//


@class EventKitModel;

@interface TTMainViewController : UIViewController
{
    EventKitModel *_dataModel;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *controlButton;

@end
