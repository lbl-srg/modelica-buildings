within Buildings.ThermalZones.Detailed.BaseClasses;
function cfdStartCosimulation "Start the coupled simulation with CFD"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialStartCosimulation;

external"C" retVal = cfdStartCosimulation(
    cfdFilNam,
    name,
    A,
    til,
    bouCon,
    nPorts,
    portName,
    haveSensor,
    sensorName,
    haveShade,
    nSur,
    nSen,
    nConExtWin,
    nXi,
    nC,
    haveSource,
    nSou,
    sourceName,
    rho_start) annotation (Include="#include <cfdStartCosimulation.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      LibraryDirectory="modelica://Buildings/Resources/Library", Library="ffd");

  annotation (Documentation(info="<html>
<p>
This function calls a C function to start the coupled simulation with CFD.</html>",
revisions="<html>
<ul>
<li>
November 1, 2019, by Xu Han, Wangda Zuo:<br/>
Changed structure.
</li>
<li>
August 16, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

end cfdStartCosimulation;
