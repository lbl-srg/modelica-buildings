within Buildings.Rooms.BaseClasses;
function launchFFD "Launch FFD simulation"

external"C" ffd_dll();
  annotation (Include="#include <ffd_dll.h>", Library=
        "FFD-DLL");

end launchFFD;
