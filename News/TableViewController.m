//
//  ViewController.m
//  News
//
//  Created by KASEY MOFFAT on 3/15/15.
//  Copyright (c) 2015 KASEY MOFFAT. All rights reserved.
//
// Grid view credit to https://github.com/ashfurrow/AFTabledCollectionView

#import "TableViewController.h"
#import "TableViewCell.h"
#import "FeedDownloader.h"
#import "ImageDownloader.h"
#import "CollectionViewCell.h"

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic, strong) NSMutableDictionary *imageCache;
@property (nonatomic, strong) NSArray *urls;

@end

@implementation TableViewController

-(void)loadView
{
    [super loadView];
    
    self.urls = @[@"http://radaronline.com/feed/",
                      @"http://recode.net/feed/",
                      @"http://www.californiagoldenblogs.com/rss/current",
                      @"http://espn.go.com/blog/feed?blog=pac12",
                      @"http://techcrunch.com/feed",
                      @"http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml",
                      @"http://www.producthunt.com/feed",
                      @"https://news.ycombinator.com/rss",
                      @"http://www.fastcompany.com/rss.xml",
                      @"http://www.reddit.com/.rss",
                      @"http://pandodaily.com.feedsportal.com/c/35141/f/650422/index.rss",
                      @"http://parislemon.com/rss",
                      @"http://feeds.gawker.com/gizmodo/full",
                      @"http://www.vice.com/rss",
                      @"http://rss.slashdot.org/Slashdot/slashdot",
                      @"http://feeds.arstechnica.com/arstechnica/index/"];
    self.feedArray = [NSMutableArray arrayWithCapacity:self.urls.count];

    for (NSInteger tableViewRow = 0; tableViewRow < self.urls.count; tableViewRow++)
    {
        NSString *url = self.urls[tableViewRow];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tableViewRow inSection:0];
        [self downloadEntrySummariesForFeedWithUrl:url atIndexPath:indexPath];
    }
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
}

#pragma mark Async Feed Downloads and UI Updates
- (void)downloadEntrySummariesForFeedWithUrl:(NSString *)url atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"downloading feed: %@", url);
    Feed *feed = [[Feed alloc] init];
    feed.feed_link = url;
    self.feedArray[indexPath.row] = feed;
    [feed downloadEntrySummariesWithCompletion:^{
        [self updateUIForFeedAtIndexPath:indexPath];
        [self downloadImagesForFeed:feed atIndexPath:indexPath];
//        [self saveFeedData];
    }];
}

- (void)downloadImagesForFeed:(Feed *)feed atIndexPath:(NSIndexPath *)indexPath {
    for (NSInteger imageIndex = 0; imageIndex < feed.entry_images.count; imageIndex++) {
        [feed downloadEntryImageAtIndex:imageIndex withCompletion:^(NSData *imageData){
            if (!self.imageCache) {
                self.imageCache = [[NSMutableDictionary alloc] init];
            }
            NSLog(@"setting image for key: %@", feed.entry_images[imageIndex]);
            NSLog(@"imageData length: %lu", (unsigned long)imageData.length);
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                self.imageCache[feed.entry_images[imageIndex]] = [UIImage imageWithData:imageData];
                [self updateUIForFeedImageAtIndexPath:indexPath andImageIndex:imageIndex];
                Feed *feed = (Feed *)self.feedArray[indexPath.row];
                feed.entry_image_data[feed.entry_links[imageIndex]] = imageData;
//                [self saveImageData];
            }
        }];
    }
}

-(void)updateUIForFeedImageAtIndexPath:(NSIndexPath *)indexPath andImageIndex:(NSInteger) imageIndex {
    TableViewCell *cell = (TableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSIndexPath *collectionIndexPath = [NSIndexPath indexPathForRow:imageIndex inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.collectionView reloadItemsAtIndexPaths:@[collectionIndexPath]];
    });
}

-(void)updateUIForFeedAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    });
}

#pragma mark Data Persistance
-(void)saveFeedData {
    NSMutableArray *allFeeds = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.feedArray.count; index++) {
        Feed *feed = self.feedArray[index];
        NSDictionary *feedData = feed.raw_feed_data;
        if (feedData) {
            [allFeeds addObject:feedData];
        }
    }
    if (allFeeds.count == self.urls.count) {
        NSLog(@"saving feed data: %@", allFeeds);
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.news"];
        [defaults setObject:allFeeds forKey:@"allFeeds"];
    }
}

-(void)saveImageData {
    NSMutableArray *allImageData = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.feedArray.count; index++) {
        Feed *feed = self.feedArray[index];
        NSDictionary *feedImageData = feed.entry_image_data;
        if (feedImageData) {
            [allImageData addObject:feedImageData];
        }
    }
    NSLog(@"saving image data");
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.news"];
    [defaults setObject:allImageData forKey:@"allImageData"];
}

#pragma mark View Life Cycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedArray.count;
//    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(TableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self index:indexPath.row];
    NSInteger index = cell.collectionView.tag;
    
    CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.feedArray.count;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return NULL;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 20;
//}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Feed *feed = self.feedArray[collectionView.tag];
    return feed.entry_titles.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    Feed *feed = self.feedArray[collectionView.tag];

    CollectionViewCell *collectionCell = (CollectionViewCell *)cell;
    [collectionCell updateTitleLabel:feed.entry_titles[indexPath.row]];
    UIImage *cachedImage = self.imageCache[feed.entry_images[indexPath.row]];
    if (cachedImage) {
        NSLog(@"getting image from cache");
        collectionCell.imageView.image = cachedImage;
    } else {
        collectionCell.imageView.image = [UIImage imageWithData:feed.entry_image_data[feed.entry_links[indexPath.row]]];
    }
//    collectionCell.imageView.image = [UIImage imageWithData:feed.entry_image_data[feed.entry_links[indexPath.row]]];
    return cell;
}

-(UIImage *)resizeImage:(NSData *)imageData {
    UIImage *image = [UIImage imageWithData:imageData];
    CGSize itemSize = CGSizeMake(150, 150);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    NSInteger index = collectionView.tag;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}

@end
