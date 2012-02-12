//
//  FESSolarCalculator.m
//  SolarCalculatorExample
//
//  Created by Dan Weeks on 2012-02-11.
//  Copyright © 2012 Daniel Weeks.
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif

#import "FESSolarCalculator.h"

@interface FESSolarCalculator ( )

@property (nonatomic, readwrite, strong) NSDate *sunrise;
@property (nonatomic, readwrite, strong) NSDate *sunset;
@property (nonatomic, readwrite, strong) NSDate *civilSunrise;
@property (nonatomic, readwrite, strong) NSDate *civilSunset;
@property (nonatomic, readwrite, strong) NSDate *nauticalSunrise;
@property (nonatomic, readwrite, strong) NSDate *nauticalSunset;
@property (nonatomic, readwrite, strong) NSDate *astronomicalSunrise;
@property (nonatomic, readwrite, strong) NSDate *astronomicalSunset;

@end

@implementation FESSolarCalculator

@synthesize startDate=_startDate;
@synthesize location=_location;
@synthesize sunrise=_sunrise;
@synthesize sunset=_sunset;
@synthesize civilSunrise=_civilSunrise;
@synthesize civilSunset=_civilSunset;
@synthesize nauticalSunrise=_nauticalSunrise;
@synthesize nauticalSunset=_nauticalSunset;
@synthesize astronomicalSunrise=_astronomicalSunrise;
@synthesize astronomicalSunset=_astronomicalSunset;


-(void)invalidateResults
{
    
}

-(void)setStartDate:(NSDate *)startDate
{
    // override the default setter for startDate so that we can invalidate previous results
    [self invalidateResults];
}

-(void)setLocation:(CLLocation *)location
{
    // override the default setter for location so that we can invalidate previous results
    [self invalidateResults];
}


@end
