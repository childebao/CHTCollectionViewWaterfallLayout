//
//  ViewController.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "ViewController.h"
#import "CHTCollectionViewWaterfallCell.h"

#define CELL_WIDTH 129
#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"

@interface ViewController()
@property (nonatomic, strong) NSMutableArray *cellHeights;
@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.cellWidth = CELL_WIDTH;        // Default if not setting runtime attribute
    }
    return self;
}

#pragma mark - Accessors
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];

        layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
        layout.delegate = self;

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

- (NSMutableArray *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray arrayWithCapacity:CELL_COUNT];
        for (NSInteger i = 0; i < CELL_COUNT; i++) {
            _cellHeights[i] = @(arc4random()%100*2+100);
        }
    }
    return _cellHeights;
}

#pragma mark - Life Cycle
- (void)dealloc
{
    [_collectionView removeFromSuperview];
    _collectionView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
    [self updateLayout];
}

- (void)updateLayout
{
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = self.collectionView.bounds.size.width / self.cellWidth;
    layout.itemWidth = self.cellWidth;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return CELL_COUNT;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                               forIndexPath:indexPath];

    cell.displayString = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeights[indexPath.item] floatValue];
}

@end
