//
//  CirculatorGPSAppDelegate.m
//  CirculatorGPS
//
//  Created by Marc Irlandez on 5/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


#import "CirculatorGPSAppDelegate.h"
#import "DirectionsViewController.h"
#import "StopsViewController.h"
#import "TimetableViewController.h"
#import <UIKit/UIKit.h>
#import <JSON/JSON.h>
#import <Foundation/NSAutoreleasePool.h>

@implementation CirculatorGPSAppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize mapScrollView, mapImage;

@synthesize findNavController;

@synthesize currentRoute, currentDirection, currentStop;

@synthesize routesViewController, directionsViewController, stopsViewController, timetableViewController;

@synthesize currentLocation;

@synthesize currentRoutes, currentDirections, currentStops, currentPredictions;

@synthesize activityIndicator;

- (NSString *) stringWithUrl:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:
								url cachePolicy:
								NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
	
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}


- (id) dictionaryWithUrl:(NSURL *)url
{
	//SBJSON *jsonParser = [SBJSON new];
	NSString *jsonString = [self stringWithUrl:url];
	
	//NSLog(@"Got this form JSON");
	//NSLog(jsonString);
	
	// Parse the JSON into an Object
	NSDictionary *dir = [jsonString JSONValue];
	return dir;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	
	NSString *url = [NSString stringWithFormat:@"http://proximobus.appspot.com/agencies/dc-circulator/routes.json"];
	NSDictionary *dir = [self dictionaryWithUrl:[NSURL URLWithString:url]];
	self.currentRoutes = [dir valueForKey:@"items"];
	
	UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"map" ofType:@"png"]]];
	[self setMapImage:tempImageView];
	[tempImageView release];
	
	mapScrollView.contentSize = CGSizeMake(mapImage.frame.size.width, mapImage.frame.size.height);
	mapScrollView.maximumZoomScale = 3.0;
	mapScrollView.minimumZoomScale = 0.5;
	[mapScrollView setContentOffset:CGPointMake(mapImage.frame.size.width/2, mapImage.frame.size.height/2)];
	mapScrollView.clipsToBounds = YES;
	mapScrollView.delegate = self;
    [mapScrollView addSubview:mapImage];
    
	[routesViewController setTitle:@"Pick A Route"];
	findNavController.viewControllers = [NSArray arrayWithObjects:routesViewController, nil];
	
	[window addSubview:[tabBarController view]];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.center = window.center;
	activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	[window addSubview:activityIndicator];
	
	[window makeKeyAndVisible];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return mapImage;
}


- (void)dealloc {
	[findNavController release];
	[directionsViewController release];
	[stopsViewController release];
	[timetableViewController release];
	[mapScrollView release];
	[mapImage release];
    [tabBarController release];
	[activityIndicator release];
	[window release];
    [super dealloc];
}


- (void) routeClicked:(NSString *)routeId {
	NSLog(@"routeClicked START: %@", routeId);
	self.currentRoute = [self getRoute:routeId];
	self.currentDirections = [self getDirections:routeId];
	
	[directionsViewController setTitle:@"Pick A Direction"];
	[[directionsViewController tableView] reloadData];
	[findNavController pushViewController:directionsViewController animated:YES];
	NSLog(@"routeClicked END: %@", routeId);
}


- (void) directionClicked:(NSString *)directionId {
	NSLog(@"directionClicked START: %@", directionId);
	self.currentDirection = [self getDirection:directionId];
	self.currentStops = [self getStops:[self currentDirection]];
	self.currentStop = [self getClosestStop:[self currentDirection]];
	
	[stopsViewController setTitle:@"Pick A Stop"];
	[[stopsViewController tableView] reloadData];
	[findNavController pushViewController:stopsViewController animated:YES];
	NSLog(@"directionClicked END: %@", directionId);
}

- (void) stopClicked:(NSString *)stopId {
	NSLog(@"stopClicked START: %@", stopId);
	self.currentStop = [self getStop:stopId];
	self.currentPredictions = [self getPredictions:stopId];
	[timetableViewController setTitle:@"Predictions"];
	[[timetableViewController tableView] reloadData];
	[findNavController pushViewController:timetableViewController animated:YES];
	
	//[activityIndicator startAnimating];
	//[NSThread detachNewThreadSelector:@selector(hitWebService:) toTarget:self withObject:nil];
	NSLog(@"stopClicked END: %@", stopId);
}


// NOT BEING CALLED RIGHT NOW.
- (void)hitWebService:(id)someObject {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	[timetableViewController setTitle:@"Closest Buses"];
	[[timetableViewController tableView] reloadData];
	[findNavController pushViewController:timetableViewController animated:YES];
	[p release];
	[NSThread exit];
}


- (NSDictionary *) getRoute:(NSString *)id {
	
	NSLog(@"getRoute START: %@", id);
	NSEnumerator *e = [currentRoutes objectEnumerator];
	NSDictionary *route;
	while ( (route = [e nextObject]) ) {
		if ([id isEqualToString:[route valueForKey:@"id"]]) {
			NSLog(@"getColor END: %@", id);
			return (NSDictionary *) route;
		}
	}
	NSLog(@"getRoute END: %@", id);
	return nil;
}


- (NSMutableArray *) getDirections:(NSString *)routeId {
	NSLog(@"getDirections START: %@", routeId);
	NSString *url = [NSString stringWithFormat:@"http://proximobus.appspot.com/agencies/dc-circulator/routes/%@/runs.json", routeId];
	NSDictionary *dir = [self dictionaryWithUrl:[NSURL URLWithString:url]];
	NSLog(@"getDirections END: %@", routeId);
	return [dir valueForKey:@"items"];
}


- (NSDictionary *) getDirection:(NSString *)directionId {
	NSLog(@"getDirection START: %@", directionId);
	NSEnumerator *e = [currentDirections objectEnumerator];
	NSDictionary *direction;
	while ( (direction = [e nextObject]) ) {
		if ([directionId isEqualToString:[direction valueForKey:@"id"]]) {
			return (NSDictionary *) direction;
		}
	}
	NSLog(@"getDirection END: %@", directionId);
	return nil;
}


- (NSMutableArray *) getStops:(NSDictionary *)direction {
	NSLog(@"getStops START: %@", [direction valueForKey:@"id"]);
	NSString *url = [NSString stringWithFormat:@"http://proximobus.appspot.com/agencies/dc-circulator/routes/%@/runs/%@/stops.json", [direction valueForKey:@"route_id"], [direction valueForKey:@"id"]];
	NSDictionary *dir = [self dictionaryWithUrl:[NSURL URLWithString:url]];
	//stops = [[NSMutableArray alloc] initWithArray:[dir valueForKey:@"items"]];
	//currentStops = [[NSMutableArray alloc] initWithArray:[dir valueForKey:@"items"]];
	NSLog(@"getStops END: %@", [direction valueForKey:@"id"]);
	return [dir valueForKey:@"items"];
}


- (NSDictionary *) getStop:(NSString *)id {
	NSLog(@"getStop: %@", id);
	NSEnumerator *e = [[self currentStops] objectEnumerator];
	NSDictionary *stop;
	while ( (stop = [e nextObject]) ) {
		if ([id isEqualToString:[stop valueForKey:@"id"]]) {
			return (NSDictionary *) stop;
		}
	}
	NSLog(@"getStop END: %@", id);
	return nil;
}


- (NSDictionary *)getClosestStop:(NSDictionary *)direction {
	NSLog(@"getClosestStop START: %@", [direction valueForKey:@"id"]);
	NSLog(@"getClosestStop:currentLocation: %@", currentLocation);
	NSEnumerator *e = [[self currentStops] objectEnumerator];
	NSDictionary *stop;
	NSDictionary *closestStop = nil;
	double closestDistance = 999999999;
	while ( (stop = [e nextObject]) ) {
		//NSLog(@"looping through routeStops: %@", stop);
		CLLocation *location = [[CLLocation alloc] initWithLatitude:[[stop objectForKey:@"latitude"] floatValue] longitude:[[stop objectForKey:@"longitude"] floatValue]];
		double currentDistance = [currentLocation getDistanceFrom:location];
		if (currentDistance < closestDistance) {
			//NSLog(@"getClosestStop:found a closer stop!: %@", stop);
			closestStop = stop;
			closestDistance = currentDistance;
		}
	}
	NSLog(@"getClosestStop:closestStop: %@", [closestStop valueForKey:@"id"]);
	return closestStop;
}


- (NSMutableArray *) getPredictions:(NSString *)stopId {
	NSLog(@"getPredictions START: %@", stopId);	
	NSString *url = [NSString stringWithFormat:@"http://proximobus.appspot.com/agencies/dc-circulator/stops/%@/predictions/by-route/%@.json", stopId, [[self currentRoute] valueForKey:@"id"]];
	NSLog(@"URL: %@", url);
	NSDictionary *dir = [self dictionaryWithUrl:[NSURL URLWithString:url]];
	NSLog(@"Pred: %@", [dir valueForKey:@"items"]);
	//stops = [[NSMutableArray alloc] initWithArray:[dir valueForKey:@"items"]];
	//currentStops = [[NSMutableArray alloc] initWithArray:[dir valueForKey:@"items"]];
	NSLog(@"getPredictions END: %@", stopId);
	return [dir valueForKey:@"items"];
}

// NOT CALLED RIGHT NOW
- (NSMutableArray *) getClosestBuses:(NSDictionary *)stop {
	NSLog(@"getClosestBuses START");
		
	//double milesConversion = 0.000621371192;
	NSMutableArray *closestBuses = [[NSMutableArray alloc] initWithCapacity:10];
	// Get buses from webservice than iterate over it, remove the timetables variable
	NSString *url = [NSString stringWithFormat:@"http://dc-circ.appspot.com/api/nextBus.json?route_id=%@&stop_id=%@", [stop valueForKey:@"route_id"], [stop valueForKey:@"stop_id"]];
	id response = [self dictionaryWithUrl:[NSURL URLWithString:url]];
	NSEnumerator *e = [response objectEnumerator];
	
	/*
	 NSDictionary *closestBus;
	 while ( (closestBus = [e nextObject]) ) {
	 CLLocation *location = [[CLLocation alloc] initWithLatitude:[[stop objectForKey:@"lat"] floatValue] longitude:[[stop objectForKey:@"lon"] floatValue]];
	 double currentDistance = [currentLocation getDistanceFrom:location] * milesConversion;
	 [closestBuses addObject:[NSString stringWithFormat:@"Bus %@ is %0.2f miles away", [closestBus valueForKey:@"number"], currentDistance]];
	 }
	*/
	
	NSString *busInfo;
	while ( (busInfo = [e nextObject]) ) {
		[closestBuses addObject:busInfo];
	}
		
	NSLog(@"getClosestBuses END");
	return closestBuses;
}


@end
