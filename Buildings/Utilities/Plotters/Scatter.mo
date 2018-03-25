within Buildings.Utilities.Plotters;
block Scatter "Block that plots one or multiple scatter plots"
  extends Buildings.Utilities.Plotters.BaseClasses.PartialPlotter;

  parameter String xlabel = "" "x-label"
    annotation(Dialog(group="Labels"));

  Modelica.Blocks.Interfaces.RealInput x "x-data" annotation (
      Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80}),
        iconTransformation(extent={{-20,20},{20,-20}},
        rotation=0,
        origin={-120,-80})));
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
          textString="y"),
        Ellipse(
          extent={{-12,-44},{-6,-50}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{4,-40},{10,-46}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-26,-48},{-20,-54}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-42,-30},{-36,-36}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-42,-54},{-36,-60}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-42,-42},{-36,-48}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{44,-6},{50,-12}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{44,-30},{50,-36}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,-36},{24,-42}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{44,-18},{50,-24}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,-32},{38,-38}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,16},{6,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-52,16},{-46,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,16},{-30,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,16},{-12,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,16},{16,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{58,52},{64,46}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{34,52},{40,46}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,52},{16,46}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-26,16},{-20,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{34,16},{40,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,16},{28,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{34,28},{40,22}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{34,42},{40,36}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,16},{-4,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,42},{-4,36}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,28},{-4,22}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,52},{-4,46}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,52},{6,46}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,52},{28,46}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{48,52},{54,46}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-28,-24},{-22,-30}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,-20},{-8,-26}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{2,-16},{8,-22}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{16,-12},{22,-18}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,-8},{36,-14}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,-54},{-56,-60}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-52,-54},{-46,-60}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{56,-6},{62,-12}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{66,-6},{72,-12}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
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
