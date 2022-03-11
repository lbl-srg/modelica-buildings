within Buildings.ThermalZones.Detailed.BaseClasses;
class ISATThread "Class used to handle ISAT thread"
   extends ExternalObject;
   // constructor
   function constructor "Allocate memeory for cosimulation variables"
    output ISATThread ISATThre "Handler of ISAT thread";
    external "C" ISATThre = isatcosim()   annotation (Include="#include <isatcosim.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      LibraryDirectory="modelica://Buildings/Resources/Library", Library="isat");
     annotation (Documentation(info="<html>
<p>
Constructor allocates memory for co-simulation variables when co-simulation starts.
</p>
</html>",   revisions="<html>
<ul>
<li>
April 5, 2019, by Xu Han and Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
   end constructor;

   // destructor
   function destructor "Release isat library"
    input ISATThread ISATThre "Handler of ISAT thread";
    external"C" isatSendStopCommand(ISATThre) annotation (Include="#include <isatSendStopCommand.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      LibraryDirectory="modelica://Buildings/Resources/Library", Library="isat");
      annotation (Documentation(info="<html>
<p>
Destructor sends stop command to ISAT and releases memory for co-simulation variables at the end of the simulation.
</p>
</html>",   revisions="<html>
<ul>
<li>
April 5, 2019, by Xu Han and Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
   end destructor;
     annotation (Documentation(info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external function definition,
named <code>destructor</code> and <code>constructor</code> respectively.
</html>",   revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end ISATThread;
