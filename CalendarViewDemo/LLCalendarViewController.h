//
//  LLCalendarViewController.h
//  CalendarViewDemo
//
//  Created by Jeremy Lubin on 9/9/13.
//  Copyright (c) 2013 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLCalendarViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property UICollectionView *calendarView;

@end
