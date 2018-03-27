within Buildings.ThermalZones.Detailed.BaseClasses;
function cfdCloseThread "Close CFD Thread"

external"C" cfdCloseThread() annotation (Include=
        "#include <cfdCloseThread.c>", IncludeDirectory=
        "modelica://Buildings/Resources/C-Sources");

  annotation (Documentation(info="<html>
<p>
This function calls a C function to send a stop command to CFD to stop the CFD simulation.</html>",
        revisions="<html>
<ul>
<li>
August 16, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

end cfdCloseThread;
