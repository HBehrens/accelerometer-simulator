//
//  SegmentedTableCell.m
//  AccSim
//
//  Created by Otto Chrons on 9/25/08.
//  Copyright 2008 Seastringo Oy. All rights reserved.
//

#import "SegmentedTableCell.h"


@implementation SegmentedTableCell

@synthesize segmentedControl;
@synthesize notificationName;
@synthesize title;

- (id)initWithFrameItems:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier title:(NSString*)titleName items:(NSArray*)items {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		CGRect rect = CGRectMake(125, 2, 180, 40);
		segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
		segmentedControl.frame = rect;
		segmentedControl.selectedSegmentIndex = 0;
		segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		[segmentedControl addTarget:self 
				   action:@selector(buttonPressed:) 
		 forControlEvents:UIControlEventValueChanged];
		[[self contentView] addSubview:segmentedControl];

		rect = CGRectMake(20, 2, 95, 40);
		title = [[UILabel alloc] initWithFrame:rect];
		title.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		[title setText:titleName];
		[[self contentView] addSubview:title];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;		
    }
    return self;
}

- (void)buttonPressed:(UISegmentedControl*)control {
	NSLog(@"SegmentedControl:buttonPressed: New value is %d\n", 
		  control.selectedSegmentIndex);
	[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:control];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[segmentedControl release];
    [super dealloc];
}


@end
