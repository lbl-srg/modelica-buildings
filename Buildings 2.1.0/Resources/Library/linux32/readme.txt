The files
  libpython2.7.so  libpython2.7.so.1.0
are stored here to allow running the Python examples
in Buildings.Utilities.IO.Python27 using
Dymola 2013 FD01 or Dymola 2014
on Linux Ubuntu 64 bit.

Dymola 2013 FD01 and Dymola 2014 generate 32 bit code,
and the examples in Buildings.Utilities.IO.Python27
require linking the executable to libpython2.7.so.

To run the examples in Dymola version prior to version 2014,
you also need to change dymola.sh.

See the user's guide Buildings.Utilities.IO.Python27.UsersGuide

April 2, 2013, mwetter@lbl.gov
