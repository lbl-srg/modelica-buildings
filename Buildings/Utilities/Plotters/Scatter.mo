within Buildings.Utilities.Plotters;
block Scatter "Block that plots one or multiple scatter plots"
  extends Buildings.Utilities.Plotters.BaseClasses.PartialPlotter;

  parameter String xlabel = "" "x-label";

  Modelica.Blocks.Interfaces.RealInput x "x-data" annotation (
      Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}),
        iconTransformation(extent={{-20,20},{20,-20}},
        rotation=90,
        origin={0,-120})));

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
    mode: 'lines+markers',
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
    title: '" + title + "',
    xaxis: { title: '" + xlabel + "'}";
    if (n == 1) then
      str := str + ",
    yaxis: { title: '" + legend[1] + "'}";
    end if;
  str := str + "
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
    if firstCall then
      Buildings.Utilities.Plotters.BaseClasses.print(
      plt=plt,
      string=
        "const allData_" + insNam + " = [[" + String(x) + str + "]",
        finalCall = false);
      firstCall :=false;
    else
      Buildings.Utilities.Plotters.BaseClasses.print(
      plt=plt,
      string= ", [" + String(x) + str + "]",
      finalCall = false);
    end if;
  end when;
  annotation (
    defaultComponentName="sca",
    Icon(graphics={
    Line(origin={6.061,-31.816},
        points={{67.939,-6.184},{65.362,36.056},{21.939,17.816},{-68.061,-26.184},
              {-56.061,11.816},{-70.061,47.816}},
        color = {0,0,127},
        smooth = Smooth.Bezier),
    Line(origin={4.061,-71.816},
        points={{-46.061,121.816},{67.939,137.816},{43.939,17.816},{1.939,75.816},
              {-40.061,21.816},{-58.061,97.816}},
        color={244,125,35},
        smooth=Smooth.Bezier),
        Text(
          extent={{48,-70},{74,-94}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          textString="x"),
        Text(
          extent={{-102,96},{-76,72}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          textString="y")}),
Documentation(info="<html>
<p>
Block that plots <code>n</code> time series that are connected
at the input port <code>y</code> against the independent data
that are connected at the input port <code>x</code>.
</p>
<p>
To use this block, set the parameter <code>n</code> to the
number of time series <code>y</code> that you like to plot
against <code>x</code>.
Then, connect the signals for the independent data
to <code>x</code> and the signals for the dependent data to
<code>y</code>.
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
end Scatter;
