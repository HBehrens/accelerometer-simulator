//
//  SliderTableCell.m
//  MikeTeoTutorial
//
//  Created by Michael Teo http://miketeo.net/
//  Use of this file is governed by Creative Commons Attribution-Non Commercial License
//

#import "SliderTableCell.h"

@implementation SliderTableCell

@synthesize slider;
@synthesize title;
@synthesize notificationName;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		CGRect rect = CGRectMake(20.0, 2.0, 260.0, 40.0);
		slider = [[UISlider alloc] initWithFrame:rect];
		slider.continuous = YES;
		slider.maximumValue = 100.0;
		slider.minimumValue = 0.0;
		[slider addTarget:self 
				   action:@selector(sliderChanged:) 
		 forControlEvents:UIControlEventValueChanged];
		[[self contentView] addSubview:slider];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;		
	}
	return self;
}

- (void)sliderChanged:(UISlider*)control {
	NSNumber* value = [NSNumber numberWithFloat:control.value];
	NSLog(@"SliderTableCell:sliderChanged: Slider value changed. New value is %d.\n",
		  [value intValue]);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SliderChanged" object:control];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}


- (void)dealloc {
	[super dealloc];
}


@end
