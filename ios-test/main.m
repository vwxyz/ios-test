//
//  main.m
//  ios-test
//
//  Created by hitoshi on 5/14/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <PixateFreestyle/PixateFreestyle.h>

int main(int argc, char * argv[])
{
    @autoreleasepool {
        [PixateFreestyle initializePixateFreestyle];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
