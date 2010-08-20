#import "ClosestBusViewController.h"

@implementation ClosestBusViewController

- (void)viewDidLoad { 	
	locationController = [[CoreLocationController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc {
	[locationController release];
    [super dealloc];
}

- (void)locationUpdate:(CLLocation *)location {
	locationLabel.text = [location description];
}

- (void)locationError:(NSError *)error {
	locationLabel.text = [error description];
}

@end
