//
//  LLAppDelegate.h
//  CalendarViewDemo
//
//  Created by Jeremy Lubin on 9/9/13.
//  Copyright (c) 2013 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLCalendarViewController;

@interface LLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) LLCalendarViewController *rootViewController;

@end
