//
//  NetworkView.h
//  AccSim
//
//  Created by Otto Chrons on 9/25/08.
//  Copyright 2008 Enzymia Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <unistd.h>
#include <netdb.h>

// view for configuring network parameters
@interface NetworkView : UIViewController  <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
	IBOutlet UITableView *myTableView;
	IBOutlet UINavigationBar *myNavigationBar;

	UISegmentedControl *networkMode;
	UITextField *ipAddressView;
	UITextField *ipPortView;
	NSString *ipAddress;
	
	// using BSD sockets
	int udpSocket;
	struct sockaddr_in targetAddress;
	bool networkEnabled;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UINavigationBar *myNavigationBar;

@end
