//
//  TimetableViewController.h
//  CirculatorGPS
//
//  Created by Marc Irlandez on 5/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"

@class CirculatorGPSAppDelegate;

@interface TimetableViewController : UITableViewController {
	IBOutlet CirculatorGPSAppDelegate *appDelegate;
	//CoreLocationController *locationController;
}

//- (void)locationUpdate:(CLLocation *)location; 
//- (void)locationError:(NSError *)error;

@end
