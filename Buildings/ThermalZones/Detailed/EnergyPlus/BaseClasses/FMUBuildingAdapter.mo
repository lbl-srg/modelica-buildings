within Buildings.ThermalZones.Detailed.EnergyPlus.BaseClasses;
class FMUBuildingAdapter "Class used to couple the FMU"
extends ExternalObject;
    function constructor
      "Construct an extendable array that can be used to store double values"
      input String fmuName "Name of the FMU file";
      output FMUBuildingAdapter adapter;

      external "C" adapter = FMUBuildingInit(fmuName)
      annotation(Include="#include <FMUBuildingInit.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources");

      annotation(Documentation(info="<html>
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

  function destructor "Release storage of table and close the external object"
    input FMUBuildingAdapter adapter;
    external "C" FMUBuildingFree(adapter)
    annotation(Include=" #include <FMUBuildingFree.c>",
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
of the data structure needed to communicate with EnergyPlus.

</html>",
revisions="<html>
<ul>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FMUBuildingAdapter;
