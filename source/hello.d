module hello;

import pyd.pyd;
import std.stdio;

void hello() {
    writefln("Hello, world!");
}

export extern(C) void PydMain() {
    def!(hello)();
    module_init();
}
