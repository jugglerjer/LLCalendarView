//
//  LLCalendarViewController.m
//  CalendarViewDemo
//
//  Created by Jeremy Lubin on 9/9/13.
//  Copyright (c) 2013 Lubin Labs. All rights reserved.
//

#import "LLCalendarViewController.h"
#import "LLSpringyCalendarViewLayout.h"
#import "LLCalendarDayCell.h"

static NSString * const CalendarDayCellIdentifier = @"CalendarDayCell";

@interface LLCalendarViewController ()

@property NSArray *datesArray;

@end

@implementation LLCalendarViewController

#define KeyboardHeight           216
#define kNumberOfDaysInWeek      7
#define kNumberOfWeeksInMonth    6
#define kNumberOfMonthsToDisplay 25
#define secondsInDay() (60 * 60 * 24)

- (id)init
{
    if (self = [super init])
    {
        // Initiate date management
        [self setupDates];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the calendar layout object
    LLCalendarViewLayout *calendarLayout = [[LLCalendarViewLayout alloc] init];
    
    // Create the calendar collection view
    CGRect calendarFrame = CGRectMake(0.0, self.view.frame.size.height - KeyboardHeight,
                                      self.view.frame.size.width, KeyboardHeight);
    _calendarView = [[UICollectionView alloc] initWithFrame:calendarFrame collectionViewLayout:calendarLayout];
    _calendarView.dataSource = self;
    _calendarView.delegate = self;
    _calendarView.pagingEnabled = YES;
    _calendarView.backgroundColor = [UIColor clearColor];
    [_calendarView registerClass:[LLCalendarDayCell class] forCellWithReuseIdentifier:CalendarDayCellIdentifier];
    [self.view addSubview:_calendarView];
}

# pragma mark - Calendar Data Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kNumberOfMonthsToDisplay;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kNumberOfDaysInWeek * kNumberOfWeeksInMonth;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LLCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarDayCellIdentifier forIndexPath:indexPath];
    
    NSDate *date = _datesArray[indexPath.section][indexPath.item];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d"];
    cell.dateLabel.text = [formatter stringFromDate:date];
    cell.dateLabel.font = [UIFont systemFontOfSize:9.0];
    
    return cell;
}

# pragma mark Date Handling Methods

- (void)setupDates
{
    // Determine the start date for the calendar view
    // by taking a predefined number of months on either side
    // of the given midpoint date
    NSInteger previousMonthCount = -(kNumberOfMonthsToDisplay - 1) / 2;
//    NSInteger subsequentMonthCount = (kNumberOfMonthsToDisplay - 1) / 2;
    
    NSDate *midPointDate = [NSDate date];
    NSDate *startDate = [NSDate dateWithTimeInterval:previousMonthCount * kNumberOfWeeksInMonth * kNumberOfDaysInWeek * secondsInDay()
                                           sinceDate:[midPointDate beginningOfMonth]];
    
    // Create a dictionary of months wherein each
    // item is populated with an array of dates
    // ----------------------------------------
    NSMutableArray *months = [NSMutableArray arrayWithCapacity:kNumberOfMonthsToDisplay];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *monthComponent = [[NSDateComponents alloc] init];
    [monthComponent setMonth:1];
    NSDate *nextMonthDate = startDate;
    for (NSInteger i = 0; i < kNumberOfMonthsToDisplay; i++)
    {
        NSArray *days = [self datesForMonthAndYearComponents:[[NSCalendar currentCalendar] components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:nextMonthDate]];
        [months addObject:days];
        nextMonthDate = [calendar dateByAddingComponents:monthComponent toDate:nextMonthDate options:0];
    }
    
    _datesArray = months;
}

- (NSArray *)datesForMonthAndYearComponents:(NSDateComponents *)components
{
    NSMutableArray *dates = [NSMutableArray arrayWithCapacity:kNumberOfDaysInWeek * kNumberOfWeeksInMonth];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Determine how many dates that need to be displayed prior to and after the given month
    [components setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:components];
    NSDateComponents *weekdayComponent = [calendar components:NSWeekdayCalendarUnit fromDate:firstDate];
    NSInteger numberOfDaysBefore = [weekdayComponent weekday] - 1;
    NSInteger numberOfDaysAfter = (kNumberOfDaysInWeek * kNumberOfWeeksInMonth) - (numberOfDaysBefore + [firstDate daysInMonth]);
    
    // Fetch each of the dates that need to be displayed prior to the first day of the given month
    for (NSInteger i = numberOfDaysBefore; i > 0; i--)
    {
        NSDate *priorDate = [NSDate dateWithTimeInterval:-(i*secondsInDay()) sinceDate:firstDate];
        [dates addObject:priorDate];
    }
    
    // Create each of the dates in the month
    for (NSInteger i = 0; i < [firstDate daysInMonth] ; i++)
    {
        NSDate *nextDate = [NSDate dateWithTimeInterval:i*secondsInDay() sinceDate:firstDate];
        [dates addObject:nextDate];
    }
    
    // Create of the dates that fall after the current month ends
    NSDate *lastDateOfMonth = [dates lastObject];
    for (NSInteger i = 1; i <= numberOfDaysAfter; i++)
    {
        NSDate *postDate = [NSDate dateWithTimeInterval:i*secondsInDay() sinceDate:lastDateOfMonth];
        [dates addObject:postDate];
    }
    
    return dates;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
