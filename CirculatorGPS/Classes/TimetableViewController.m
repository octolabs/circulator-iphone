//
//  TimetableViewController.m
//  CirculatorGPS
//
//  Created by Marc Irlandez on 5/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimetableViewController.h"
#import "CirculatorGPSAppDelegate.h"


@implementation TimetableViewController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[appDelegate currentPredictions] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	NSDictionary *prediction = (NSDictionary *)[[appDelegate currentPredictions] objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
								   reuseIdentifier:CellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UILabel *statusLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 8, 290, 30)] autorelease];
	statusLabel.font = [UIFont systemFontOfSize:15];
	statusLabel.textColor = [UIColor blackColor];
	statusLabel.lineBreakMode = UILineBreakModeWordWrap;
	statusLabel.numberOfLines = 0;
	statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	statusLabel.text = [NSString stringWithFormat:@"A bus is %@ minutes away", [prediction valueForKey:@"minutes"]];
	cell.text = [prediction valueForKey:@"block_id"];
	cell.textColor = [UIColor clearColor];
	[cell.contentView addSubview:statusLabel];
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *prediction = (NSDictionary *)[[appDelegate currentPredictions] objectAtIndex:indexPath.row];
	NSString *text = [NSString stringWithFormat:@"A bus is %@ minutes away", [prediction valueForKey:@"minutes"]];
	UIFont *font = [UIFont systemFontOfSize:15];
	CGSize withinSize = CGSizeMake(tableView.bounds.size.width, 1000.0);
	CGSize size = [text sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
	return size.height + 20.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"DirectionsViewController:didSelectRowAtIndexPath");
    // Navigation logic -- create and push a new view controller
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=http://proximobus.appspot.com/agencies/dc-circulator/routes/%@/vehicles.kml", [[appDelegate currentRoute] valueForKey:@"id"]]]];
}


/*
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 return @"Predictions";
 }
 */

/*
 - (void)viewDidLoad {
 [super viewDidLoad];
 // Uncomment the following line to add the Edit button to the navigation bar.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 }
 */


/*
 // Override to support editing the list
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support conditional editing of the list
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support rearranging the list
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the list
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end

