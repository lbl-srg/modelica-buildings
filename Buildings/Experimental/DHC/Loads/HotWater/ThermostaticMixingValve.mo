within Buildings.Experimental.DHC.Loads.HotWater;
model ThermostaticMixingValve
  "A model for a thermostatic mixing valve"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.MassFlowRate mMix_flow_nominal
    "Nominal mixed water flow rate to fixture";

  Modelica.Fluid.Interfaces.FluidPort_a port_hot(redeclare package Medium =
        Medium) "Port for hot water supply"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_col(redeclare package Medium =
        Medium) "Port for domestic cold water supply"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Blocks.Interfaces.RealInput TMixSet(
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint of mixed water outlet"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}}),
        iconTransformation(extent={{-120,10},{-100,30}})));

  Modelica.Blocks.Interfaces.RealInput yMixSet(final min=0, final unit="1")
    "Mixed water fractional flow rate at TMixSet, as fraction of mMix_flow_nominal"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,80}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,80})));

  Fluid.Sensors.TemperatureTwoPort senTemHot(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mMix_flow_nominal,
    tau=0) "Hot water temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Fluid.Sensors.TemperatureTwoPort senTemCol(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mMix_flow_nominal,
    tau=0) "Cold water temperature"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Modelica.Units.SI.MassFlowRate mMix_flow = gaiMMix_flow.y
    "Mass flow rate of mixed water";
  Controls.OBC.CDL.Utilities.Assert assTHotTooLow(message="Hot water temperature is insufficient to meet mixed water set point")
    "Assertion that triggers a warning whenever the hot water temperature becomes too low"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
protected
  Controls.OBC.CDL.Reals.Subtract dTMix
    "Temperature difference mixed minus cold"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Controls.OBC.CDL.Reals.Subtract dTHot "Temperature difference hot minus cold"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Utilities.Math.SmoothMax dTHot_nonZero(deltaX=dTSmall/4)
    "Temperature difference bounded away from zero"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Controls.OBC.CDL.Reals.Sources.Constant dTSmaDiv(
    final k(final unit="K")=dTSmall)
    "Small temperature difference to avoid division by zero"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Controls.OBC.CDL.Reals.Divide temRat
    "Ratio of temperatures (T_mix-T_col)/(T_hot-T_col)"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Math.Gain gaiMMix_flow(final k=mMix_flow_nominal)
    "Gain for multiplying domestic hot water schedule" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,-20})));
  Controls.OBC.CDL.Reals.Multiply mHot_flow(
    u1(final unit="1"),
    u2(final unit="kg/s"),
    y(final unit="kg/s"))
    "Hot water flow rate"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Controls.OBC.CDL.Reals.Subtract mCol_flow "Cold water flow rate"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Fluid.Sources.MassFlowSource_T sinHot(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for hot water supply"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Fluid.Sources.MassFlowSource_T sinCol(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for cold water supply"
    annotation (Placement(transformation(extent={{8,-90},{-12,-70}})));
  Modelica.Blocks.Math.Gain sigHot(final k=-1)
    "Sign change to extract mass flow rate" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-40})));
  Modelica.Blocks.Math.Gain sigCol(final k=-1)
    "Sign change to extract mass flow rate" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-80})));
  Controls.OBC.CDL.Reals.Greater dTMon(h=dTSmall/4)
    "Inequality to monitor whether temperatures are sufficient to meet set point"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  parameter Modelica.Units.SI.Temperature dTSmall = 0.01 "Small temperature used to avoid division by zero";
equation
  connect(senTemHot.port_a, port_hot) annotation (Line(points={{-80,-40},{-100,-40}},
                              color={0,127,255}));
  connect(port_col, senTemCol.port_a)
    annotation (Line(points={{-100,-80},{-80,-80}}, color={0,127,255}));
  connect(dTMix.u1, TMixSet) annotation (Line(points={{-42,76},{-74,76},{-74,20},
          {-110,20}}, color={0,0,127}));
  connect(senTemCol.T, dTMix.u2) annotation (Line(points={{-70,-69},{-70,-60},{-52,
          -60},{-52,64},{-42,64}}, color={0,0,127}));
  connect(dTHot.u1, senTemHot.T)
    annotation (Line(points={{-42,46},{-70,46},{-70,-29}}, color={0,0,127}));
  connect(dTHot.u2, senTemCol.T) annotation (Line(points={{-42,34},{-46,34},{-46,
          -60},{-70,-60},{-70,-69}}, color={0,0,127}));
  connect(dTHot_nonZero.u1, dTHot.y) annotation (Line(points={{-2,36},{-10,36},{
          -10,40},{-18,40}}, color={0,0,127}));
  connect(dTHot_nonZero.u2, dTSmaDiv.y) annotation (Line(points={{-2,24},{-8,24},
          {-8,10},{-18,10}},  color={0,0,127}));
  connect(dTHot_nonZero.y, temRat.u2) annotation (Line(points={{21,30},{30,30},{
          30,44},{38,44}}, color={0,0,127}));
  connect(temRat.u1, dTMix.y) annotation (Line(points={{38,56},{-10,56},{-10,70},
          {-18,70}},color={0,0,127}));
  connect(yMixSet, gaiMMix_flow.u) annotation (Line(points={{-110,80},{-80,80},{
          -80,-20},{-42,-20}}, color={0,0,127}));
  connect(mHot_flow.u1, temRat.y) annotation (Line(points={{18,-4},{10,-4},{10,10},
          {70,10},{70,50},{62,50}}, color={0,0,127}));
  connect(gaiMMix_flow.y, mHot_flow.u2) annotation (Line(points={{-19,-20},{0,-20},
          {0,-16},{18,-16}}, color={0,0,127}));
  connect(gaiMMix_flow.y, mCol_flow.u1) annotation (Line(points={{-19,-20},{0,-20},
          {0,14},{50,14},{50,-4},{58,-4}}, color={0,0,127}));
  connect(mHot_flow.y, mCol_flow.u2) annotation (Line(points={{42,-10},{52,-10},
          {52,-16},{58,-16}}, color={0,0,127}));
  connect(sigCol.y, sinCol.m_flow_in) annotation (Line(points={{39,-80},{26,-80},
          {26,-72},{10,-72}}, color={0,0,127}));
  connect(sigHot.y, sinHot.m_flow_in) annotation (Line(points={{39,-40},{26,-40},
          {26,-32},{12,-32}}, color={0,0,127}));
  connect(sigHot.u, mHot_flow.y) annotation (Line(points={{62,-40},{72,-40},{72,
          -24},{52,-24},{52,-10},{42,-10}}, color={0,0,127}));
  connect(mCol_flow.y, sigCol.u) annotation (Line(points={{82,-10},{90,-10},{90,
          -80},{62,-80}}, color={0,0,127}));
  connect(sinCol.ports[1], senTemCol.port_b)
    annotation (Line(points={{-12,-80},{-60,-80}}, color={0,127,255}));
  connect(sinHot.ports[1], senTemHot.port_b)
    annotation (Line(points={{-10,-40},{-60,-40}}, color={0,127,255}));
  connect(dTMon.y, assTHotTooLow.u)
    annotation (Line(points={{42,80},{58,80}}, color={255,0,255}));
  connect(dTMon.u1, dTHot.y) annotation (Line(points={{18,80},{-14,80},{-14,40},
          {-18,40}}, color={0,0,127}));
  connect(dTSmaDiv.y, dTMon.u2) annotation (Line(points={{-18,10},{-8,10},{-8,72},
          {18,72}}, color={0,0,127}));
  annotation (
  defaultComponentName="theMixVal",
  preferredView="info",Documentation(info="<html>
<p>
This model implements a thermostatic mixing valve, which uses
a PI feedback controller to mix hot and cold fluid to achieve a specified 
hot water outlet temperature to send to a fixture(s).
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2023 by David Blum:<br/>
Updated for release.
</li>
<li>
June 16, 2022 by Dre Helmns:<br/>
Initial Implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
    Rectangle(
      extent={{-3,32},{3,-32}},
      fillPattern=FillPattern.Solid,
      fillColor={28,108,200},
          origin={-70,-81},
          rotation=90,
          pattern=LinePattern.None),
      Text(
          extent={{-153,147},{147,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Polygon(points={{-10,30},{-10,30}}, lineColor={28,108,200}),
        Polygon(
          points={{-15,-3},{15,17},{15,-23},{-15,-3}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-37,-55},
          rotation=270),
    Rectangle(
      extent={{-4,4},{4,-4}},
      fillPattern=FillPattern.Solid,
      fillColor={102,44,145},
          origin={82,-40},
          rotation=90,
          pattern=LinePattern.None),
    Rectangle(
      extent={{-3,7},{3,-7}},
      fillPattern=FillPattern.Solid,
      fillColor={28,108,200},
          origin={-41,-77},
          rotation=180,
          pattern=LinePattern.None),
        Line(
          points={{66,4},{64,42}},
          color={0,0,0},
          pattern=LinePattern.None),
        Text(
          extent={{-96,46},{-54,14}},
          textColor={0,0,0},
          textString="TMixSet"),
    Rectangle(
      extent={{-4,16},{4,-16}},
      fillPattern=FillPattern.Solid,
      fillColor={238,46,47},
          origin={-86,-40},
          rotation=90,
          pattern=LinePattern.None),
    Rectangle(
      extent={{-4,22},{4,-22}},
      fillPattern=FillPattern.Solid,
      fillColor={102,44,145},
          origin={88,-58},
          rotation=180,
          pattern=LinePattern.None),
        Polygon(
          points={{-15,-3},{15,17},{15,-23},{-15,-3}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-55,-43},
          rotation=180),
        Polygon(
          points={{-15,-3},{15,17},{15,-23},{-15,-3}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-25,-37},
          rotation=360),
        Text(
          extent={{-96,108},{-54,76}},
          textColor={0,0,0},
          textString="yMixSet"),
        Line(points={{-100,20},{-40,20},{-40,-40}}, color={0,0,0}),
        Line(points={{-100,80},{48,80},{48,-40}}, color={0,0,0}),
        Polygon(
          points={{-15,-3},{15,17},{15,-23},{-15,-3}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={63,-37},
          rotation=360),
        Polygon(
          points={{-15,-3},{15,17},{15,-23},{-15,-3}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={33,-43},
          rotation=180),
    Rectangle(
      extent={{-4,14},{4,-14}},
      fillPattern=FillPattern.Solid,
      fillColor={102,44,145},
          origin={4,-40},
          rotation=90,
          pattern=LinePattern.None)}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThermostaticMixingValve;
