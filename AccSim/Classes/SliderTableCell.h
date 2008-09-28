//
//  SliderTableCell.h
//  MikeTeoTutorial
//
//  Created by Michael Teo http://miketeo.net/
//  Use of this file is governed by Creative Commons Attribution-Non Commercial License
//

#import <UIKit/UIKit.h>


@interface SliderTableCell : UITableViewCell {
	UILabel *title;
	UISlider *slider;

	NSString* notificationName;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) NSString *notificationName;

@end
