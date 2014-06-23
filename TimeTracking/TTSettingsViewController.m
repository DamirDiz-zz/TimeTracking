//
//  TTSettingsViewController.m
//  TimeTracking
//
//  Created by Damir Dizdarevic on 29.05.14.
//  Copyright (c) 2014 --. All rights reserved.
//

#import "TTSettingsViewController.h"
#import "TTSettingsTableViewCell.h"

@interface TTSettingsViewController ()

@end

@implementation TTSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIColor *myBlueColor = [UIColor colorWithRed:65.0f/255.0f green:169.0f/255.0f blue:223.0f/255.0f alpha:1.f];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:myBlueColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeSettings:(id)sender
{
    TTSettingsTableViewCell *startCell =    (TTSettingsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    TTSettingsTableViewCell *endCell =      (TTSettingsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[startCell getTextFieldText] forKey:@"TTSettings_startCellUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:[endCell getTextFieldText] forKey:@"TTSettings_endCellUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self dismissViewControllerAnimated:YES completion:^(void) {
        NSLog(@"Settings closed");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    
    NSString *startURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"TTSettings_startCellUrl"];
    NSString *endURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"TTSettings_endCellUrl"];

    if(indexPath.section == 0) {
        
        [cell.textField setPlaceholder:@"http://someurl.com/actions/start.php"];
        
        switch (indexPath.row) {
            case 0:
                [cell setLabelText:@"Start"];
                
                if(startURL) {
                    [cell setTextFieldText:startURL];
                }
                
                break;
            case 1:
                [cell setLabelText:@"Stop"];
                
                if(endURL) {
                    [cell setTextFieldText:endURL];
                }
                
                break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"API-Configuration";
    }
    
    return NULL;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(section == 0) {
        return @"Please provide the URL's for a Time-Tracking Software API calls. (optional)";
    }
    
    return NULL;
}


@end
