within Buildings.ThermalZones.Detailed.BaseClasses;
function isatStartCosimulation
  "Start the coupled simulation with ISAT"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialStartCosimulation;

external"C" retVal = isatStartCosimulation(
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
    rho_start) annotation (Include="#include <isatStartCosimulation.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      LibraryDirectory="modelica://Buildings/Resources/Library", Library="isat");

  annotation (Documentation(info="<html>
<p>
This function calls a C function to start the coupled simulation with ISAT.</html>",
        revisions="<html>
<ul>
<li>
November 1, 2019, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end isatStartCosimulation;
