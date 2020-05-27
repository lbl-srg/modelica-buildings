within Buildings.Obsolete.Utilities.IO;
package Python27 "Package to call Python functions"
  extends Modelica.Icons.VariantsPackage;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains blocks and functions that embed Python 2.7 in Modelica.
Data can be sent to Python functions and received from Python functions.
This allows for example data analysis in Python as part of a Modelica model,
or data exchange as part of a hardware-in-the-loop simulation in which
Python is used to communicate with hardware.
</p>
<p>
See
<a href=\"modelica://Buildings.Obsolete.Utilities.IO.Python27.UsersGuide\">
Buildings.Obsolete.Utilities.IO.Python27.UsersGuide</a>
for instruction.
</p>
</html>",revisions="<html>
<ul>
<li>
March 06, 2020, by Jianjun Hu:<br/>
Moved from <code>Buildings.Utilities.IO</code> to here.<br/>
This is for
<a href=\"https://github.com/Buildings/modelica-Buildings/issues/1760\"> #1760</a>.
</li>
</ul>
</html>"));
end Python27;
