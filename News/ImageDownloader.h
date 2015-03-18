//
//  ImageDownloader.h
//  News
//
//  Created by KASEY MOFFAT on 3/15/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) void (^completionHandler)(NSData *);
- (void)start;

@end
