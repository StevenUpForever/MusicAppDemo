//
//  FetchWebData.m
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/17.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import "FetchWebData.h"
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
@implementation FetchWebData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.resourceArray = [[NSMutableArray alloc]initWithObjects:@"https://itunes.apple.com/us/rss/topsongs/limit=25/json",
                              @"https://itunes.apple.com/us/rss/topmovies/limit=25/genre=4401/json",
                              @"https://itunes.apple.com/us/rss/topfreeebooks/limit=25/json",
                              @"https://itunes.apple.com/us/rss/topmusicvideos/limit=25/json",
                              @"https://itunes.apple.com/us/rss/toppodcasts/limit=25/json",
                              @"https://itunes.apple.com/us/rss/topfreeapplications/limit=25/json",
                              @"https://itunes.apple.com/us/rss/topaudiobooks/limit=25/json",
                              @"https://itunes.apple.com/us/rss/toptvepisodes/limit=25/genre=4003/json",
                              @"https://itunes.apple.com/us/rss/topitunesucollections/limit=25/json",
                              nil];
        self.titleArray = [[NSMutableArray alloc]initWithObjects:@"Top Songs", @"Top Movies", @"Top eBooks", @"Top Music Videos", @"Top podcasts", @"Top Apps", @"Top AudioBooks", @"Top Episodes", @"Top iTunesU", nil];
    }
    return self;
}

- (void)fetchMainData: (NSInteger)index
{
    self.dataArray = [[NSMutableArray alloc]init];
    self.imageArray = [[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:[self.resourceArray objectAtIndex:index] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary *responseObject) {
        NSDictionary *feed = [responseObject objectForKey:@"feed"];
        NSArray *entry = [feed objectForKey:@"entry"];
        for (NSDictionary *data in entry)
        {
            [self.dataArray addObject:[data valueForKeyPath:@"title.label"]];
            NSArray *imageArray = [data objectForKey:@"im:image"];
            NSString *imageDetail = [imageArray[1] objectForKey:@"label"];
            NSURL *url = [NSURL URLWithString:imageDetail];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            [self.imageArray addObject:image];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mainTableViewReload" object:self];
    }
         failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
             NSLog(@"%@", [error description]);
         }];
}

- (void)fetchDetailData: (NSInteger)index
{
    self.bigImage = [[NSMutableArray alloc]init];
    self.albumName = [[NSMutableArray alloc]init];
    self.artist = [[NSMutableArray alloc]init];
    self.releaseDate = [[NSMutableArray alloc]init];
    self.price = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:[self.resourceArray objectAtIndex:index] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *feed = [responseObject objectForKey:@"feed"];
        NSArray *entry = [feed objectForKey:@"entry"];
        for (NSDictionary *data in entry)
        {
            [self.albumName addObject:[data valueForKeyPath:@"im:name.label"]];
            [self.price addObject:[data valueForKeyPath:@"im:price.label"]];
            [self.artist addObject:[data valueForKeyPath:@"im:artist.label"]];
            [self.releaseDate addObject:[data valueForKeyPath:@"im:releaseDate.attributes.label"]];
            NSArray *imageArray = [data objectForKey:@"im:image"];
            NSString *bigImageDetail = [imageArray[2] objectForKey:@"label"];
            NSURL *bigUrl = [NSURL URLWithString:bigImageDetail];
            NSData *bigData = [NSData dataWithContentsOfURL:bigUrl];
            UIImage *bigImage = [UIImage imageWithData:bigData];
            [self.bigImage addObject:bigImage];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"detailReload" object:self];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", [error description]);
    }];
}

- (void)fetchMediaData: (NSInteger)index
{
    self.media = [[NSMutableArray alloc]init];
    self.webpage = [[NSMutableArray alloc]init];

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:[self.resourceArray objectAtIndex:index] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *feed = [responseObject objectForKey:@"feed"];
        NSArray *entry = [feed objectForKey:@"entry"];
        for (NSDictionary *data in entry)
        {
            NSString *webStrOriginal = [data valueForKeyPath:@"im:name.label"];
            NSString *webStrResult = [webStrOriginal stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            [self.webpage addObject:webStrResult];
            NSArray *audioArray = [data objectForKey:@"link"];
            NSDictionary *audiolink = [audioArray[1] objectForKey:@"attributes"];
            NSString *href = [audiolink objectForKey:@"href"];
            [self.media addObject:href];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"mediaViewLoad" object:self];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", [error description]);
    }];
}

- (void)fetchTextData: (NSInteger)index
{
    self.summary = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager GET:[self.resourceArray objectAtIndex:index] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *feed = [responseObject objectForKey:@"feed"];
        NSArray *entry = [feed objectForKey:@"entry"];
        for (NSDictionary *data in entry)
        {
            NSString *summaryStr = [data valueForKeyPath:@"summary.label"];
            if (!summaryStr) {
                summaryStr = @"Null";
            }
            [self.summary addObject:summaryStr];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"textViewLoad" object:self];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@", [error description]);
    }];
}


@end
