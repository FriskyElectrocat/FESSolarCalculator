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
#include "math.h"

double const FESSolarCalculatorZenithOfficial = 90.8333;
double const FESSolarCalculatorZenithCivil = 96.0;
double const FESSolarCalculatorZenithNautical = 102.0;
double const FESSolarCalculatorZenithAstronomical = 108.0;

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
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger numberDayOfYear = [gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:[NSDate date]];
    
    NSLog(@"blah %i", numberDayOfYear);
}

#pragma mark -
#pragma mark Calculation Ops

- (double)approximateTimeFromDayOfYear:(NSUInteger)dayOfYear longitude:(CLLocationDegrees)longitude direction:(FESSolarCalculationDirection)direction
{
    double longitudeHour = longitude / 15.0;
    double baseTime = 6;
    if ((direction & FESSolarCalculationSetting) == FESSolarCalculationSetting) {
        baseTime = 18;
    } 
    // t = N + ((18 - lngHour) / 24)
    double approximateTime = dayOfYear + ((baseTime - longitudeHour) / 24.0);
    return approximateTime;
}

- (double)sunsMeanAnomolyFromApproximateTime:(double)approximateTime
{
    // M = (0.9856 * t) - 3.289
    double sunsMeanAnomoly = (0.9856 * approximateTime) - 3.289;
    return sunsMeanAnomoly;
}

- (double)sunsTrueLongitudeFromMeanAnomoly:(double)meanAnomoly
{
    // L = M + (1.916 * sin(M)) + (0.020 * sin(2 * M)) + 282.634
    double meanAnomolyinRadians = meanAnomoly * M_PI / 180;
    double trueLongitude = meanAnomoly + (1.916 * sin(meanAnomolyinRadians)) + (0.020 * sin(2 * meanAnomolyinRadians)) + 282.634;
    if (trueLongitude > 360.0) {
        trueLongitude -= 360.0;
    } else if (trueLongitude < 0.0) {
        trueLongitude += 360.0;        
    }
    return trueLongitude;
}

- (double)sunsRightAscensionFromTrueLongitude:(double)trueLongitude
{
    // RA = atan(0.91764 * tan(L))
    // Lquadrant  = (floor( L/90)) * 90
	// RAquadrant = (floor(RA/90)) * 90
	// RA = RA + (Lquadrant - RAquadrant)
    // RA = RA / 15
    
    double rightAscension = atan(0.91764  * tan(trueLongitude));
    double Lquadrant = floor(trueLongitude/90) * 90;
    double RAquadrant = floor(rightAscension/90) *90;
    rightAscension = rightAscension + (Lquadrant - RAquadrant);
    rightAscension = rightAscension / 15.0;
    return rightAscension;
}

- (double)sunsLocalHourAngleFromTrueLongitude:(double)trueLongitude latitude:(CLLocationDegrees)latitude zenith:(double)zenith direction:(FESSolarCalculationDirection)direction
{
    // sinDec = 0.39782 * sin(L)
	// cosDec = cos(asin(sinDec))
    
    double sinDeclination = 0.39782 * sin(trueLongitude * M_PI / 180);
    double cosDeclination = cos(asin(sinDeclination));
    
    // cosH = (cos(zenith) - (sinDec * sin(latitude))) / (cosDec * cos(latitude))

    double latitudeInRadians = latitude * M_PI / 180;
    double cosH = (cos(zenith) - (sinDeclination * sin(latitudeInRadians))) / (cosDeclination * cos(latitudeInRadians));

	// if (cosH >  1) 
	//  the sun never rises on this location (on the specified date)
	// if (cosH < -1)
	//  the sun never sets on this location (on the specified date)

    // TODO: figure out how to specify the sun never rises or sets (find the next day it does?)

    // if rising time is desired:
	//   H = 360 - acos(cosH)
	// if setting time is desired:
	//   H = acos(cosH)

    double sunsLocalHourAngle = acos(cosH);
    if ((direction & FESSolarCalculationRising) == FESSolarCalculationRising) {
        sunsLocalHourAngle = 360.0 - sunsLocalHourAngle;
    }
	
    // H = H / 15
    sunsLocalHourAngle = sunsLocalHourAngle / 15.0;

    return sunsLocalHourAngle;
}

- (double)calculateLocalMeanTimeFromLocalHourAngle:(double)localHourAngle rightAscension:(double)rightAscension approximateTime:(double)approximateTime
{
    // T = H + RA - (0.06571 * t) - 6.622
    double localMeanTime = localHourAngle + rightAscension - (0.06571 * approximateTime) - 6.622;
    return localMeanTime;
}

- (double)convertToUTCFromLocalMeanTime:(double)localMeanTime longitudeHour:(double)longitudeHour
{
    // UT = T - lngHour
    // NOTE: UT potentially needs to be adjusted into the range [0,24) by adding/subtracting 24
    double timeinUTC = localMeanTime - longitudeHour;
    if (timeinUTC > 24.0) {
        timeinUTC -= 24.0;
    } else if (timeinUTC < 0.0) {
        timeinUTC += 24.0;
    }
    return timeinUTC;
}

@end
