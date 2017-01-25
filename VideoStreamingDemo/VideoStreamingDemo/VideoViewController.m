//
//  ViewController.m
//  VideoStreamingDemo
//
//  Created by Sachin Patil on 20/01/17.
//  Copyright © 2017 Cuelogic Technologies. All rights reserved.
//

#import "VideoViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface VideoViewController () <GUIPlayerViewDelegate,IMAAdsLoaderDelegate,IMAAdsManagerDelegate>

@property (nonatomic, strong) GUIPlayerView* player;
@property (nonatomic, strong) IBOutlet UIView* playerView;
@property (nonatomic, strong) IBOutlet UITableView* tblView;
@property (nonatomic, strong) IMAAdsLoader *adsLoader;

@property(nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;
@property(nonatomic, strong) IMAAdsManager *adsManager;
@property(nonatomic, strong) IMACompanionAdSlot *companionSlot;


@end

@implementation VideoViewController

NSArray *videoArray;

@synthesize videoListDict;

NSString *const kTestAppAdTagUrl =
@"https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&"
@"iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&"
@"gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&"
@"cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator=";


#pragma mark -
#pragma mark ==============================
#pragma mark Memory Management
#pragma mark ==============================

- (void)didReceiveMemoryWarning {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark ==============================
#pragma mark View Life Cycle
#pragma mark ==============================

- (void)viewDidLoad {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    [super viewDidLoad];
    
    [self addPlayer];
    
    [self setUpContentPlayer];
    [self setupAdsLoader];
    [self requestAds];
    
    [self readPlistFile];
}

#pragma mark -
#pragma mark ==============================
#pragma mark
#pragma mark ==============================

- (void) readPlistFile {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"VideoData" ofType:@"plist"];
    NSDictionary *contentDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    videoArray = [NSArray arrayWithObject:[contentDict valueForKey:@"iOS"]][0];
    //videoArray = [NSArray arrayWithObject:[contentDict objectForKey:@"iOS"]];
    [_tblView reloadData];
}

#pragma mark -
#pragma mark ==============================
#pragma mark Private Methods
#pragma mark ==============================

- (void) addPlayer {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    
    self.player = [[GUIPlayerView alloc] initWithFrame:CGRectMake(0,50, self.playerView.frame.size.width, self.playerView.frame.size.height)];
    [self.player setDelegate:self];
    [self.view addSubview:self.player];
    NSURL *URL1 = [NSURL URLWithString:@"http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4"];
    //NSURL *URL2 = [NSURL URLWithString:@"http://techslides.com/demos/sample-videos/small.mp4"];
    //NSURL *URL3 = [NSURL URLWithString:@"https://youtu.be/71SbR2w3LP4"];
    //NSURL *URL4 = [NSURL URLWithString:@"http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4"];
    [self.player setVideoURL:URL1];
    
    [self.player prepareAndPlayAutomatically:NO];
    [self.view bringSubviewToFront:self.player];
    
    //[self requestAds];
}

- (void)playerWillEnterFullscreen {
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)playerWillLeaveFullscreen {
    [[self navigationController] setNavigationBarHidden:NO];
}

- (void)playerDidEndPlaying {
    [self.adsLoader contentComplete];
}

- (void)playerFailedToPlayToEnd {
    NSLog(@"Error: could not play video");
    [self.player clean];
}

#pragma mark -
#pragma mark ==============================
#pragma mark Setup Ads
#pragma mark ==============================

- (void)setupAdsLoader {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    // Re-use this IMAAdsLoader instance for the entire lifecycle of your app.
    self.adsLoader = [[IMAAdsLoader alloc] initWithSettings:nil];
    // NOTE: This line will cause a warning until the next step, "Get the Ads Manager".
    self.adsLoader.delegate = self;
}

- (void)requestAds {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    // Create an ad display container for ad rendering.
    IMAAdDisplayContainer *adDisplayContainer =
    [[IMAAdDisplayContainer alloc] initWithAdContainer:self.player companionSlots:nil];
    // Create an ad request with our ad tag, display container, and optional user context.
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:kTestAppAdTagUrl
                                                  adDisplayContainer:adDisplayContainer
                                                     contentPlayhead:self.contentPlayhead
                                                         userContext:nil];
    [self.adsLoader requestAdsWithRequest:request];
}

- (void)setUpContentPlayer {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    // Set up our content playhead and contentComplete callback.
    self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.player.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.player.currentItem];
}

- (void)contentDidFinishPlaying:(NSNotification *)notification {
    // Make sure we don't call contentComplete as a result of an ad completing.
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    if (notification.object == self.player.player.currentItem) {
        // NOTE: This line will cause an error until the next step, "Request Ads".
        [self.adsLoader contentComplete];
    }
}

#pragma mark -
#pragma mark ==============================
#pragma mark IMAAdsLoaderDelegate
#pragma mark ==============================

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
    self.adsManager = adsLoadedData.adsManager;
    
    // NOTE: This line will cause a warning until the next step, "Display Ads".
    self.adsManager.delegate = self;
    
    // Create ads rendering settings and tell the SDK to use the in-app browser.
    IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
    adsRenderingSettings.webOpenerPresentingController = self;
    
    // Initialize the ads manager.
    [self.adsManager initializeWithAdsRenderingSettings:adsRenderingSettings];
}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    // Something went wrong loading ads. Log the error and play the content.
    NSLog(@"Error loading ads: %@", adErrorData.adError.message);
    //[self.player play];
}


#pragma mark -
#pragma mark ==============================
#pragma mark IMAAdsManagerDelegate
#pragma mark ==============================

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    if (event.type == kIMAAdEvent_LOADED) {
        // When the SDK notifies us that ads have been loaded, play them.
        [adsManager start];
    }
    
    if (event.type == kIMAAdEvent_COMPLETE) {
        NSLog( @"event.type == kIMAAdEvent_COMPLETE");
        
    }
}

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    // Something went wrong with the ads manager after ads were loaded. Log the error and play the content.
    NSLog(@"AdsManager error: %@", error.message);
    [self.player play];
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    // The SDK is going to play ads, so pause the content.
    [self.player pause];
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    // The SDK is done playing ads (at least for now), so resume the content.
    [self.player play];
}

#pragma mark -
#pragma mark ==============================
#pragma mark TableViewDelegates
#pragma mark ==============================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    return videoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell"];
    cell.clipsToBounds =YES;
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(VideoTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    NSArray *videoDataArr = videoArray[indexPath.row];
   // NSDictionary *videoDict =
//    cell.lblDetails = [videoDict valueForKey:@"videoDetails"];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[videoDict objectForKey:@"videoUrl"]]
//                 placeholderImage:[UIImage imageNamed:@""]
//                          options:SDWebImageRefreshCached];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog( @"<%d - (%s)>", __LINE__, __FUNCTION__);
    NSString *categoryName = @"Android";
    return categoryName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

@end
