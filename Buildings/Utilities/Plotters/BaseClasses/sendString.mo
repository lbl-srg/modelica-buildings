within Buildings.Utilities.Plotters.BaseClasses;
function sendString "Function that prints a string to the html file"
  extends Modelica.Icons.Function;
  input Buildings.Utilities.Plotters.BaseClasses.Backend plt
    "Plot object";
  input String string "String to be printed";

  external "C" plotSendString(plt, string) annotation (
    Include="#include <plotSendString.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation (Documentation(info="<html>
<p>
External function that prints <code>string</code>
to the plot object.
</p>
</html>", revisions="<html>
<ul><li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end sendString;
