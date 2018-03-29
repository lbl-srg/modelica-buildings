within Buildings.Utilities.Plotters.BaseClasses;
function sendTerminalString "Function that prints the string to be added at the end of the html file"
  extends Modelica.Icons.Function;
  input Buildings.Utilities.Plotters.BaseClasses.Backend plt
    "Plot object";
  input String string "String to be printed";

  external "C" plotSendTerminalString(plt, string) annotation (
    Include="#include <plotSendTerminalString.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation (Documentation(info="<html>
<p>
External function that prints <code>string</code>
to the plot object.
The string will be added at the end of the html file.
</p>
</html>", revisions="<html>
<ul><li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end sendTerminalString;
