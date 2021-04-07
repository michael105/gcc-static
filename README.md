## gcc-static

When compiling statically linked binaries, quite often 
the linked shared libraries do have dependencies, not linked in;
what results in unresolved symbols.


Here is a quickly hacked script, which scans recursively for the dependencies,
and calls gcc with all the libraries to link.

It's work in progress; but working now basically.

just call gcc-static.pl the way you'd call gcc, (or set CC to gcc-static.pl);
gcc-static.pl will call gcc with the needed arguments.



For linking statically, I'd also recommend sourcing all sourcefiles into 
a single file. (just include the sources into e.g. src.c with #include directives)

Somehow, this results in much smaller binaries with gcc.


This is just a working first "release"; feel free to change the script, and do a pull request.




