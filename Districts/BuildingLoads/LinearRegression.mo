within Districts.BuildingLoads;
model LinearRegression
  "Whole building load model based on linear regression and table look-up"
extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter String fileName="NoName"
    "File where matrix with regression coefficients is stored"
    annotation(Dialog(group="table data definition", enable = tableOnFile,
                         __Dymola_loadSelector(filter=".txt files (*.txt);;All files (*.*)",
                         caption="Open file in which table is present")));
  parameter Real pf=0.8 "Power factor";
  BoundaryConditions.WeatherData.Bus
      weaBus "Weather Data Bus" annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}),     iconTransformation(extent={{-110,-10},{-90,10}})));
  BaseClasses.LinearRegression regLoa(final fileName=fileName)
    "Building load based on a piecewise linear regression"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Electrical.AC.Loads.VariableCapacitorResistor totEleLoa[3](
    each P_nominal=1/3.,
    each pf=pf) "Total building electrical load"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
protected
  Electrical.AC.Interfaces.Adaptor adaptor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,0})));

  Modelica.Blocks.Routing.Replicator replicator(nout=3)
    "Replicator for the 3 phases"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
public
  Electrical.AC.Interfaces.ThreePhasePlug threePhasePlug
    "Electricity connection of building"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.Constant fixme[3](each k=0)
    "Placeholder until the new electrical system is implemented"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
equation
  connect(regLoa.TOut, weaBus.TDryBul)           annotation (Line(
      points={{-62,8},{-80,8},{-80,0},{-100,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(regLoa.TDewPoi, weaBus.TDewPoi)           annotation (Line(
      points={{-62,4},{-80,4},{-80,0},{-100,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(regLoa.HDirNor, weaBus.HDirNor)           annotation (Line(
      points={{-62,-4},{-80,-4},{-80,0},{-100,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(regLoa.HDif, weaBus.HDifHor)           annotation (Line(
      points={{-62,-8},{-80,-8},{-80,4.44089e-16},{-100,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(totEleLoa[1].sPhasePlug, adaptor.phase3) annotation (Line(
      points={{40,0},{50,0},{50,6},{60,6}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(totEleLoa[2].sPhasePlug, adaptor.phase2) annotation (Line(
      points={{40,0},{60,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(totEleLoa[3].sPhasePlug, adaptor.phase1) annotation (Line(
      points={{40,0},{50,0},{50,-6},{60,-6}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(regLoa.PTot, replicator.u) annotation (Line(
      points={{-39,-5},{-20,-5},{-20,0},{-12,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(adaptor.threePhasePlug, threePhasePlug) annotation (Line(
      points={{78,0},{100,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(fixme.y, totEleLoa.y) annotation (Line(
      points={{1,50},{16,50},{16,0},{20,0},{20,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{0,28},{80,-100}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,14},{26,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,14},{48,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,14},{70,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-2},{70,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-2},{48,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-2},{26,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-18},{70,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-18},{48,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-18},{26,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-34},{70,-44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-34},{48,-44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-34},{26,-44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-50},{70,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-50},{48,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-50},{26,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-66},{70,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-66},{48,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-66},{26,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-82},{70,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-82},{48,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-82},{26,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{38,46},{-16,28},{92,28},{38,46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,54},{-56,70},{-38,64},{-10,84}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-84,92},{-84,50},{-4,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-86,86},{-84,92},{-82,86}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-10,52},{-4,50},{-10,48}},
          color={0,0,0},
          smooth=Smooth.None)}),
                Documentation(info="<html>
Model for a building load. This model computes the load of a building
using a family of linear regression models.
The model takes as a connector the weather data. This is the input
for the regression.
On the right hand side, there is a connector for a three-phase
electrical connection, which contains the total building load.
The model assumes that the current in the three phases are balanced.
The power factor is a model parameter.
</p>
<p>
Each regression model has the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
y(t) = &beta;<sub>0</sub>(t) + &beta;<sub>1</sub>(t) u(t),
</p>
<p>
where <i>y(&sdot;) &isin; &#8477;<sup>9</sup></i> is the output vector,
<i>u(&sdot;) &isin; &#8477;<sup>4</sup></i> is the input vector,
<i>&beta;<sub>0</sub>(&sdot;) &isin; &#8477;<sup>9</sup></i> and
<i>&beta;<sub>1</sub>(&sdot;) &isin; &#8477;<sup>9 &times; 4</sup></i> are
regression coefficients.
The regression coefficients are obtained from a table, which is stored in the following
format:
<pre>
#1
double tab1(\"number_of_time_stamps\", 47)
#
# This data format is used to feed the coefficients from the reduced order model
# to the load model in Modelica.
#
# The equation is 
#    y = B0 + B1 * u, 
# where y has the following components:
#  y1: QCoo, cooling provided at the cooling coil in Watts
#  y2: QHea, heating provided at the heating coil in Watts
#  y3: PLigInd, power for indoor lights in Watts
#  y4: PPlu, power for plug loads in Watts
#  y5: PFan, power for supply fan (and return fan if present) in Watts
#  y6: PDX, power for compressor and condenser fan of DX coil in Watts
#  y7: PLigOut, power for outdoor lights in Watts
#  y8: PTot, whole building electricity usage in Watts, may include elevators, bathroom fans etc.
#  y9: PGas, whole building gas usage in Watts
#
# Hence, there are 9 outputs.
#
# The input vector u has the following four components:
# u1: TOut, outside air temperature in Kelvin
# u2: TDewPoi, outside dewpoint temperature in Kelvin
# u3: HDif, diffuse horizontal solar irradiation in W/m2, as obtained from TMY3
# u4: HDirNor, direct normal irradiation in W/m2, as obtained from TMY3
#
# The columns below contain the following format
# C1: time in seconds. Beginning of a year is 0s.
# C2: Weekday indicator: 1: Monday, 2: Tuesday, ...; For a holiday, use -1 for Monday holiday, -2 for Tuesday holiday, etc.
# C3: B0[1]
# C4: B0[2]
# ....
# C11: B0[9]
# C12: B1[1, 1]
# C13: B1[1, 2]
# ...
# C47: B1[9, 4]
# What follows below are the day of week indicator, the time stamps
# and the regression coefficients.
0.0      x      x    etc.
</pre>

</html>", revisions="<html>
<ul>
<li>
April 22, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end LinearRegression;
