within Buildings.Utilities.Plotters.BaseClasses;
function print "Function that prints a string to the html file"
  extends Modelica.Icons.Function;
  input Buildings.Utilities.Plotters.BaseClasses.Backend plt
    "Plot object";
  input String string "String to be printed";
  input Boolean finalCall "Set to true for the last call, which will write the content to disk";

  external "C" plotPrint(plt, string, finalCall) annotation (Include="#include <plotPrint.c>",
                   IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation (Documentation(info="<html>
<p>
External function that prints the string <code>str</code>
to the plot object.
</p>
</html>", revisions="<html>
<ul><li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end print;
