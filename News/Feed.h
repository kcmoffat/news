//
//  Feed.h
//  News
//
//  Created by KASEY MOFFAT on 3/15/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject
@property (copy, nonatomic) NSString *feed_link;
@property (copy, nonatomic) NSString *feed_icon;
@property (copy, nonatomic) NSString *feed_title;
@property (strong, nonatomic) NSArray *entry_titles;
@property (strong, nonatomic) NSArray *entry_images;
@property (strong, nonatomic) NSArray *entry_links;
@property (strong, nonatomic) NSArray *entry_descriptions;
@property (strong, nonatomic) NSMutableDictionary *entry_image_data;
@property (strong, nonatomic) NSDictionary *raw_feed_data;

- (void)downloadEntrySummariesWithCompletion:(void(^)(void))completion;
- (void)downloadEntryImageAtIndex:(NSInteger)index withCompletion:(void(^)(NSData *))completion;
- (void)readFromDictionary:(NSDictionary *)d;
@end
