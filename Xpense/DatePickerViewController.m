//
//  DatePickerViewController.m
//  Xpense
//
//  Created by Vincent Nguyen on 7/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController () {
    NSDate *_initDate;
}

@end

@implementation DatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDate:(NSDate *)date {
    self = [self initWithNibName:NSStringFromClass([DatePickerViewController class]) bundle:nil];
    if (self) {
        _initDate = [date retain];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.datePicker setDate:_initDate animated:YES];
    [self updateLabelText];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(didFinishSelectDate:)]) {
        [self.delegate didFinishSelectDate:self.datePicker.date];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_initDate release];
    [_dateLabel release];
    [_datePicker release];
    [super dealloc];
}
- (IBAction)datePickerValueChanged:(id)sender {
    [self updateLabelText];
}

- (void)updateLabelText {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *date = self.datePicker.date;
    self.dateLabel.text = [formatter stringFromDate:date];
}

@end
