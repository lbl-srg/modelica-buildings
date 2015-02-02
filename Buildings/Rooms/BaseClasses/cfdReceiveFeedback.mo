within Buildings.Rooms.BaseClasses;
function cfdReceiveFeedback "Receive the feedback from CFD"
  output Integer retVal
    "Return value of the function (0 indicates CFD successfully stopped.)";
external"C" retVal = cfdReceiveFeedback() annotation (Include=
        "#include <cfdReceiveFeedback.c>", IncludeDirectory=
        "modelica://Buildings/Resources/C-Sources");
  annotation (Documentation(info="<html>
<p>
This function calls a C function to receive the feedback from CFD about the status of performing a Stop command sent by Modelica.</html>",
        revisions="<html>
<ul>
<li>
August 16, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

end cfdReceiveFeedback;
