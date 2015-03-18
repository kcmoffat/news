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
@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation TableViewController

-(void)loadView
{
    [super loadView];
    
    NSArray *urls = @[@"http://techcrunch.com/feed",
                      @"http://www.californiagoldenblogs.com/rss/current",
                      @"http://recode.net/feed/",
                      @"http://www.californiagoldenblogs.com/rss/current",
                      @"http://techcrunch.com/feed",
                      @"http://www.californiagoldenblogs.com/rss/current",
                      @"http://techcrunch.com/feed",
                      @"http://www.californiagoldenblogs.com/rss/current",
                      @"http://techcrunch.com/feed",
                      @"http://www.californiagoldenblogs.com/rss/current"];
    self.urls = [NSMutableArray arrayWithArray:urls];
    
    self.feedArray = [NSMutableArray arrayWithCapacity:urls.count];

    for (NSInteger tableViewRow = 0; tableViewRow < urls.count; tableViewRow++)
    {
        NSString *url = urls[tableViewRow];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tableViewRow inSection:0];
        [self downloadEntrySummariesForFeedWithUrl:url atIndexPath:indexPath];
    }
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
}

- (void)downloadEntrySummariesForFeedWithUrl:(NSString *)url atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"downloading feed: %@", url);
    Feed *feed = [[Feed alloc] init];
    feed.feed_link = url;
    self.feedArray[indexPath.row] = feed;
    [feed downloadEntrySummariesWithCompletion:^{
        [self updateUIForFeedAtIndexPath:indexPath];
        [self downloadImagesForFeed:feed atIndexPath:indexPath];
    }];
}

- (void)downloadImagesForFeed:(Feed *)feed atIndexPath:(NSIndexPath *)indexPath {
    for (NSInteger imageIndex = 0; imageIndex < feed.entry_images.count; imageIndex++) {
        ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.imageUrl = feed.entry_images[imageIndex];
        [imageDownloader setCompletionHandler:^(NSData *imageData) {
            ((Feed *)self.feedArray[indexPath.row]).entry_image_data[feed.entry_links[imageIndex]] = imageData;
            TableViewCell *cell = (TableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            NSIndexPath *collectionIndexPath = [NSIndexPath indexPathForRow:imageIndex inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.collectionView reloadItemsAtIndexPaths:@[collectionIndexPath]];
            });
        }];
        [imageDownloader start];
    }
}

-(void)updateUIForFeedAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    });
}

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
    [collectionCell.label setText:feed.entry_titles[indexPath.row]];
//    collectionCell.imageData = feed.entry_image_data[feed.entry_links[indexPath.row]];
    collectionCell.imageView.image = [UIImage imageWithData:feed.entry_image_data[feed.entry_links[indexPath.row]]];
    return cell;
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
