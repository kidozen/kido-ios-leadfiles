//
//  KZShareFileCell.h
//  LeadFiles
//
//  Created by Christian Carnero on 5/2/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZShareFileCell : UICollectionViewCell

@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UILabel * uiLabel;

@property (nonatomic, strong, readwrite) NSMutableArray * shareFileObject;

@end
