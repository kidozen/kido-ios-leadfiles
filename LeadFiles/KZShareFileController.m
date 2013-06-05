//
//  KZShareFileController.m
//  LeadFiles
//
//  Created by Christian Carnero on 5/2/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//
#import "KZShareFileController.h"
#import "KZShareFileCell.h"
#import "KZAppDelegate.h"
#import "KGModal.h"
#import "MKEntryPanel.h"
#import "KZSalesForceLeadsController.h"
#import "KZHelpViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MJPopupBackgroundView.h"
#import "KZBrowserController.h"

static NSString * const FileShareCellIdentifier = @"FileShareCell";

@interface KZShareFileController ()
{
}
@end

@implementation KZShareFileController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
                                          initWithTitle:@"info" style:UIBarButtonItemStylePlain 
                                          target:self action:@selector(showHelp)];
        self.navigationItem.rightBarButtonItem = infoButton;
    }
    return self;
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (!_shareFileFoldersAndFiles)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [[KidoZen sharedApplication] getFilesFromShareFilePath:_shareFilePath withBlock:^(id kidozenResponse) {
            [self setBarTitle];
            self.shareFileFoldersAndFiles = kidozenResponse;
            [self.collectionView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
    [self setUpView];
}

-(void) setBarTitle
{
    NSArray * fullPath = [_shareFilePath componentsSeparatedByString:@"/"];
    NSString * title = [fullPath objectAtIndex:fullPath.count-2];
    self.navigationItem.title = title;
}

- (void)setupUserLayout
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            self.shareFileLayout.numberOfColumns = 7;
            self.shareFileLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
            
        } else {
            self.shareFileLayout.numberOfColumns = 4;
            self.shareFileLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, sideInset);
        }
    }
    else
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            self.shareFileLayout.numberOfColumns = 3;
            // handle insets for iPhone 4 or 5
            CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;
            self.shareFileLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
            
        } else {
            self.shareFileLayout.numberOfColumns = 2;
            self.shareFileLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
        }
}

-(void)setUpView
{
    //self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    [self.collectionView registerClass:[KZShareFileCell class] forCellWithReuseIdentifier:FileShareCellIdentifier];
    
    //Load images optimization
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
    
    // Set up recognizers.
	UITapGestureRecognizer *tapPressHandler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressHandler:)];
	tapPressHandler.numberOfTapsRequired = 2;
	tapPressHandler.delegate = self;
    tapPressHandler.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:tapPressHandler];
    
    [self setupUserLayout];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            self.shareFileLayout.numberOfColumns = 7;
            self.shareFileLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
            
        } else {
            self.shareFileLayout.numberOfColumns = 4;
            self.shareFileLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, sideInset);
        }
    }
    else
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            self.shareFileLayout.numberOfColumns = 3;
            // handle insets for iPhone 4 or 5
            CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;
            self.shareFileLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
        } else {
            self.shareFileLayout.numberOfColumns = 2;
            self.shareFileLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
        }
}

#pragma mark - UICollectionViewDataSource


- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_shareFileFoldersAndFiles count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KZShareFileCell *fileShareCell = [collectionView dequeueReusableCellWithReuseIdentifier:FileShareCellIdentifier forIndexPath:indexPath];
    __block UILongPressGestureRecognizer *longPressGesture;
    
    // load images in the background
    //TODO: HEY! ME! Check the following lines potential memory leak?
    __weak KZShareFileController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                NSDictionary * itm = [_shareFileFoldersAndFiles objectAtIndex:indexPath.row];
                NSString * imagename = nil;
                if ([[itm objectForKey:@"type"] isEqualToString:@"file"]) {
                    imagename = @"file.png";
                    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
                    longPressGesture.minimumPressDuration = 2.0;
                    longPressGesture.cancelsTouchesInView = YES;
                    [fileShareCell.contentView addGestureRecognizer:longPressGesture];
                }
                else {
                    imagename = @"folder.png";
                }
                fileShareCell.imageView.image = [UIImage imageNamed:imagename];
                fileShareCell.uiLabel.text = [itm objectForKey:@"displayname"];
            }
        });
    }];
    [self.thumbnailQueue addOperation:operation];

    return fileShareCell;
}


- (void)showInformation:(NSString *)text
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    CGRect welcomeLabelRect = contentView.bounds;
    welcomeLabelRect.origin.y = 20;
    welcomeLabelRect.size.height = 20;
    UIFont *welcomeLabelFont = [UIFont boldSystemFontOfSize:17];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:welcomeLabelRect];
    welcomeLabel.text = @"File details";
    welcomeLabel.font = welcomeLabelFont;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.shadowColor = [UIColor blackColor];
    welcomeLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:welcomeLabel];
    
    CGRect infoLabelRect = CGRectInset(contentView.bounds, 5, 5);
    infoLabelRect.origin.y = CGRectGetMaxY(welcomeLabelRect)+5;
    infoLabelRect.size.height -= CGRectGetMinY(infoLabelRect);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.text =text;
    infoLabel.numberOfLines = 6;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.shadowColor = [UIColor blackColor];
    infoLabel.shadowOffset = CGSizeMake(0, 1);
    [contentView addSubview:infoLabel];
    
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}


- (IBAction)showHelp
{
    KZHelpViewController * hvc = [[KZHelpViewController alloc] initWithNibName:@"KZHelpViewController" bundle:nil];
    [[KGModal sharedInstance] showWithContentView:hvc.view];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionView didSelectItemAtIndexPath");
    if (_floatingMenu && _floatingMenu.isVisible == YES) {
        return;
    }
    NSDictionary * itm = [_shareFileFoldersAndFiles objectAtIndex:indexPath.row];
    if ([[itm objectForKey:@"type"] isEqualToString:@"folder"]) {
        KZShareFileController *fsc = [[KZShareFileController alloc] initWithNibName:@"KZShareFileController" bundle:nil];
        NSString * selectedFolder = [itm objectForKey:@"filename"];
        [fsc setShareFilePath:[NSString stringWithFormat:@"%@%@/",_shareFilePath, selectedFolder]];
        [[ThisApp navigatorController] pushViewController:fsc animated:YES];
    }
    else {
        NSString * labelText = [NSString stringWithFormat:@"Display name: %@\nCreator: %@\nDate: %@\nParent Name: %@\n",
                                [itm objectForKey:@"displayname"],
                                [itm objectForKey:@"creatorname"],
                                [itm objectForKey:@"creationdate"],
                                [itm objectForKey:@"parentname"]];
        
        [self showInformation:labelText];

    }
}

#pragma mark - TileMenu delegate


- (NSInteger)numberOfTilesInMenu:(MGTileMenuController *)tileMenu
{
	return 4;
}


- (UIImage *)imageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *images = [NSArray arrayWithObjects:
					   @"Email",
					   @"Share",
					   @"Search",
                       @"Pocket",
					   nil];
	if (tileNumber >= 0 && tileNumber < images.count) {
		return [UIImage imageNamed:[images objectAtIndex:tileNumber]];
	}
	
	return [UIImage imageNamed:@"Text"];
}


- (NSString *)labelForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *labels = [NSArray arrayWithObjects:
					   @"Email",
					   @"Salesforce",
                       @"Details",
                       @"Download",
					   nil];
	if (tileNumber >= 0 && tileNumber < labels.count) {
		return [labels objectAtIndex:tileNumber];
	}
	
	return @"Tile";
}


- (NSString *)descriptionForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *hints = [NSArray arrayWithObjects:
                      @"Email link",
                      @"Assign",
                      @"Details",
                      @"Download",
                      nil];
	if (tileNumber >= 0 && tileNumber < hints.count) {
		return [hints objectAtIndex:tileNumber];
	}
	
	return @"It's a tile button!";
}


- (UIImage *)backgroundImageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	return [UIImage imageNamed:@"grey_gradient@2x"];
}


- (BOOL)isTileEnabled:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	return YES;
}


- (void)tileMenu:(MGTileMenuController *)tileMenu didActivateTile:(NSInteger)tileNumber
{
	NSLog(@"Tile %d activated (%@)", tileNumber, [self labelForTile:tileNumber inMenu:_floatingMenu]);
    switch (tileNumber) {
        case 0:
            [self sendEmail:nil];
            break;
        case 1: // Show Leads
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            KZSalesForceLeadsController * svc = (KZSalesForceLeadsController *) [[ThisApp menuController] leftViewController];
            NSString * filename = [[_shareFileFoldersAndFiles objectAtIndex:_selectedIndexPath.row] objectForKey:@"filename"];
            NSString * fileid = [[_shareFileFoldersAndFiles objectAtIndex:_selectedIndexPath.row] objectForKey:@"id"];
            [[KidoZen sharedApplication] getFileLinkUsingFileId:fileid andPath:self.shareFilePath withBlock:^(id fileurl) {
                [svc setFileSelected:filename];
                [svc setFileUrl:fileurl];
                [[ThisApp menuController] showLeftController:YES];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }];

            break;
        }
        case 2:
            [self showOwners];
            break;
        case 3:
            [self openFile];
            break;
        default:
            break;
    }
}


- (void)tileMenuDidDismiss:(MGTileMenuController *)tileMenu
{
	_floatingMenu = nil;
}


#pragma mark - Gesture handling


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // Ensure ... ??
	if (TRUE == YES) {
		return YES;
	}	
	return NO;
}

- (void)tapPressHandler:(UITapGestureRecognizer *) sender {
            NSLog(@"tapPressHandler.");
    CGPoint loc = [sender locationInView:self.view];
    if (_floatingMenu && _floatingMenu.isVisible == YES) {
        // Only dismiss if the tap wasn't inside the tile menu itself.
        if (!CGRectContainsPoint(_floatingMenu.view.frame, loc)) {
            [_floatingMenu dismissMenu];
        }
    }
}

- (void)longPressHandler:(UILongPressGestureRecognizer *) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //
        CGPoint touchPoint = [sender locationInView:self.collectionView];
        self.selectedIndexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];
        //
        CGPoint loc = [sender locationInView:self.view];
        if (!_floatingMenu || _floatingMenu.isVisible == NO) {
            if (!_floatingMenu) {
                _floatingMenu = [[MGTileMenuController alloc] initWithDelegate:self];
                _floatingMenu.dismissAfterTileActivated = NO; // to make it easier to play with in the demo app.
            }
            [_floatingMenu displayMenuCenteredOnPoint:loc inView:self.view];
        }
    }
}

-(void)sendEmail:(NSString *) mail
{
    [MKEntryPanel showPanelWithTitle:NSLocalizedString(@"Enter the email Address", @"") inView:self.view onTextEntered:^(NSString* email) {
        NSString * fileid = [[_shareFileFoldersAndFiles objectAtIndex:_selectedIndexPath.row] objectForKey:@"id"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [[KidoZen sharedApplication] getFileLinkUsingFileId:fileid andPath:self.shareFilePath withBlock:^(id message) {
            [[KidoZen sharedApplication] sendToEmail:email fileUrl:message withBlock:^(id message) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }];
        }];
    }];
}

-(void) openFile
{
    NSString * fileid = [[_shareFileFoldersAndFiles objectAtIndex:_selectedIndexPath.row] objectForKey:@"id"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[KidoZen sharedApplication] getFileLinkUsingFileId:fileid andPath:self.shareFilePath withBlock:^(id message) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_floatingMenu dismissMenu];
        KZBrowserController *bc = [[KZBrowserController alloc] initWithNibName:@"KZBrowserController" bundle:nil];
        [bc setFileUrl:message];
        [[ThisApp navigatorController] pushViewController:bc animated:YES];
        
    }];
}

-(void)showOwners
{
    NSString * filename = [[_shareFileFoldersAndFiles objectAtIndex:_selectedIndexPath.row] objectForKey:@"filename"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[KidoZen sharedApplication] getFileOwners:filename withBlock:^(id kidozenResponse) {
        NSMutableString * leads = [NSMutableString stringWithString:@""];
        BOOL hasleads =false;
        for (NSDictionary * itm in kidozenResponse) {
            hasleads = true;
            [leads appendString:[itm objectForKey:@"lead"]];
            [leads appendString:@"\n"];
            
        }
        if (!hasleads) {
            leads = [NSMutableString stringWithString:@"No leads related"];
        }
        [self showInformation:leads];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


@end
