within Buildings.Utilities.IO.Plot;
model Configuration "Configuration for plotters"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)
    "Sample period of component";
  parameter String fileName = "plots.html" "Name of html file";
  parameter Buildings.Utilities.IO.Plot.Types.TimeUnit timeUnit = Types.TimeUnit.hours
  "Time unit for plot";
  annotation (
  defaultComponentName="plotConfiguration",
    defaultComponentPrefixes="inner",
    missingInnerMessage="
Your model is using an outer \"plotConfiguration\" component but
an inner \"plotConfiguration\" component is not defined.
For simulation drag Buildings.Utilities.IO.Plot.Configuration into your model
to specify system properties.",
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
          Line(
            points={{-80.0,78.0},{-80.0,-90.0}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
          Line(
            points={{-90.0,-80.0},{82.0,-80.0}},
            color={192,192,192}),
    Line(origin = {-1.939,-1.816},
        points = {{81.939,36.056},{65.362,36.056},{14.39,-26.199},{-29.966,113.485},{-65.374,-61.217},{-78.061,-78.184}},
        color = {0,0,127},
        smooth = Smooth.Bezier)}),                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block can be used to globally configure the parameters
for the blocks from the package
<a href=\"Buildings.Utilities.IO.Plot\">Buildings.Utilities.IO.Plot</a>.
Use this block for example to set the same
plot file name and sampling time.
</p>
<p>
To use this block, simply drag it at the top-most level, or higher,
where your plotters are.
</p>
</html>"));
end Configuration;
