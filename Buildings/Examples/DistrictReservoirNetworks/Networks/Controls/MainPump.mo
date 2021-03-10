within Buildings.Examples.DistrictReservoirNetworks.Networks.Controls;
block MainPump "Controller for main pump"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nMix(min=1) "Number of mixing points after the substations";
  parameter Integer nSou(min=1) "Number of heat sources (and heat sinks)";
  parameter Real yPumMin(min=0.01, max=1, final unit="1") = 0.05
    "Minimum pump speed";
  parameter Modelica.SIunits.Temperature TMin(
    displayUnit="degC") = 281.15 "Minimum loop temperature";
  parameter Modelica.SIunits.Temperature TMax(
    displayUnit="degC") = 291.15 "Maximum loop temperature";
  parameter Modelica.SIunits.TemperatureDifference dTSlo(min=1) = 2
    "Temperature difference for slope";
  parameter Boolean use_temperatureShift = true
    "Set to false to disable temperature shift of slopes";
  final parameter Modelica.SIunits.TemperatureDifference delta(min=1)=
    if use_temperatureShift then TMax-TMin-3*dTSlo else 0 "Maximum shift of slopes";
  parameter Modelica.SIunits.TemperatureDifference dTSou_nominal[nSou](
    each min=0) = fill(4, nSou) "Nominal temperature difference over source";
  parameter Real k=0.01
    "Gain of controller that shifts upper and lower temperature setpoints";
  parameter Modelica.SIunits.Time Ti(displayUnit="min") = 300
    "Time constant of integrator block that shifts upper and lower temperature setpoints";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix[nMix](
    each final unit="K",
    each displayUnit="degC")
    "Temperatures at the mixing points"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouIn[nSou](
    each final unit="K",
    each displayUnit="degC")
    "Temperatures at the inlets of the sources"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouOut[nSou](
    each final unit="K",
    each displayUnit="degC")
    "Temperatures at the outlets of the sources"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(min=0, max=1, unit="1")
    "Pump control signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin TMixMin(
    final nin=nMix,
    y(final unit="K",
      displayUnit="degC"))
    "Minimum temperature at mixing points"
    annotation (Placement(transformation(extent={{-70,-22},{-50,-2}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax TMixMax(
    final nin=nMix,
    y(final unit="K",
      displayUnit="degC"))
    "Maximum temperature at mixing points"
    annotation (Placement(transformation(extent={{-70,8},{-50,28}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    nin=nSou,
    k=fill(1, nSou))
    annotation (Placement(transformation(extent={{-40,-142},{-20,-122}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dTSou[nSou](each final k1=-1)
    "Temperature differences over source"
    annotation (Placement(transformation(extent={{-70,-142},{-50,-122}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain dTSou_nor(k=1/(sum(dTSou_nominal)))
    "Normalization of temperature difference over source"
    annotation (Placement(transformation(extent={{-10,-142},{10,-122}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conShi(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=k,
    Ti(displayUnit="min") = Ti,
    final yMax=1,
    final yMin=-1)
    "Controller to shift the min/max slopes"
    annotation (Placement(transformation(extent={{20,-112},{40,-92}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0)
    "Set point for source dT"
    annotation (Placement(transformation(extent={{-10,-92},{10,-72}})));
  Buildings.Controls.OBC.CDL.Continuous.Line uppCur "Upper curve"
    annotation (Placement(transformation(extent={{30,8},{50,28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "Constant 1"
    annotation (Placement(transformation(extent={{-70,68},{-50,88}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yMin(k=yPumMin)
    "Minimum pump speed"
    annotation (Placement(transformation(extent={{-70,38},{-50,58}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TMax_nominal(k=TMax)
    "Maximum temperature"
    annotation (Placement(transformation(extent={{-70,144},{-50,164}})));
  Buildings.Controls.OBC.CDL.Continuous.Add TMax_upper(k2=-delta,
    y(unit="K", displayUnit="degC"))
    "Upper value of upper slope after shifting it"
    annotation (Placement(transformation(extent={{-30,138},{-10,158}})));
  Buildings.Controls.OBC.CDL.Continuous.Max sPos "Positive shift"
    annotation (Placement(transformation(extent={{60,-94},{80,-74}})));
  Buildings.Controls.OBC.CDL.Continuous.Min sNeg "Negative shift"
    annotation (Placement(transformation(extent={{60,-132},{80,-112}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TMax_lower(p=-dTSlo, k=1)
    "Minimum temperatuer value of upper slope after shifting it"
    annotation (Placement(transformation(extent={{10,137},{30,159}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lowCur "Lower curve"
    annotation (Placement(transformation(extent={{30,-22},{50,-2}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TMin_nominal(k=TMin)
    "Minimum temperature"
    annotation (Placement(transformation(extent={{-70,98},{-50,118}})));
  Buildings.Controls.OBC.CDL.Continuous.Add TMin_lower(k2=-delta,
    y(unit="K", displayUnit="degC"))
    "Lower value of lower slope after shifting it"
    annotation (Placement(transformation(extent={{-30,98},{-10,118}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TMin_upper(p=+dTSlo, k=1)
    "Maximum temperatuer value of lower slope after shifting it"
    annotation (Placement(transformation(extent={{10,98},{30,118}})));
  Buildings.Controls.OBC.CDL.Continuous.Max ySetPum "Change in pump signal"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(TMix, TMixMin.u) annotation (Line(points={{-120,60},{-86,60},{-86,-12},
          {-72,-12}},
                color={0,0,127}));
  connect(TMix, TMixMax.u) annotation (Line(points={{-120,60},{-86,60},{-86,18},
          {-72,18}},
                color={0,0,127}));
  connect(dTSou.u1, TSouIn) annotation (Line(points={{-72,-126},{-90,-126},{-90,
          0},{-120,0}}, color={0,0,127}));
  connect(dTSou.u2, TSouOut) annotation (Line(points={{-72,-138},{-94,-138},{-94,
          -60},{-120,-60}}, color={0,0,127}));
  connect(mulSum.u, dTSou.y)
    annotation (Line(points={{-42,-132},{-48,-132}}, color={0,0,127}));
  connect(mulSum.y, dTSou_nor.u)
    annotation (Line(points={{-18,-132},{-12,-132}}, color={0,0,127}));
  connect(dTSou_nor.y, conShi.u_m)
    annotation (Line(points={{12,-132},{30,-132},{30,-114}}, color={0,0,127}));
  connect(conShi.u_s, zer.y) annotation (Line(points={{18,-102},{16,-102},{16,-82},
          {12,-82}},
                 color={0,0,127}));
  connect(uppCur.u, TMixMax.y)
    annotation (Line(points={{28,18},{-48,18}}, color={0,0,127}));
  connect(uppCur.f1, yMin.y) annotation (Line(points={{28,22},{-30,22},{-30,48},
          {-48,48}}, color={0,0,127}));
  connect(uppCur.f2, one.y) annotation (Line(points={{28,10},{-26,10},{-26,78},{
          -48,78}}, color={0,0,127}));
  connect(TMax_nominal.y, TMax_upper.u1)
    annotation (Line(points={{-48,154},{-32,154}}, color={0,0,127}));
  connect(zer.y, sPos.u1) annotation (Line(points={{12,-82},{46,-82},{46,-78},{58,
          -78}}, color={0,0,127}));
  connect(zer.y, sNeg.u1) annotation (Line(points={{12,-82},{46,-82},{46,-116},{
          58,-116}},
                 color={0,0,127}));
  connect(conShi.y, sPos.u2) annotation (Line(points={{42,-102},{50,-102},{50,-90},
          {58,-90}}, color={0,0,127}));
  connect(conShi.y, sNeg.u2) annotation (Line(points={{42,-102},{50,-102},{50,-128},
          {58,-128}},color={0,0,127}));
  connect(TMax_lower.u, TMax_upper.y)
    annotation (Line(points={{8,148},{-8,148}},   color={0,0,127}));
  connect(uppCur.x1, TMax_lower.y) annotation (Line(points={{28,26},{20,26},{20,
          82},{42,82},{42,148},{32,148}}, color={0,0,127}));
  connect(TMax_upper.y, uppCur.x2) annotation (Line(points={{-8,148},{0,148},{0,
          14},{28,14}}, color={0,0,127}));
  connect(TMixMin.y, lowCur.u)
    annotation (Line(points={{-48,-12},{28,-12}}, color={0,0,127}));
  connect(TMin_nominal.y, TMin_lower.u1) annotation (Line(points={{-48,108},{-40,
          108},{-40,114},{-32,114}}, color={0,0,127}));
  connect(TMin_lower.y, TMin_upper.u)
    annotation (Line(points={{-8,108},{8,108}}, color={0,0,127}));
  connect(TMin_upper.y, lowCur.x2) annotation (Line(points={{32,108},{36,108},{36,
          86},{16,86},{16,-16},{28,-16}}, color={0,0,127}));
  connect(TMin_lower.y, lowCur.x1) annotation (Line(points={{-8,108},{-4,108},{-4,
          -4},{28,-4}}, color={0,0,127}));
  connect(lowCur.f1, one.y) annotation (Line(points={{28,-8},{-26,-8},{-26,78},{
          -48,78}}, color={0,0,127}));
  connect(lowCur.f2, yMin.y) annotation (Line(points={{28,-20},{-30,-20},{-30,48},
          {-48,48}}, color={0,0,127}));
  connect(uppCur.y, ySetPum.u1)
    annotation (Line(points={{52,18},{56,18},{56,6},{58,6}}, color={0,0,127}));
  connect(lowCur.y, ySetPum.u2) annotation (Line(points={{52,-12},{56,-12},{56,-6},
          {58,-6}}, color={0,0,127}));
  connect(ySetPum.y, y)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(sPos.y, TMax_upper.u2) annotation (Line(points={{82,-84},{88,-84},{88,
          134},{-40,134},{-40,142},{-32,142}}, color={0,0,127}));
  connect(sNeg.y, TMin_lower.u2) annotation (Line(points={{82,-122},{94,-122},{
          94,94},{-40,94},{-40,102},{-32,102}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-180},{100,180}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-52,52},{54,-52}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,68},{-76,54}},
          lineColor={0,0,127},
          textString="TMix"),
        Text(
          extent={{-94,8},{-76,-6}},
          lineColor={0,0,127},
          textString="TSouIn"),
        Text(
          extent={{-94,-52},{-76,-66}},
          lineColor={0,0,127},
          textString="TSouOut"),
        Text(
          extent={{76,8},{94,-6}},
          lineColor={0,0,127},
          textString="y"),
        Ellipse(
          extent={{-50,50},{52,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,50},{0,-50},{52,0},{0,50}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
September 12, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Controller for the main circulation pump.
</p>
<p>
This controller adjust the pump speed in order to reduce the speed, unless
the water temperature at the mixing points after the agents in the district is too high
or too low, as measured by the difference to <code>TMin</code> and <code>TMax</code>,
in which case the pump speed is increased to avoid that the loop gets too cold or too warm.
The control is as follows:
Let <code>TMixMin</code> and <code>TMixMax</code> be the
minimum and maximum mixing temperatures.
If <code>TMax-TMixMax</code> or <code>TMixMin-TMin</code> is too small,
the pump speed is increased.
If the difference is larger than <code>dTSlo</code>, then the pump speed
is set to the minimum speed <code>yPumMin</code>.
This calculation is done for both, <code>TMixMin</code> and <code>TMixMax</code>.
The actual pump speed is then the larger of the two pump signals.
Therefore, the pump speeds are calculated as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"Image of the control that adjusts the pump speed\"
src=\"modelica://DHCNetworks/Resources/Images/Controls/MainPump.png\"/>
</p>
<p>
Moreover, the district loop temperature is adjusted by changing the mass
flow rate of the pump to increase the overall efficiency if there is net
cooling or net heating on the loop. Specifically,
if the district heating or cooling loop is in net heating (cooling) mode,
it is favorable to increase (decrease) the loop temperature, which can
be done by increasing the pump speed. Whether the loop
is in heating or cooling mode is determined based on the temperature differences
across the loop sources, which are the inputs <code>TSouIn</code> and <code>TSouOut</code>.
Each heat source or sink needs to be connected to one element of these
vectorized input signals.
This net difference is then used with a PI-controller to determine how much the slopes
should be shifted in order to increase the pump speed.
The shift of these slopes is indicated by the arrows
in the figure.
Note that this controller must be configured to be slow reacting, as it requires the
feedback from the district heating and cooling loop.
</p>
<p>
For a typical usage of this controller, see
<a href=\"modelica://DHCNetworks.Controls.Validation.MainPumpClosedLoop\">
DHCNetworks.Controls.Validation.MainPumpClosedLoop</a>.
</p>
</html>"));
end MainPump;
