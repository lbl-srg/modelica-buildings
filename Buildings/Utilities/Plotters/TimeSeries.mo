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
initial equation
  timeConverted = 0;
algorithm
  when terminal() then
    Buildings.Utilities.Plotters.BaseClasses.print(
    plt=plt,
    string="];
  ",finalCall = false);
  for i in 1:n loop
    str := "
  const x_" + insNam + String(i) + " = {
    x: allData_" + insNam + ".map(x => x[0]),
    y: allData_" + insNam + ".map(x => x[" + String(i) + "]),
    type: 'scatter',
    " + plotMode + "
    name: '" + legend[i] + "'
  };";
    Buildings.Utilities.Plotters.BaseClasses.print(
      plt=plt,
      string=str,
      finalCall = false);
  end for;

  str := "
  var data_" + insNam + " = [";
  Buildings.Utilities.Plotters.BaseClasses.print(
      plt=plt,
      string=str,
      finalCall = false);

  // Loop over all variables, and print them to the C implementation.
  // We print frequently as Dymola truncates the string if it becomes
  // too long.
  for i in 1:n loop
    str := "x_" + insNam + String(i);
    if i < n then
      str := str + ",";
    else
      str := str + "];";
    end if;
    Buildings.Utilities.Plotters.BaseClasses.print(
      plt=plt,
      string=str,
      finalCall = false);
  end for;

  // Plot layout
  str := "
  var layout_" + insNam + " = { 
    xaxis: { title: 'time [" + timeUnitString + "]'}
    };
  Plotly.newPlot('" + insNam + "', data_" + insNam + ", layout_" + insNam + ");
    </script>
  ";
  Buildings.Utilities.Plotters.BaseClasses.print(
    plt=plt,
    string=str,
    finalCall = true);
  elsewhen {sampleTrigger} then
    str :="";
    for i in 1:n loop
      str :=str + ", " + String(y[i]);
    end for;
    if timeUnit == Buildings.Utilities.Plotters.Types.TimeUnit.seconds then
      timeConverted :=time;
    elseif timeUnit == Buildings.Utilities.Plotters.Types.TimeUnit.minutes then
      timeConverted :=time/60.;
    elseif timeUnit == Buildings.Utilities.Plotters.Types.TimeUnit.hours then
      timeConverted :=time/3600.;
    else
      timeConverted :=time/86400.;
    end if;
    if firstCall then
      Buildings.Utilities.Plotters.BaseClasses.print(
      plt=plt,
      string=
        "const allData_" + insNam + " = [[" + String(timeConverted) + str + "]",
        finalCall = false);
      firstCall :=false;
    else
      Buildings.Utilities.Plotters.BaseClasses.print(
      plt=plt,
      string= ", [" + String(timeConverted) + str + "]",
      finalCall = false);
    end if;
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
          lineColor={0,0,0},
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
