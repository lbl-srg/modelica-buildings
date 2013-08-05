within Buildings.Rooms.BaseClasses;
function createSharedMemory "Create shared memory and set the parameters"

  input String[nSur] name "Surface names"; //Fixme: need to add nPorts
  input Modelica.SIunits.Area[nSur] A "Surface areas";
  input Modelica.SIunits.Angle[nSur] til "Surface tilt";
  input Buildings.Rooms.Types.CFDBoundaryConditions[nSur] bouCon
    "Type of boundary condition";
  input Integer nPorts(min=0)
    "Number of fluid ports for the HVAC inlet and outlets";
  input String portName[nPorts]
    "Names of fluid ports as declared in the CFD input file";
  input Boolean haveSensor "Flag, true if the model has at least one sensor";
  input String sensorName[nSen]
    "Names of sensors as declared in the CFD input file";
  input Boolean haveShade "Flag, true if the windows have a shade";
  input Integer nSur "Number of surfaces";
  input Integer nSen(min=0)
    "Number of sensors that are connected to CFD output";
  input Integer nConExtWin( min=0)
    "number of exterior construction  with window";

external"C" instantiate(name, A, til, bouCon, nPorts, portName, haveSensor, sensorName, haveShade, nSur, nSen, nConExtWin);
  annotation (Include="#include <interface_ffd.h>", Library=
        "ModelicaInterface");

end createSharedMemory;
