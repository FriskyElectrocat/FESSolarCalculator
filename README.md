# FESSolarCalculator

Calculate sunrise, sunset, and twilight times for a given location.

## Goals

1. Given a location and a date provide:
    * Sunrise date and time for that location
        * may not be on that day
    * Sunset date and time for that location
        * may not be on that day
    * Dawn and Dusk times for that location:
        * Official
        * Civil
        * Nautical
        * Astronomical
2. Allow the user to disable some calculations (e.g., only calculate Official Twilight) when run.
3. Provide an easy way to get the information out.
4. Allow the user to view in local to the geolocation time or device time? (not sure about this yet)

## API

There is only one class: `FESSolarCalculator`

* need: basic calculation object with `-init`
    * can be given date and location objects later
* need: pass in date and time to get back new object with `-initWithDate:andLocation:`
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
* setting new date or location invalidates the current calculations
* provide isSunUp() method? Needs modification based on which zenith

## Automatic Reference Counting (ARC)

The source code in this repository uses Automatic Reference Counting. No plans exist to support non-ARC code at this time.


## License

This code is licensed under the MIT license. A little attribution in an about box would be nice, but is not mandatory. The license is reproduced below:

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
