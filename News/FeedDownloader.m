//
//  FeedDownloader.m
//  News
//
//  Created by KASEY MOFFAT on 3/15/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import "FeedDownloader.h"

@implementation FeedDownloader

- (void)start
{
    NSString *urlString = [NSString stringWithFormat:@"http://feed-watch-api.appspot.com/?url=%@", self.feedURL];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                     {
                                         if (!error) {
                                             NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                             NSLog(@"feed: %@", d);
                                             if (self.completionHandler) {
                                                 self.completionHandler(d);
                                             }
                                         } else {
                                             NSLog(@"error: %@", error.description);
                                         }
                                     }];
    [sessionTask resume];
}

@end
