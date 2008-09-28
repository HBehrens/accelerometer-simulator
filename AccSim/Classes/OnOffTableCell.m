//
//  OnOffTableCell.m
//  MikeTeoTutorial
//
//  Created by Michael Teo http://miketeo.net/
//  Use of this file is governed by Creative Commons Attribution-Non Commercial License
//

#import "OnOffTableCell.h"

@implementation OnOffTableCell

@synthesize title;
@synthesize onOffSwitch;
@synthesize notificationName;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		CGRect rect;
		rect = CGRectMake(195.0, 8.0, 60.0, 40.0);
		onOffSwitch = [[UISwitch alloc] initWithFrame:rect];
		[onOffSwitch addTarget:self 
					 action:@selector(switchToggled:) 
					 forControlEvents:UIControlEventValueChanged];
		[[self contentView] addSubview:onOffSwitch];
		
		rect = CGRectMake(20.0, 2.0, 150.0, 40.0);
		title = [[UILabel alloc] initWithFrame:rect];
		[[self contentView] addSubview:title];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

- (void)switchToggled:(UISwitch*)control {
	NSLog(@"OnOffTableCell:switchToggled: Switch toggled for '%s'. New value is %d\n", 
		  [self.title.text UTF8String], 
		  control.on);
	[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:control];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

- (void)dealloc {
	[super dealloc];
}

@end
