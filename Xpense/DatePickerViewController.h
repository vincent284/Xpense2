//
//  DatePickerViewController.h
//  Xpense
//
//  Created by Vincent Nguyen on 7/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewControllerProtocol <NSObject>
- (void)didFinishSelectDate:(NSDate *)newDate;
@end

@interface DatePickerViewController : UIViewController

@property (nonatomic, assign) id <DatePickerViewControllerProtocol> delegate;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerValueChanged:(id)sender;
- (id)initWithDate:(NSDate *)date;
@end
