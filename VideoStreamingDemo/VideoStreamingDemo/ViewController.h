//
//  ViewController.h
//  MachineTestDemo
//
//  Created by Sachin Patil on 21/08/15.
//  Copyright (c) 2015 Sachin Patil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryTableViewCell.h"
#import "ImageCategoryData.h"


@interface ViewController : UIViewController<GalleryTableViewCellProtocol, UICollectionViewDelegate, UICollectionViewDataSource>
{
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UICollectionView *ImageSliderCollection;
    __weak IBOutlet UIPageControl *pageControl;
}

@end

