within Buildings.Utilities.Plotters.BaseClasses;
function sendReal "Function that sends an array of Real values to be written to the html file"
  extends Modelica.Icons.Function;
  input Buildings.Utilities.Plotters.BaseClasses.Backend plt
    "Plot object";
  input Real[:] x "Array of Real values to be sent to printer";

  external "C" plotSendReal(plt, x) annotation (
    Include="#include <plotSendReal.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation (Documentation(info="<html>
<p>
External function that prints the array of Real values <code>x</code>
to the plot object.
The number of elements in <code>x</code> is declared in the contructor
<a href=\"modelica://Buildings.Utilities.Plotters.BaseClasses.Backend\">
Buildings.Utilities.Plotters.BaseClasses.Backend</a>.
</p>
</html>", revisions="<html>
<ul><li>
March 27, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end sendReal;
