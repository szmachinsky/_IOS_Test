//
//  MasterViewController.m
//  test_nav_xib
//
//  Created by Sergei on 19.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Test1_VC.h"
#import "Test2_VC.h"
#import "Test3_VC.h"
#import "TstNew1_VC.h"
#import "TstNew2_VC.h"

#import "LoadFiles_VC.h"
#import "YandexTest_VC.h"



/*
#import <objc/runtime.h>
#import "iSmartObjectSwizzling.h"

@interface UIRefreshControl (test_swizz)
+ (void)load;
@end

static const char offsetForControl;

@implementation UIRefreshControl (test_swizz)

+ (void)load
{
    NSLog(@"\n\n --SWIZZLE-- for UIRefreshControl \n\n");
    [self swizzleInstanceMethod:self oldSelector:@selector(beginRefreshing) newSelector:@selector(ZS_beginRefreshing)];
    [self swizzleInstanceMethod:self oldSelector:@selector(endRefreshing) newSelector:@selector(ZS_endRefreshing)];
}

- (void)ZS_beginRefreshing
{
    UITableView *tableView = [self selfTableView];
    UIScrollView *s = tableView;
    float off = tableView.contentOffset.y;
//    float offStart = s.s
    NSNumber *val1 = [tableView valueForKey:@"startOffsetY"];
    NSNumber *val2 = [tableView valueForKey:@"lastUpdateOffsetY"];
    NSNumber *tim = [tableView valueForKey:@"contentOffsetAnimationDuration"];
    NSArray *a = [tableView valueForKey:@"animation"];
    
    NSLog(@"");
    NSLog(@" --SWIZZLE-- ZS_beginRefreshing offset.y=%f   of1=%.2f of2=%.2f tim=%.2f anim=%d  \n\n",off,[val1 floatValue],[val2 floatValue],[tim floatValue],a.count);
    objc_setAssociatedObject(self, &offsetForControl, @(off), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSLog(@" --offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
    NSLog(@" -------- super beginRefreshing--------");
    [self ZS_beginRefreshing];
    NSLog(@" --offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
}

- (void)ZS_endRefreshing
{
    UITableView *tableView = [self selfTableView];
    float off = [objc_getAssociatedObject(self, &offsetForControl) floatValue];
    
    NSLog(@"");
    NSLog(@" --SWIZZLE-- ZS_1-endRefreshing offset.y=%f  Off=%f\n\n",tableView.contentOffset.y,off);
    
    //    [[self selfTableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop
    //                                        animated:NO];
    //    NSLog(@"\n\n --SWIZZLE-- ZS_2-endRefreshing offset.y=%f\n\n",[self selfTableView].contentOffset.y);
    
    NSLog(@" --offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
    NSLog(@" -------- super endRefreshing -------");
    [self ZS_endRefreshing];
    NSLog(@" --offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset)); //zs1
    
//    if (fabs(off - tableView.contentOffset.y) > 1.0) {
//        NSLog(@" --SWIZZLE-- >>> change offset to = %f \n\n",off);
// //       UITableView *tableView = [self selfTableView];
//        CGPoint p = tableView.contentOffset;
//        p.y = off;
//        [tableView setContentOffset:p animated:YES];
//    }
    
//    CGPoint p1 = [tableView contentOffset];
//    UIEdgeInsets ins = [tableView  contentInset];
//    p1.y = - ins.top;
//    [tableView setContentOffset:p1 animated:YES];
    
    float time = 0.3;
    NSNumber *tim = [tableView valueForKey:@"contentOffsetAnimationDuration"];
    if (tim) {
        time = [tim floatValue];
    };
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self performSelector:@selector(correctOffset) withObject:nil afterDelay:time+0.05]; //0.3
    NSLog(@" --SWIZZLE-- ZS_2-endRefreshing offset.y=%f\n\n",tableView.contentOffset.y);
}

-(UITableView*)selfTableView
{
    UITableView *tableView;
    UIView* v = [self superview];
    if ([v isKindOfClass:[UITableView class]]) {
        tableView = (UITableView*)v;
    }
    return tableView;
}

-(void)correctOffset
{
@try
  {
    UITableView *tableView = [self selfTableView];
    if (!tableView)
        return;
    
    BOOL drgn = tableView.isDragging;
    BOOL dec = tableView.isDecelerating;
    
    CGPoint p = [tableView contentOffset];
    float offY = p.y;
    float insTop = tableView.contentInset.top;
    float sum = offY + insTop;
    
    NSLog(@".");
    NSLog(@" --SWIZZ-- ??? CHECK  correctOffset offset.y=%.3f  inset.top=%.3f  sum=%.3f / drgn=%d  decel=%d",offY,insTop,sum,drgn,dec);
    if ((fabsf(sum) > 10.0)&&(offY < 0.0))
    {
        p.y = (insTop>0.0)?(-insTop):0.0;  //- insTop;
        NSLog(@" --SWIZZ-- !!! CORRECT offset to:%f",p.y);
        [tableView setContentOffset:p animated:YES];
    }
    
  }
@finally
  {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
  }
}


@end

*/


@interface MasterViewController () {
    NSMutableArray *_objects;
    NSInteger def_rows;
}
@end

@implementation MasterViewController
{
    Test1_VC *vc1;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    def_rows = 6;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
//    NSLog(@"test - NSLog");
//    _NSLog(@"test - _NSLog");
//    _NSLog0(@"test - _NSLog0");
//    printf("test1 %d\n",def_rows);
//    printf("test2 %d\n",def_rows);
    
//    Class ALSdkClass = NSClassFromString(@"TstNew2_VC");
//    ALSdkClass = nil;
    
    BOOL b = self.navigationController.interactivePopGestureRecognizer.enabled;
    NSLog(@"\n viewDidLoad-end :%d++",b);
    b = NO;
    
}


-(void)configureRefresh
{
    self.refreshControl = [FX_UIRefreshControl new];
    
    [self.refreshControl addTarget:self action:@selector(doRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    
    
//    NSString *s = @"Refreshing table...";
//    NSMutableAttributedString* content = [[NSMutableAttributedString alloc] initWithString:s
//                                                                                attributes:
//                                          @{
//                                            NSFontAttributeName:
//                                                [UIFont fontWithName:@"Arial-BoldMT" size:15],
//                                            NSForegroundColorAttributeName:
//                                                [UIColor colorWithRed:0.251 green:0.000 blue:0.502 alpha:1]
//                                            }];
//    
//    NSRange r = [s rangeOfString:@"table"];
//    [content addAttributes:
//     @{
//       NSStrokeColorAttributeName:[UIColor redColor],
//       NSStrokeWidthAttributeName: @-2.0
//       } range:r];
//    self.refreshControl.attributedTitle = content;
    
    
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:s];
    
    self.refreshControl.tintColor = [UIColor redColor];
    //    self.refreshControl.backgroundColor = [UIColor yellowColor];
    //    [self.refreshControl endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@" -1-viewWillAppear-begin--");
    [super viewWillAppear:animated];

    void (*msg)(id,SEL) = (void(*)(id,SEL))objc_msgSend;
    SEL sel1 =  NSSelectorFromString(@"reloadData");
//  SEL sel2 = @selector(reloadData);
    msg(self.tableView,sel1);
    
////    dispatch_async(dispatch_get_main_queue(), ^{ //zs4
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^{
//        NSLog(@"\n -3!-viewWillAppear-end--");
//    [NSThread sleepForTimeInterval:2.0];
//        NSLog(@"\n -3!!!!-viewWillAppear-end--");
//        });

    
    BOOL b = self.navigationController.interactivePopGestureRecognizer.enabled;
    NSLog(@" -1-viewWillAppear-end :%d--",b);
    b = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@" +2+viewDidAppear-begin++");
    [super viewDidAppear:animated];
    
//    dispatch_async(dispatch_get_main_queue(), ^{ //zs4
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
    });
    
    BOOL b = self.navigationController.interactivePopGestureRecognizer.enabled;
    NSLog(@" +2+viewDidAppear-end :%d++",b);
    b = NO;
    
    id id1 = self;
    id id2 = self.navigationController.interactivePopGestureRecognizer.delegate;
    id id3 = self.navigationController;
    NSLog(@" 0))) self=(%p)  delegate=(%p)  nav=(%p)",id1,id2,id3);
    id1 = id2;
    

    NSLog(@" DID APPEAR_1 offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    [self configureRefresh];
    
    NSLog(@" DID APPEAR_2 offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    b=NO;
}


//-(void)viewWillLayoutSubviews
//{
//    NSLog(@"\n =1=viewWillLayoutSubviews-begin==");
//    [super viewWillLayoutSubviews];
////    dispatch_async(dispatch_get_main_queue(), ^{ //zs4
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^{
//        NSLog(@"\n =3!=viewWillLayoutSubviews-end==");
//    [NSThread sleepForTimeInterval:1.0];
//        NSLog(@"\n =3!!!!=viewWillLayoutSubviews-end==");
//    });
//    NSLog(@"\n =1=viewWillLayoutSubviews-end==");
//}
//
//-(void)viewDidLayoutSubviews
//{
//    NSLog(@"\n =2=viewDidLayoutSubviews-begin==");
//   [super viewDidLayoutSubviews];
////    dispatch_async(dispatch_get_main_queue(), ^{ //zs4
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^{
//        NSLog(@"\n =3!=viewDidLayoutSubviews-end==");
//    [NSThread sleepForTimeInterval:1.0];
//        NSLog(@"\n =3!!!!=viewDidLayoutSubviews-end==");
//    });
//    NSLog(@"\n =2=viewDidLayoutSubviews-end==");
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSInteger col = _objects.count; //0
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
//    [_objects insertObject:[NSDate date] atIndex:0];
    [_objects addObject:[NSDate date]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:def_rows+col inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];//UITableViewRowAnimationAutomatic];
//    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger col = def_rows + _objects.count;
//    NSLog(@"row count = %ld",(long)col);
    return (def_rows + _objects.count);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"...";

    NSDate *object;
    NSInteger ind = indexPath.row;
    NSLog(@">>got cell_%ld",(long)ind);
    switch (ind) {
        case 0:
            cell.textLabel.text = @"Test1_VC - Dealloc";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
        case 1:
            cell.textLabel.text = @"Test2_VC - Act Sheet";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
        case 2:
            cell.textLabel.text = @"Test3_VC - Test Cache";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
            
        case 3:
            cell.textLabel.text = @"LoadFiles_VC";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
        case 4:
            cell.textLabel.text = @"YANDEX_TEST";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
            
        case 5:
            cell.textLabel.text = @"NEW_1_2";
            NSLog(@"-----%@-----",cell.textLabel.text);
            [self performSelector:@selector(delayed) withObject:nil afterDelay:1.0];
            break;
            
        default:
            object = _objects[ind - def_rows];
            cell.textLabel.text = [object description];
            NSLog(@"--%@--",cell.textLabel.text);
            break;
    }
    
    cell.textLabel.alpha = 0.1;
    [UIView animateWithDuration:1.0
                     animations:^{
//                         NSLog(@"anim beg");
                         cell.textLabel.alpha = 0.9;
                     } completion:^(BOOL finished) {
//                         NSLog(@"%d %f",finished,cell.textLabel.alpha);
                     }];
    

//    NSLog(@"cell end");
    
    return cell;
}
 -(void)delayed
{
    NSLog(@"del");
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (!vc1) {
            vc1 = [[Test1_VC alloc] init];
        }
        [self.navigationController pushViewController:vc1 animated:YES];
    }
    if (indexPath.row == 1) {
        Test2_VC *vc = [[Test2_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        Test3_VC *vc = [[Test3_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {
        LoadFiles_VC *vc = [[LoadFiles_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 4) {
        YandexTest_VC *vc = [[YandexTest_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 5) {
        TstNew1_VC *vc = [[TstNew1_VC alloc] init];
//        TstNew2_VC *vc = [[TstNew2_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
  
    if (indexPath.row == 6) {
        [self manualRefresh];
//        [self performSelector:@selector(manualRefresh) withObject:nil afterDelay:0.1];
    }
    
    if (indexPath.row > 6) {
        if (!self.detailViewController) {
            self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        }
        NSDate *object = _objects[indexPath.row - def_rows];
        self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
    
    
}

//===========================REFRESH CONTROL===========================================
#pragma mark - -REFRESH CONTROL


-(void)doRefresh:(UIRefreshControl*) sender {
    // ... refresh the table data ...
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh_1"];

    NSLog(@" =DO= REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
//    sleep(2);
//    NSLog(@"\n\n =1= REFRESH END ==\n");
//   [sender endRefreshing];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.0];
}


-(void)manualRefresh
{
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh_2"];
    NSLog(@" =20= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    BOOL anim = NO;
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop
//                                  animated:anim];
    
    NSLog(@" =21= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));

//    CGPoint p1 = [self.tableView contentOffset];
//    p1.y -= self.refreshControl.bounds.size.height;
//    [self.tableView setContentOffset:p1 animated:anim];
    
    
    NSLog(@" =22= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    NSLog(@"--------- beginRefreshing ----------");
    [self.refreshControl beginRefreshing];
    
    NSLog(@" =23= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    CGPoint p1 = [self.tableView contentOffset];
    UIEdgeInsets ins = [self.tableView  contentInset];
//  p1.y -= self.refreshControl.bounds.size.height;
    p1.y = (ins.top>0.0)?(-ins.top):0.0; //- ins.top;
    [self.tableView setContentOffset:p1 animated:anim];
    
    NSLog(@" =24= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.0];
 }

-(void)stopRefresh
{
    NSLog(@" REFRESH END_1 offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    NSAssert([NSThread isMainThread], @"Should called only from main thread!");
    
    NSLog(@"--------- endRefreshing ----------");
    [self.refreshControl endRefreshing];
    
    NSLog(@" REFRESH END_2 offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
//    CGPoint p1 = [self.tableView contentOffset]; //zs1
//    UIEdgeInsets ins = [self.tableView  contentInset];
//    p1.y = (ins.top>0.0)?(-ins.top):0.0; //- ins.top;
//    [self.tableView setContentOffset:p1 animated:YES];
    
    
    [self performSelector:@selector(checkOffsetAfterRefrechControl) withObject:nil afterDelay:0.75]; //0.3
}

-(void)checkOffsetAfterRefrechControl
{
//    NSLog(@"\n\n REFRESH CONTROL_1 offset=%f %d\n",self.tableView.contentOffset.y,self.refreshControl.isRefreshing);
    NSLog(@"_");
    NSLog(@" CHECK REFRESH CONTROL offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop
//                                  animated:NO];
//    
//    NSLog(@"\n\n REFRESH CONTROL_2 offset=%f %d\n",self.tableView.contentOffset.y,self.refreshControl.isRefreshing);
}


@end
