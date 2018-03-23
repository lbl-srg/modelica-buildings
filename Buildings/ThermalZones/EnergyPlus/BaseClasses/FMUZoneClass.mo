within Buildings.ThermalZones.EnergyPlus.BaseClasses;
class FMUZoneClass "Class used to couple the FMU"
extends ExternalObject;
  function constructor
    "Construct to connect to a thermal zone in EnergyPlus"
    input String fmuName "Name of the FMU";
    input String zoneName "Name of the thermal zone";
    input Integer nFluPor "Number of fluid ports of zone";
    input Integer nVarSen "Number of variables sent to EnergyPlus";
    input String[:] varNamSen "Names of variables sent to EnergyPlus";
    //input Integer[:] valRefVarSen "Value references of variables sent to EnergyPlus";
    input Integer nVarRec "Number of variables received from EnergyPlus";
    input String[:] varNamRec "Names of variables received from EnergyPlus";
    input Integer[:] valRefVarRec "Value references of variables received from EnergyPlus";
    output FMUZoneClass adapter;
    //       external "C" adapter = FMUZoneInit(fmuName, zoneName, nFluPor,
    //         nVarSen, varNamSen, valRefVarSen, nVarRec, varNamRec, valRefVarRec)
    //       annotation(Include="#include <FMUZoneInit.c>",
    //       IncludeDirectory="modelica://Buildings/Resources/C-Sources");

  external"C" adapter = FMUZoneInit(
        fmuName,
        zoneName,
        nFluPor) annotation (Include="#include <FMUZoneInit.c>",
        IncludeDirectory="modelica://Buildings/Resources/C-Sources");


    annotation (Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>FMUBuildingAdapter</code> that
will be used to store the data structure needed to communicate with EnergyPlus.
</p>
</html>", revisions="<html>
<ul>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end constructor;

  function destructor "Release storage"
    input FMUZoneClass adapter;
    external "C" FMUZoneFree(adapter)
    annotation(Include=" #include <FMUZoneFree.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>ExtendableArray</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end destructor;
annotation(Documentation(info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external function definition,
named <code>destructor</code> and <code>constructor</code> respectively.
<p>
These functions create and release an external object that allows the storage
of the data structure needed to communicate with the EnergyPlus FMU.

</html>",
revisions="<html>
<ul>
<li>
March 21, 2018, by Thierry S. Nouidui:<br/>
Revised implementation for efficiency.
</li>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FMUZoneClass;
