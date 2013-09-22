//
//  LLCalendarDayCell.m
//  CalendarViewDemo
//
//  Created by Jeremy Lubin on 9/9/13.
//  Copyright (c) 2013 Lubin Labs. All rights reserved.
//

#import "LLCalendarDayCell.h"

@implementation LLCalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dateFormat = [[NSDateFormatter alloc] init];
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:_dateLabel];
    }
    return self;
}

- (void)configureWithDate:(NSDate *)date
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
