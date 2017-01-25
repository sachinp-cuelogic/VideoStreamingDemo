//
//  GalleryTableViewCell.h
//  MachineTestDemo
//
//  Created by Sachin Patil on 21/08/15.
//  Copyright (c) 2015 Sachin Patil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryCollectionViewCell.h"
#import "ImageInfo.h"

@protocol GalleryTableViewCellProtocol <NSObject>
-(void) galleryTableViewOnImageSelected:(ImageInfo* ) imageInfo;
@end

@interface GalleryTableViewCell : UITableViewCell
{
    __weak IBOutlet UICollectionView *galleryCollectionView;
}

@property(nonatomic, weak) id<GalleryTableViewCellProtocol> delegate;

-(void) addImages:(NSArray *) arrayImages;

@end
