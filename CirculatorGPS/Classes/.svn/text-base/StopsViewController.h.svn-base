//
//  StopsViewController.h
//  CirculatorGPSAppDelegate
//
//  Created by Marc Irlandez on 4/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"

@class CirculatorGPSAppDelegate;

@interface StopsViewController : UITableViewController <CoreLocationControllerDelegate> {
	IBOutlet CirculatorGPSAppDelegate *appDelegate;
	CoreLocationController *locationController;
}

- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;

@end
