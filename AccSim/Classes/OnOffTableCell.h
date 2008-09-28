//
//  OnOffTableCell.h
//  MikeTeoTutorial
//
//  Created by Michael Teo http://miketeo.net/
//  Use of this file is governed by Creative Commons Attribution-Non Commercial License
//

#import <UIKit/UIKit.h>


@interface OnOffTableCell : UITableViewCell {
	UILabel *title;
	UISwitch *onOffSwitch;
	
	NSString* notificationName;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UISwitch *onOffSwitch;
@property (nonatomic, retain) NSString *notificationName;

@end
