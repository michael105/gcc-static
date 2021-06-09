## gcc-static

When compiling statically linked binaries, quite often 
you have to change the Makefile, or end up calling gcc yourself with the compiled object files.
However, the linked (originally shared) libraries very often do have dependencies, not linked in;
what results in unresolved symbols.


So here is a quickly hacked script, which scans recursively for the dependencies 
of all linked shared libraries,
and calls gcc with according arguments to link against the static libraries (.a).


just call gcc-static.pl the way you'd call gcc, (or set CC to gcc-static.pl);
gcc-static.pl will call gcc with the needed arguments.



For linking statically, I'd also recommend sourcing all sourcefiles into 
a single file. (include the sources into e.g. src.c with #include directives)

This results most times in much smaller binaries with gcc.
(I'm not really sure why, obviously the optimizer can do a better job,
but this shouldnt't pay out with a sometimes 90% smaller binary.
Perhaps there are more gcc switches I'm missing?)





