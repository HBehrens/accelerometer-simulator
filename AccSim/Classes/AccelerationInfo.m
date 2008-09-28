//
//  AccelerationInfo.m
//  AccSim
//
//  Created by Otto Chrons on 9/26/08.
//  Copyright 2008 Enzymia Ltd.. All rights reserved.
//

#import "AccelerationInfo.h"


@implementation AccelerationInfo

@synthesize deviceID;
@synthesize absTime;
@synthesize x, y, z;

+ (AccelerationInfo*)createWithTimestamp:(NSTimeInterval)timeStamp X:(UIAccelerationValue)x Y:(UIAccelerationValue)y Z:(UIAccelerationValue)z
{
	AccelerationInfo *newInfo = [AccelerationInfo alloc];

	newInfo.absTime = timeStamp;
	newInfo.deviceID = [[UIDevice currentDevice] uniqueIdentifier];
	newInfo.x = x;
	newInfo.y = y;
	newInfo.z = z;
	
	return newInfo;
}

@end
