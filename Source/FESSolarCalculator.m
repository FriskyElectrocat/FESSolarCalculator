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
-(void)calculate;

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
        _startDate = inDate;
        _location = inLocation;
    }
    [self calculate];
    return self;
}

- (id)initWithDate:(NSDate *)inDate location:(CLLocation *)inLocation mask:(FESSolarCalculationType)inMask
{
    self = [self init];
    if (self) {
        _startDate = inDate;
        _location = inLocation;
        _operationsMask = inMask;
    }
    [self calculate];
    return self;
}

#pragma mark -
#pragma mark Property Ops

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
#pragma mark Calculation

- (void)calculate
{
    // math in this method comes directly from http://users.electromagnetic.net/bu/astro/sunrise-set.php
    // with a change to calculate twilight times as well (that information comes from
    // http://williams.best.vwh.net/sunrise_sunset_algorithm.htm ). The math in the first url
    // is sourced from http://www.astro.uu.nl/~strous/AA/en/reken/zonpositie.html which no longer exists
    // but a copy was found on the Wayback Machine at
    // http://web.archive.org/web/20110723172451/http://www.astro.uu.nl/~strous/AA/en/reken/zonpositie.html
    // All constants can be referenced and are explained on the archive.org page
    
    // run the calculations based on the users criteria at initalization time
    int JulianDayNumber = [FESSolarCalculator julianDayNumberFromDate:self.startDate];
    double JanuaryFirst2000JDN = 2451545.0;
    
    // this formula requires west longitude, thus 75W = 75, 45E = -45
    // convert to get it there
    double westLongitude = self.location.coordinate.longitude * -1.0;
    
    // define some of our mathmatical values;
    double Nearest = 0.0;
    double ElipticalLongitudeOfSun = 0.0;
    double ElipticalLongitudeRadians = ElipticalLongitudeOfSun * toRadians;
    double MeanAnomoly = 0.0;
    double MeanAnomolyRadians = MeanAnomoly * toRadians;
    double MAprev = -1.0;
    double Jtransit = 0.0;
    
    // we loop through our calculations for Jtransit
    // Running the loop the first time we then re-run it with Jtransit
    // as the input to refine MeanAnomoly. Once MeanAnomoly is equal
    // to the previous run's MeanAnomoly calculation we can continue
    while (MeanAnomoly != MAprev) {
        MAprev = MeanAnomoly;
        Nearest = round(((double)JulianDayNumber - JanuaryFirst2000JDN - 0.0009) - (westLongitude/360.0));
        double Japprox = JanuaryFirst2000JDN + 0.0009 + (westLongitude/360.0) + Nearest;
        if (Jtransit != 0.0) {
            Japprox = Jtransit;
        }
        double Ms = (357.5291 + 0.98560028 * (Japprox - JanuaryFirst2000JDN));
        MeanAnomoly = fmod(Ms, 360.0);
        MeanAnomolyRadians = MeanAnomoly * toRadians;
        double EquationOfCenter = (1.9148 * sin(MeanAnomolyRadians)) + (0.0200 * sin(2.0 * (MeanAnomolyRadians))) + (0.0003 * sin(3.0 * (MeanAnomolyRadians)));
        double eLs = (MeanAnomoly + 102.9372 + EquationOfCenter + 180.0);
        ElipticalLongitudeOfSun = fmod(eLs, 360.0);
        ElipticalLongitudeRadians = ElipticalLongitudeOfSun * toRadians;
        if (Jtransit == 0.0) {
            Jtransit = Japprox + (0.0053 * sin(MeanAnomolyRadians)) - (0.0069 * sin(2.0 * ElipticalLongitudeRadians));
        }
    }
    
    double DeclinationOfSun = asin( sin(ElipticalLongitudeRadians) * sin(23.45 * toRadians) ) * toDegrees;
    double DeclinationOfSunRadians = DeclinationOfSun * toRadians;
    
    // We now have solar noon for our day
    _solarNoon = [FESSolarCalculator dateFromJulianDayNumber:Jtransit];
    
    // create a block to run our per-zenith calculations based on solar noon
    void (^computeSolarData)(FESSolarCalculationType, double) = ^(FESSolarCalculationType calculationType, double zenith) {
        double H1 = (cos(zenith * toRadians) - sin(self.location.coordinate.latitude * toRadians) * sin(DeclinationOfSunRadians));
        double H2 = (cos(self.location.coordinate.latitude * toRadians) * cos(DeclinationOfSunRadians));
        double HourAngle = acos( (H1  * toRadians) / (H2  * toRadians) ) * toDegrees;

        double Jss = JanuaryFirst2000JDN + 0.0009 + ((HourAngle + westLongitude)/360.0) + Nearest;
        
        // compute the setting time from Jss approximation
        double Jset = Jss + (0.0053 * sin(MeanAnomolyRadians)) - (0.0069 * sin(2.0 * ElipticalLongitudeRadians));
        // calculate the rise time based on solar noon and the set time
        double Jrise = Jtransit - (Jset - Jtransit);        
        
        // assign the rise and set dates to the correct properties
        NSDate *riseDate = [FESSolarCalculator dateFromJulianDayNumber:Jrise];
        NSDate *setDate = [FESSolarCalculator dateFromJulianDayNumber:Jset];
        if ((calculationType & FESSolarCalculationOfficial) == FESSolarCalculationOfficial) {
            _sunrise = riseDate;
            _sunset = setDate;
        } else if ((calculationType & FESSolarCalculationCivil) == FESSolarCalculationCivil) {
            _civilDawn = riseDate;
            _civilDusk = setDate;
        } else if ((calculationType & FESSolarCalculationNautical) == FESSolarCalculationNautical) {
            _nauticalDawn = riseDate;
            _nauticalDusk = setDate;
        } else if ((calculationType & FESSolarCalculationAstronomical) == FESSolarCalculationAstronomical) {            
            _astronomicalDawn = riseDate;
            _astronomicalDusk = setDate;
        }
    };
    
    // figure out which operations to work on
    FESSolarCalculationType theseOps = self.operationsMask;
    if ((self.operationsMask & FESSolarCalculationAll) == FESSolarCalculationAll) {
        theseOps = FESSolarCalculationOfficial | FESSolarCalculationCivil | FESSolarCalculationNautical | FESSolarCalculationAstronomical;
    }
    if ((theseOps & FESSolarCalculationOfficial) == FESSolarCalculationOfficial) {
        computeSolarData(FESSolarCalculationOfficial, FESSolarCalculationZenithOfficial);
    }
    if ((theseOps & FESSolarCalculationCivil) == FESSolarCalculationCivil) {
        computeSolarData(FESSolarCalculationCivil, FESSolarCalculationZenithCivil);
    }
    if ((theseOps & FESSolarCalculationNautical) == FESSolarCalculationNautical) {
        computeSolarData(FESSolarCalculationNautical, FESSolarCalculationZenithNautical);
    }
    if ((theseOps & FESSolarCalculationAstronomical) == FESSolarCalculationAstronomical) {
        computeSolarData(FESSolarCalculationAstronomical, FESSolarCalculationZenithAstronomical);
    }
}

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
