//
//  DetailViewController.m
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/17.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import "DetailViewController.h"
#import "FetchWebData.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "CommentTableViewController.h"

static NSInteger likeNum, unlikeNum;

@interface DetailViewController ()<AVAudioPlayerDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;
@property (weak, nonatomic) IBOutlet UILabel *Price;

@property (nonatomic) FetchWebData *detailWebdata;
@property (nonatomic) MBProgressHUD *progress;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *unlikeCount;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *fastForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *rewindButton;

@property (nonatomic)AVAudioPlayer *audio;
@property (nonatomic)AVPlayer *movie;

@end
@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progress = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.progress];
    self.progress.labelText = @"Waiting for Data";
    [self.progress show:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.detailView.backgroundColor = [UIColor clearColor];
    
    self.detailWebdata = [[FetchWebData alloc]init];
    self.likeCount.text = [NSString stringWithFormat:@"%ld", likeNum];
    self.unlikeCount.text = [NSString stringWithFormat:@"%ld", unlikeNum];
    
    [self.detailWebdata fetchDetailData:self.dataIndex];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(detailReload) name:@"detailReload" object:nil];
    
    if (self.dataIndex == 0 || self.dataIndex == 1 || self.dataIndex == 3 || self.dataIndex == 6 || self.dataIndex == 7) {
        [self.detailWebdata fetchMediaData:self.dataIndex];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mediaViewLoad) name:@"mediaViewLoad" object:nil];
    }
    else if (self.dataIndex == 2 || self.dataIndex == 4 || self.dataIndex == 5 || self.dataIndex == 8)
    {
        [self mediaUtilityHide];
        
        [self.detailWebdata fetchTextData:self.dataIndex];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewLoad) name:@"textViewLoad" object:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.audio stop];
}

#pragma mark - common parts of detail view controller

- (void)detailReload
{
    [self.progress hide:YES];
    self.navigationItem.title = [self.detailWebdata.albumName objectAtIndex:self.detailIndex];
    self.detailImage.image = [self.detailWebdata.bigImage objectAtIndex:self.detailIndex];
    self.artist.text = [NSString stringWithFormat:@"Artist: %@", [self.detailWebdata.artist objectAtIndex:self.detailIndex]];
    self.releaseDate.text = [NSString stringWithFormat:@"Date: %@",[self.detailWebdata.releaseDate objectAtIndex:self.detailIndex]];
    self.Price.text = [NSString stringWithFormat:@"Price: %@", [self.detailWebdata.price objectAtIndex:self.detailIndex]];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"detailReload" object:nil];
}

- (IBAction)likeButton {
    likeNum += 1;
    self.likeCount.text = [NSString stringWithFormat:@"%ld", likeNum];
}

- (IBAction)unlikeButtion {
    unlikeNum += 1;
    self.unlikeCount.text = [NSString stringWithFormat:@"%ld", unlikeNum];
}

#pragma mark - media part of detail view controller

- (void)mediaViewLoad
{
    //Audio part
    if (self.dataIndex == 0 || self.dataIndex == 6) {
        NSURL *url = [NSURL URLWithString:[self.detailWebdata.media objectAtIndex:self.detailIndex]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.audio = [[AVAudioPlayer alloc]initWithData:data error:nil];
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        
        UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.detailView.frame), CGRectGetHeight(self.detailView.frame))];
        NSURL *webUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/#q=%@", [self.detailWebdata.webpage objectAtIndex:self.detailIndex]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:webUrl];
        [webview loadRequest:request];
        [self.detailView addSubview:webview];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"mediaViewLoad" object:nil];
        
        
    }
    
    //Video Part
    else if (self.dataIndex == 1 || self.dataIndex == 3 || self.dataIndex == 7)
    {
        NSURL *url = [NSURL URLWithString:[self.detailWebdata.media objectAtIndex:self.detailIndex]];
        self.movie = [[AVPlayer alloc]initWithURL:url];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.movie];
        playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.detailView.frame), CGRectGetHeight(self.detailView.frame));
        [self.detailView.layer addSublayer:playerLayer];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"mediaViewLoad" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.movie.currentItem];
        
    }
    
    [self sliderInitial];
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(sliderProcess) userInfo:nil repeats:YES];
    [self.mySlider addTarget:self action:@selector(audioTimeChange) forControlEvents:UIControlEventValueChanged];
}


- (void)sliderInitial
{
    self.mySlider.minimumTrackTintColor = [UIColor blueColor];
    self.mySlider.minimumValue = 0.0;
    self.mySlider.value = 0.0;
    if (self.dataIndex == 0 || self.dataIndex == 6)
    {
        self.mySlider.maximumValue = self.audio.duration;
    }
    else if (self.dataIndex == 1 || self.dataIndex == 3 || self.dataIndex == 7)
    {
        CMTime movieTime = self.movie.currentItem.asset.duration;
        self.mySlider.maximumValue = movieTime.value/movieTime.timescale;
    }
}

- (void)sliderProcess
{
    if (self.dataIndex == 0 || self.dataIndex == 6)
    {
        self.mySlider.value = self.audio.currentTime;
    }
    else if (self.dataIndex == 1 || self.dataIndex == 3 || self.dataIndex == 7)
    {
        CMTime movieTime = self.movie.currentTime;
        self.mySlider.value = movieTime.value/movieTime.timescale;
    }
    
}

- (void)audioTimeChange
{
    if (self.dataIndex == 0 || self.dataIndex == 6)
    {
        self.audio.currentTime = self.mySlider.value;
    }
    else if (self.dataIndex == 1 || self.dataIndex == 3 || self.dataIndex == 7)
    {
        [self.movie seekToTime:CMTimeMake(self.mySlider.value * 60, 60)];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

- (void)movieDidEnd
{
    [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.movie seekToTime:kCMTimeZero];
    
     [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.movie.currentItem];
}

- (IBAction)play:(id)sender {
    if (self.dataIndex == 0 || self.dataIndex == 6) {
        if ([self.audio isPlaying])
        {
            [self.audio pause];
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        }
        else{
            [self.audio play];
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    }
    else if (self.dataIndex == 1 || self.dataIndex == 3 || self.dataIndex == 7){
        if (self.movie.rate > 0 && !self.movie.error)
        {
            [self.movie pause];
            [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        }
        else{
            [self.movie play];
            [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    }
    
}

- (IBAction)rewind {
    if (self.dataIndex == 0 || self.dataIndex == 6) {
        self.mySlider.value -= self.mySlider.maximumValue/10;
        self.audio.currentTime -= self.audio.duration/10;
    }
    else if (self.dataIndex == 1 || self.dataIndex == 3 || self.dataIndex == 7)
    {
        self.mySlider.value -= self.mySlider.maximumValue/10;
        [self.movie seekToTime:CMTimeMake(self.mySlider.value * 60, 60)];

    }
}

- (IBAction)fastForward {
    if (self.dataIndex == 0 || self.dataIndex == 6) {
        self.mySlider.value += self.mySlider.maximumValue/10;
        self.audio.currentTime += self.audio.duration/10;
    }
    else if (self.dataIndex == 1 || self.dataIndex == 3 || self.dataIndex == 7)
    {
        self.mySlider.value += self.mySlider.maximumValue/10;
        [self.movie seekToTime:CMTimeMake(self.mySlider.value * 60, 60)];
    }
}

#pragma mark - text part of detail view controller

- (void)textViewLoad
{
    UITextView *textView = [[UITextView alloc]initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.detailView.frame), CGRectGetHeight(self.detailView.frame))];
    [self.detailView addSubview:textView];
    textView.text = [self.detailWebdata.summary objectAtIndex:self.detailIndex];
    textView.editable = NO;
    [textView setFont:[UIFont fontWithName:@"Arial" size:20]];
    textView.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"textViewLoad" object:nil];
}

- (void)mediaUtilityHide
{
    [self.mySlider removeFromSuperview];
    [self.playButton removeFromSuperview];
    [self.fastForwardButton removeFromSuperview];
    [self.rewindButton removeFromSuperview];
}

@end
