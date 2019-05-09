within Buildings.Experimental.EnergyPlus.BaseClasses;
class FMUZoneClass "Class used to couple the FMU"
extends ExternalObject;
  function constructor
    "Construct to connect to a thermal zone in EnergyPlus"
    input String idfName "Name of the IDF";
    input String weaName "Name of the weather file";
    input String iddName "Name of the IDD file";
    //    input String epLibName "Name of the Energyplus FMI library";
    input String zoneName "Name of the thermal zone";
    input String fmuName
      "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)";
    output FMUZoneClass adapter;
    external "C" adapter = ZoneAllocate(
      idfName,
      weaName,
      iddName,
      zoneName,
      fmuName)
        annotation (
          IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
          Include="#include \"ZoneAllocate.c\"",
          Library={"fmilib_shared", "dl"});
          // dl provides dlsym to load EnergyPlus dll, which is needed by OpenModelica compiler

    annotation (Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>adapter</code> that
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
    external "C" ZoneFree(adapter)
        annotation (
          IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
          Include="#include \"ZoneFree.c\"");

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
April 04, 2018, by Thierry S. Nouidui:<br/>
Added additional parameters for parametrizing
the EnergyPlus model.
</li>
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
