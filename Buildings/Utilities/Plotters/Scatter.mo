within Buildings.Utilities.Plotters;
block Scatter "Block that plots one or multiple scatter plots"
  extends Modelica.Blocks.Icons.Block;

  outer Buildings.Utilities.Plotters.Configuration plotConfiguration
    "Default plot configuration";

  parameter String fileName = plotConfiguration.fileName "Name of html file";

  parameter Modelica.SIunits.Time samplePeriod(min=1E-3) = plotConfiguration.samplePeriod
    "Sample period of component";

  parameter String title "Title of the plot";

  parameter String xlabel = "" "x-label";

  parameter Integer n(min=1) = 1 "Number of independent data series (dimension of y)";

  parameter String[n] legend "String array for legend, such as {\"x1\", \"x2\"}";

  Modelica.Blocks.Interfaces.RealInput x "x-data" annotation (
      Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}),
        iconTransformation(extent={{-20,20},{20,-20}},
        rotation=90,
        origin={0,-120})));

  Modelica.Blocks.Interfaces.RealVectorInput y[n] "y-data" annotation (
      Placement(transformation(extent={{-130,-20},{-90,20}}),
        iconTransformation(extent={{-140,20},{-100,-20}})));

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";
  parameter String insNam = Modelica.Utilities.Strings.replace(
    getInstanceName(), ".", "_")
    "Name of this instance with periods replace by underscore";

  output Boolean sampleTrigger "True, if sample time instant";

  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";
  Buildings.Utilities.Plotters.BaseClasses.Backend plt=
    Buildings.Utilities.Plotters.BaseClasses.Backend(fileName=fileName)
    "Object that stores data for this plot";
  String str "Temporary string";

initial equation
  t0 = time;
  Buildings.Utilities.Plotters.BaseClasses.print(
    plt=plt,
    string="
    <div id=\"" + insNam + "\"></div>
    <script>
    ",
    finalCall = false);
  str = "";
algorithm
  sampleTrigger :=sample(t0, samplePeriod);
  when sampleTrigger then
    firstTrigger :=time <= t0 + samplePeriod/2;
  end when;

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
    if time <= t0 + samplePeriod/2 then
      Buildings.Utilities.Plotters.BaseClasses.print(
      plt=plt,
      string=
        "const allData_" + insNam + " = [[" + String(x) + str + "]",
        finalCall = false);
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
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{-74,90},{-82,68},{-66,68},{-74,90}}),
          Line(
            points={{-74,78},{-74,-80}},
            color={192,192,192}),
          Polygon(
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{96,-68},{74,-60},{74,-76},{96,-68}}),
          Line(
            points={{-84,-68},{88,-68}},
            color={192,192,192}),
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
