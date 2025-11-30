# Test the functions provided by human_datetime_py
from datetime import datetime
import human_datetime_py as hdt

if __name__ == "__main__":
    year: str = str(datetime.now().year)
    month: int = datetime.now().month
    day: str = str(datetime.now().day).zfill(2)
    hh: str = str(datetime.now().hour).zfill(2)
    mm: str = str(datetime.now().minute).zfill(2)
    ss: str = str(datetime.now().second).zfill(2)

    isoformat: str = datetime.now().isoformat()
    shortformat: str = f"{day} {hdt.get_short_month(month)} {year} {hh}:{mm}:{ss} GMT"
    print()
    print(f"GMT is equivalent to {hdt.get_timezone_str('GMT')}")
    lpy_2024 = "2024 was a leap year" if hdt.is_leap_year(2024) else "2024 wasn't a leap year"
    print(lpy_2024)
    lpy_2025 = "2025 was a leap year" if hdt.is_leap_year(2025) else "2025 was not a leap year"
    print(lpy_2025)
    feb_2024 = "In 2024, February had 29 days" if hdt.days_in_feb(2024) == 29 else "In 2024, February had 28 days"
    print(feb_2024)
    feb_2025 = "In 2025, February had 29 days" if hdt.days_in_feb(2025) == 29 else "In 2025, February had 28 days"
    print(feb_2025)
    days_2024 = "2024 had 366 days" if hdt.days_in_year(2024) == 366 else "2024 had 365 days"
    print(days_2024)
    days_2025 = "2025 had 366 days" if hdt.days_in_year(2025) == 366 else "2025 had 365 days"
    print(days_2025)
    print(f"This month's short name is {hdt.get_short_month(month)}.")
    print(f"This month's long name is {hdt.get_long_month(month)}.")
    print()
    print(f"The date/time for EET is {hdt.convert_datetime_str_to_timezone(shortformat, 'EET')} (shortformat).")
    print()
    print(f"The date/time for EET is {hdt.isoformat_to_timezone(isoformat, 'EET')} (isoformat).")
    print()
    print(f"The name of the timezone for EET is {hdt.get_named_timezone('EET')}.")
    print()
    print(shortformat)
    print(f"Unix time is {hdt.human_str_to_unix(shortformat)} from shortformat.")
    print()
    print(isoformat)
    print(f"Unix time is {hdt.isoformat_to_unix(isoformat)} from isoformat.")
    print()
    print("From shortformat:")
    hdt.human_datetime_str_summary(shortformat)
    print()
    print("From isoformat:")
    hdt.isoformat_summary(isoformat)
    print()
    print(f"Unix time is {hdt.unix_now()} (unix_now).")
    print()
    print(f"Equivalent timezone for Europe/London: {hdt.get_equivalent_timezone_str_from_iana('Europe/London', month)}")
    print(f"Timezone for Europe/London: {hdt.get_timezone_str_from_iana('Europe/London', month)}")
