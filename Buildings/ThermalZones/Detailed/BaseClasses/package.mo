within Buildings.ThermalZones.Detailed;
package BaseClasses "Package with base classes for Buildings.ThermalZones.Detailed"
  extends Modelica.Icons.BasesPackage;


  partial function PartialsendParameters
  "Partial function sendParameters from Modelica to external sovler"
    input String cfdFilNam "CFD input file name";
    input String[nSur] name "Surface names";
    input Modelica.SIunits.Area[nSur] A "Surface areas";
    input Modelica.SIunits.Angle[nSur] til "Surface tilt";
    input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions[nSur] bouCon
      "Type of boundary condition";
    input Integer nPorts(min=0)
      "Number of fluid ports for the HVAC inlet and outlets";
    input String portName[nPorts]
      "Names of fluid ports as declared in the CFD input file";
    input Boolean haveSensor "Flag, true if the model has at least one sensor";
    input String sensorName[nSen]
      "Names of sensors as declared in the CFD input file";
    input Boolean haveShade "Flag, true if the windows have a shade";
    input Integer nSur(min=2) "Number of surfaces";
    input Integer nSen(min=0)
      "Number of sensors that are connected to CFD output";
    input Integer nConExtWin(min=0)
      "number of exterior construction with window";
    input Boolean verbose "Set to true for verbose output";
    input Integer nXi
      "Number of independent species concentration of the inflowing medium";
    input Integer nC "Number of trace substances of the inflowing medium";
    input Boolean haveSource
      "Flag, true if the model has at least one source";
    input Integer nSou(min=0)
      "Number of sources that are connected to CFD output";
    input String sourceName[nSou]
      "Names of sources as declared in the CFD input file";
    input Modelica.SIunits.Density rho_start "Density at initial state";
protected
    Integer coSimFlag=0;

    annotation (Documentation(info="<html>
<p>Partial model for the function that calls a C function to conduct the data exchange between Modelica and CFD or ISAT program during the coupled simulation.</p>
</html>",   revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

  end PartialsendParameters;

  partial function Partialexchange "Partial function exchange"
    input Integer flag "Communication flag to write to CFD";
    input Modelica.SIunits.Time t "Current simulation time in seconds to write";
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
<p>Partial model for the function that conducts the data exchange between Modelica and CFD or ISAT program during the coupled simulation.</p>
</html>",   revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

  end Partialexchange;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.ThermalZones.Detailed\">Buildings.ThermalZones.Detailed</a>.
</p>
</html>"));
end BaseClasses;
