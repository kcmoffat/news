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
        NSLog(@"finished download");
        [self readFromDictionary:feedData];
        if (completion) {
            completion();
        }
    };
    [downloader start];
}

-(void)readFromDictionary:(NSDictionary *)d {
    NSDictionary *feed = d[@"feed"];
    self.title = feed[@"feed_title"];
    self.entry_links = feed[@"entry_links"];
    self.entry_titles = feed[@"entry_titles"];
    self.entry_images = feed[@"entry_images"];
    self.entry_image_data = [[NSMutableDictionary alloc] init];
}
@end
