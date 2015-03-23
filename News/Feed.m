//
//  Feed.m
//  News
//
//  Created by KASEY MOFFAT on 3/15/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import "Feed.h"
#import "FeedDownloader.h"
#import "ImageDownloader.h"

@implementation Feed


- (void)downloadEntrySummariesWithCompletion:(void(^)(void))completion {
    FeedDownloader *downloader = [[FeedDownloader alloc] init];
    downloader.feedURL = self.feed_link;
    downloader.completionHandler = ^(NSDictionary *feedData) {
        [self readFromDictionary:feedData];
        if (completion) {
            completion();
        }
    };
    [downloader start];
}

- (void)downloadEntryImageAtIndex:(NSInteger)index withCompletion:(void (^)(NSData *imageData))completion {
    ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
    imageDownloader.imageUrl = self.entry_images[index];
    [imageDownloader setCompletionHandler:^(NSData *imageData) {
        if (completion) {
            completion(imageData);
        }
    }];
    [imageDownloader start];
}

-(void)readFromDictionary:(NSDictionary *)d {
    self.raw_feed_data = d;
    NSDictionary *feed = d[@"feed"];
    self.feed_title = feed[@"feed_title"];
    self.feed_icon = feed[@"feed_icon"];
    self.entry_links = feed[@"entry_links"];
    self.entry_titles = feed[@"entry_titles"];
    self.entry_images = feed[@"entry_images"];
    self.entry_descriptions = feed[@"entry_descriptions"];
    self.entry_image_data = [[NSMutableDictionary alloc] init];
}
@end
