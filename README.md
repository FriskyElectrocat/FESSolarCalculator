# FESSolarCalculator

Calculate sunrise, sunset, and twilight times for a given location and date.

## Goals

1. Given a location and a date provide:
    * Sunrise date and time for that location
    * Sunset date and time for that location
    * Solar Noon date and time (when the sun is overhead)
    * Dawn and Dusk times for that location:
        * Official
        * Civil
        * Nautical
        * Astronomical
2. Allow the user to disable some calculations (e.g., only calculate Official Twilight) when run.
3. Provide an easy way to get the information out.

## API

There is only one class: `FESSolarCalculator`

* pass in date and time to get back new object with `-initWithDate:location:`
* limit what calculations are done with `-initWithDate:location:mask:`
    * see the `FESSolarCalculationType` enum for the types of calculations
* property readwrite: NSDate date
* property readwrite: CLLocation location
* property readonly: NSDate sunrise (Official)
* property readonly: NSDate sunset (Official)
* property readonly: NSDate solarNoon
* property readonly: NSDate civilDawn
* property readonly: NSDate civilDusk
* property readonly: NSDate nauticalDawn
* property readonly: NSDate nauticalDusk
* property readonly: NSDate astronomicalDawn
* property readonly: NSDate astronomicalDusk

## Precision

The precision is likely around three minutes, mostly due to approximation. Also, this calculation does not take into account the effect of air temperature, altitude, etc. Together, these may affect the time by 5 minutes or more. This is likely not what you need if you are in need of a very precise solar calculation.

Note that dates prior to 01 January 2000 GMT are not guarenteed to return correct results at this time.

## Automatic Reference Counting (ARC)

The source code in this repository uses Automatic Reference Counting. No plans exist to support non-ARC code at this time.

## License

This code is licensed under the MIT license. The license is reproduced below.
If a non-attribution license is required contact Dan Weeks for details:

Copyright © 2012 Daniel Weeks.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
