//
//  StopsViewController.m
//  CirculatorGPSAppDelegate
//
//  Created by Marc Irlandez on 4/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StopsViewController.h"
#import "CirculatorGPSAppDelegate.h"
#import "DirectionsViewController.h"


@implementation StopsViewController


/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	[super viewDidLoad];
	locationController = [[CoreLocationController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
}


- (void)dealloc {
	[locationController release];
    [super dealloc];
}

- (void)locationUpdate:(CLLocation *)location {
	NSLog(@"stopViewController:locationUpdate START: %@", location);
	appDelegate.currentLocation = location;
	//locationLabel.text = [location description];
	NSLog(@"stopViewController:locationUpdate END: %@", location);
}

- (void)locationError:(NSError *)error {
	//locationLabel.text = [error description];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[appDelegate currentStops] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	NSDictionary *stop = (NSDictionary *)[[appDelegate currentStops] objectAtIndex:indexPath.row];

	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:CellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UILabel *statusLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 8, 290, 30)] autorelease];

	if ([[appDelegate currentStop] valueForKey:@"id"] == [stop valueForKey:@"id"]) {
		statusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
		statusLabel.textColor = [UIColor redColor];
		statusLabel.text = [NSString stringWithFormat:@"%@ (Nearest Stop)", [stop valueForKey:@"display_name"]];
	} else {
		statusLabel.font = [UIFont systemFontOfSize:15];
		statusLabel.textColor = [UIColor blackColor];
		statusLabel.text = [stop valueForKey:@"display_name"];
	}
	
	statusLabel.lineBreakMode = UILineBreakModeWordWrap;
	statusLabel.numberOfLines = 0;
	statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	cell.text = [stop valueForKey:@"id"];
	cell.textColor = [UIColor clearColor];
	[cell.contentView addSubview:statusLabel];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *stop = (NSDictionary *)[[appDelegate currentStops] objectAtIndex:indexPath.row];
	if ([[appDelegate currentStop] valueForKey:@"id"] == [stop valueForKey:@"id"]) {
		NSString *text = [NSString stringWithFormat:@"%@ (Nearest Stop)", [stop valueForKey:@"display_name"]];
		UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
		CGSize withinSize = CGSizeMake(tableView.bounds.size.width-30.0, 1000.0);
		CGSize size = [text sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
		return size.height + 30.0;
	} else {
		NSString *text = [stop valueForKey:@"display_name"];
		UIFont *font = [UIFont systemFontOfSize:15];
		CGSize withinSize = CGSizeMake(tableView.bounds.size.width-30.0, 1000.0);
		CGSize size = [text sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
		return size.height + 30.0;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"StopsViewController:didSelectRowAtIndexPath");
    // Navigation logic -- create and push a new view controller
	[appDelegate stopClicked:[[tableView cellForRowAtIndexPath:indexPath] text]];
}

/*

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[appDelegate currentDirection] valueForKey:@"display_name"];
}


 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 }
 if (editingStyle == UITableViewCellEditingStyleInsert) {
 }
 }
 */

/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 }
 */
/*
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 }
 */

/*
- (void)dealloc {
    [super dealloc];
}
*/

@end

