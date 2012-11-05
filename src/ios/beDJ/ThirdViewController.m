//
//  ThirdViewController.m
//  QuTrack
//
//  Created by Garrett Galow on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewController.h"
#import "QueueCell.h"
#import "Venues.h"
#import "VoteViewController.h"
#import "VoteView.h"

@implementation ThirdViewController

@synthesize playlistTable, selectedPath, pullToRefreshView;

NSArray* letterArray;
NSArray* sortTypeArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Array Sorting
- (NSInteger)sectionForObject:(id)object collationString:(NSString*)string {
    NSString* selectedString = [[[object valueForKey:string] substringToIndex:1] uppercaseString];
    NSInteger position = [letterArray indexOfObject:selectedString];
    if (position == NSNotFound) {
        return 26;
    } else {
        return [letterArray indexOfObject:selectedString];
    }
}

- (NSArray *)sortedArrayFromArray:(NSArray *)array collationString:(NSString*) string {
    NSMutableArray* sortedArray = [array mutableCopy];
    [sortedArray sortUsingComparator:^(id obj1, id obj2) {
        NSString* artist1 = [obj1 valueForKey:string];
        NSString* artist2 = [obj2 valueForKey:string];
        NSComparisonResult artistComparison = [artist1 localizedCaseInsensitiveCompare:artist2];
        if (artistComparison == NSOrderedSame) {
            NSString* name1 = [obj1 valueForKey:@"name"];
            NSString* name2 = [obj2 valueForKey:@"name"];
            return [name1 localizedCaseInsensitiveCompare:name2];
        } else {
            return artistComparison;
        }

//        NSNumber* val1;
//        NSNumber* val2;
//        return (NSComparisonResult)[val2 compare:val1];
    }];
    return sortedArray;
//    NSSortDescriptor *alphaSortDescriptor = [[NSSortDescriptor alloc] initWithKey:string ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
//    
//    return [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSortDescriptor]];
}

-(NSArray *)partitionObjects:(NSArray *)array collationString:(NSString*)string {
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++)
    {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    //put each object into a section
    for (id object in array)
    {
        NSInteger index = [self sectionForObject:object collationString:string];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //sort each section
    for (NSArray *section in unsortedSections)
    {
        [sections addObject:[self sortedArrayFromArray:section collationString:string]];
    }
    
    return sections;
}

#pragma mark - Instance Methods

-(void) startLoading {
//    [indicator startAnimating];
//    [loadingView setHidden:NO];
    [innerNoVenueView setHidden:YES];
//    [innerLoadingView setHidden:NO];
}

-(IBAction) refreshButtonPressed:(id) sender {
    if ([[Venues sharedVenues] currentVenue] != nil) {
//        [indicator startAnimating];
//        [loadingView setHidden:NO];
        [innerNoVenueView setHidden:YES];
//        [innerLoadingView setHidden:NO];
        [[Playlist sharedPlaylist] updatePlaylistDataWithSender:self];
    }
}

-(void) removeSearchBarKeyboard {
    if ([sBar isFirstResponder]) {
        [sBar resignFirstResponder];
    }
}

-(void)backgroundTapped:(id)sender {
    [self removeSearchBarKeyboard];
}

#pragma mark - Playlist Delegate
-(void) playlistUpdated {
    if (searching) {
        [searchArray removeAllObjects];
        [self searchTableView];
        tableArray = searchArray;
        [playlistTable reloadData];
    } else {
        NSString* collationString = [sortTypeArray objectAtIndex:sBar.selectedScopeButtonIndex];
        tableArray = [self partitionObjects:[[Playlist sharedPlaylist] songs] collationString:collationString];
        [playlistTable reloadData];
    }
    
    NSNumber* voteCount = [[Playlist sharedPlaylist] userVotes];
    if ([voteCount intValue] == -1) {
        numVotes.text = @"~ Votes";
    }else {
        if ([voteCount intValue] == 1) {
            numVotes.text = [NSString stringWithFormat:@"%@ Vote",[voteCount stringValue]];
        } else {
            numVotes.text = [NSString stringWithFormat:@"%@ Votes",[voteCount stringValue]];
        }
    }
    [self.pullToRefreshView finishLoading];
//    outstandingOperations -= 1;
//    if (outstandingOperations == 0) {
//        [indicator stopAnimating];
//        [loadingView setHidden:YES];
//    }
}

-(void)automatedPlaylistUpdated {
    if (searching) {
        [searchArray removeAllObjects];
        [self searchTableView];
        tableArray = searchArray;
        [playlistTable reloadData];
    } else {
        NSString* collationString = [sortTypeArray objectAtIndex:sBar.selectedScopeButtonIndex];
        tableArray = [self partitionObjects:[[Playlist sharedPlaylist] songs] collationString:collationString];
        [playlistTable reloadData];
    }
    
    NSNumber* voteCount = [[Playlist sharedPlaylist] userVotes];
    if ([voteCount intValue] == -1) {
        numVotes.text = @"~ Votes";
    }else {
        if ([voteCount intValue] == 1) {
            numVotes.text = [NSString stringWithFormat:@"%@ Vote",[voteCount stringValue]];
        } else {
            numVotes.text = [NSString stringWithFormat:@"%@ Votes",[voteCount stringValue]];
        }
    }
}

#pragma mark - Search Bar Delegate Methods

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searching = NO;
    searchBar.text = @"";
    [searchArray removeAllObjects];
    [searchBar resignFirstResponder];
    NSString* collationString = [sortTypeArray objectAtIndex:sBar.selectedScopeButtonIndex];
    tableArray = [self partitionObjects:[[Playlist sharedPlaylist] songs] collationString:collationString];
    [searchBar setShowsCancelButton:NO animated:YES];
//    searchBar.showsScopeBar = NO;
    [playlistTable reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    if (searching) {
        [searchArray removeAllObjects];
        [self searchTableView];
        tableArray = searchArray;
    } else {
        NSString* collationString = [sortTypeArray objectAtIndex:sBar.selectedScopeButtonIndex];
        tableArray = [self partitionObjects:[[Playlist sharedPlaylist] songs] collationString:collationString];
    }
    [playlistTable reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    searchBar.showsScopeBar = YES;
//    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Artist",@"Title", nil];
    searchBar.selectedScopeButtonIndex = 0;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searching = YES;
    [searchBar resignFirstResponder];
    [self searchTableView];
    tableArray = searchArray;
    [playlistTable reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [searchArray removeAllObjects];
    searching = YES;
    if([searchText length] > 0) {
        
//        searching = YES;
        [self searchTableView];
        tableArray = searchArray;
    }
    else {
        
        searching = NO;
        NSString* collationString = [sortTypeArray objectAtIndex:sBar.selectedScopeButtonIndex];
        tableArray = [self partitionObjects:[[Playlist sharedPlaylist] songs] collationString:collationString];
    }
    [playlistTable reloadData];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    if (searching) {
        [searchArray removeAllObjects];
        [self searchTableView];
        tableArray = searchArray;
        [searchBar setShowsCancelButton:NO animated:YES];
    } else {
        NSString* collationString = [sortTypeArray objectAtIndex:sBar.selectedScopeButtonIndex];
        tableArray = [self partitionObjects:[[Playlist sharedPlaylist] songs] collationString:collationString];
        [searchBar setShowsCancelButton:NO animated:YES];
    }
    
    [playlistTable reloadData];
    
}

- (void) searchTableView {
    
    NSString *searchText = sBar.text;
    
    for (NSDictionary* dictionary in [[Playlist sharedPlaylist] songs])
    {
        
        //artist is index 0 so false, title is index 1 so true
        NSString* sTemp = (sBar.selectedScopeButtonIndex) ? [dictionary objectForKey:@"name"] : [dictionary objectForKey:@"artist"];
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [searchArray addObject:dictionary];
    }
}

#pragma mark - Table Setup

//Name of the side index titles
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    return nil;
}

//The string to set for the header of the parameter section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
    
//    BOOL showSection = [[tableArray objectAtIndex:section] count] != 0;
//    //only show the section title if there are rows in the section
//    return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //If there are entries to be displayed then we want a header otherwise no header
    BOOL showSection = (searching) ? YES : [[tableArray objectAtIndex:section] count] != 0;
    
    return (showSection) ? 25 : 0;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (searching) {
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.backgroundColor = [UIColor blackColor];
        headerLabel.text = [NSString stringWithFormat:@"   Search Results"];
//        headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
        headerLabel.textColor = [UIColor colorWithRed:(60432.0/65535.0) green:(28089.0/65535.0) blue:0 alpha:1];
        headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        headerLabel.textAlignment = UITextAlignmentLeft;
        return headerLabel;

    } else {
        BOOL showSection = [[tableArray objectAtIndex:section] count] != 0;
        //only show the section title if there are rows in the section
        if (!showSection) {
            return nil;
        } else {
            UILabel* headerLabel = [[UILabel alloc] init];
            headerLabel.backgroundColor = [UIColor blackColor];
            headerLabel.text = [NSString stringWithFormat:@"   %@",[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section]];
//            headerLabel.textColor = [UIColor colorWithRed:.07 green:.65 blue:.71 alpha:1];
            headerLabel.textColor = [UIColor colorWithRed:(60432.0/65535.0) green:(28089.0/65535.0) blue:0 alpha:1];
            headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
            headerLabel.textAlignment = UITextAlignmentLeft;
            return headerLabel;
        }
    }
}


//I think...You return the index of the array to go to for such a side index
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //sectionForSectionIndexTitleAtIndex: is a bit buggy, but is still useable
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

//How many sections to go in the table
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (searching) {
        return 1;
    } else {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
    }
}

//Says how many entries go in the given section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (searching) {
        return [tableArray count];
    } else {
        return [[tableArray objectAtIndex:section] count];
    }
}

//When necessary to display new cells, passes the table and the index path (section and row) to load the new cell that will be displayed
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"QueueCell";
    
    QueueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QueueCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    NSDictionary* song;
    if (searching) {
        song = [tableArray objectAtIndex:indexPath.row];
    } else {
    
        song = [[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    cell.title.text = [song objectForKey:@"name"];
    cell.artist.text = [song objectForKey:@"artist"];
    
    cell.votes.text = [[song objectForKey:@"votes"] stringValue];
    
    cell.selfVotes.text = [NSString stringWithFormat:@"(%@)",[[song objectForKey:@"uservotes"] stringValue]];
    
    cell.songImage.image = [UIImage imageNamed:@"194-note-2@2xw.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor blackColor];
    cell.layer.cornerRadius = 5.0;
    cell.layer.masksToBounds = YES;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self removeSearchBarKeyboard];
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedPath = indexPath;
    NSDictionary* song;
    if (searching) {
        song = [tableArray objectAtIndex:selectedPath.row];
    } else {
        song = [[tableArray objectAtIndex:selectedPath.section] objectAtIndex:selectedPath.row];
    }
    
//    VoteViewController* voteController = [self.storyboard instantiateViewControllerWithIdentifier:@"VoteViewController"];
    VoteViewController* voteController = [[VoteViewController alloc] init];
    
    VoteView* voteView = (VoteView*)voteController.view;
    [voteView setSong:song];
    [voteView setDelegate:self];
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^(){
        [voteView setCenter:CGPointMake(160, 480+voteView.bounds.size.height/2)];
        [self.parentViewController.view addSubview:voteView];
        [voteView setCenter:CGPointMake(160, 481-voteView.bounds.size.height/2)];
    }completion:nil];
    [[voteView picker] selectRow:0 inComponent:0 animated:YES];
    [voteController viewDidAppear:NO];
    
    //Set up inset view to cast vote
//    [[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Cast Vote", @"Undo Vote", nil] showInView:self.parentViewController.view];
//    selectedPath = indexPath;
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSString* song = [[[tableArray objectAtIndex:selectedPath.section] objectAtIndex:selectedPath.row] valueForKey:@"SONG_id"];
//    if (buttonIndex == 2) {
//        return;
//    } else {
//        if (buttonIndex == 0) {
//            
//            [[Playlist sharedPlaylist] castVote:song withVotes:@"1" withSender:self];
//            
//        } else if (buttonIndex == 1) {
//            
//            [[Playlist sharedPlaylist] undoVote:song withVotes:@"1" withSender:self];
//        }
//        [indicator startAnimating];
//        [loadingView setHidden:NO];
//        [innerNoVenueView setHidden:YES];
//        [innerLoadingView setHidden:NO];
//        
////        outstandingOperations += 1;
//    }
//}

#pragma mark SSPullToRefresh Delegate Methods

- (void)refresh {
    [self.pullToRefreshView startLoadingAndExpand:YES];
    // Load data...
    [[Playlist sharedPlaylist] updatePlaylistDataWithSender:self];
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self refresh];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

//    outstandingOperations = 0;
    letterArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U",@"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    sortTypeArray = [NSArray arrayWithObjects:@"artist",@"name", nil];
//    innerLoadingView.layer.cornerRadius = 5.0;
//    innerLoadingView.layer.masksToBounds = YES;
    innerNoVenueView.layer.cornerRadius = 5.0;
    innerNoVenueView.layer.masksToBounds = YES;
    
    searchArray = [[NSMutableArray alloc] initWithCapacity:1];
    searching = NO;
    
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:playlistTable delegate:self];
    pullToRefreshView.contentView = [[DJPullToRefreshContentView alloc] initWithFrame:CGRectZero];
    
//    CGRect newFrame = CGRectMake(0.0, 0.0, playlistTable.bounds.size.width, playlistTable.frame.size.height);
//    playlistTable.tableHeaderView.backgroundColor = [UIColor clearColor];
//    playlistTable.tableHeaderView.frame = newFrame;
//    playlistTable.tableHeaderView = tableViewHeader; // note this will override UITableView's 'sectionHeaderHeight' property
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Playlist sharedPlaylist] addDelegate:self];
    if ([[Venues sharedVenues] currentVenue] == nil) {
//        [loadingView setHidden:NO];
//        [innerLoadingView setHidden:YES];
        [innerNoVenueView setHidden:NO];
        
        NSString* collationString = [sortTypeArray objectAtIndex:sBar.selectedScopeButtonIndex];
        tableArray = [self partitionObjects:[NSMutableArray arrayWithCapacity:1] collationString:collationString];
        [playlistTable reloadData];
        
    } else if ([[NSDate date] timeIntervalSinceDate:[[Playlist sharedPlaylist] lastUpdate]] > 10) {
        [self refresh];
//        [indicator startAnimating];
//        [loadingView setHidden:NO];
//        [innerLoadingView setHidden:NO];
        [innerNoVenueView setHidden:YES];
//        [[Playlist sharedPlaylist] updatePlaylistDataWithSender:self];
        
    } else {
        [innerNoVenueView setHidden:YES];
//        [loadingView setHidden:YES];
        if (searching) {
            tableArray = searchArray;
        } else {
            NSString* collationString = [sortTypeArray objectAtIndex:sBar.selectedScopeButtonIndex];
            tableArray = [self partitionObjects:[[Playlist sharedPlaylist] songs] collationString:collationString];
        }
        [playlistTable reloadData];
        
        NSNumber* voteCount = [[Playlist sharedPlaylist] userVotes];
        if ([voteCount intValue] == -1) {
            numVotes.text = @"~ Votes";
        }else {
            numVotes.text = [voteCount stringValue];
            if ([voteCount intValue] == 1) {
                numVotes.text = [NSString stringWithFormat:@"%@ Vote",[voteCount stringValue]];
            } else {
                numVotes.text = [NSString stringWithFormat:@"%@ Votes",[voteCount stringValue]];
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[Playlist sharedPlaylist] removeDelegate:self];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
