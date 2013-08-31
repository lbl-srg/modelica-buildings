within Districts.BuildingLoads;
model LinearRegression
  "Whole building load model based on linear regression and table look-up"
extends Modelica.Blocks.Interfaces.BlockIcon;
extends Modelica.Icons.UnderConstruction;
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

  Electrical.AC.ThreePhasesBalanced.Loads.CapacitiveLoadP
                                            loadRC(mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
    pf=pf,
    linear=linear_AC,
    V_nominal=V_nominal_AC) "Resistive and capacitive building load"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_n
                                            terminal "Electrical connector"
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
  Electrical.DC.Loads.Conductor conDC(mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
    linear=linear_DC,
    V_nominal=V_nominal_DC) "Conductor for DC load"
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Districts.Electrical.DC.Interfaces.Terminal_p terminal_dc(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.TwoConductor)
    "Generalised terminal"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{10,-32},{30,-12}})));
  parameter Boolean linear_AC=false
    "If =true introduce a linearization in the AC load";
  parameter Boolean linear_DC=false
    "If =true introduce a linearization in the DC load";
  parameter Modelica.SIunits.Voltage V_nominal_AC "AC Voltage of the district";
  parameter Modelica.SIunits.Voltage V_nominal_DC "DC Voltage of the district";
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
  connect(terminal, loadRC.terminal) annotation (Line(
      points={{104,4.44089e-16},{64,4.44089e-16},{64,0},{60,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(regLoa.PTot, add.u1) annotation (Line(
      points={{-39,-5},{-17.5,-5},{-17.5,-16},{8,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, loadRC.Pow) annotation (Line(
      points={{31,-22},{34,-22},{34,0},{40,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conDC.terminal, terminal_dc) annotation (Line(
      points={{60,-60},{100,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(regLoa.PLigInd, add.u2) annotation (Line(
      points={{-39,5},{-30,5},{-30,-28},{8,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(regLoa.PLigInd, conDC.Pow) annotation (Line(
      points={{-39,5},{-30,5},{-30,-60},{40,-60}},
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
April 22, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end LinearRegression;
