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

#import "TestClass.h"
#import <objc/message.h>


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
    
    
    [self configureRefresh];
    
    
    //3D 
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)] &&
        (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable))
    {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }    
    
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
    
//    self.refreshControl.tintColor = [UIColor redColor];
    
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
    
    
    
    Class cls = NSClassFromString(@"UIRefreshControl");
    Block_Check block = ^UIView*(UIView* v) {
        if ([v isKindOfClass:cls]) {
            UIRefreshControl *ref = (UIRefreshControl*)v;
            if (!ref.isHidden && ref.refreshing) {
                return v;                
            }
        }
        return nil;
    };
    UIRefreshControl *ref = (UIRefreshControl*)[self findInSubviews:self.view block:block];
    if (ref) 
    {
        CGPoint p = self.tableView.contentOffset;
        NSLog(@"\n\n !!!!!!!!!! RELOAD REFRESH 1 : %f !!!!!!!!! \n",self.tableView.contentOffset.y);
        [ref endRefreshing];
//        [self performSelector:@selector(reststartREfresh) withObject:nil afterDelay:0.01];
        [ref beginRefreshing];
        
//        CGPoint p1 = [self.tableView contentOffset];
//        UIEdgeInsets ins = [self.tableView  contentInset];
//        //  p1.y -= self.refreshControl.bounds.size.height;
//        p1.y = (ins.top>0.0)?(-ins.top):0.0; //- ins.top;
//        [self.tableView setContentOffset:p1 animated:NO];  
        [self.tableView setContentOffset:p animated:NO];
        NSLog(@"\n\n !!!!!!!!!! RELOAD REFRESH 2 : %f !!!!!!!!! \n",self.tableView.contentOffset.y);
    }
    
}

-(void)reststartREfresh
{
    UIRefreshControl *cont = self.refreshControl;
    [cont beginRefreshing];
    return;
    
    
    self.refreshControl = nil;
    self.refreshControl = cont;
    
//    [self.refreshControl addTarget:self action:@selector(doRefresh:) forControlEvents:UIControlEventValueChanged];

//    [self configureRefresh];
    [self manualRefresh];
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
    
//    [self configureRefresh];
    
    NSLog(@" DID APPEAR_2 offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    b=NO;
    
//    TestClass *tst = [TestClass new];
    
    typedef void(*InitFun)(id,SEL,id);
    InitFun initFun = NULL;
    
    Class MyClass = NSClassFromString(@"TestClass");
    SEL   selector1     = NSSelectorFromString(@"testClassMethod:");
    SEL   selector2     = NSSelectorFromString(@"testRunMethod:");
    
    
    Method initMethod1 = class_getClassMethod(MyClass, selector1);
    Method initMethod2 = class_getInstanceMethod(MyClass, selector2);
   
    //initFun = (void (*)(id,SEL,NSString*))objc_msgSend; /////A will call initialize now
    initFun = (InitFun)method_getImplementation(initMethod1); //B will NOT call initialize now!!!
    
    initFun(MyClass, selector1, @"_string_Param_"); //A will call initialize now

    TestClass *tst = [TestClass new]; //A - not inizialize - init //B - inizialize - init
    
    b=NO;
    return;
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

-(UIViewController*)controllerToCall:(NSIndexPath *)indexPath
{   
    UIViewController *cont = nil;
    //Test1_VC *vc1 = nil;
    if (indexPath.row == 0) {
        if (!vc1) {
            vc1 = [[Test1_VC alloc] init];
        }
        cont = vc1;
    }
    if (indexPath.row == 1) {
        Test2_VC *vc = [[Test2_VC alloc] init];
        cont = vc;
    }
    if (indexPath.row == 2) {
        Test3_VC *vc = [[Test3_VC alloc] init];
        cont = vc;
    }
    if (indexPath.row == 3) {
        LoadFiles_VC *vc = [[LoadFiles_VC alloc] init];
        cont = vc;
    }
    if (indexPath.row == 4) {
        YandexTest_VC *vc = [[YandexTest_VC alloc] init];
        cont = vc;
    }
    if (indexPath.row == 5) {
        TstNew1_VC *vc = [[TstNew1_VC alloc] init];
        //        TstNew2_VC *vc = [[TstNew2_VC alloc] init];
        cont = vc;
    }

    return cont;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *cont = [self controllerToCall:indexPath];
    if (cont) {
        [self.navigationController pushViewController:cont animated:YES];
    }
    
//    if (indexPath.row == 0) {
//        if (!vc1) {
//            vc1 = [[Test1_VC alloc] init];
//        }
//        [self.navigationController pushViewController:vc1 animated:YES];
//    }
//    if (indexPath.row == 1) {
//        Test2_VC *vc = [[Test2_VC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if (indexPath.row == 2) {
//        Test3_VC *vc = [[Test3_VC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if (indexPath.row == 3) {
//        LoadFiles_VC *vc = [[LoadFiles_VC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if (indexPath.row == 4) {
//        YandexTest_VC *vc = [[YandexTest_VC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if (indexPath.row == 5) {
//        TstNew1_VC *vc = [[TstNew1_VC alloc] init];
////        TstNew2_VC *vc = [[TstNew2_VC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
  
    
    if (indexPath.row == 6) {
        [self manualRefresh];
//        [self performSelector:@selector(manualRefresh) withObject:nil afterDelay:0.1];
    }
    if (indexPath.row == 7) {
//        [self testSubview];
        [self performSelector:@selector(testSubview) withObject:nil afterDelay:0.1];
    }
   
    if (indexPath.row > 7) {
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

    NSLog(@" =====DO= REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
//    sleep(2);
//    NSLog(@"\n\n =1= REFRESH END ==\n");
//   [sender endRefreshing];
    [self testSubview];
    
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:10.0];
}


-(void)manualRefresh
{
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh_2"];
///    NSLog(@" =20= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    BOOL anim = YES;
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop
//                                  animated:anim];
    
///    NSLog(@" =21= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));

//    CGPoint p1 = [self.tableView contentOffset];
//    p1.y -= self.refreshControl.bounds.size.height;
//    [self.tableView setContentOffset:p1 animated:anim];
    
    
///    NSLog(@" =22= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    NSLog(@"--------- beginRefreshing ----------");
//    [self testSubview];
    [self.refreshControl beginRefreshing];
//    [self testSubview];
    
///    NSLog(@" =23= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    CGPoint p1 = [self.tableView contentOffset];
    UIEdgeInsets ins = [self.tableView  contentInset];
//  p1.y -= self.refreshControl.bounds.size.height;
    p1.y = (ins.top>0.0)?(-ins.top):0.0; //- ins.top;
    [self.tableView setContentOffset:p1 animated:anim];
    
///    NSLog(@" =24= MANUAL REFRESH BEGIN offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:10.0];
 }

-(void)stopRefresh
{
    NSLog(@" REFRESH END_1 offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));
    NSAssert([NSThread isMainThread], @"Should called only from main thread!");
    
    NSLog(@"--------- endRefreshing ----------");
    
//    [self testSubview];
    
    [self.refreshControl endRefreshing];
    
//    [self testSubview];
    
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
    NSLog(@"===");
    NSLog(@"=============== CHECK REFRESH CONTROL offset=(%@) inset=(%@)",NSStringFromCGPoint(self.tableView.contentOffset),NSStringFromUIEdgeInsets(self.tableView.contentInset));

    [self testSubview];
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop
//                                  animated:NO];
//    
//    NSLog(@"\n\n REFRESH CONTROL_2 offset=%f %d\n",self.tableView.contentOffset.y,self.refreshControl.isRefreshing);
}




//===========================================================================================================

typedef UIView* (^Block_Check)(UIView* v);
#define max_search_dip_level 25


-(void)testSubview
{    
    Class cl1 = [UIRefreshControl class];
    Class cl2 = NSClassFromString(@"UIRefreshControl");
    Class cl3 = NSClassFromString(@"FX_UIRefreshControl");
    Class cl4 = NSClassFromString(@"_UIRefreshControlModernReplicatorView");
    Block_Check block = ^UIView*(UIView* v) {
        if ([v isKindOfClass:cl2]) {
            return v;
        }
        return nil;
    };
    
//    UIView *v = self.tableView.refr
    
    UIRefreshControl *aViev = (UIRefreshControl*)[self findInSubviews:self.view block:block];
    if (aViev) {
        NSString *scl = NSStringFromClass([aViev class]);
        BOOL bol = aViev.superview;
        NSString *ss = NSStringFromClass([aViev.superview class]);
        NSLog(@"----------- found0(%@) hidden:%d  superview:%d(%@) refreshing=%d-------------",scl,aViev.isHidden,bol,ss,aViev.refreshing);
        
        UIView *v0 = (UIView*)[aViev valueForKeyPath:@"_contentView"];
        scl = NSStringFromClass([v0 class]);
 //       NSLog(@"-- found1:(%@) --",scl);
        CALayer *lay0 = v0.layer;
        NSArray *anim0 = [lay0 animationKeys];
                
        UIView *v1 = (UIView*)[aViev valueForKeyPath:@"_contentView._replicatorView"];
        scl = NSStringFromClass([v1 class]);
//        NSLog(@"-- found2:(%@) --",scl);
        CALayer *lay1 = v1.layer;
        NSArray *anim1 = [lay1 animationKeys];
                
        NSLog(@">>>>>>>>>>> anim1=%@",anim1);
        v0 = nil;
    } else {
        NSLog(@"-- not found --");        
    }
    
}


-(UIView*)findInSubviews:(UIView*)v block:(Block_Check)find_block
{
    static int level = 0;
    NSArray *subviews = v.subviews;
    __block UIView *findView = nil;
    
    @try
    {
        level++;
        NSLog(@"\n\n  --------------->> find in:%@  /subviews=%lu --level=%d-------\n",NSStringFromClass([v class]),(unsigned long)v.subviews.count,level);
        if (level > max_search_dip_level) {
            return findView;
        }
        [subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
            if (find_block(view)) {
                NSLog(@" >>> YES FOUND in (%@) at level %d!!!! \n",NSStringFromClass([view class]),level);
                *stop = YES;
                findView = view;
            }
        }];
        if (!findView) {
            for (UIView *v in subviews) {
                if (v.subviews.count) {
                    UIView *vi = [self findInSubviews:v block:find_block];
                    if (vi) {
                        findView = vi;
                        break;
                    }
                }
            }
        }
    } //try
    @finally {
        level--;
        return findView;
    }
    
}


//=============================================================================
#pragma mark - 3d touch

- (BOOL)isForceTouchAvailable 
{
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) 
    {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}



//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection 
//{ 
//    [super traitCollectionDidChange:previousTraitCollection];
//    if ([self isForceTouchAvailable]) 
//    {
//        if (!self.previewingContext) {
//            self.previewingContext = [self registerForPreviewingWithDelegate:self 
//                                         sourceView:self.view];
//        }
//    } else {
//        if (self.previewingContext) {
//            [self unregisterForPreviewingWithContext:self.previewingContext];
//            self.previewingContext = nil;
//        }
//    }
//}


- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext 
                       viewControllerForLocation:(CGPoint)location 
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if (indexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
//        id *content = self.data[indexPath.row];
        
        UIViewController *previewController = [self controllerToCall:indexPath];
        
//        previewController.content = content;
        
        previewingContext.sourceRect = cell.frame;
        
        return previewController;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit 
{
    if (viewControllerToCommit) {
        [self.navigationController pushViewController:viewControllerToCommit animated:YES];
    }
}



- (NSArray<id<UIPreviewActionItem>> *)___previewActionItems 
{
    __weak typeof(self) weakSelf = self;
    UIPreviewAction *shareAction1 = [UIPreviewAction actionWithTitle:@"Share1" 
                                                               style:UIPreviewActionStyleDefault 
                                                             handler:^(UIPreviewAction *action, UIViewController *previewViewController){
                                                                 NSLog(@"ACTION 1");
                                                             }];
    UIPreviewAction *shareAction2 = [UIPreviewAction actionWithTitle:@"Share2" 
                                                               style:UIPreviewActionStyleDefault 
                                                             handler:^(UIPreviewAction *action, UIViewController *previewViewController){
                                                                 NSLog(@"ACTION 2");
                                                             }];
    UIPreviewAction *shareAction3 = [UIPreviewAction actionWithTitle:@"Share3" 
                                                               style:UIPreviewActionStyleDefault 
                                                             handler:^(UIPreviewAction *action, UIViewController *previewViewController){
                                                                 NSLog(@"ACTION 3");
                                                             }];
    
    return @[shareAction1,shareAction2,shareAction3];
}


- (NSArray<id> *)previewActionItems {
    
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Action 1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 1 triggered");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Destructive Action" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Destructive Action triggered");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Selected Action" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Selected Action triggered");
    }];
    
    // add them to an arrary
    NSArray *actions = @[action1, action2, action3];
    
    // and return them
    return actions;
}

@end



