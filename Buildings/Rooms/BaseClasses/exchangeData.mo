within Buildings.Rooms.BaseClasses;
function exchangeData "Exchange data between FFD and Modelica"
  input Integer flag "Communication flag to write to FFD";
  input Modelica.SIunits.Time t "Current simulation time in seconds to write";
  input Modelica.SIunits.Time dt(min=100*Modelica.Constants.eps)
    "Requested time step length";
  input Real[nU] u "Input for FFD";
  input Integer nU "Number of inputs for FFD";
  input Integer nY "Number of outputs from FFD";
  output Modelica.SIunits.Time simTimRea
    "Current simulation time in seconds read from FFD";
  output Real[nY] y "Output computed by FFD";
  output Integer retVal;
external"C" retVal = exchangeData(
    t,
    dt,
    u,
    nU,
    nY,
    simTimRea,
    y);
  annotation (Include="#include <interface_ffd.h>", Library="ModelicaInterface");

end exchangeData;
