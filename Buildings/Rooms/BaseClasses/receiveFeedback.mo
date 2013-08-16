within Buildings.Rooms.BaseClasses;
function receiveFeedback "Receive the feedback from CFD "
  output Integer flag;
external"C" flag = stopCosim();
  annotation (Include="#include <interface_ffd.h>", Library="ModelicaInterface");

end receiveFeedback;
