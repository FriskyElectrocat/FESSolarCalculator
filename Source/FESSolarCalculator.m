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

double const FESSolarCalculationZenithOfficial = 90.83;
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

-(void)invalidateResults;
-(void)computeSolarDataForType:(FESSolarCalculationType)calculationType andZenith:(double) zenith;

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
#pragma mark User Facing
/*
- (void)old_calculate
{
    // run the calculations based on the users criteria
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger numberDayOfYear = [gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self.startDate];
    
    double longitudeHour = [self longitudeHourFromLongitude:self.location.coordinate.longitude];
    double approximateTimeRising = [self approximateTimeFromDayOfYear:numberDayOfYear longitudeHour:longitudeHour direction:FESSolarCalculationRising];
    double approximateTimeSetting = [self approximateTimeFromDayOfYear:numberDayOfYear longitudeHour:longitudeHour direction:FESSolarCalculationSetting];
    double meanAnomolyRising = [self sunsMeanAnomolyFromApproximateTime:approximateTimeRising];
    double meanAnomolySetting = [self sunsMeanAnomolyFromApproximateTime:approximateTimeSetting];
    double trueLongitudeRising = [self sunsTrueLongitudeFromMeanAnomoly:meanAnomolyRising];
    double trueLongitudeSetting = [self sunsTrueLongitudeFromMeanAnomoly:meanAnomolySetting];
    double rightAscensionRising = [self sunsRightAscensionFromTrueLongitude:trueLongitudeRising];
    double rightAscensionSetting = [self sunsRightAscensionFromTrueLongitude:trueLongitudeSetting];
    
    void (^computeSolarData)(FESSolarCalculationType, FESSolarCalculationDirection, double) = ^(FESSolarCalculationType calculationType, FESSolarCalculationDirection direction, double zenith) {
        
        double trueLongitude = trueLongitudeRising;
        double rightAscension = rightAscensionRising;
        double approximateTime = approximateTimeRising;
        if ((direction & FESSolarCalculationSetting) == FESSolarCalculationSetting) {
            trueLongitude = trueLongitudeSetting;
            rightAscension = rightAscensionSetting;
            approximateTime = approximateTimeSetting;
        }
        double localHourAngle = [self sunsLocalHourAngleFromTrueLongitude:trueLongitude latitude:self.location.coordinate.latitude zenith:zenith direction:direction];
        double localMeanTime = [self calculateLocalMeanTimeFromLocalHourAngle:localHourAngle rightAscension:rightAscension approximateTime:approximateTime];
        double timeInUTC = [self convertToUTCFromLocalMeanTime:localMeanTime longitudeHour:longitudeHour];
        
        NSLog(@"local hour: %f", localHourAngle);
        NSLog(@"time in UTC: %f", timeInUTC);
        NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self.startDate];
        [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [components setHour:(int)round(timeInUTC)];
        double minutes = (timeInUTC - round(timeInUTC)) * 60;
        [components setMinute:(int)round(minutes)];
        [components setSecond:(int)((minutes - round(minutes)) * 60)];
        
        NSDate *setDate = [gregorian dateFromComponents:components];
        NSLog(@"start: %@", self.startDate);
        NSLog(@"set: %@", setDate);
        
        if ((calculationType & FESSolarCalculationOfficial) == FESSolarCalculationOfficial) {
            if ((direction & FESSolarCalculationRising) == FESSolarCalculationRising) {
                _sunrise = setDate;
            } else {
                _sunset = setDate;
            }
        } else if ((calculationType & FESSolarCalculationCivil) == FESSolarCalculationCivil) {
            if ((direction & FESSolarCalculationRising) == FESSolarCalculationRising) {
                _civilDawn = setDate;
            } else {
                _civilDusk = setDate;
            }
        } else if ((calculationType & FESSolarCalculationNautical) == FESSolarCalculationNautical) {
            if ((direction & FESSolarCalculationRising) == FESSolarCalculationRising) {
                _nauticalDawn = setDate;
            } else {
                _nauticalDusk = setDate;
            }
        } else if ((calculationType & FESSolarCalculationAstronomical) == FESSolarCalculationAstronomical) {            
            if ((direction & FESSolarCalculationRising) == FESSolarCalculationRising) {
                _astronomicalDawn = setDate;
            } else {
                _astronomicalDusk = setDate;
            }
        }
    };
    
    FESSolarCalculationType theseOps = self.operationsMask;
    if ((self.operationsMask & FESSolarCalculationAll) == FESSolarCalculationAll) {
        theseOps = FESSolarCalculationOfficial | FESSolarCalculationCivil | FESSolarCalculationNautical | FESSolarCalculationAstronomical;
    }
    if ((theseOps & FESSolarCalculationOfficial) == FESSolarCalculationOfficial) {
        computeSolarData(FESSolarCalculationOfficial, FESSolarCalculationRising, FESSolarCalculationZenithOfficial);
        computeSolarData(FESSolarCalculationOfficial, FESSolarCalculationSetting, FESSolarCalculationZenithOfficial);
        NSLog(@"sunrise: %@", self.sunrise);
        NSLog(@"sunset: %@", self.sunset);
        NSTimeInterval dayLength = [self.sunset timeIntervalSinceDate:self.sunrise] / 60.0 / 60.0;
        NSLog(@"day length: %f", dayLength);
        double halfDayLength = dayLength / 2.0;
        NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit) fromDate:self.sunrise];
        [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];        
        //        [components setHour:components.hour + (int)round(halfDayLength)];
        //        double minutes = halfDayLength - (round(halfDayLength) * 60);
        //        [components setMinute:(int)round(minutes)];
        //        [components setSecond:(int)((minutes - round(minutes)) * 60)];
        [components setSecond:(int)(round(halfDayLength))];
        _solarNoon = [gregorian dateFromComponents:components];
    }
    if ((theseOps & FESSolarCalculationCivil) == FESSolarCalculationCivil) {
        computeSolarData(FESSolarCalculationCivil, FESSolarCalculationRising, FESSolarCalculationZenithCivil);
        computeSolarData(FESSolarCalculationCivil, FESSolarCalculationSetting, FESSolarCalculationZenithCivil);
    }
    if ((theseOps & FESSolarCalculationNautical) == FESSolarCalculationNautical) {
        computeSolarData(FESSolarCalculationNautical, FESSolarCalculationRising, FESSolarCalculationZenithNautical);
        computeSolarData(FESSolarCalculationNautical, FESSolarCalculationSetting, FESSolarCalculationZenithNautical);
    }
    if ((theseOps & FESSolarCalculationAstronomical) == FESSolarCalculationAstronomical) {
        computeSolarData(FESSolarCalculationAstronomical, FESSolarCalculationRising, FESSolarCalculationZenithAstronomical);
        computeSolarData(FESSolarCalculationAstronomical, FESSolarCalculationSetting, FESSolarCalculationZenithAstronomical);
    }
    
}
*/

-(void)computeSolarDataForType:(FESSolarCalculationType)calculationType andZenith:(double) zenith
{

}

- (void)calculate
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    // run the calculations based on the users criteria
    int JulianDayNumber = [FESSolarCalculator julianDayNumberFromDate:self.startDate];
    NSLog(@"Julian Date: %i", JulianDayNumber);
    double westLongitude = self.location.coordinate.longitude * -1.0; // 75W = 75, 45E = -45
    
    double Nearest = 0.0;
    double ElipticalLongitudeOfSun = 0.0;
    double ElipticalLongitudeRadians = ElipticalLongitudeOfSun * toRadians;
    double MeanAnomoly = 0.0;
    double MeanAnomolyRadians = MeanAnomoly * toRadians;
    double MAprev = -1.0;
    double Jtransit = 0.0;
    
    while (MeanAnomoly != MAprev) {
        NSLog(@"-------------------------------------> running Jtransit calculation!");
        MAprev = MeanAnomoly;
        Nearest = round(((double)JulianDayNumber - 2451545.0 - 0.0009) - (westLongitude/360.0));
        NSLog(@"Nearest: %0.10f", Nearest);
        double Japprox = 2451545.0 + 0.0009 + (westLongitude/360.0) + Nearest;
        if (Jtransit != 0.0) {
            Japprox = Jtransit;
        }
        NSLog(@"Japprox: %0.10f", Japprox);
        double Ms = (357.5291 + 0.98560028 * (Japprox - 2451545));
        NSLog(@"Ms: %0.10f", Ms);
        MeanAnomoly = fmod(Ms, 360.0);
        MeanAnomolyRadians = MeanAnomoly * toRadians;
        NSLog(@"MeanAnomoly: %0.10f", MeanAnomoly);
        double EquationOfCenter = (1.9148 * sin(MeanAnomolyRadians)) + (0.0200 * sin(2.0 * (MeanAnomolyRadians))) + (0.0003 * sin(3.0 * (MeanAnomolyRadians)));
        NSLog(@"EquationOfCenter: %0.10f", EquationOfCenter);
        double eLs = (MeanAnomoly + 102.9372 + EquationOfCenter + 180.0);
        ElipticalLongitudeOfSun = fmod(eLs, 360.0);
        ElipticalLongitudeRadians = ElipticalLongitudeOfSun * toRadians;
        NSLog(@"eLs: %0.10f", eLs);
        NSLog(@"ElipticalLongitudeOfSun: %0.10f", ElipticalLongitudeOfSun);
        if (Jtransit == 0.0) {
            Jtransit = Japprox + (0.0053 * sin(MeanAnomolyRadians)) - (0.0069 * sin(2.0 * ElipticalLongitudeRadians));
        }
        NSLog(@"Jtransit: %0.10f -> %@", Jtransit, [df stringFromDate:[FESSolarCalculator dateFromJulianDayNumber:Jtransit]]);
    }
    
    NSLog(@"------------------- done\nMeanAnomoly: %0.10f\nMprev: %0.10f", MeanAnomoly, MAprev);
    
    double DeclinationOfSun = asin( sin(ElipticalLongitudeRadians) * sin(23.45 * toRadians) ) * toDegrees;
    double DeclinationOfSunRadians = DeclinationOfSun * toRadians;
    NSLog(@"DeclinationOfSun: %0.10f", DeclinationOfSun);
    
    //  --- zenith-based calculations
    
    double H1 = (cos(FESSolarCalculationZenithOfficial * toRadians) - sin(self.location.coordinate.latitude * toRadians) * sin(DeclinationOfSunRadians));
    double H2 = (cos(self.location.coordinate.latitude * toRadians) * cos(DeclinationOfSunRadians));
    double H = acos( (H1  * toRadians) / (H2  * toRadians) ) * toDegrees;
    NSLog(@"H1: %0.10f", H1);
    NSLog(@"H2: %0.10f", H2);
    NSLog(@"H: %0.10f", H);
    double Jss = 2451545.0 + 0.0009 + ((H + westLongitude)/360.0) + Nearest;
    NSLog(@"Jss: %0.10f", Jss);
    double Jset = Jss + (0.0053 * sin(MeanAnomolyRadians)) - (0.0069 * sin(2.0 * ElipticalLongitudeRadians));
    double Jrise = Jtransit - (Jset - Jtransit);
    NSLog(@"Jtransit: %0.10f -> %@", Jtransit, [df stringFromDate:[FESSolarCalculator dateFromJulianDayNumber:Jtransit]]);
    NSLog(@"Jrise: %0.10f -> %@", Jrise, [df stringFromDate:[FESSolarCalculator dateFromJulianDayNumber:Jrise]]);
    NSLog(@"Jset: %0.10f -> %@", Jset, [df stringFromDate:[FESSolarCalculator dateFromJulianDayNumber:Jset]]);
}

#pragma mark -
#pragma mark Calculation Ops


#pragma mark -
#pragma mark Class Methods

// NOTE: converting to and from the Julian Day Number can be done with NSDateFormatter.
// I debated doing that once I found the "g" format string, but then I discovered the 
// NSDateFormatter returns and is based off of 08:00 GMT rather than noon/12:00 GMT.
// A bug report has been filed with Apple, see http://openradar.appspot.com/11023565 
// for details. These will be revisited when or if that bug is resolved.

+ (int)julianDayNumberFromDate:(NSDate *)inDate
{
    // calculation of Julian Day Number (http://en.wikipedia.org/wiki/Julian_day ) from Gregorian Date
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inDate];
    int a = (14 - (int)[components month]) / 12;
    int y = (int)[components year] +  4800 - a;
    int m = (int)[components month] + (12 * a) - 3;
    int JulianDayNumber = (int)[components day] + (((153 * m) + 2) / 5) + (365 * y) + (y/4) - (y/100) + (y/400) - 32045;
    return JulianDayNumber;
}

+ (NSDate *)dateFromJulianDayNumber:(double)julianDayValue
{
    // calculation of Gregorian date from Julian Day Number ( http://en.wikipedia.org/wiki/Julian_day )
    int JulianDayNumber = (int)floor(julianDayValue);
    int J = floor(JulianDayNumber + 0.5);
    int j = J + 32044;
    int g = j / 146097;
    int dg = j - (j/146097) * 146097; // mod
    int c = (dg / 36524 + 1) * 3 / 4;
    int dc = dg - c * 36524;
    int b = dc / 1461;
    int db = dc - (dc/1461) * 1461; // mod
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
    double timeValue = ((julianDayValue - floor(julianDayValue)) + 0.5) * 24;
    components.hour = (int)floor(timeValue);
    double minutes = (timeValue - floor(timeValue)) * 60;
    components.minute = (int)floor(minutes);
    components.second = (int)((minutes - floor(minutes)) * 60);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *returnDate = [calendar dateFromComponents:components];
    return returnDate;
}

@end
