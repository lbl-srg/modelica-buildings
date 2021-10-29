within Buildings.ThermalZones.Detailed.BaseClasses;
partial function Partialexchange "Partial function exchange"
    input Integer flag "Communication flag to write to CFD";
    input Modelica.SIunits.Time t "Current model time in seconds to write";
    input Modelica.SIunits.Time dt(min=100*Modelica.Constants.eps)
      "Requested time step length";
    input Real[nU] u "Input for CFD";
    input Integer nU "Number of inputs for CFD";
    input Real[nY] yFixed "Fixed values (used for debugging only)";
    input Integer nY "Number of outputs from CFD";
    output Modelica.SIunits.Time modTimRea
      "Current model time in seconds read from CFD";
    input Boolean verbose "Set to true for verbose output";
    output Real[nY] y "Output computed by CFD";
    output Integer retVal
      "The exit value, which is negative if an error occurred";

    annotation (Documentation(info="<html>
<p>
Partial model for the function that conducts the data exchange between Modelica and CFD or ISAT program
during the coupled simulation.
</p>
</html>",   revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end Partialexchange;
