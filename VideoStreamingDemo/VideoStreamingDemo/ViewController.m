//
//  ViewController.m
//  MachineTestDemo
//
//  Created by Sachin Patil on 21/08/15.
//  Copyright (c) 2015 Sachin Patil. All rights reserved.
//

#import "ViewController.h"
#import "Constant.h"
#import "VideoPagerViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "VideoViewController.h"


#define URL_PATH @"/imageData.php"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray *allImageData;
    NSDictionary *videoData;
    GalleryTableViewCell *protoTypeCell;
    ImageInfo *iInfo;
}

#pragma mark -
#pragma mark ==============================
#pragma mark View Life cycle
#pragma mark ==============================


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    [self readPlistFile];
    [self setUpPagerView];
    [self setPageIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) readPlistFile {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"VideoData" ofType:@"plist"];
    videoData = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [tblView reloadData];
}

#pragma mark -
#pragma mark ==============================
#pragma mark Status Bar
#pragma mark ==============================

-(void) setStatusBarHidden
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark ==============================
#pragma mark Private Functions
#pragma mark ==============================


#pragma mark -
#pragma mark ==============================
#pragma mark PrototypeCell
#pragma mark ==============================

- (GalleryTableViewCell *)protoTypeCell
{
    if (!protoTypeCell) {
        protoTypeCell = [tblView dequeueReusableCellWithIdentifier:@"GalleryTableViewCell"];
    }
    return protoTypeCell;
}


- (void)configureCell:(GalleryTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    NSString *title = videoData.allKeys[indexPath.row];
    NSArray *categorydata = [[NSArray alloc]initWithArray:(NSArray *)[videoData objectForKey:title]];
    cell.delegate = self;
    [cell addImages:categorydata];
    
}

-(void)setUpPagerView {
    
    [ImageSliderCollection registerNib:[UINib nibWithNibName:@"VideoPagerCell" bundle:nil]  forCellWithReuseIdentifier:@"VideoCell"];
    ImageSliderCollection.showsHorizontalScrollIndicator = NO;
    [ImageSliderCollection setPagingEnabled:YES];
    
}

-(void)setPageIndicator {
    [pageControl setNumberOfPages:4];
    [pageControl setCurrentPage:0];
}


-(void) galleryTableViewOnImageSelected:(ImageInfo *)imageInfo
{
    DebugLog(@"");
    iInfo = imageInfo;
    [self performSegueWithIdentifier:@"VideoViewController" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"VideoViewController"]) {
        VideoViewController *videoViewController = segue.destinationViewController;
        videoViewController.imageInfo = iInfo;
    }
}

#pragma mark -
#pragma mark ==============================
#pragma mark TableViewDelegates
#pragma mark ==============================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DebugLog(@"");
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    DebugLog(@"");
    return videoData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"");
    DebugLog(@"Row: %ld",(long)indexPath.row);
    GalleryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GalleryTableViewCell"];
    cell.clipsToBounds =YES;

    if(indexPath.section == 0){
        NSString *title = videoData.allKeys[0];
        NSArray *categorydata = [[NSArray alloc]initWithArray:(NSArray *)[videoData objectForKey:title]];
        cell.delegate = self;
        [cell addImages:categorydata];
        
    }else if (indexPath.section == 1) {
        NSString *title = videoData.allKeys[1];
        NSArray *categorydata = [[NSArray alloc]initWithArray:(NSArray *)[videoData objectForKey:title]];
        cell.delegate = self;
        [cell addImages:categorydata];
        
    }else if (indexPath.section == 2){
        NSString *title = videoData.allKeys[2];
        NSArray *categorydata = [[NSArray alloc]initWithArray:(NSArray *)[videoData objectForKey:title]];
        cell.delegate = self;
        [cell addImages:categorydata];
        
    }
    
    //[self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    DebugLog(@"");
    NSString *categoryName = videoData.allKeys[section];
    return categoryName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

#pragma mark -
#pragma mark ==============================
#pragma mark CollectionViewDatasource
#pragma mark ==============================

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoPagerViewCell *cell = [ImageSliderCollection dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    NSString *title = videoData.allKeys[2];
    NSArray *categorydata = [[NSArray alloc]initWithArray:(NSArray *)[videoData objectForKey:title]];
    NSDictionary *imgInfo = categorydata[indexPath.row];
    NSURL *imgURL = [NSURL URLWithString: [imgInfo objectForKey:@"imageUrl"]];
    [cell.imageView sd_setImageWithURL:imgURL
                    placeholderImage:[UIImage imageNamed:@""]
                             options:SDWebImageRefreshCached];

    return  cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20; // This is the minimum inter item spacing, can be more
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    iInfo = nil;
    [self performSegueWithIdentifier:@"VideoViewController" sender:self];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage  = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    [pageControl setCurrentPage: currentPage];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

-(void)willDisplayCell {
    
}


@end
