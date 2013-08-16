within Buildings.Rooms.BaseClasses;
function sendStopComannd "Send the stop command to CFD"

  output Integer flag;
external"C" flag = sendStopCommand();
  annotation (Include="#include <interface_ffd.h>", Library="ModelicaInterface");

end sendStopComannd;
