//
//  GalleryTableViewCell.m
//  MachineTestDemo
//
//  Created by Sachin Patil on 21/08/15.
//  Copyright (c) 2015 Sachin Patil. All rights reserved.
//

#import "GalleryTableViewCell.h"
#import "Constant.h"
#import "SDWebImage/UIImageView+WebCache.h"



@implementation GalleryTableViewCell
{
    NSArray *arrImages;
}

@synthesize delegate;

#pragma mark -
#pragma mark ==============================
#pragma mark Init
#pragma mark ==============================


- (void)awakeFromNib {
    // Initialization code
}

#pragma mark -
#pragma mark ==============================
#pragma mark Public Functions
#pragma mark ==============================

-(void) addImages:(NSArray *) arrayImages{
    DebugLog(@"");
    arrImages = arrayImages;
    [galleryCollectionView reloadData];
}

#pragma mark -
#pragma mark ==============================
#pragma mark CollectionView Delegates/DataSource
#pragma mark ==============================

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    DebugLog(@"");
    return arrImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"");
   GalleryCollectionViewCell *galleryCell= [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *imgInfo = arrImages[indexPath.row];
    NSURL *imgURL = [NSURL URLWithString: [imgInfo objectForKey:@"imageUrl"]];
    [galleryCell.thumbnailView.thumbnailImageView sd_setImageWithURL:imgURL
                                                    placeholderImage:[UIImage imageNamed:@""]
                                                             options:SDWebImageRefreshCached];
    galleryCell.thumbnailView.lblDesc.text = [imgInfo objectForKey:@"videoDetails"];
    
    return galleryCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageInfo *imgInfo = arrImages[indexPath.row];
    [delegate galleryTableViewOnImageSelected:imgInfo];
}

@end
