//
//  CategoryViewController.h
//  Xpense
//
//  Created by Vincent Nguyen on 4/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewControllerDelegate;

@interface CategoryViewController : UITableViewController <UIGestureRecognizerDelegate>
@property (nonatomic, assign) id <CategoryViewControllerDelegate> delegate;

- (id)initWithCategoryName:(NSString *)categoryName;

@end

@protocol CategoryViewControllerDelegate <NSObject>
- (void)categoryViewController:(CategoryViewController *)controller didFinishChoosingCategory:(NSString *)categoryName;
@end