module hello;

import pyd.pyd;
import std.stdio;

void hello() {
    writefln("Hello, world!");
}

extern(C) export void PydMain() {
    def!(hello)();
    module_init("hello");
}
