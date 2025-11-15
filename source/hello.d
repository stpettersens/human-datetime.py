module hello;

import pyd.pyd;
import std.stdio;

void hello() {
    writefln("Hello from D!");
}

int add(int a, int b) {
    return (a + b);
}

export extern(C) void PydMain() {
    def!(hello)();
    def!(add)();
    module_init();
}
