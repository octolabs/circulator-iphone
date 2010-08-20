//
//  CirculatorGPSAppDelegate.h
//  CirculatorGPS
//
//  Created by Marc Irlandez on 5/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreLocationController;
@class RoutesViewController;
@class DirectionsViewController;
@class StopsViewController;
@class TimetableViewController;
@class CLLocation;

@interface CirculatorGPSAppDelegate : NSObject <UIApplicationDelegate, UIScrollViewDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet UITabBarController *tabBarController;
	IBOutlet UIScrollView *mapScrollView;
	UIImageView *mapImage;

	IBOutlet UINavigationController *findNavController;

	IBOutlet RoutesViewController *routesViewController;
	IBOutlet DirectionsViewController *directionsViewController;
	IBOutlet StopsViewController *stopsViewController;
	IBOutlet TimetableViewController *timetableViewController;
		
	NSDictionary *currentRoute;
	NSDictionary *currentDirection;
	NSDictionary *currentStop;

	NSArray *currentRoutes;
	NSArray *currentDirections;
	NSArray *currentStops;
	NSArray *currentPredictions;
	
	CLLocation *currentLocation;
	
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) UIScrollView *mapScrollView;
@property (nonatomic, retain) UIImageView *mapImage;

- (id) dictionaryWithUrl:(NSURL *)url;
- (NSDictionary *) getRoute:(NSString *)routeId;
- (NSMutableArray *) getDirections:(NSString *)routeId;
- (NSDictionary *) getDirection:(NSString *)directionId;
- (NSMutableArray *) getStops:(NSDictionary *)direction;
- (NSDictionary *) getStop:(NSString *)stopId;
- (NSDictionary *) getClosestStop:(NSDictionary *)direction;
- (NSMutableArray *) getClosestBuses:(NSDictionary *)direction;
- (NSMutableArray *) getPredictions:(NSString *)stopId;

- (void) routeClicked:(NSString *) routeId;
- (void) directionClicked:(NSString *) directionId;
- (void) stopClicked:(NSString *) stopId;

@property (nonatomic, retain) UINavigationController *findNavController;

@property (nonatomic, retain) RoutesViewController *routesViewController;
@property (nonatomic, retain) DirectionsViewController *directionsViewController;
@property (nonatomic, retain) StopsViewController *stopsViewController;
@property (nonatomic, retain) TimetableViewController *timetableViewController;

@property (retain) CLLocation *currentLocation;

@property (retain) NSDictionary *currentRoute;
@property (retain) NSDictionary *currentDirection;
@property (retain) NSDictionary *currentStop;

@property (retain) NSArray *currentRoutes;
@property (retain) NSArray *currentDirections;
@property (retain) NSArray *currentStops;
@property (retain) NSArray *currentPredictions;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end

