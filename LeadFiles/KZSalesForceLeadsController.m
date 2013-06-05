//
//  LeftDemoViewController.m
//  PKRevealController
//
//  Created by Philip Kluz on 1/18/13.
//  Copyright (c) 2013 zuui.org. All rights reserved.
//
#import "KZSalesForceLeadsController.h"
#import "KZAppDelegate.h"
#import "KidoZen.h"

@implementation KZSalesForceLeadsController

@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;


#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
	self.title = @"SalesForce";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    if (!self.listContent) {
       [[KidoZen sharedApplication] getLeadsFromSalesforce:^(id kidozenResponse) {
           self.listContent = kidozenResponse;
           [self.tableView reloadData];
           [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
       }];
    }
    
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        self.searchDisplayController.searchBar.frame = CGRectMake(500, 50, 250, 44);
        self.searchDisplayController.searchResultsTableView.frame = CGRectMake(500, 100, 250, 400);

        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
    self.searchDisplayController.searchBar.placeholder = @"Search Lead";
}

- (void)viewDidUnload
{
	self.filteredListContent = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
    NSDictionary *lead = [self selectLeadFromTableView:tableView withIndexPath:indexPath];
	
	cell.textLabel.text = [lead objectForKey:@"Name"];
	return cell;
}

-(NSDictionary *) selectLeadFromTableView:(UITableView *) tableView withIndexPath:(NSIndexPath *) indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView)
        return [self.filteredListContent objectAtIndex:indexPath.row];
	else
        return  [self.listContent objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_fileSelected) {
        return;
    }

    UIViewController *detailsViewController = [[UIViewController alloc] init];
    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
    NSDictionary *lead = [self selectLeadFromTableView:tableView withIndexPath:indexPath];
	detailsViewController.title = [lead objectForKey:@"Name"];
    _leadSelected =[lead objectForKey:@"Name"];
    [[self navigationController] pushViewController:detailsViewController animated:YES];

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you really want to assign this file?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [[ThisApp menuController] showRootController:YES];
        self.uiAlerViewMessage = @"File and Lead relation has been saved in Kidozen";
        [[KidoZen sharedApplication] assignFile:_fileSelected toLead:_leadSelected withBlock:^(id message) {
            [[KidoZen sharedApplication] createIdeaForFile:_fileUrl andLead:_leadSelected withBlock:^(id msg) {
                if (msg) {
                    self.uiAlerViewMessage = @"File and Lead relation has been saved in Kidozen and a new Idea was created in Salesforce";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:self.uiAlerViewMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
            }];
        }];
    }
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (NSDictionary *lead in listContent)
	{
        NSComparisonResult result = [[lead objectForKey:@"Name"] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
		{
            [self.filteredListContent addObject:lead];
        }
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Autorotation

/*
* Please get familiar with iOS 6 new rotation handling as if you were to nest this controller within a UINavigationController,
* the UINavigationController would _NOT_ relay rotation requests to his children on its own!
*/

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end