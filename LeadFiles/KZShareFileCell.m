//
//  KZShareFileCell.m
//  LeadFiles
//
//  Created by Christian Carnero on 5/2/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import "KZShareFileCell.h"
#import <QuartzCore/QuartzCore.h>


@interface KZShareFileCell()
{
    UIImage * fileImage;
}
    
@end

@implementation KZShareFileCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize itemSize = self.bounds.size;
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];

        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowOpacity = 0.5f;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeTopLeft;
        self.imageView.clipsToBounds = YES;
        
        
        [self.contentView addSubview:self.imageView];

        int top = itemSize.height - 30;
        int width = itemSize.width;
        self.uiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, width, 40)];
        
        self.autoresizesSubviews = YES;
        self.uiLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight);
        self.uiLabel.font = [UIFont boldSystemFontOfSize:12];
        self.uiLabel.textAlignment = NSTextAlignmentCenter;
        self.uiLabel.backgroundColor = [UIColor clearColor];
        self.uiLabel.adjustsFontSizeToFitWidth = YES;

        [self addSubview:self.uiLabel];

    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.uiLabel = nil;
    self.imageView.image = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//}

@end
