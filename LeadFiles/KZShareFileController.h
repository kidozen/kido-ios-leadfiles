//
//  KZShareFileController.h
//  LeadFiles
//
//  Created by Christian Carnero on 5/2/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZShareFileLayout.h"
#import "MGTileMenuController.h"

@interface KZShareFileController : UICollectionViewController <UICollectionViewDataSource,UICollectionViewDelegate, MGTileMenuDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet KZShareFileLayout *shareFileLayout;
@property (nonatomic, strong) NSMutableArray *filesAndFolders;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@property (nonatomic, strong) MGTileMenuController * floatingMenu;

@property (atomic, strong) NSString * shareFilePath;
@property (atomic, strong) NSMutableArray * shareFileFoldersAndFiles;
@property (atomic, strong) NSIndexPath * selectedIndexPath;
//@property (nonatomic, strong) NSString * selectedLead;
@end
