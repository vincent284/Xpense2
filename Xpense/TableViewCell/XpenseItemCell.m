//
//  XpenseItemCell.m
//  Xpense
//
//  Created by Vincent Nguyen on 10/3/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "XpenseItemCell.h"

@implementation XpenseItemCell

+ (id)createNewCell {
    id cell = nil;
	
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
	
	for(id currentObject in topLevelObjects)
	{
		if([currentObject isKindOfClass:[self class]])
		{
			cell = currentObject;
			break;
		}
	}
	
	return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_amountLabel release];
    [_categoryLabel release];
    [_dateLabel release];
    [super dealloc];
}
@end
