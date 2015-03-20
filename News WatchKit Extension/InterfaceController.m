//
//  InterfaceController.m
//  News WatchKit Extension
//
//  Created by KASEY MOFFAT on 3/17/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.news"];
    NSLog(@"feedData: %@", [defaults objectForKey:@"allFeeds"]);
    NSLog(@"imageFeedData count: %lu", (unsigned long)[[defaults objectForKey:@"allFeeds"] count]);
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



