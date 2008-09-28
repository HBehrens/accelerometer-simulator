//
//  SegmentedTableCell.h
//  AccSim
//
//  Created by Otto Chrons on 9/25/08.
//  Copyright 2008 Seastringo Oy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SegmentedTableCell : UITableViewCell {
	UISegmentedControl *segmentedControl;
	UILabel *title;
	NSString* notificationName;
}

- (id)initWithFrameItems:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier title:(NSString*)titleName items:(NSArray*)items;

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSString *notificationName;

@end
