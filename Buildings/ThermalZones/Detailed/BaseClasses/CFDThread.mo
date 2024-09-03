within Buildings.ThermalZones.Detailed.BaseClasses;
class CFDThread "class used to handle CFD thread"
   extends ExternalObject;

   // constructor
   function constructor "allocate memeory for cosimulation variables"
    extends Modelica.Icons.Function;
    output CFDThread FFDThre "the handler of FFD thread";
    external"C" FFDThre = cfdcosim()   annotation (Include="#include <cfdcosim.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      LibraryDirectory="modelica://Buildings/Resources/Library", Library="ffd");
     annotation (Documentation(info="<html>
<p>
Constructor allocates memory for co-simulation variables when co-simulation starts
</html>",   revisions="<html>
<ul>
<li>
July, 2018, by Wei Tian and Xu Han:<br/>
First implementation.
</li>
</ul>
</html>"));
   end constructor;

   // destructor
   function destructor "release ffd.dll or ffd.so"
    extends Modelica.Icons.Function;
    input CFDThread FFDThre "the handler of FFD thread";
    external"C" cfdSendStopCommand(FFDThre) annotation (Include="#include <cfdSendStopCommand.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      LibraryDirectory="modelica://Buildings/Resources/Library", Library="ffd");
      annotation (Documentation(info="<html>
<p>
Destructor sends stop command to FFD and releases memory for co-simulation variables at the end of the simulation

</html>",   revisions="<html>
<ul>
<li>
July, 2018, by Wei Tian and Xu Han:<br/>
First implementation.
</li>
</ul>
</html>"));
   end destructor;
     annotation (Documentation(info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external function definition,
named <code>destructor</code> and <code>constructor</code> respectively.
To fix the issue FFD fails in JModelica tests due to unsupported OS #612.
</html>",   revisions="<html>
<ul>
<li>
July 27, 2018, by Wei Tian and Xu Han:<br/>
First implementation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/612\">issue 612</a>.
</li>
</ul>
</html>"));

end CFDThread;
