//
//  GalleryCollectionViewCell.h
//  MachineTestDemo
//
//  Created by Sachin Patil on 21/08/15.
//  Copyright (c) 2015 Sachin Patil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailView.h"

@interface GalleryCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)IBOutlet ThumbnailView *thumbnailView;

@end
