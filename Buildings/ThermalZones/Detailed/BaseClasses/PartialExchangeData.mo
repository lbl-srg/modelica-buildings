within Buildings.ThermalZones.Detailed.BaseClasses;
partial function PartialExchangeData
  "Partial model for Exchanging data between CFD and Modelica"
  input Integer flag "Communication flag to CFD";
  input Modelica.SIunits.Time t "Current Modelica simulation time to CFD";
  input Modelica.SIunits.Time dt(min=100*Modelica.Constants.eps)
    "Requested synchronization time step size";
  input Real[nU] u "Input to CFD";
  input Integer nU "Number of inputs to CFD";
  input Integer nY "Number of outputs from CFD";
  output Modelica.SIunits.Time modTimRea "Current model time from CFD";
  output Real[nY] y "Output computed by CFD";
  output Integer retVal "Return value for CFD simulation status";

  annotation (Documentation(info="<html>
<p>Partial model for the function that calls a C function to conduct the data exchange between Modelica and CFD or ISAT program during the coupled simulation.</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

end PartialExchangeData;
