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

- (void)testResultsNotNil
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:27.771667 longitude:-122.223333];
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
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:27.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation];
    [[self solarCalculation] calculate];
    // setting the date should invalidate the previous results
    STAssertNotNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    [[self solarCalculation] setStartDate:startDate];
    
    STAssertEqualObjects([[self solarCalculation] sunrise], nil, @"resetting date did not set sunrise to nil");
    STAssertEqualObjects([[self solarCalculation] sunset], nil, @"resetting date did not set sunset to nil");
    STAssertEqualObjects([[self solarCalculation] solarNoon], nil, @"resetting date did not set solarNoon to nil");
    STAssertEqualObjects([[self solarCalculation] civilDawn], nil, @"resetting date did not set civilDawn to nil");
    STAssertEqualObjects([[self solarCalculation] civilDusk], nil, @"resetting date did not set civilDusk to nil");
    STAssertEqualObjects([[self solarCalculation] nauticalDawn], nil, @"resetting date did not set nauticalDawn to nil");
    STAssertEqualObjects([[self solarCalculation] nauticalDusk], nil, @"resetting date did not set nauticalDusk to nil");
    STAssertEqualObjects([[self solarCalculation] astronomicalDawn], nil, @"resetting date did not set astronomicalDawn to nil");
    STAssertEqualObjects([[self solarCalculation] astronomicalDusk], nil, @"resetting date did not set astronomicalDusk to nil");
}

- (void)testInvalidateResultsByLocation
{
    NSDate *startDate = [NSDate date];
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:27.771667 longitude:-122.223333];
    _solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation];
    [[self solarCalculation] calculate];
    // setting the date should invalidate the previous results
    STAssertNotNil([[self solarCalculation] sunrise], @"sunrise is nil after calculation run");
    [[self solarCalculation] setLocation:startLocation];
    
    STAssertEqualObjects([[self solarCalculation] sunrise], nil, @"resetting date did not set sunrise to nil");
    STAssertEqualObjects([[self solarCalculation] sunset], nil, @"resetting date did not set sunset to nil");
    STAssertEqualObjects([[self solarCalculation] solarNoon], nil, @"resetting date did not set solarNoon to nil");
    STAssertEqualObjects([[self solarCalculation] civilDawn], nil, @"resetting date did not set civilDawn to nil");
    STAssertEqualObjects([[self solarCalculation] civilDusk], nil, @"resetting date did not set civilDusk to nil");
    STAssertEqualObjects([[self solarCalculation] nauticalDawn], nil, @"resetting date did not set nauticalDawn to nil");
    STAssertEqualObjects([[self solarCalculation] nauticalDusk], nil, @"resetting date did not set nauticalDusk to nil");
    STAssertEqualObjects([[self solarCalculation] astronomicalDawn], nil, @"resetting date did not set astronomicalDawn to nil");
    STAssertEqualObjects([[self solarCalculation] astronomicalDusk], nil, @"resetting date did not set astronomicalDusk to nil");
}

- (void)testKnownDateLocation_0
{
    // run a calculation for a known date and location with known sunrise and sunet times
    // calculated at http://www.sunrisesunset.com/
    // date: Sun 2012-02-19
    // location: Oakland, CA (37 46.3' N, 122 13.4' W) [37.771667 -122.223333]
    // Twilight, Astronomical: 05:27
    // Twilight, Nautical: 05:58
    // Twilight, Civil: 06:28
    // Sunrise: 06:55
    // Solar noon: 12:23
    // Sunset: 17:51
    // Twilight, Civil: 18:17
    // Twilight, Nautical: 18:48
    // Twilight, Astronomical: 19:18
    // Day length: 10h 56m
    
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:27.771667 longitude:-122.223333];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:2012];
    [components setMonth:2];
    [components setDay:19];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *startDate = [gregorian dateFromComponents:components];

    FESSolarCalculator *solarCalculation = [[FESSolarCalculator alloc] initWithDate:startDate location:startLocation];
    
    NSDate *compareDate;
    // sunrise
    [components setHour:6];
    [components setMinute:55];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([solarCalculation sunrise], compareDate, @"Known and generated sunrise date/time don't match");

    // sunset
    [components setHour:17];
    [components setMinute:51];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([solarCalculation sunset], compareDate, @"Known and generated sunset date/time don't match");

    // solar noon
    [components setHour:12];
    [components setMinute:23];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([solarCalculation solarNoon], compareDate, @"Known and generated solar noon date/time don't match");

    // civil dawn
    [components setHour:6];
    [components setMinute:28];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([solarCalculation civilDawn], compareDate, @"Known and generated civil dawn date/time don't match");

    // civil dusk
    [components setHour:18];
    [components setMinute:17];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([solarCalculation civilDusk], compareDate, @"Known and generated civil dusk date/time don't match");
    
    // nautical dawn
    [components setHour:5];
    [components setMinute:58];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([solarCalculation nauticalDawn], compareDate, @"Known and generated nautical dawn date/time don't match");
    
    // nautical dusk
    [components setHour:18];
    [components setMinute:48];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([solarCalculation nauticalDusk], compareDate, @"Known and generated nautical dusk date/time don't match");

    // astronomical dawn
    [components setHour:5];
    [components setMinute:27];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([solarCalculation astronomicalDawn], compareDate, @"Known and generated astronomical dawn date/time don't match");
    
    // astronomical dusk
    [components setHour:19];
    [components setMinute:18];
    compareDate = [gregorian dateFromComponents:components];
    STAssertEqualObjects([solarCalculation astronomicalDusk], compareDate, @"Known and generated astronomical dusk date/time don't match");

}

@end
