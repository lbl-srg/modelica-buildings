within Buildings.ThermalZones.Detailed.BaseClasses;
partial function PartialsendParameters
  "Partial function to send parameters from Modelica to external CFD solver"
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
<p>
Partial function to call a C function to conduct the data exchange between
Modelica and CFD or ISAT program during the coupled simulation.
</p>
</html>",   revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialsendParameters;
