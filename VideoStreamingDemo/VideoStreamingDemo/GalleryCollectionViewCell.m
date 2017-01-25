//
//  GalleryCollectionViewCell.m
//  MachineTestDemo
//
//  Created by Sachin Patil on 21/08/15.
//  Copyright (c) 2015 Sachin Patil. All rights reserved.
//

#import "GalleryCollectionViewCell.h"

@implementation GalleryCollectionViewCell
@synthesize thumbnailView;

-(void)awakeFromNib
{
    thumbnailView.layer.cornerRadius = 5.0f;
    thumbnailView.clipsToBounds = YES;
}

@end
