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

// math sources: 
// http://users.electromagnetic.net/bu/astro/sunrise-set.php
// http://en.wikipedia.org/wiki/Julian_day

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif

#import "FESSolarCalculator.h"
#include "math.h"

//#if defined(FESSOLARCALCULATOR_DEBUG) && (FESSOLARCALCULATOR_DEBUG == 1)
#if defined(DEBUG) && (DEBUG == 1)
    #define dNSLog( a, var_args1... ) NSLog( a, ## var_args1 )
    #define dElseNSLog( a, var_args1...) else NSLog( a, ## var_args1 )
#else
    #define dNSLog( a, var_args...)
    #define dElseNSLog( a, var_args1...)
#endif

double const FESSolarCalculationZenithOfficial = 90.8333;
double const FESSolarCalculationZenithCivil = 96.0;
double const FESSolarCalculationZenithNautical = 102.0;
double const FESSolarCalculationZenithAstronomical = 108.0;

double const toRadians = M_PI / 180;
double const toDegrees = 180 / M_PI;

@interface FESSolarCalculator ( )

@property (nonatomic, readwrite, strong) NSDate *sunrise;
@property (nonatomic, readwrite, strong) NSDate *sunset;
@property (nonatomic, readwrite, strong) NSDate *solarNoon;
@property (nonatomic, readwrite, strong) NSDate *civilDawn;
@property (nonatomic, readwrite, strong) NSDate *civilDusk;
@property (nonatomic, readwrite, strong) NSDate *nauticalDawn;
@property (nonatomic, readwrite, strong) NSDate *nauticalDusk;
@property (nonatomic, readwrite, strong) NSDate *astronomicalDawn;
@property (nonatomic, readwrite, strong) NSDate *astronomicalDusk;

- (void)invalidateResults;

@end

@implementation FESSolarCalculator

@synthesize operationsMask=_operationsMask;
@synthesize startDate=_startDate;
@synthesize location=_location;
@synthesize sunrise=_sunrise;
@synthesize sunset=_sunset;
@synthesize solarNoon=_solarNoon;
@synthesize civilDawn=_civilDawn;
@synthesize civilDusk=_civilDusk;
@synthesize nauticalDawn=_nauticalDawn;
@synthesize nauticalDusk=_nauticalDusk;
@synthesize astronomicalDawn=_astronomicalDawn;
@synthesize astronomicalDusk=_astronomicalDusk;

#pragma mark -
#pragma mark Initializers


- (id)init
{
    self = [super init];
    if (self) {
        // set our default operations mask
        _operationsMask = FESSolarCalculationAll;
        [self invalidateResults];
    }
    return self;
}

- (id)initWithDate:(NSDate *)inDate location:(CLLocation *)inLocation
{
    self = [self init];
    if (self) {
        [self setStartDate:inDate];
        [self setLocation:inLocation];
    }
    return self;
}

- (id)initWithDate:(NSDate *)inDate location:(CLLocation *)inLocation mask:(FESSolarCalculationType)inMask
{
    self = [self initWithDate:inDate location:inLocation];
    if (self) {
        [self setOperationsMask:inMask];
    }
    return self;
}

#pragma mark -
#pragma mark Property Ops

- (void)setStartDate:(NSDate *)inDate
{
    // override the default setter for startDate so that we can invalidate previous results
    [self invalidateResults];
    _startDate = inDate;
}

- (void)setLocation:(CLLocation *)inLocation
{
    // override the default setter for location so that we can invalidate previous results
    [self invalidateResults];
    _location = inLocation;
}

- (void)invalidateResults
{
    // when users set new inputs the output values need to be invalidated
    _sunrise = nil;
    _sunset = nil;
    _solarNoon = nil;
    _civilDawn = nil;
    _civilDusk = nil;
    _nauticalDawn = nil;
    _nauticalDusk = nil;
    _astronomicalDawn = nil;
    _astronomicalDusk = nil;
}

#pragma mark -
#pragma mark User Facing Methods

- (void)calculate
{
    // run the calculations based on the users criteria
    int JulianDayNumber = [FESSolarCalculator julianDayNumberFromDate:self.startDate];
    double westLongitude = self.location.coordinate.longitude * -1; // 75W = 75, 45E = -45
    double ns = ((double)JulianDayNumber - 2451545 - 0.0009) - (westLongitude/360.0);
    double n = round(ns);
    double Js = 2451545 + 0.0009 + (westLongitude/360) + n;
    double Ms = (357.5291 + 0.98560028 * (Js - 2451545));
    double M = [FESSolarCalculator modValue:Ms with:360.0];
    double C = (1.9148 * sin(M)) + (0.0200 * sin(2 * M)) + (0.0003 * sin(3 * M));
    double eLs = (M + 102.9372 + C + 180);
    double eL = [FESSolarCalculator modValue:eLs with:360.0];
    double Jtransit = Js + (0.0053 * sin(M)) - (0.0069 * sin(2 * eL));
    double hourAngle = asin( sin(eL) * sin(23.45) );
    NSLog(@"hourAngle: %f", hourAngle);
    double H = acos( (cos(FESSolarCalculationZenithOfficial * toRadians) - sin(self.location.coordinate.latitude * toRadians) * sin(hourAngle)) / (cos(self.location.coordinate.latitude * toRadians) * cos(hourAngle)) );
    NSLog(@"H: %f", H);
    double Jss = 2451545 + 0.0009 + ((H + westLongitude)/360) + n;
    NSLog(@"Jss: %f", Jss);
    double Jset = Jss + (0.0053 * sin(M)) - (0.0069 * sin(2 * eL));
    double Jrise = Jtransit - (Jset - Jtransit);
    NSLog(@"Jtransit: %f -> %@", Jtransit, [FESSolarCalculator gregorianDateFromJulianDayNumber:Jtransit]);
    NSLog(@"Jrise: %f -> %@", Jrise, [FESSolarCalculator gregorianDateFromJulianDayNumber:Jrise]);
    NSLog(@"Jset: %f -> %@", Jset, [FESSolarCalculator gregorianDateFromJulianDayNumber:Jset]);
}

#pragma mark -
#pragma mark Class Methods

+ (double)modValue:(double)a with:(double)b
{
    return a - (a/b) + b;
}

+ (int)julianDayNumberFromDate:(NSDate *)inDate
{
    // calculation of Julian Day Number (http://en.wikipedia.org/wiki/Julian_day ) from Gregorian Date
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inDate];
    int a = (14 - (int)[components month]) / 12;
    int y = (int)[components year] +  4800 - a;
    int m = (int)[components month] + (12 * a) - 3;
    int JulianDayNumber = (int)[components day] + (((153 * m) + 2) / 5) + (365 * y) + (y/4) - (y/100) + (y/400) - 32045;
    NSLog(@"JDN: %i", JulianDayNumber);
    return JulianDayNumber;
}

+ (NSDate *)gregorianDateFromJulianDayNumber:(double)julianDayValue
{
    // calculation of Gregorian date from Julian Day Number ( http://en.wikipedia.org/wiki/Julian_day )
    int JulianDayNumber = (int)julianDayValue;
    int J = floor(JulianDayNumber + 0.5);
    int j = J + 32044;
    int g = j / 146097;
    int dg = j - (j/146097) * 146097;
    int c = (dg / 36524 + 1) * 3 / 4;
    int dc = dg - c * 36524;
    int b = dc / 1461;
    int db = dc - (dc/1461) * 1461;
    int a = (db / 365 + 1) * 3 / 4;
    int da = db - a * 365;
    int y = g * 400 + c * 100 + b * 4 + a;
    int m = (da * 5 + 308) / 153 - 2;
    int d = da - (m + 4) * 153 / 5 + 122;
    NSDateComponents *components = [NSDateComponents new];
    components.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    components.year = y - 4800 + (m + 2) / 12;
    components.month = ((m+2) - ((m+2)/12) * 12) + 1;
    components.day = d + 1;
    double timeValue = ((julianDayValue - round(julianDayValue)) + 0.5) * 24;
    components.hour = (int)round(timeValue);
    double minutes = (timeValue - round(timeValue)) * 60;
    components.minute = (int)round(minutes);
    components.second = (int)((minutes - round(minutes)) * 60);
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [cal dateFromComponents:components];
}

#pragma mark -
#pragma mark Calculation Ops


@end
