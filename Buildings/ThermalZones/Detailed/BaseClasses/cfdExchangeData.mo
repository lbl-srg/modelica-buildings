within Buildings.ThermalZones.Detailed.BaseClasses;
function cfdExchangeData "Exchange data between CFD and Modelica"
  extends Modelica.Icons.Function;
  input Integer flag "Communication flag to CFD";
  input Modelica.Units.SI.Time t "Current Modelica simulation time to CFD";
  input Modelica.Units.SI.Time dt(min=100*Modelica.Constants.eps)
    "Requested synchronization time step size";
  input Real[nU] u "Input to CFD";
  input Integer nU "Number of inputs to CFD";
  input Integer nY "Number of outputs from CFD";
  output Modelica.Units.SI.Time modTimRea "Current model time from CFD";
  output Real[nY] y "Output computed by CFD";
  output Integer retVal "Return value for CFD simulation status";
external"C" retVal = cfdExchangeData(
    t,
    dt,
    u,
    nU,
    nY,
    modTimRea,
    y) annotation (Include="#include <cfdExchangeData.c>", IncludeDirectory=
        "modelica://Buildings/Resources/C-Sources");
  annotation (Documentation(info="<html>
<p>
This function calls a C function to conduct the data exchange between Modelica and CFD program during the coupled simulation.</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

end cfdExchangeData;
