//
//  FeedDownloader.h
//  News
//
//  Created by KASEY MOFFAT on 3/15/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"

@interface FeedDownloader : NSObject

@property (nonatomic, copy) NSString *feedURL;
@property (nonatomic, copy) void (^completionHandler)(NSDictionary *);
- (void)start;

@end
