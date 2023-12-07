within Buildings.Experimental.DHC.Loads.HotWater;
model ThermostaticMixingValve
  "A model for a thermostatic mixing valve"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.MassFlowRate mMix_flow_nominal
    "Nominal mixed water flow rate to fixture";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Control gains",
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Control gains",
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real relTol = 0.005 "Relative tolerance on energy balance, if not met, a warning will be issued at end of simulation"
    annotation(Dialog(tab="Advanced"));

  Modelica.Fluid.Interfaces.FluidPort_a port_hot(redeclare package Medium =
        Medium) "Port for hot water supply"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_col(redeclare package Medium =
        Medium) "Port for domestic cold water supply"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Blocks.Interfaces.RealInput TMixSet(
    final unit="K",
    displayUnit="degC") "Temperature setpoint of mixed water outlet"
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

  Buildings.Fluid.Sensors.TemperatureTwoPort senTHot(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mMix_flow_nominal,
    tau=0) "Hot water temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCol(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mMix_flow_nominal,
    tau=0) "Cold water temperature"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTMix(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mMix_flow_nominal,
    tau=0) "Mixed water temperature"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Reals.PID conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    yMax=1,
    yMin=0) annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Reals.Divide ratEne
    "Ratio of actual over required energy (must be near 1 if load is satisfied)"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=1,
    m_flow_nominal={-mMix_flow_nominal,mMix_flow_nominal,mMix_flow_nominal},
    dp_nominal={0,0,0}) "Mixing of hot water and cold water"
    annotation (Placement(transformation(extent={{10,-50},{-10,-70}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Multiply mulMHot_flow
    "Multiplication to output required hot water mass flow rate"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  EnergyMeter eneMetReq "Required energy"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  EnergyMeter eneMetAct "Actual energy"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  block EnergyMeter "Block that outputs integrated energy, bounded away from zero"
    extends Modelica.Blocks.Icons.Block;

    Modelica.Blocks.Interfaces.RealInput TMix(final unit="K", displayUnit="degC")
      "Temperature of mixed water outlet" annotation (Placement(transformation(
            extent={{-120,50},{-100,70}}), iconTransformation(extent={{-120,50},{-100,
              70}})));
    Modelica.Blocks.Interfaces.RealInput TCol(final unit="K", displayUnit="degC")
      "Temperature of cold water" annotation (Placement(transformation(extent={{-120,
              -10},{-100,10}}), iconTransformation(extent={{-120,-10},{-100,10}})));
    Modelica.Blocks.Interfaces.RealInput m_flow(final unit="kg/s")
      "Mass flow rate" annotation (Placement(transformation(extent={{-120,-70},{-100,
              -50}}), iconTransformation(extent={{-120,-70},{-100,-50}})));
    Modelica.Blocks.Interfaces.RealOutput E(final unit="J") "Consumed energy"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Units.SI.Energy EInt(
      start=0,
      fixed=true,
      unbounded=true,
      nominal=1E9) "Integral of H_flow";
    Modelica.Units.SI.HeatFlowRate H_flow "Enthalpy flow rate";
  equation
    der(EInt) = H_flow;
    H_flow = m_flow * Buildings.Utilities.Psychrometrics.Constants.cpWatLiq * (TMix-TCol);
    E = max(Buildings.Utilities.Psychrometrics.Constants.cpWatLiq*1, EInt);
    annotation (
    defaultComponentName="eneMet",
    Icon(graphics={
          Text(
            extent={{-96,72},{-70,48}},
            textColor={0,0,88},
            textString="TMix"),
          Text(
            extent={{-94,14},{-68,-10}},
            textColor={0,0,88},
            textString="TCol"),
          Text(
            extent={{-94,-46},{-68,-70}},
            textColor={0,0,88},
            textString="m_flow"),
          Text(
            extent={{68,12},{94,-12}},
            textColor={0,0,88},
            textString="E")}), Documentation(info="<html>
<p>
Block that outputs the integrated enthalpy flow rate.
</p>
<p>
To avoid division by zero in downstream blocks, the output is bounded away from zero.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 5, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end EnergyMeter;

protected
  parameter Modelica.Units.SI.Temperature dTSmall = 0.1 "Small temperature used to avoid division by zero";

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiMMix_flow(final k=mMix_flow_nominal)
    "Gain for multiplying domestic hot water schedule" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,30})));

  Buildings.Fluid.Movers.BaseClasses.IdealSource floSouHot(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_small=1E-4*mMix_flow_nominal,
    final control_m_flow=true,
    final control_dp=false)
    "Forced mass flow rate for hot water"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sinMMix(
    redeclare final package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Sink for mixed mass flow rate" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-60})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiMMix_sign(final k=-1)
    "Gain to invert sign" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,-10})));
equation
  connect(senTHot.port_a, port_hot)
    annotation (Line(points={{-80,-40},{-100,-40}}, color={0,127,255}));
  connect(port_col, senTCol.port_a)
    annotation (Line(points={{-100,-80},{-80,-80}}, color={0,127,255}));
  connect(yMixSet, gaiMMix_flow.u) annotation (Line(points={{-110,80},{-90,80},{
          -90,30},{-82,30}},   color={0,0,127}));
  connect(floSouHot.port_a, senTHot.port_b)
    annotation (Line(points={{-40,-40},{-60,-40}}, color={0,127,255}));
  connect(conPID.u_s, TMixSet) annotation (Line(points={{-22,0},{-88,0},{-88,20},
          {-110,20}}, color={0,0,127}));
  connect(senTMix.T, conPID.u_m) annotation (Line(points={{30,-49},{30,-20},{
          -10,-20},{-10,-12}}, color={0,0,127}));
  connect(sinMMix.m_flow_in, gaiMMix_sign.y) annotation (Line(points={{82,-52},
          {88,-52},{88,-10},{82,-10}}, color={0,0,127}));
  connect(mulMHot_flow.y, floSouHot.m_flow_in) annotation (Line(points={{82,20},
          {90,20},{90,-28},{-36,-28},{-36,-32}}, color={0,0,127}));
  connect(gaiMMix_flow.y, mulMHot_flow.u1) annotation (Line(points={{-58,30},{
          40,30},{40,26},{58,26}}, color={0,0,127}));
  connect(conPID.y, mulMHot_flow.u2) annotation (Line(points={{2,0},{50,0},{50,
          14},{58,14}},    color={0,0,127}));
  connect(gaiMMix_flow.y, gaiMMix_sign.u) annotation (Line(points={{-58,30},{40,
          30},{40,-10},{58,-10}}, color={0,0,127}));
  connect(senTMix.port_b, sinMMix.ports[1])
    annotation (Line(points={{40,-60},{60,-60}}, color={0,127,255}));
  connect(eneMetReq.TMix, TMixSet) annotation (Line(points={{-21,56},{-88,56},{-88,
          20},{-110,20}}, color={0,0,127}));
  connect(eneMetReq.TCol, senTCol.T) annotation (Line(points={{-21,50},{-52,50},
          {-52,-60},{-70,-60},{-70,-69}}, color={0,0,127}));
  connect(gaiMMix_flow.y, eneMetReq.m_flow) annotation (Line(points={{-58,30},{-32,
          30},{-32,44},{-21,44}}, color={0,0,127}));
  connect(eneMetAct.TMix, senTMix.T) annotation (Line(points={{-21,86},{-28,86},
          {-28,20},{30,20},{30,-49}}, color={0,0,127}));
  connect(eneMetAct.TCol, senTCol.T) annotation (Line(points={{-21,80},{-52,80},
          {-52,-60},{-70,-60},{-70,-69}}, color={0,0,127}));
  connect(eneMetAct.m_flow, gaiMMix_flow.y) annotation (Line(points={{-21,74},{-24,
          74},{-24,30},{-58,30}}, color={0,0,127}));
  connect(eneMetReq.E, ratEne.u2) annotation (Line(points={{1,50},{10,50},{10,64},
          {18,64}}, color={0,0,127}));
  connect(eneMetAct.E, ratEne.u1) annotation (Line(points={{1,80},{10,80},{10,76},
          {18,76}}, color={0,0,127}));
  when terminal() then
    assert(
      abs(1-ratEne.y) < relTol,
      "In " + getInstanceName() + ": Required domestic hot water flow rate is not met. Ratio of actual over required energy = " + String(ratEne.y),
      level=AssertionLevel.warning);
  end when;
  connect(floSouHot.port_b, jun.port_3)
    annotation (Line(points={{-20,-40},{0,-40},{0,-50}}, color={0,127,255}));
  connect(senTCol.port_b, jun.port_2) annotation (Line(points={{-60,-80},{-20,
          -80},{-20,-60},{-10,-60}}, color={0,127,255}));
  connect(jun.port_1, senTMix.port_a)
    annotation (Line(points={{10,-60},{20,-60}}, color={0,127,255}));
  annotation (
  defaultComponentName="theMixVal",
  preferredView="info",Documentation(info="<html>
<p>
This model implements a thermostatic mixing valve, which uses
a PI feedback controller to mix hot and cold fluid to achieve a specified 
mixed water outlet temperature.
</p>
<p>
If the mixed water temperature cannot be provided within a tolerance of <code>relTol</code>,
averaged over the whole simulation period,
then an assertion warning will be written at the end of the simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
December 7, 2023, by David Blum:<br/>
Added junction.
</li>
<li>
October 17, 2023, by Michael Wetter:<br/>
Revised implementation.
</li>
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
