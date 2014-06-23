//
//  TTSettingsTableViewCell.m
//  TimeTracking
//
//  Created by Damir Dizdarevic on 31.05.14.
//  Copyright (c) 2014 --. All rights reserved.
//

#import "TTSettingsTableViewCell.h"

@implementation TTSettingsTableViewCell 

@synthesize label = _label, textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField.delegate = self;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLabelText:(NSString *)labelText
{
    self.label.text = labelText;
}

- (void)setTextFieldText:(NSString *)labelText
{
    self.textField.text = labelText;
}

- (NSString *)getTextFieldText
{
    return self.textField.text;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"WSIS");
    [textField resignFirstResponder];
    
    return YES;
}

@end
