//
//  FirstViewController.m
//  AccSim
//
//  Created by Otto Chrons on 9/24/08.
//  Copyright Enzymia Ltd. 2008. All rights reserved.
//

#import "AccelerometerViewController.h"
#import "AccelerationInfo.h"

@implementation AccelerometerViewController
@synthesize myTableView;
@synthesize myNavigationBar;
@synthesize values;
@synthesize axis;
@synthesize accelerometerMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Register for acceleration sensor notifications
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(sensorUpdated:) 
													 name:@"AccelerationSensor" 
												   object:nil];
		CGRect rect = CGRectMake(270, 2, 35, 40);
		// create UI elements
		values = (UILabel**)calloc(sizeof(UILabel*),3);
		axis = (UISlider**)calloc(sizeof(UISlider*),3);
		values[0] = [[UILabel alloc] initWithFrame:rect];
		values[1] = [[UILabel alloc] initWithFrame:rect];
		values[2] = [[UILabel alloc] initWithFrame:rect];
		axis[0] = [[UISlider alloc] initWithFrame:rect];
		axis[1] = [[UISlider alloc] initWithFrame:rect];
		axis[2] = [[UISlider alloc] initWithFrame:rect];
		
		// start in sensor mode
		self.accelerometerMode = kAccelerometerSensor;
		updateTime = 0;
	}
	return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch( section ) {
		case 0:
			// sensor or manual
			return 1;
		case 1:
			// x y and z sliders
			return 3;
	}
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section {
	switch( section ) {
		case 0:
			// no header needed
			return 0.0;
		case 1:
			return 25.0;
	}
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch( section ) {
		case 0:
			// no header
			return nil;
		case 1:
			return @"Values";
	}
    return nil;
}

// this method populates the table view with cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* sliderName;
	UITableViewCell *cell;
	UILabel *value;
	NSInteger tag;
	UISlider *slider;	

	// create table cell views
	switch( indexPath.section*10 + indexPath.row ) {
		case 00:
			cell = [tableView dequeueReusableCellWithIdentifier:@"Mode"];
			if (cell == nil) {
				CGRect rect = CGRectMake(0, 0, 300, 44);
			
				cell = [[UITableViewCell alloc] initWithFrame:rect reuseIdentifier:@"Mode"];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UILabel *title;
				UISegmentedControl *segmentedControl;
				
				// create a two-button control for switching between Sensor and Manual modes
				rect = CGRectMake(135, 7, 170, 30);
				segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Sensor",@"Manual",nil]];
				segmentedControl.frame = rect;
				segmentedControl.selectedSegmentIndex = 0;
				segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
				segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
				// listen for change events
				[segmentedControl addTarget:self 
									 action:@selector(modeChanged:) 
						   forControlEvents:UIControlEventValueChanged];
				[cell.contentView addSubview:segmentedControl];
				[segmentedControl release];
				
				rect = CGRectMake(20, 2, 95, 40);
				title = [[UILabel alloc] initWithFrame:rect];
				title.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
				[title setText:@"Mode"];
				[cell.contentView addSubview:title];
				[title release];
				

			}
			return cell;

		// process X, Y and Z sliders with same code, init names differently
		case 10:
			sliderName = @"XSlider";
			goto createSlider;
		case 11:
			sliderName = @"YSlider";
			goto createSlider;
		case 12:
			sliderName = @"ZSlider";
			goto createSlider;

		createSlider:
			// get a pointer to UI object
			value = values[indexPath.row];
			slider = axis[indexPath.row];

			// tag helps identifying controls later on
			tag = indexPath.row;
			
			cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:sliderName];
			if (cell == nil) {
				CGRect rect = CGRectMake(0, 0, 300, 44);
				
				cell = [[UITableViewCell alloc] initWithFrame:rect reuseIdentifier:sliderName];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				UILabel *title;
				
				rect = CGRectMake(20, 2, 15, 40);
				title = [[UILabel alloc] initWithFrame:rect];
				title.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
				// get the first character of slider name as label
				[title setText:[sliderName substringToIndex:1]];
				[cell.contentView addSubview:title];
				[title release];
				
				// slider is already created in the initialization function, just fill in the details
				rect = CGRectMake(40, 2, 210, 40);
				[slider setFrame:rect];
				slider.tag = tag;
				slider.continuous = YES;
				// start in disabled mode, because we default to Sensor
				slider.enabled = NO;
				// iPhone HW seems to be producing values in the range of -2.3 to 2.3
				slider.maximumValue = 3.0;
				slider.minimumValue = -3.0;
				slider.value = 0.0;
				// monitor changes
				[slider addTarget:self 
						   action:@selector(accelerationChanged:) 
				 forControlEvents:UIControlEventValueChanged];
				[cell.contentView addSubview:slider];

				rect = CGRectMake(254, 2, 42, 40);
				// update value label details
				[value setFrame:rect];
				value.autoresizingMask = UIViewAutoresizingNone;
				value.lineBreakMode = UILineBreakModeClip;
				[value setText:@"0.0"];
				[cell.contentView addSubview:value];
			}
			return cell;
	}
	return nil;
}

// called when Sensor|Manual control is switched
- (void)modeChanged:(UISegmentedControl*)control {
	NSLog(@"Mode changed: New value is %d\n", 
		  control.selectedSegmentIndex);

	// is manual mode on?
	BOOL isEnabled = (control.selectedSegmentIndex == 1 ) ? YES : NO;
	accelerometerMode = isEnabled ? kAccelerometerManual : kAccelerometerSensor;
	
	// enable or disable sliders depending on the mode
	axis[0].enabled = isEnabled;
	axis[1].enabled = isEnabled;
	axis[2].enabled = isEnabled;
}

// one of the sliders has been updated by the user
- (void)accelerationChanged:(UISlider*)control {
	UIAccelerationValue x, y, z;
	
	// get manual values
	x = axis[0].value;
	y = axis[1].value;
	z = axis[2].value;
	
	// create information message
	AccelerationInfo *accelInfo = [AccelerationInfo createWithTimestamp:CFAbsoluteTimeGetCurrent() X:x Y:y Z:z];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AccelerationUpdate" object:accelInfo];	
	
	// update matching value label
	NSString *valueStr = [NSString stringWithFormat:@"%1.3f", control.value];
	[values[control.tag] setText:valueStr];
}

// UIAccelerometerDelegate method, called when the device accelerates.
// this function is called regardless of our own mode setting
// this way also "manual" acceleration messages are sent at the same frequency as sensor
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	UIAccelerationValue x, y, z;
	NSTimeInterval timeStamp;
	
	if( accelerometerMode == kAccelerometerSensor )
	{
		// read the sensor values
		x = acceleration.x;
		y = acceleration.y;
		z = acceleration.z;
		timeStamp = acceleration.timestamp;
	}
	else
	{
		// get manual values
		x = axis[0].value;
		y = axis[1].value;
		z = axis[2].value;
		timeStamp = CFAbsoluteTimeGetCurrent();
	}
		
	// create information message
	AccelerationInfo *accelInfo = [AccelerationInfo createWithTimestamp:timeStamp X:x Y:y Z:z];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"AccelerationUpdate" object:accelInfo];
	
	// update UI with a notification message if more than 0.2 sec has passed
	if( accelerometerMode == kAccelerometerSensor && fabs(acceleration.timestamp - updateTime) > 0.2 )
	{
		updateTime = acceleration.timestamp;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"AccelerationSensor" object:acceleration];
	}
}	

- (void)sensorUpdated:(NSNotification*)notification {
	UIAcceleration* acceleration = (UIAcceleration*)[notification object];

	// Update the accelerometer view
	[axis[0] setValue:acceleration.x];
	[axis[1] setValue:acceleration.y];
	[axis[2] setValue:acceleration.z];
	[values[0] setText:[NSString stringWithFormat:@"%1.3f",acceleration.x]];
	[values[1] setText:[NSString stringWithFormat:@"%1.3f",acceleration.y]];
	[values[2] setText:[NSString stringWithFormat:@"%1.3f",acceleration.z]];
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
 }
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
 - (void)viewDidLoad {
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[values[0] release];
	[values[1] release];
	[values[2] release];
	[axis[0] release];
	[axis[1] release];
	[axis[2] release];
	[super dealloc];
	free(values);
	free(axis);
}

@end
