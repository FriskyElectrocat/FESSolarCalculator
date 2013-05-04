//
//  CLLocation+FESGraticule.m
//  SolarCalculatorExample
//
//  Created by Dan Weeks on 2012-03-15.
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

#import "CLLocation+FESGraticule.h"

FESCLLocationCoordinate2D FESCLLocationCoordinate2DMake(FESCLLocationDegrees degrees, FESCLLocationMinutes minutes, FESCLLocationSeconds seconds)
{
    FESCLLocationCoordinate2D retValue;
    retValue.degrees = degrees;
    retValue.minutes = minutes;
    retValue.seconds = seconds;
    return retValue;
}

@implementation CLLocation (FESGraticule)

+ (CLLocation *)fes_initWithLatitude:(FESCLLocationCoordinate2D)latitude
                        andLongitude:(FESCLLocationCoordinate2D)longitude
{
    CLLocationDegrees latitudeDeg = [CLLocation fes_decimalDegreesForCoordinate:latitude];
    CLLocationDegrees longitudeDeg = [CLLocation fes_decimalDegreesForCoordinate:longitude];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitudeDeg longitude:longitudeDeg];
    return location;
}

+ (CLLocationDegrees)fes_decimalDegreesForCoordinate:(FESCLLocationCoordinate2D)coordinate
{

    NSInteger latitudeSign = 1;
    if (coordinate.degrees < 0){
        latitudeSign = -1;
    }
    CLLocationDegrees retDegrees = coordinate.degrees;
    retDegrees += latitudeSign * (coordinate.minutes / 60.);
    retDegrees += latitudeSign * (coordinate.seconds / 3600.);
    return retDegrees;
}

+ (FESCLLocationCoordinate2D)fes_coordinateForDecimalDegrees:(CLLocationDegrees)degrees_
{

    double seconds = round(fabs(degrees_ * 3600));
    double degrees = floor(seconds / 3600.0);
    if (degrees_ < 0.0) {
        degrees *= -1.0;
    }
    seconds = fmod(seconds, 3600.0);
    double minutes = seconds / 60.0;
    seconds = fmod(seconds, 60.0);

    return FESCLLocationCoordinate2DMake((FESCLLocationDegrees)degrees,
                                         (FESCLLocationMinutes)minutes,
                                         (FESCLLocationSeconds)seconds);
}

@end
