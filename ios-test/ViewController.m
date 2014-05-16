//
//  ViewController.m
//  ios-test
//
//  Created by hitoshi on 5/14/14.
//
//

#import "ViewController.h"
//#import <AFNetworking/AFNetworking.h>
//#import <XMLReader-Arc/XMLReader.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *theUrlString = @"http://vivianaranha.com/testpopup.xml";
    NSURL *theUrl = [NSURL URLWithString:theUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:theUrl];
    
    //    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //    NSLog(@"%@",theConnection);
    
    //Easy Way
    NSData *thedata = [NSData dataWithContentsOfURL:theUrl];
    NSString *myRealData = [[NSString alloc] initWithData:thedata encoding:NSUTF8StringEncoding];
    
    //    NSLog(@"Easy Data: %@",myRealData);
    NSError *error = nil;
    NSDictionary *myDataDict = [XMLReader dictionaryForXMLData:thedata error:&error];
//    NSLog(@"%@",[myDataDict description]);
    
//    NSLog(@"%@",[[[myDataDict objectForKey:@"appmessages"] objectForKey:@"popup"] objectAtIndex:0]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




@end
