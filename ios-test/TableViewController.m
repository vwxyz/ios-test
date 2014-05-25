//
//  TableViewController.m
//  ios-test
//
//  Created by hitoshi on 5/15/14.
//
//

#import "TableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <PixateFreestyle/PixateFreestyle.h>

@interface TableViewController ()

@end

@implementation TableViewController

#pragma mark - ライフサイクル

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 受信、辞書データに変換
    NSDictionary *xmldata = [self getxml:@"https://gist.githubusercontent.com/vwxyz/0b4b9c9ffa8e99a86812/raw/4a8ea764b18ad8f5fb46df1b98abcecae84830b6/sample.xml"];
    NSString *title = [xmldata valueForKeyPath:@"receipt.title.text"];


    //NSLog(@"%@",[[[xmldata objectForKey:@"receipt"] objectForKey:@"title"] objectForKey:@"text"]);
    //NSLog(@"%@",[xmldata description]);
    
    //合計計算
    int total = 0;
    NSArray *arr = [xmldata valueForKeyPath:@"receipt.line-item"];
    for(int i=0; i< [arr count]; i++){
        total = total + [[arr[i] valueForKeyPath:@"price.text"] intValue];
    }
    // 950-> ¥950に
    NSString *total_string = @"¥";
    total_string = [total_string stringByAppendingString:[NSString stringWithFormat:@"%d",total]];
    //NSLog(@"%@",total_string);
    
    
    //section名
    
    groupName = @[
                  title
                  ,@""
                  ,@""
                  ];
    groups = @[
               @[
                   [[[xmldata valueForKeyPath:@"receipt.subtitle"] objectAtIndex:0] objectForKey:@"text"],
                   [[[xmldata valueForKeyPath:@"receipt.subtitle"] objectAtIndex:1] objectForKey:@"text"],
                   [[[xmldata valueForKeyPath:@"receipt.subtitle"] objectAtIndex:2] objectForKey:@"text"],
                   ],
               [xmldata valueForKeyPath:@"receipt.line-item"],
               @[total_string]
               ];
    
    //tableviewの表示内容を生成
    [self.tableView reloadData];
    
    //tableviewの表示内容を画像に変換
    [self getImage];
    
}




NSArray *groupName;
NSArray *groups;

#pragma mark - xmlデータ取得、nsdictionaryへ変換
- (NSDictionary *)getxml:(NSString *) theUrlString
{
    NSError *error=nil;
    NSURL *theUrl = [NSURL URLWithString:theUrlString];
    NSData *theData = [NSData dataWithContentsOfURL:theUrl];
    NSDictionary *dict= [XMLReader dictionaryForXMLData:theData error:&error];

    return dict;
}

#pragma mark - Table view data source

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [groupName count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groups[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *members = groups[indexPath.section];
        //第１セクションの設定
        if (indexPath.section==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.styleClass = @"shopInfo";
            cell.textLabel.text = members[indexPath.row];
            return cell;
        }
        
        //第２セクションの設定
        else if (indexPath.section==1) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.detailTextLabel.text       = [@"¥" stringByAppendingString:[members[indexPath.row] valueForKeyPath:@"price.text"]];
            cell.textLabel.text = [members[indexPath.row] valueForKeyPath:@"name.text"];
            return cell;
        }
        //第3セクションの設定
        else{
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.textLabel.text       = @"合計";
            cell.detailTextLabel.text = members[indexPath.row];//[members[indexPath.row] valueForKeyPath:@"totalPrice"];
            return cell;
      }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
    
}

- (UIView *) tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *view = [tv dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"Header"];
    }
    
    view.textLabel.text = groupName[section];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

#pragma mark - tableviewの表示内容を画像に変換、さらにグレースケールに変換、保存

- (void)getImage
{
    UITableView *view = self.tableView;
    view.backgroundColor = [UIColor whiteColor];
    //    view.separatorColor = [UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    //    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //グレースケールに変換
    UIImage *grayImage = [self convertGrayScaleImage:image];
    
    SEL sel = @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(grayImage, self, sel, NULL);
    //    [dataSaveImage writeToFile:[path stringByAppendingPathComponent:@"test.png"] atomically:YES];
    
}
//via http://stackoverflow.com/questions/18921703/implicit-conversion-from-enumeration-type-enum-cgimagealphainfo-to-different-e

#define kBitsPerComponent 8
#define kBitmapInfo       kCGImageAlphaNone

-(UIImage*)convertGrayScaleImage:(UIImage*)image

{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGBitmapInfo bitmapInfo = (CGBitmapInfo) kBitmapInfo;
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0,colorSpace, bitmapInfo);
    CGRect rect = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, rect, [image CGImage]);
    CGImageRef grayscale = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage* grasyScaleImage = [UIImage imageWithCGImage:grayscale];
    CFRelease(grayscale);
    return grasyScaleImage;
    
}

- (void) savingImageIsFinished:(UIImage *)_image didFinishSavingWithError:(NSError *)_error contextInfo:(void *)_contextInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"レシート保存" message:@"アルバムへ保存しました" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
