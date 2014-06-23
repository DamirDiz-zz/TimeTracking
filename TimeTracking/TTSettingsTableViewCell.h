//
//  TTSettingsTableViewCell.h
//  TimeTracking
//
//  Created by Damir Dizdarevic on 31.05.14.
//  Copyright (c) 2014 --. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTSettingsTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void)setLabelText:(NSString *)labelText;
- (void)setTextFieldText:(NSString *)labelText;
- (NSString *)getTextFieldText;

@end
