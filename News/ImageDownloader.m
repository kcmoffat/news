//
//  ImageDownloader.m
//  News
//
//  Created by KASEY MOFFAT on 3/15/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

- (void)start
{
    NSString *urlString = [self.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                     {
                                         if (!error) {
                                             if (self.completionHandler) {
                                                 self.completionHandler(data);
                                             }
                                         } else {
                                             NSLog(@"error: %@", error.description);
                                         }
                                     }];
    [sessionTask resume];
}

@end
