//
//  TTMainViewController.m
//  TimeTracking
//
//  Created by Damir Dizdarevic on 29.05.14.
//  Copyright (c) 2014 --. All rights reserved.
//

#import "TTMainViewController.h"
#import "EventKitModel.h"
#import "EventKitModel+Actions.h" // startEvent, stopEvent

@interface TTMainViewController ()

@property (nonatomic, weak) UIColor *myBlueColor;
@property (nonatomic, weak) UIColor *myGrayColor;

@end

@implementation TTMainViewController

- (UIColor *)myBlueColor
{
    return [UIColor colorWithRed:65.0f/255.0f green:169.0f/255.0f blue:223.0f/255.0f alpha:1.f];
}

- (UIColor *)myGrayColor
{
    return [UIColor colorWithWhite:150.0f/255.0f alpha:1.0f];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.navigationController.navigationBar setTintColor:[self myGrayColor]];
    [self.navigationController.navigationBar setBarTintColor:[self myBlueColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [self myGrayColor]}];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    UIImage *image = [UIImage imageNamed:@"topbaricon.png"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];

}

- (IBAction)controlButtonTouched:(id)sender
{
    if([_dataModel timerRunning]) {
        [_dataModel stopEvent];
        [[self timeLabel] setText:[_dataModel eventInfo]];
        [[self timeLabel] setTextColor:[self myGrayColor]];
       [self.controlButton setImage:[UIImage imageNamed:@"topbarstart"]];

    } else {
        [_dataModel startEvent];
        [[self timeLabel] setText:[_dataModel eventInfo]];
        [[self timeLabel] setTextColor:[self myBlueColor]];
        [self.controlButton setImage:[UIImage imageNamed:@"topbarstop"]];
    }
    

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    _dataModel = [[EventKitModel alloc] initWithCalendarName:@"TimeTracking"];
    
    [self updateTime];
}

- (void)updateTime
{
    [[self timeLabel] setText:[_dataModel eventInfo]];

    if([_dataModel timerRunning]) {
//        NSLog(@"Timmer is running");
        [self.controlButton setImage:[UIImage imageNamed:@"topbarstop"]];
        [[self timeLabel] setTextColor:[self myBlueColor]];
    } else {
//        NSLog(@"Timmer is not running");
       [self.controlButton setImage:[UIImage imageNamed:@"topbarstart"]];
        [[self timeLabel] setTextColor:[self myGrayColor]];
    }
    
    //selbständiges updaten
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
