#import <UIKit/UIKit.h>
#import "CoreLocationController.h"

@interface ClosestBusViewController : UIViewController <CoreLocationControllerDelegate> {
	IBOutlet UILabel *locationLabel;
	CoreLocationController *locationController;
}

- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;

@end