/* Simple functions for working with human readable dates and times for D (dlang).
   Written by Sam Saint-Pettersen, 2025.

   Released to Public domain. Use as you wish.
*/

module human_datetime;

import std.uni;
import std.stdio;
import std.array;
import std.format;
import std.datetime;
import std.datetime.timezone;
import std.conv : to;

import iana : zones;

struct DateTimeTZ {
    int day;
    int month;
    int year;
    int hh;
    int mm;
    int ss;
    Tz tz;
    string timezone;
    bool error;
}

enum HumanDateStyle {
    DD_MON_YYYY = 0,
    MON_DD_YYYY = 1,
    YYYY_MON_DD = 2,

    DD_MONTH_YYYY = 3,
    MONTH_DD_YYYY = 4,
    YYYY_MONTH_DD = 5,

    DD_MM_YYYY = 6,
    MM_DD_YYYY = 7,
    YYYY_MM_DD = 8,

    DD_MM_YY = 9,
    MM_DD_YY = 10,
    YY_MM_DD = 11,

    DASHED_YYYY_MON_DD = 12,
    ISO_FORMAT = 13 // This is {YYYY}-{MM}-{DD}T{HH}:{MM}:{SS}.{MS}
}

enum ShortMonth {
    JAN = 1,
    FEB = 2,
    MAR = 3,
    APR = 4,
    MAY = 5,
    JUN = 6,
    JUL = 7,
    AUG = 8,
    SEP = 9,
    OCT = 10,
    NOV = 11,
    DEC = 12
}

enum LongMonth {
    JANUARY = 1,
    FEBRUARY = 2, // 28 or 29 days.
    MARCH = 3,
    APRIL = 4, // 30 days.
    MAY = 5,
    JUNE = 6, // 30 days.
    JULY = 7,
    AUGUST = 8,
    SEPTEMBER = 9, // 30 days.
    OCTOBER = 10,
    NOVEMBER = 11, // 30 days.
    DECEMBER = 12
}

enum Tz : float {
    IDLW = -12,
    SST = -11,
    HST = -10,
    UTC95 = -9.5,
    AKST = -9,
    PST = -8,
    MST = -7,
    CST = -6,
    EST = -5,
    EDT = -4,
    NST = -3.5,
    ART = -3,
    NDT = -2.5,
    GST = -2,
    CVT = -1,
    UTC = 0,
    CET = 1,
    EET = 2,
    AST = 3, // Arab Standard Time, use AsT for Atlantic Standard Time.
    IRST = 3.5,
    AMT = 4,
    AFT = 4.5,
    PKT = 5,
    IST = 5.5,
    NPT = 5.75,
    OMST = 6,
    MMT = 6.5,
    KRAT = 7,
    IRKST = 8,
    ACWST = 8.75,
    YAKT = 9,
    ACST = 9.5,
    VLAT = 10,
    ACDT = 10.5,
    MAGT = 11,
    PET = 12,
    CHAsT = 12.75,
    WST = 13,
    CHADT = 13.75,
    LINT = 14
}

bool in_summer_time(string iana_timezone, int month) {
    if (month > 3 && month < 11)
        return true;

    return false;
}

Tz get_timezone_from_iana(string iana_timezone, int month) {
    try {
        if (in_summer_time(iana_timezone, month)) {
            return get_timezone(zones[iana_timezone].summer);
        }
        return get_timezone(zones[iana_timezone].tz);
    }
    catch (Exception e) {
        writefln("Invalid IANA timezone: %s", iana_timezone);
        if (in_summer_time("Europe/London", month)) {
            return Tz.CET;
        }
        return Tz.UTC;
    }
}

string get_equivalent_timezone_str_from_iana(string iana_timezone, int month) {
    return to!string(get_timezone_from_iana(iana_timezone, month));
}

string get_timezone_str_from_iana(string iana_timezone, int month) {
    try {
        if (in_summer_time(iana_timezone, month)) {
            return to!string(zones[iana_timezone].summer);
        }
        return to!string(zones[iana_timezone].tz);
    }
    catch (Exception e) {
        writefln("Invalid IANA timezone: %s", iana_timezone);
        if (in_summer_time("Europe/London", month)) {
            return "BST";
        }
        return to!string(Tz.UTC);
    }
}

Tz get_timezone(string timezone) {
    Tz tz = Tz.UTC;

    // Map equivalent timezones to the mAsTer Tz enum.
    // All - or + offsets to UTC.
    switch (timezone) {
        case "CKT":
        case "TAHT":
            tz = Tz.HST; // - 10
            break;

        case "GMT-9.5":
        case "UTC-9.5":
            tz = Tz.UTC95; // - 9.5
            break;

        case "HDT":
        case "GMT-9":
        case "UTC-9":
            tz = Tz.AKST; // - 9
            break;

        case "AKDT":
        case "GMT-8":
        case "UTC-8":
            tz = Tz.PST; // - 8
            break;

        case "PDT":
        case "GMT-7":
        case "UTC-7":
            tz = Tz.MST; // - 7
            break;

        case "MDT":
        case "GALT":
        case "EAST":
        case "GMT-6":
        case "UTC-6":
            tz = Tz.CST; // - 6
            break;

        case "ACT":
        case "CDT":
        case "COT":
        case "EADT":
        case "ECT":
        case "PET":
        case "GMT-5":
        case "UTC-5":
            tz = Tz.EST; // -5
            break;

        case "VET":
        case "CLDT":
        case "PYT":
        case "AsT": // Atlantic Standard Time
        case "GYT":
        case "BOT":
        case "GMT-4":
        case "UTC-4":
            tz = Tz.EDT; // -4
            break;

        case "ADT":
        case "AMST":
        case "ART":
        case "BRT":
        case "CLST":
        case "FKST":
        case "GFT":
        case "PMST":
        case "PYST":
        case "ROTT":
        case "SRT":
        case "UYT":
        case "WGST":
        case "CLT":
        case "GMT-3":
        case "UTC-3":
            tz = Tz.ART; // -3
            break;

        case "WGT":
        case "FNT":
        case "PMDT":
            tz = Tz.GST; // -2
            break;

        case "AZOT":
        case "EGT":
            tz = Tz.CVT; // -1
            break;

        case "Z":
        case "GMT":
        case "WET":
        case "AZOST":
        case "EGST":
        case "GMT-0":
        case "GMT+0":
        case "UTC-0":
        case "UTC+0":
            tz = Tz.UTC; // 0
            break;

        case "BST":
        case "WAT":
        case "WEST":
        case "IsT": // Irish Standard Time
        case "MET":
        case "GMT+1":
        case "UTC+1":
            tz = Tz.CET; // + 1
            break;

        case "CAT":
        case "CEST":
        case "KALT":
        case "SAST":
        case "WAST":
        case "EGY":
        case "MEST":
        case "GMT+2":
        case "UTC+2":
            tz = Tz.EET; // + 2
            break;

        case "EEST":
        case "MSK":
        case "IDT":
        case "FET":
        case "EGYST":
        case "TRT":
        case "EAT":
        case "GMT+3":
        case "UTC+3":
            tz = Tz.AST; // + 3
            break;

        case "AZT":
        case "GET":
        case "GST":
        case "MUT":
        case "RET":
        case "SAMT":
        case "SCT":
        case "VOLT":
        case "MSK+1":
        case "GMT+4":
        case "UTC+4":
            tz = Tz.AMT; // + 4
            break;

        case "HMT":
        case "MAWT":
        case "MVT":
        case "ORAT":
        case "TFT":
        case "TJT":
        case "TMT":
        case "UZT":
        case "YEKT":
        case "QYZT":
        case "GMT+5":
        case "UTC+5":
            tz = Tz.PKT; // + 5
            break;

        case "SLST":
            tz = Tz.IST; // + 5.5
            break;

        case "BTT":
        case "XJT":
        case "KGT":
        case "IOT":
        case "GMT+6":
        case "UTC+6":
            tz = Tz.OMST; // + 6
            break;

        case "GMT+6.5":
        case "UTC+6.5":
            tz = Tz.MMT; // + 6.5
            break;

        case "ICT":
        case "IWST":
        case "HOVT":
        case "NOVT":
        case "WIB":
        case "DAVT":
        case "CXT":
        case "GMT+7":
        case "UTC+7":
            tz = Tz.KRAT; // + 7
            break;

        case "AWST":
        case "BNT":
        case "CST":
        case "ICST":
        case "MYT":
        case "CHOT":
        case "ULAT":
        case "PHT":
        case "TST":
        case "WITA":
        case "SGT":
        case "HKT":
        case "IRKT":
        case "GMT+8":
        case "UTC+8":
            tz = Tz.IRKST; // + 8
            break;

        case "TLT":
        case "IEST":
        case "JST":
        case "PWT":
        case "KST":
        case "WIT":
        case "GMT+9":
        case "UTC+9":
            tz = Tz.YAKT; // + 9
            break;

        case "AEST":
        case "CHUT":
        case "PGT":
        case "ChST":
        case "DDUT":
        case "GMT+10":
        case "UTC+10":
            tz = Tz.VLAT; // + 10
            break;

        case "AEDT":
        case "LHST":
        case "PONT":
        case "SAKT":
        case "SRET":
        case "SBT":
        case "VUT":
        case "NFT":
        case "LHDT":
        case "KOST":
        case "NUT":
        case "NCT":
        case "GMT+11":
        case "UTC+11":
            tz = Tz.MAGT; // + 11
            break;

        case "PETT":
        case "FJT":
        case "GILT":
        case "MHT":
        case "NRT":
        case "TVT":
        case "NFDT":
        case "ANAT":
        case "WFT":
        case "NZST":
        case "GMT+12":
        case "UTC+12":
            tz = Tz.PET; // + 12
            break;

        case "GMT+12.75":
        case "UTC+12.75":
            tz = tz.CHAsT; // + 12.75
            break;

        case "NZDT":
        case "TOT":
        case "TKT":
        case "GMT+13":
        case "UTC+13":
            tz = Tz.WST; // + 13
            break;

        case "GMT+13.75":
        case "UTC+13.75":
            tz = Tz.CHADT; // + 13.75
            break;

         case "GMT+14":
         case "UTC+14":
            tz = Tz.LINT; // + 14
            break;

        default: // Resolve as is.
            tz = to!Tz(timezone.toUpper);
            break;
    }

    return tz;
}

string get_timezone_str(string timezone) {
    return to!string(get_timezone(timezone));
}

bool is_leap_year(int year) {
    bool leap = false;
    if (year % 4 == 0)
        leap = true;

    if (year % 100 == 0 && year % 400 != 0)
        leap = false;

    return leap;
}

int days_in_feb(int year) {
    return is_leap_year(year) ? 29 : 28;
}

int days_in_year(int year) {
    return is_leap_year(year) ? 366 : 365;
}

DateTimeTZ create_datetime_tz(string human_datetime, HumanDateStyle style) {
    DateTimeTZ date;
    long unixtime = 0L;

    if (style == HumanDateStyle.DASHED_YYYY_MON_DD) {
        human_datetime = human_datetime.replace("-", " ");
        style = HumanDateStyle.YYYY_MON_DD;
    }
    else if (style == HumanDateStyle.ISO_FORMAT) {
        human_datetime = human_datetime.replace("T", " ");
        human_datetime = human_datetime.replace("-", " ").split(".")[0];
        style = HumanDateStyle.YYYY_MM_DD;
    }

    string[] in_date = human_datetime.split();
    int d = 0;
    int m = 0;
    int y = 0;

    int hh = 0;
    int mm = 0;
    int ss = 0;

    Tz tz = Tz.UTC; // Default to UTC.
    string timezone = "UTC";

    try {
        if (in_date.length == 5) {
            tz = get_timezone(in_date[4]);
            timezone = in_date[4].toUpper;
        }

        switch (style) {
            case HumanDateStyle.DD_MON_YYYY:
                d = to!int(in_date[0]);
                m = to!ShortMonth(in_date[1].toUpper);
                y = to!int(in_date[2]);
                break;

            case HumanDateStyle.MON_DD_YYYY:
                m = to!ShortMonth(in_date[0].toUpper);
                d = to!int(in_date[1]);
                y = to!int(in_date[2]);
                break;

            case HumanDateStyle.YYYY_MON_DD:
                y = to!int(in_date[0]);
                m = to!ShortMonth(in_date[1].toUpper);
                d = to!int(in_date[2]);
                break;

            case HumanDateStyle.DD_MONTH_YYYY:
                d = to!int(in_date[0]);
                m = to!LongMonth(in_date[1].toUpper);
                y = to!int(in_date[2]);
                break;

            case HumanDateStyle.MONTH_DD_YYYY:
                m = to!LongMonth(in_date[0].toUpper);
                d = to!int(in_date[1]);
                y = to!int(in_date[2]);
                break;

            case HumanDateStyle.YYYY_MONTH_DD:
                y = to!int(in_date[0]);
                m = to!LongMonth(in_date[1].toUpper);
                d = to!int(in_date[2]);
                break;

            case HumanDateStyle.DD_MM_YYYY:
                d = to!int(in_date[0]);
                m = to!int(in_date[1]);
                y = to!int(in_date[2]);
                break;

            case HumanDateStyle.MM_DD_YYYY:
                m = to!int(in_date[0]);
                d = to!int(in_date[1]);
                y = to!int(in_date[2]);
                break;

            case HumanDateStyle.YYYY_MM_DD:
                y = to!int(in_date[0]);
                m = to!int(in_date[1]);
                d = to!int(in_date[2]);
                break;

            // Short year dates start at 2000 and end at 2099
            // (i.e. 00 is 2000 and 99 is 2099).
            case HumanDateStyle.DD_MM_YY:
                d = to!int(in_date[0]);
                m = to!int(in_date[1]);
                y = (2000 + to!int(in_date[2]));
                break;

            case HumanDateStyle.MM_DD_YY:
                m = to!int(in_date[0]);
                d = to!int(in_date[1]);
                y = (2000 + to!int(in_date[2]));
                break;

            case HumanDateStyle.YY_MM_DD:
                y = (2000 + to!int(in_date[0]));
                m = to!int(in_date[1]);
                d = to!int(in_date[2]);
                break;

            default:
                break;
        }

        // February constraints.
        if (m == 2) {
            int feb_days = days_in_feb(y);
            if (d > feb_days || d < 1)
                throw new Exception(format("February in %d can only have 1-%d days.", y, feb_days));
        }

        // April, June, September, November contraints.
        if ((d > 30 || d < 1) && (m == 4 || m == 6 || m == 9 || m == 11)) {
            throw new Exception("April, June, September or November can only have 1-30 days.");
        }

        // Any other month constraints.
        if (d > 31 || d < 1) {
            throw new Exception("A month can only have 1-31 days.");
        }

        string[] time = in_date[3].split(':');

        hh = to!int(time[0]);
        mm = to!int(time[1]);
        ss = to!int(time[2]);

        if (hh < 0 || hh > 23) {
            throw new Exception("Hour must be between 0-23.");
        }

        if (mm < 0 || mm > 59) {
            throw new Exception("Minutes must be between 0-59.");
        }

        if (ss < 0 || ss > 59) {
            throw new Exception("Seconds must be between 0-59.");
        }
    }
    catch (Exception e) {
        writeln("Invalid date and/or time provided.");
        writeln(e);
        date.error = true;
        return date;
    }

    date.year = y;
    date.month = m;
    date.day = d;
    date.hh = hh;
    date.mm = mm;
    date.ss = ss;
    date.tz = tz;
    date.timezone = timezone;
    date.error = false;
    return date;
}

string get_short_month(int month) {
    ShortMonth m = to!ShortMonth(month);
    string mon = to!string(m);
    return format("%s%s", mon[0], mon[1 .. $].toLower);
}

string get_long_month(int month) {
    LongMonth m = to!LongMonth(month);
    string mon = to!string(m);
    return format("%s%s", mon[0], mon[1 .. $].toLower);
}

string get_iso_8601_date(DateTimeTZ date) {
    return format("%04d-%02d-%02d", date.year, date.mm, date.day);
}

string get_time_24hrs(DateTimeTZ date) {
    return format("%02d:%02d:%02d", date.hh, date.mm, date.ss);
}

string get_time_12hrs(DateTimeTZ date) {
    return "!TODO";
}

DateTimeTZ convert_datetime_to_timezone(DateTimeTZ date, string target_timezone) {
    if (date.tz == get_timezone(target_timezone))
        return date; // No conversion.

    date.timezone = target_timezone;

    Tz target = get_timezone(target_timezone);

    int hours = date.hh;
    int mins = date.mm;

    double shift = to!double(target);
    double fr = (shift - to!int(shift));

    int offset_hrs = cast(int)target;
    double offset_mins = (shift - to!int(shift)) * 60;

    if (offset_mins >= 30) offset_hrs++;

    writefln("Shift = %.2f", shift);
    writefln("Offset hours = %d, Offset mins = %.2f", offset_hrs, offset_mins);
    writeln();

    date.hh = (((hours + offset_hrs) % 24 + 24) % 24);
    date.mm = (((mins + to!int(offset_mins)) % 60 + 60) % 60);

    // TODO
    //date.year
    //date.month
    //date.day

    return date;
}

DateTimeTZ convert_datetime_to_utc(DateTimeTZ date) {
    if (date.tz == Tz.UTC)
        return date; // No conversion.

    return convert_datetime_to_timezone(date, "UTC");
}

string convert_datetime_to_timezone(string human_datetime, HumanDateStyle style, string target_timezone) {
    DateTimeTZ date = create_datetime_tz(human_datetime, style);
    if (date.error)
        return "-1";

    date = convert_datetime_to_timezone(date, target_timezone);
    return format("%04d-%02d-%02d %02d:%02d:%02d %s",
    date.year, date.month, date.day, date.hh, date.mm, date.ss, date.timezone);
}

string convert_datetime_to_timezone(string human_datetime, string target_timezone) {
    return convert_datetime_to_timezone(human_datetime, HumanDateStyle.DD_MON_YYYY, target_timezone);
}

string convert_datetime_str_to_timezone(string human_datetime, string target_timezone) {
    return convert_datetime_to_timezone(human_datetime, target_timezone);
}

string isoformat_to_timezone(string isoformat, string target_timezone) {
    return convert_datetime_to_timezone(isoformat, HumanDateStyle.ISO_FORMAT, target_timezone);
}

// Print a human readable summary of a date and time.
int human_datetime_summary(string human_datetime, HumanDateStyle style) {
    DateTimeTZ date = create_datetime_tz(human_datetime, style);
    if (date.error)
        return -1;

    writeln("** Human Readable Date Time Summary **");
    writefln("The year is %d", date.year);
    writefln("There are %d days in this year.", days_in_year(date.year));
    writefln("February this year has %d days.", days_in_feb(date.year));
    writefln("The short month is %s.", get_short_month(date.month));
    writefln("The long month is %s.", get_long_month(date.month));
    writefln("The month number is %d.", date.month);
    writefln("The day number is %d.", date.day);
    writefln("The ISO 8601 date is %s.", get_iso_8601_date(date));
    writefln("The time given is %s.", get_time_24hrs(date));
    writefln("The timezone given was %s.", date.timezone);
    writefln("This is equivalent to %s.", to!string(date.tz));
    writefln("The offset to UTC is %.2f.", date.tz);

    return 0;
}

int human_datetime_summary(string human_datetime) {
    return human_datetime_summary(human_datetime, HumanDateStyle.DD_MON_YYYY);
}

int human_datetime_str_summary(string human_datetime) {
    return human_datetime_summary(human_datetime, HumanDateStyle.DD_MON_YYYY);
}

// Use long as return type as this supports unix timestamps
// beyond year 2038.
long human_to_unix(string human_datetime, HumanDateStyle style) {
    DateTimeTZ date = create_datetime_tz(human_datetime, style);
    if (date.error)
        return -1;

    // Unix time constraint.
    if (date.year < 1970) {
        writeln("Error: Dates before 1970 cannot be used to determine Unix timestamp.");
        return -1;
    }

    // Convert date time to UTC as necessary.
    date = convert_datetime_to_utc(date);

    long unixtime = SysTime(DateTime(date.year, date.month, date.day, date.hh, date.mm, date.ss),
    new immutable SimpleTimeZone(dur!"minutes"(0), date.timezone)).toUnixTime();

    return unixtime;
}

long human_to_unix(string human_datetime) {
    return human_to_unix(human_datetime, HumanDateStyle.DD_MON_YYYY);
}

long human_str_to_unix(string human_datetime) {
    return human_to_unix(human_datetime);
}

int isoformat_summary(string isoformat) {
    return human_datetime_summary(isoformat, HumanDateStyle.ISO_FORMAT);
}

long isoformat_to_unix(string isoformat) {
    return human_to_unix(isoformat, HumanDateStyle.ISO_FORMAT);
}

long unix_now() {
    auto now = Clock.currTime();
    return now.toUnixTime();
}
