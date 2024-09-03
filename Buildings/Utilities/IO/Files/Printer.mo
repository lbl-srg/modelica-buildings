within Buildings.Utilities.IO.Files;
model Printer "Model that prints values to a file"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(
    firstTrigger(
      start=false,
      fixed=true));

  parameter String header="" "Header to be printed";
  parameter String fileName="" "File name (empty string is the terminal)";
  parameter Integer nin=1 "Number of inputs";
  parameter Integer configuration = 1
    "Index for treating final report (see documentation)";
  parameter Integer minimumLength =  1 "Minimum length of result string";
  parameter Integer significantDigits = 16 "Number of significant digits";
  Modelica.Blocks.Interfaces.RealInput x[nin] "Value to be printed"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

initial algorithm
  if (fileName <> "") then
    Modelica.Utilities.Files.removeFile(fileName);
  end if;
  Modelica.Utilities.Streams.print(fileName=fileName, string=header);
equation
  if configuration < 3 then
  when {sampleTrigger, initial()} then
      Buildings.Utilities.IO.Files.BaseClasses.printRealArray(
                                      x=x, fileName=fileName,
                                      minimumLength=minimumLength,
                                      significantDigits=significantDigits);
  end when;
  end if;
  when terminal() then
    if configuration >= 2 then
       Buildings.Utilities.IO.Files.BaseClasses.printRealArray(
                                      x=x, fileName=fileName,
                                      minimumLength=minimumLength,
                                      significantDigits=significantDigits);
   end if;
  end when;
  annotation (Icon(graphics={
        Text(
          extent={{-58,-46},{62,-84}},
          textColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString=
               "%fileName"),
        Polygon(
          points={{-56,76},{-56,-72},{50,-72},{76,-50},{76,76},{-56,76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,58},{-4,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,58},{48,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,26},{48,18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,26},{-4,18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,-10},{48,-18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-10},{-4,-18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,-44},{48,-52}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-44},{-4,-52}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="pri",
Documentation(info="<html>
<p>
This model prints to a file or the terminal at a fixed sample interval.
</p>
<p>
The parameter <code>configuration</code> controls the printing as follows:
</p>
<table summary=\"summary\" border=\"1\">
<tr><td><code>configuration</code></td><td>configuration</td></tr>
<tr><td><code>1</code></td> <td>print at sample times only</td></tr>
<tr><td><code>2</code></td> <td>print at sample times and at end of simulation</td></tr>
<tr><td><code>3</code></td> <td>print at end of simulation only</td></tr>
 </table>
</html>", revisions="<html>
<ul>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set start value for <code>firstTrigger</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
<li>
May 27, 2011 by Michael Wetter:<br/>
Changed parameter <code>precision</code> to <code>significantDigits</code>
and <code>minimumWidth</code> to <code>minimumLength</code> to use the same
terminology as the Modelica Standard Library.
</li>
<li>
October 1, 2008 by Michael Wetter:<br/>
Revised implementation and moved to new package.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Printer;
