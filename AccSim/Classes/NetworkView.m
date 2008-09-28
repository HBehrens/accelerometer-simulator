//
//  NetworkView.m
//  AccSim
//
//  Created by Otto Chrons on 9/25/08.
//  Copyright 2008 Enzymia Ltd.. All rights reserved.
//

#import "NetworkView.h"
#import "AccelerationInfo.h"
#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <errno.h>

#define kAccelerometerSimulationPort 10552

@implementation NetworkView

@synthesize myTableView;
@synthesize myNavigationBar;

// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// create UI controls
		networkMode = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Unicast",@"Broadcast",nil]];
		// default is broadcast
		networkMode.selectedSegmentIndex = 1;
		ipAddressView = [[UITextField alloc] initWithFrame:CGRectZero];
		ipPortView = [[UITextField alloc] initWithFrame:CGRectZero];
		// default unicast address is localhost
		ipAddress = @"127.0.0.1";
		// start in network disabled mode
		networkEnabled = NO;
	
		// listen to updates from AccelerometerViewControl
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(accelerationUpdate:) 
													 name:@"AccelerationUpdate" 
												   object:nil];
		// create socket
		udpSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
		// init in broadcast mode
		int broadcast = 1;
		setsockopt(udpSocket, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof(int));

		memset((char *) &targetAddress, 0, sizeof(targetAddress));
		targetAddress.sin_family = AF_INET;
		// broadcast address 255.255.255.255
		// TODO: figure out device IP address and netmask, produce a subnet broadcast address
		targetAddress.sin_addr.s_addr = htonl(0xFFFFFFFF);
		targetAddress.sin_port = htons(kAccelerometerSimulationPort);
		targetAddress.sin_len = sizeof(targetAddress);
    }
    return self;
}

// notification handler for acceleration updates
- (void)accelerationUpdate:(NSNotification*)notification {
	AccelerationInfo* info = (AccelerationInfo*)[notification object];

	// only process is network is enabled and socket initialized OK
	if( networkEnabled && udpSocket != -1 )
	{
		// create UDP packet as formatted string
		// "ACC: <deviceid>,<timestamp>,<x>,<y>,<z>"
		const char *msg = [[NSString stringWithFormat:@"ACC: %s,%.3f,%1.3f,%1.3f,%1.3f\n",[info.deviceID UTF8String],info.absTime,info.x,info.y,info.z] UTF8String];
		int error = sendto(udpSocket, msg, strlen(msg), 0, (struct sockaddr*)&targetAddress, sizeof(targetAddress));
		if( error < 0 )
		{
			//NSLog(@"Socket error %d", errno);
		}
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch( section ) {
		case 0:
			// network enable & broadcast/unicast
			return 2;
		case 1:
			// IP address and port
			return 2;
	}
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section {
	switch( section ) {
		case 0:
			return 0.0;
		case 1:
			return 25.0;
	}
    return 0.0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch( section ) {
		case 0:
			return nil;
		case 1:
			return @"Target";
	}
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.section*10 + indexPath.row) {
		case 00:
			// create Network enabled switch
			cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NetEnabled"];
			if (cell == nil) {
				CGRect rect;
				
				cell = [[UITableViewCell alloc] initWithFrame:rect reuseIdentifier:@"NetEnabled"];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;

				rect = CGRectMake(195.0, 8.0, 60.0, 40.0);
				UISwitch *onOffSwitch = [[UISwitch alloc] initWithFrame:rect];
				[onOffSwitch addTarget:self 
								action:@selector(networkToggled:) 
					  forControlEvents:UIControlEventValueChanged];
				[cell.contentView addSubview:onOffSwitch];
				
				rect = CGRectMake(20, 0, 150, 40);
				UILabel *title = [[UILabel alloc] initWithFrame:rect];
				[title setText:@"Network"];
				[cell.contentView addSubview:title];
			}
			return cell;
		case 01:
			// create Unicast | Broadcast selector
			cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NetMode"];
			if (cell == nil) {
				CGRect rect = CGRectMake(0, 0, 300, 44);
				
				cell = [[UITableViewCell alloc] initWithFrame:rect reuseIdentifier:@"NetMode"];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				rect = CGRectMake(139, 7, 170, 30);
				networkMode.frame = rect;
				networkMode.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
				networkMode.segmentedControlStyle = UISegmentedControlStyleBar;
				[networkMode addTarget:self 
									 action:@selector(modeChanged:) 
						   forControlEvents:UIControlEventValueChanged];
				[cell.contentView addSubview:networkMode];
				
				rect = CGRectMake(20, 0, 95, 40);
				UILabel *title = [[UILabel alloc] initWithFrame:rect];
				[title setText:@"Mode"];
				[cell.contentView addSubview:title];
				[title release];
			}
			return cell;
		case 10:
			cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"IPAddress"];
			if (cell == nil) {
				CGRect rect = CGRectMake(0, 0, 300, 44);
				
				cell = [[UITableViewCell alloc] initWithFrame:rect reuseIdentifier:@"IPAddress"];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				rect = CGRectMake(139, 7, 150, 26);
				ipAddressView.frame = rect;
				ipAddressView.textColor = [UIColor darkGrayColor];
				ipAddressView.borderStyle = UITextBorderStyleRoundedRect;
				// input is IP address, so use numbers and dots keyboard
				ipAddressView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
				// init in broadcast mode
				ipAddressView.text = @"255.255.255.255";
				ipAddressView.enabled = NO;

				// delegate is needed for keyboard control
				[ipAddressView setDelegate:self];
				[cell.contentView addSubview:ipAddressView];
				
				rect = CGRectMake(20, 0, 100, 40);
				UILabel *title = [[UILabel alloc] initWithFrame:rect];
				[title setText:@"Address"];
				[cell.contentView addSubview:title];
				[title release];
			}
			return cell;
		case 11:
			cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"IPPort"];
			if (cell == nil) {
				CGRect rect = CGRectMake(0, 0, 300, 44);
				
				cell = [[UITableViewCell alloc] initWithFrame:rect reuseIdentifier:@"IPPort"];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				rect = CGRectMake(139, 7, 150, 26);
				ipPortView.frame = rect;
				ipPortView.borderStyle = UITextBorderStyleRoundedRect;
				ipPortView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
				// contents equals to current port, remember to convert net->host
				ipPortView.text = [NSString stringWithFormat:@"%d",ntohs(targetAddress.sin_port)];

				// delegate is needed for keyboard control
				[ipPortView setDelegate:self];
				[cell.contentView addSubview:ipPortView];
				
				rect = CGRectMake(20, 0, 100, 40);
				UILabel *title = [[UILabel alloc] initWithFrame:rect];
				[title setText:@"Port"];
				[cell.contentView addSubview:title];
				[title release];
			}
			return cell;
	}
	return nil;
}

// called when textfield editing ends (eg. user pressed return)
- (void)textFieldDidEndEditing:(UITextField *)textField {
	if( textField == ipAddressView )
	{
		// store IP, convert from text to IP
		ipAddress = [ipAddressView.text copy];
		const char *addr = [[ipAddressView text] UTF8String];
		inet_aton(addr, &targetAddress.sin_addr);
	}
	if( textField == ipPortView )
	{
		// store port, remember host to net conversion
		targetAddress.sin_port = htons([[ipPortView text] intValue]);
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// return pressed, close keyboard
	[textField resignFirstResponder];
	return YES;
}

// switch between broadcast and unicast
- (void)modeChanged:(UISegmentedControl*)control {
	NSLog(@"Mode changed: New value is %d\n", 
		  control.selectedSegmentIndex);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkModeSwitch" object:control];
	
	if( control.selectedSegmentIndex == 1 )
	{
		// set IP address to broadcast address and disable address text field
		ipAddressView.enabled = NO;
		ipAddressView.textColor = [UIColor darkGrayColor];

		// show broadcast address
		ipAddressView.text = @"255.255.255.255";
		targetAddress.sin_addr.s_addr = 0xFFFFFFFF;
		// enable broadcast mode on socket
		int broadcast = 1;
		setsockopt(udpSocket, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof(int));
	}
	else
	{
		// set IP address to user specified address and enable it
		ipAddressView.enabled = YES;
		ipAddressView.textColor = [UIColor blackColor];

		// retrieve stored IP address
		ipAddressView.text = ipAddress;
		const char *addr = [ipAddress UTF8String];
		inet_aton(addr, &targetAddress.sin_addr);
		
		// disable broadcast mode on socket
		int broadcast = 0;
		setsockopt(udpSocket, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof(int));
	}
}

// enable/disable network
- (void)networkToggled:(UISwitch*)control {
	NSLog(@"Network toggled: New value is %d\n", 
		  control.on);
	networkEnabled = control.on;
}
/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
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
	[ipAddressView release];
	[ipPortView release];
	[networkMode release];
    [super dealloc];
}


@end
