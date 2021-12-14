within Buildings.Utilities.Plotters;
block TimeSeries "Block that plots one or multiple time series"
  extends Buildings.Utilities.Plotters.BaseClasses.PartialPlotter;

  parameter Buildings.Utilities.Plotters.Types.TimeUnit timeUnit=
    plotConfiguration.timeUnit
    "Time unit for plot"
    annotation(Dialog(group="Labels"));

protected
  final parameter String timeUnitString=
    if timeUnit == Types.TimeUnit.seconds then
      "s"
    elseif timeUnit == Types.TimeUnit.minutes then
      "min"
    elseif timeUnit == Types.TimeUnit.hours then
      "h"
    else
      "d" "String for time unit that is used in the plotter";
  Real timeConverted "Time converted to display unit";
initial algorithm
  timeConverted := 0;

  for i in 1:n loop
    Buildings.Utilities.Plotters.BaseClasses.sendTerminalString(
      plt=plt,
      string="
  const struct_" + insNam + String(i) + " = {
    x: " + insNam + "[0],
    y: " + insNam + "[" + String(i) + "],
    type: 'scatter',
    " + plotMode + "
    name: '" + legend[i] + "'
  };");
  end for;

  Buildings.Utilities.Plotters.BaseClasses.sendTerminalString(
    plt=plt,
    string="
  var data_" + insNam + " = [");

  // Loop over all variables, and print them to the C implementation.
  // We print frequently as Dymola truncates the string if it becomes
  // too long.
  for i in 1:n loop
    Buildings.Utilities.Plotters.BaseClasses.sendTerminalString(
      plt=plt,
      string="struct_" + insNam + String(i));
    Buildings.Utilities.Plotters.BaseClasses.sendTerminalString(
      plt=plt,
      string= if (i < n) then "," else "];");
  end for;

  // Plot layout
  Buildings.Utilities.Plotters.BaseClasses.sendTerminalString(
    plt=plt,
    string="
  var layout_" + insNam + " = {
    xaxis: { title: 'time [" + timeUnitString + "]'}
    };
  Plotly.newPlot('" + insNam + "', data_" + insNam + ", layout_" + insNam + ");
    </script>
");

equation
  when sampleTrigger then
    if timeUnit == Buildings.Utilities.Plotters.Types.TimeUnit.seconds then
      timeConverted = time;
    elseif timeUnit == Buildings.Utilities.Plotters.Types.TimeUnit.minutes then
      timeConverted = time/60.;
    elseif timeUnit == Buildings.Utilities.Plotters.Types.TimeUnit.hours then
      timeConverted = time/3600.;
    else
      timeConverted = time/86400.;
    end if;
    Buildings.Utilities.Plotters.BaseClasses.sendReal(
      plt=plt,
      x = cat(1, {timeConverted}, y));
  end when;
  annotation (
  defaultComponentName="timSer",
  Icon(graphics={
    Line(origin={4.061,-23.816},
        points={{81.939,36.056},{65.362,36.056},{21.939,17.816},{-8.061,75.816},
              {-36.061,5.816},{-78.061,23.816}},
        color = {0,0,127},
        smooth = Smooth.Bezier),
    Line(origin={4.061,-71.816},
        points={{81.939,36.056},{71.939,39.816},{43.939,17.816},{1.939,75.816},{
              -40.061,21.816},{-78.061,23.816}},
        color={244,125,35},
        smooth=Smooth.Bezier),
        Text(
          extent={{50,-70},{76,-94}},
          textColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          textString="t"),
    Line(origin={4.061,6.184},
        points={{81.939,36.056},{65.362,36.056},{43.939,27.816},{11.939,75.816},
              {-36.061,5.816},{-78.061,23.816}},
        color = {0,0,127},
        smooth = Smooth.Bezier)}), Documentation(info="<html>
<p>
Block that plots <code>n</code> time series.
</p>
<p>
To use this block, set the parameter <code>n</code> to the
number of time series that you like to plot.
Then, connect the signals for these time series to the input
port <code>y</code>.
</p>
<p>
There can be multiple instances of this block.
If they share the same value for <code>fileName</code>,
then they will add their plot to the same output file.
For convenience, we recommend to drag an instance of
<a href=\"Buildings.Utilities.Plotters.Configuration\">Buildings.Utilities.Plotters.Configuration</a>
at the top-level of your model. This instance can then
be used to globally set the <code>fileName</code> and
the <code>samplePeriod</code> for all plotters.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TimeSeries;
