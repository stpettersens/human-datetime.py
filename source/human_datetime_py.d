module human_datetime_pyd;

import pyd.pyd;
import human_datetime;

extern(C) void PydMain() {
    def!(get_timezone_str)();
    def!(is_leap_year)();
    def!(days_in_feb)();
    def!(days_in_year)();
    def!(get_short_month)();
    def!(get_long_month)();
    def!(human_str_to_unix)();
    def!(isoformat_to_timezone)();
    def!(isoformat_summary)();
    def!(isoformat_to_unix)();
    def!(unix_now)();
    module_init("human_datetime_pyd");
}
