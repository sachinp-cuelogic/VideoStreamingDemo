//
//  GalleryTableViewCell.h
//  MachineTestDemo
//
//  Created by Sachin Patil on 21/08/15.
//  Copyright (c) 2015 Sachin Patil. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoTableViewCellProtocol <NSObject>

@end

@interface VideoTableViewCell : UITableViewCell
{

}

@property(nonatomic, weak) id<VideoTableViewCellProtocol> delegate;
@property(nonatomic, strong) IBOutlet UIImageView *imgView;
@property(nonatomic, strong) IBOutlet UILabel *lblDetails;

@end
