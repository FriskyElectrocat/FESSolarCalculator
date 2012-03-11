//
//  SolarCalculatorExampleTests.m
//  SolarCalculatorExampleTests
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

#import "SolarCalculatorExampleTests.h"
#import <CoreLocation/CoreLocation.h>
#import "FESSolarCalculator.h"

@implementation SolarCalculatorExampleTests

@synthesize solarCalculation=_solarCalculation;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    _solarCalculation = nil;
}

- (void)testJulianDayNumber_1
{
    // 2000-01-01 == JDN 2451545
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [NSDateComponents new];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [components setYear:2000];
    [components setMonth:1];
    [components setDay:1];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *targetDate = [cal dateFromComponents:components];
    int JDN = [FESSolarCalculator julianDayNumberFromDate:targetDate];
//    int JDN = [self.solarCalculation julianDayNumberFromDate:targetDate];
    STAssertEquals(2451545, JDN, @"Known and computed Julian Dates don't match.");
}

- (void)testJulianDayNumber_2
{
    // JDN 2451545 == 2000-01-01
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [NSDateComponents new];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [components setYear:2000];
    [components setMonth:1];
    [components setDay:1];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *targetDate = [cal dateFromComponents:components];
    NSDate *computeDate = [FESSolarCalculator dateFromJulianDayNumber:2451545.0];
    STAssertEqualObjects(targetDate, computeDate, @"Date converted from Julian Day Number does not match known date.");
}

- (void)testJulianDayNumber_3
{
    // 2000-01-01 to JDN and back to NSDate
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [NSDateComponents new];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [components setYear:2000];
    [components setMonth:1];
    [components setDay:1];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *targetDate = [cal dateFromComponents:components];
    int JDN = [FESSolarCalculator julianDayNumberFromDate:targetDate];
    STAssertEquals(2451545, JDN, @"Known and computed Julian Dates don't match.");
    NSDate *computeDate = [FESSolarCalculator dateFromJulianDayNumber:(double)JDN];
    STAssertEqualObjects(targetDate, computeDate, @"Date converted from Julian Day Number does not match known date.");
}

- (void)testJulianDayNumber_4
{
    // 2012-03-05 == JDN 2455992
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [NSDateComponents new];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [components setYear:2012];
    [components setMonth:3];
    [components setDay:5];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *targetDate = [cal dateFromComponents:components];
    int JDN = [FESSolarCalculator julianDayNumberFromDate:targetDate];
    STAssertEquals(2455992, JDN, @"Known and computed Julian Dates don't match.");
}

- (void)testJulianDayNumber_5
{
    // 2455998.5929259909 == 2012-03-11 19:13:48 -0700
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [NSDateComponents new];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
    [components setYear:2012];
    [components setMonth:3];
    [components setDay:11];
    [components setHour:19];
    [components setMinute:13];
    [components setSecond:48];
    NSDate *targetDate = [cal dateFromComponents:components];
    NSDate *julianDate = [FESSolarCalculator dateFromJulianDayNumber:2455998.5929259909];
    STAssertEqualObjects(targetDate, julianDate, @"Known and computed Dates from Julian don't match.");
}

- (void)testResultsNotNil
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation];
    [[self solarCalculation] calculate];

    STAssertNotNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    STAssertNotNil([[self solarCalculation] sunset], @"sunset is nil after calculation run");
    STAssertNotNil([[self solarCalculation] solarNoon], @"solarNoon is nil after calculation run");
    STAssertNotNil([[self solarCalculation] civilDawn], @"civilDawn is nil after calculation run");
    STAssertNotNil([[self solarCalculation] civilDusk], @"civilDusk is nil after calculation run");
    STAssertNotNil([[self solarCalculation] nauticalDawn], @"nauticalDawn is nil after calculation run");
    STAssertNotNil([[self solarCalculation] nauticalDusk], @"nauticalDusk is nil after calculation run");
    STAssertNotNil([[self solarCalculation] astronomicalDawn], @"astronomicalDawn is nil after calculation run");
    STAssertNotNil([[self solarCalculation] astronomicalDusk], @"astronomicalDusk is nil after calculation run");
}

- (void)testInvalidateResultsByDate
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation];
    [[self solarCalculation] calculate];
    // setting the date should invalidate the previous results
    STAssertNotNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    [[self solarCalculation] setStartDate:startDate];
    
    STAssertNil([[self solarCalculation] sunrise], @"resetting date did not set sunrise to nil");
    STAssertNil([[self solarCalculation] sunset], @"resetting date did not set sunset to nil");
    STAssertNil([[self solarCalculation] solarNoon], @"resetting date did not set solarNoon to nil");
    STAssertNil([[self solarCalculation] civilDawn],  @"resetting date did not set civilDawn to nil");
    STAssertNil([[self solarCalculation] civilDusk], @"resetting date did not set civilDusk to nil");
    STAssertNil([[self solarCalculation] nauticalDawn], @"resetting date did not set nauticalDawn to nil");
    STAssertNil([[self solarCalculation] nauticalDusk], @"resetting date did not set nauticalDusk to nil");
    STAssertNil([[self solarCalculation] astronomicalDawn], @"resetting date did not set astronomicalDawn to nil");
    STAssertNil([[self solarCalculation] astronomicalDusk], @"resetting date did not set astronomicalDusk to nil");
}

- (void)testInvalidateResultsByLocation
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation];
    [[self solarCalculation] calculate];
    // setting the date should invalidate the previous results
    STAssertNotNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    [[self solarCalculation] setLocation:startLocation];
    
    STAssertNil([[self solarCalculation] sunrise], @"resetting date did not set sunrise to nil");
    STAssertNil([[self solarCalculation] sunset], @"resetting date did not set sunset to nil");
    STAssertNil([[self solarCalculation] solarNoon], @"resetting date did not set solarNoon to nil");
    STAssertNil([[self solarCalculation] civilDawn],  @"resetting date did not set civilDawn to nil");
    STAssertNil([[self solarCalculation] civilDusk], @"resetting date did not set civilDusk to nil");
    STAssertNil([[self solarCalculation] nauticalDawn], @"resetting date did not set nauticalDawn to nil");
    STAssertNil([[self solarCalculation] nauticalDusk], @"resetting date did not set nauticalDusk to nil");
    STAssertNil([[self solarCalculation] astronomicalDawn], @"resetting date did not set astronomicalDawn to nil");
    STAssertNil([[self solarCalculation] astronomicalDusk], @"resetting date did not set astronomicalDusk to nil");
}

- (void)testMaskAll
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation mask:FESSolarCalculationAll];
    [[self solarCalculation] calculate];
    
    STAssertNotNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    STAssertNotNil([[self solarCalculation] sunset], @"sunset is nil after calculation run");
    STAssertNotNil([[self solarCalculation] solarNoon], @"solarNoon is nil after calculation run");
    STAssertNotNil([[self solarCalculation] civilDawn], @"civilDawn is nil after calculation run");
    STAssertNotNil([[self solarCalculation] civilDusk], @"civilDusk is nil after calculation run");
    STAssertNotNil([[self solarCalculation] nauticalDawn], @"nauticalDawn is nil after calculation run");
    STAssertNotNil([[self solarCalculation] nauticalDusk], @"nauticalDusk is nil after calculation run");
    STAssertNotNil([[self solarCalculation] astronomicalDawn], @"astronomicalDawn is nil after calculation run");
    STAssertNotNil([[self solarCalculation] astronomicalDusk], @"astronomicalDusk is nil after calculation run");
}

- (void)testMaskOfficialOnly
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation mask:FESSolarCalculationOfficial];
    [[self solarCalculation] calculate];
    
    STAssertNotNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    STAssertNotNil([[self solarCalculation] sunset], @"sunset is nil after calculation run");
    STAssertNotNil([[self solarCalculation] solarNoon], @"solarNoon is nil after calculation run");
    STAssertNil([[self solarCalculation] civilDawn],  @"resetting date did not set civilDawn to nil");
    STAssertNil([[self solarCalculation] civilDusk], @"resetting date did not set civilDusk to nil");
    STAssertNil([[self solarCalculation] nauticalDawn], @"resetting date did not set nauticalDawn to nil");
    STAssertNil([[self solarCalculation] nauticalDusk], @"resetting date did not set nauticalDusk to nil");
    STAssertNil([[self solarCalculation] astronomicalDawn], @"resetting date did not set astronomicalDawn to nil");
    STAssertNil([[self solarCalculation] astronomicalDusk], @"resetting date did not set astronomicalDusk to nil");
}

- (void)testMaskCivilOnly
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation mask:FESSolarCalculationCivil];
    [[self solarCalculation] calculate];
    
    STAssertNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    STAssertNil([[self solarCalculation] sunset], @"sunset is nil after calculation run");
    STAssertNotNil([[self solarCalculation] solarNoon], @"solarNoon is nil after calculation run");
    STAssertNotNil([[self solarCalculation] civilDawn],  @"resetting date did not set civilDawn to nil");
    STAssertNotNil([[self solarCalculation] civilDusk], @"resetting date did not set civilDusk to nil");
    STAssertNil([[self solarCalculation] nauticalDawn], @"resetting date did not set nauticalDawn to nil");
    STAssertNil([[self solarCalculation] nauticalDusk], @"resetting date did not set nauticalDusk to nil");
    STAssertNil([[self solarCalculation] astronomicalDawn], @"resetting date did not set astronomicalDawn to nil");
    STAssertNil([[self solarCalculation] astronomicalDusk], @"resetting date did not set astronomicalDusk to nil");
}

- (void)testMaskNauticalOnly
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation mask:FESSolarCalculationNautical];
    [[self solarCalculation] calculate];
    
    STAssertNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    STAssertNil([[self solarCalculation] sunset], @"sunset is nil after calculation run");
    STAssertNotNil([[self solarCalculation] solarNoon], @"solarNoon is nil after calculation run");
    STAssertNil([[self solarCalculation] civilDawn],  @"resetting date did not set civilDawn to nil");
    STAssertNil([[self solarCalculation] civilDusk], @"resetting date did not set civilDusk to nil");
    STAssertNotNil([[self solarCalculation] nauticalDawn], @"resetting date did not set nauticalDawn to nil");
    STAssertNotNil([[self solarCalculation] nauticalDusk], @"resetting date did not set nauticalDusk to nil");
    STAssertNil([[self solarCalculation] astronomicalDawn], @"resetting date did not set astronomicalDawn to nil");
    STAssertNil([[self solarCalculation] astronomicalDusk], @"resetting date did not set astronomicalDusk to nil");
}

- (void)testMaskAstronomicalOnly
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation mask:FESSolarCalculationAstronomical];
    [[self solarCalculation] calculate];
    
    STAssertNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    STAssertNil([[self solarCalculation] sunset], @"sunset is nil after calculation run");
    STAssertNotNil([[self solarCalculation] solarNoon], @"solarNoon is nil after calculation run");
    STAssertNil([[self solarCalculation] civilDawn],  @"resetting date did not set civilDawn to nil");
    STAssertNil([[self solarCalculation] civilDusk], @"resetting date did not set civilDusk to nil");
    STAssertNil([[self solarCalculation] nauticalDawn], @"resetting date did not set nauticalDawn to nil");
    STAssertNil([[self solarCalculation] nauticalDusk], @"resetting date did not set nauticalDusk to nil");
    STAssertNotNil([[self solarCalculation] astronomicalDawn], @"resetting date did not set astronomicalDawn to nil");
    STAssertNotNil([[self solarCalculation] astronomicalDusk], @"resetting date did not set astronomicalDusk to nil");
}

- (void)testMaskCombined_0
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation mask:FESSolarCalculationOfficial | FESSolarCalculationCivil | FESSolarCalculationNautical | FESSolarCalculationAstronomical];
    [[self solarCalculation] calculate];
    
    STAssertNotNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    STAssertNotNil([[self solarCalculation] sunset], @"sunset is nil after calculation run");
    STAssertNotNil([[self solarCalculation] solarNoon], @"solarNoon is nil after calculation run");
    STAssertNotNil([[self solarCalculation] civilDawn],  @"resetting date did not set civilDawn to nil");
    STAssertNotNil([[self solarCalculation] civilDusk], @"resetting date did not set civilDusk to nil");
    STAssertNotNil([[self solarCalculation] nauticalDawn], @"resetting date did not set nauticalDawn to nil");
    STAssertNotNil([[self solarCalculation] nauticalDusk], @"resetting date did not set nauticalDusk to nil");
    STAssertNotNil([[self solarCalculation] astronomicalDawn], @"resetting date did not set astronomicalDawn to nil");
    STAssertNotNil([[self solarCalculation] astronomicalDusk], @"resetting date did not set astronomicalDusk to nil");
}

- (void)testMaskCombined_1
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation mask: FESSolarCalculationCivil | FESSolarCalculationAstronomical];
    [[self solarCalculation] calculate];
    
    STAssertNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    STAssertNil([[self solarCalculation] sunset], @"sunset is nil after calculation run");
    STAssertNotNil([[self solarCalculation] solarNoon], @"solarNoon is nil after calculation run");
    STAssertNotNil([[self solarCalculation] civilDawn],  @"resetting date did not set civilDawn to nil");
    STAssertNotNil([[self solarCalculation] civilDusk], @"resetting date did not set civilDusk to nil");
    STAssertNil([[self solarCalculation] nauticalDawn], @"resetting date did not set nauticalDawn to nil");
    STAssertNil([[self solarCalculation] nauticalDusk], @"resetting date did not set nauticalDusk to nil");
    STAssertNotNil([[self solarCalculation] astronomicalDawn], @"resetting date did not set astronomicalDawn to nil");
    STAssertNotNil([[self solarCalculation] astronomicalDusk], @"resetting date did not set astronomicalDusk to nil");
}

- (void)testKnownDateLocation_0
{
    // run a calculation for a known date and location with recorded sunrise and sunet times
    // date: Sun 2012-02-19
    // location: Oakland, CA (37 46.3' N, 122 13.4' W) [37.771667 -122.223333]
    // Dawn, Astronomical: 05:27 PST
    // Dawn, Nautical: 05:58 PST
    // Dawn, Civil: 06:28 PST
    // Sunrise: 06:55 PST
    // Solar noon: 12:24 PST
    // Sunset: 17:52 PST
    // Dusk, Civil: 18:19 PST
    // Dusk, Nautical: 18:50 PST
    // Dusk, Astronomical: 19:20 PST
    
    // NOTE: Seconds had to be added to the values below
    
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
    [components setYear:2012];
    [components setMonth:2];
    [components setDay:19];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *startDate = [gregorian dateFromComponents:components];

    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation];
    [[self solarCalculation] calculate];
    
    NSDate *compareDate;
    
    // sunrise
    [components setHour:6];
    [components setMinute:55];
    [components setSecond:39];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] sunrise], compareDate, @"Known and generated sunrise date/time don't match");

    // sunset
    [components setHour:17];
    [components setMinute:52];
    [components setSecond:47];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] sunset], compareDate, @"Known and generated sunset date/time don't match");

    // solar noon
    [components setHour:12];
    [components setMinute:24];
    [components setSecond:13];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] solarNoon], compareDate, @"Known and generated solar noon date/time don't match");

    // civil dawn
    [components setHour:6];
    [components setMinute:28];
    [components setSecond:55];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] civilDawn], compareDate, @"Known and generated civil dawn date/time don't match");

    // civil dusk
    [components setHour:18];
    [components setMinute:19];
    [components setSecond:31];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] civilDusk], compareDate, @"Known and generated civil dusk date/time don't match");
    
    // nautical dawn
    [components setHour:5];
    [components setMinute:58];
    [components setSecond:17];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] nauticalDawn], compareDate, @"Known and generated nautical dawn date/time don't match");
    
    // nautical dusk
    [components setHour:18];
    [components setMinute:50];
    [components setSecond:8];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] nauticalDusk], compareDate, @"Known and generated nautical dusk date/time don't match");

    // astronomical dawn
    [components setHour:5];
    [components setMinute:27];
    [components setSecond:53];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] astronomicalDawn], compareDate, @"Known and generated astronomical dawn date/time don't match");
    
    // astronomical dusk
    [components setHour:19];
    [components setMinute:20];
    [components setSecond:33];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] astronomicalDusk], compareDate, @"Known and generated astronomical dusk date/time don't match");

}

- (void)testKnownDateLocation_1
{
    // run a calculation for a known date and location with recorded sunrise and sunet times
    // date: Sun 2012-03-11
    // location: Oakland, CA (37 46.3' N, 122 13.4' W) [37.771667 -122.223333]
    // Dawn, Astronomical: 05:59:12 PDT
    // Dawn, Nautical: 06:29:50 PDT
    // Dawn, Civil: 07:00:15 PDT
    // Sunrise: 07:26:25 PDT
    // Solar noon: 13:20:07 PDT
    // Sunset: 19:13:48 PDT
    // Dusk, Civil: 19:39:59 PDT
    // Dusk, Nautical: 20:10:23 PDT
    // Dusk, Astronomical: 20:41:01 PDT
        
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:37.771667 longitude:-122.223333];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
    [components setYear:2012];
    [components setMonth:3];
    [components setDay:11];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *startDate = [gregorian dateFromComponents:components];
    
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation];
    [[self solarCalculation] calculate];
    
    NSDate *compareDate;
    
    // sunrise
    [components setHour:7];
    [components setMinute:26];
    [components setSecond:25];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] sunrise], compareDate, @"Known and generated sunrise date/time don't match");
    
    // sunset
    [components setHour:19];
    [components setMinute:13];
    [components setSecond:48];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] sunset], compareDate, @"Known and generated sunset date/time don't match");
    
    // solar noon
    [components setHour:13];
    [components setMinute:20];
    [components setSecond:7];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] solarNoon], compareDate, @"Known and generated solar noon date/time don't match");
    
    // civil dawn
    [components setHour:7];
    [components setMinute:0];
    [components setSecond:15];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] civilDawn], compareDate, @"Known and generated civil dawn date/time don't match");
    
    // civil dusk
    [components setHour:19];
    [components setMinute:39];
    [components setSecond:59];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] civilDusk], compareDate, @"Known and generated civil dusk date/time don't match");
    
    // nautical dawn
    [components setHour:6];
    [components setMinute:29];
    [components setSecond:50];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] nauticalDawn], compareDate, @"Known and generated nautical dawn date/time don't match");
    
    // nautical dusk
    [components setHour:20];
    [components setMinute:10];
    [components setSecond:23];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] nauticalDusk], compareDate, @"Known and generated nautical dusk date/time don't match");
    
    // astronomical dawn
    [components setHour:5];
    [components setMinute:59];
    [components setSecond:12];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] astronomicalDawn], compareDate, @"Known and generated astronomical dawn date/time don't match");
    
    // astronomical dusk
    [components setHour:20];
    [components setMinute:41];
    [components setSecond:1];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([[self solarCalculation] astronomicalDusk], compareDate, @"Known and generated astronomical dusk date/time don't match");
    
}

@end
