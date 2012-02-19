//
//  FESSolarCalculator.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

enum {
    FESSolarCalculationOfficial     = 1 << 0, // zenith 90° 50'
    FESSolarCalculationCivil        = 1 << 1, // zenith 96°
    FESSolarCalculationNautical     = 1 << 2, // zenith 102°
    FESSolarCalculationAstronomical = 1 << 3, // zenith 108°
    FESSolarCalculationAll          = ~0      // all calculations
};
typedef NSUInteger FESSolarCalculation;

@interface FESSolarCalculator : NSObject

@property (nonatomic, readwrite) FESSolarCalculation operationsMask;  
@property (nonatomic, readwrite, strong, setter=setStartDate:) NSDate *startDate;
@property (nonatomic, readwrite, strong, setter=setLocation:) CLLocation *location;
@property (nonatomic, readonly, strong) NSDate *sunrise; // AKA Official
@property (nonatomic, readonly, strong) NSDate *sunset;  // AKA Official
@property (nonatomic, readonly, strong) NSDate *civilSunrise;
@property (nonatomic, readonly, strong) NSDate *civilSunset;
@property (nonatomic, readonly, strong) NSDate *nauticalSunrise;
@property (nonatomic, readonly, strong) NSDate *nauticalSunset;
@property (nonatomic, readonly, strong) NSDate *astronomicalSunrise;
@property (nonatomic, readonly, strong) NSDate *astronomicalSunset;

- (id)initWithDate:(NSDate *)inDate andLocation:(CLLocation *)inLocation;
- (void)calculate;

@end
