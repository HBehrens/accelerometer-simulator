//
//  FirstViewController.h
//  AccSim
//
//  Created by Otto Chrons on 9/24/08.
//  Copyright Enzymia Ltd. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

// operation modes for the simulation, HW sensor or manual
#define kAccelerometerSensor 1
#define kAccelerometerManual 2

@interface AccelerometerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAccelerometerDelegate> {
	// main view for storing controls
	IBOutlet UITableView *myTableView;
	IBOutlet UINavigationBar *myNavigationBar;
	
	// array of value-labels showing current acceleration on axis
	UILabel **values;
	// control sliders for manual acceleration setting, or showing current sensor values
	UISlider **axis;
	
	// mode is either kAccelerometerSensor or kAccelerometerManual
	int accelerometerMode;
	
	// when was the display last updated
	CFAbsoluteTime updateTime;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UINavigationBar *myNavigationBar;
@property (nonatomic) UILabel **values;
@property (nonatomic) UISlider **axis;
@property (nonatomic) int accelerometerMode;
@end
