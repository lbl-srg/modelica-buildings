within Buildings.DHC.Plants.Cooling.Subsystems;
model CoolingTowersParallel
  "Multiple identical cooling towers in parallel connection"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare replaceable package Medium=Buildings.Media.Water);
  parameter Integer num(
    final min=1)=2
    "Number of cooling towers";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure difference of the tower"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal
    "Nominal pressure difference of the valve";
  parameter Real ratWatAir_nominal(
    final min=0,
    final unit="1")=0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAirInWB_nominal
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Temperature TWatIn_nominal
    "Nominal water inlet temperature" annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Power PFan_nominal "Fan power"
    annotation (Dialog(group="Fan"));
  parameter Boolean use_strokeTime=true
    "Set to true to continuously open and close valve"
    annotation (Dialog(tab="Dynamics",group="Time needed to open or close valve"));
  parameter Modelica.Units.SI.Time strokeTime=30
    "Time needed to change valve position from 0 to 1" annotation (
      Dialog(
      tab="Dynamics",
      enable=use_strokeTime));
  Modelica.Blocks.Interfaces.BooleanInput on[num]
    "On signal for cooling towers"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput uFanSpe(
    final unit="1")
    "Fan speed control signal"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final unit="K",
    displayUnit="degC")
    "Entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput PFan[num](
    each final quantity="Power",
    each final unit="W")
    "Electric power consumed by fan"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput TLvg(
    final unit="K",
    displayUnit="degC")
    "Leaving water temperature"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  replaceable Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel cooTow[num](
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_small=m_flow_small,
    each final ratWatAir_nominal=ratWatAir_nominal,
    each final TAirInWB_nominal=TAirInWB_nominal,
    each final TWatIn_nominal=TWatIn_nominal,
    each final TWatOut_nominal=TWatIn_nominal-dT_nominal,
    each final PFan_nominal=PFan_nominal,
    each final dp_nominal=0)
    constrainedby
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTowerVariableSpeed(
      redeclare each final package Medium=Medium,
      each final show_T=show_T,
      each final m_flow_nominal=m_flow_nominal,
      each final energyDynamics=energyDynamics)
    "Cooling tower type"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val[num](
    redeclare each final package Medium=Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_nominal=m_flow_nominal,
    each final dpValve_nominal=dpValve_nominal,
    each final use_strokeTime=use_strokeTime,
    each strokeTime=strokeTime,
    each final dpFixed_nominal=dp_nominal)
    "Cooling tower valves"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[num]
    "Boolean signal to real signal"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final T_start=Medium.T_default)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  for i in 1:num loop
    connect(port_a,val[i].port_a)
      annotation (Line(points={{-100,0},{-60,0}},color={0,127,255}));
    connect(val[i].port_b,cooTow[i].port_a)
      annotation (Line(points={{-40,0},{-10,0}},color={0,127,255}));
    connect(uFanSpe,cooTow[i].y)
      annotation (Line(points={{-120,20},{-20,20},{-20,8},{-12,8}},color={0,0,127}));
    connect(TWetBul,cooTow[i].TAir)
      annotation (Line(points={{-120,-60},{-20,-60},{-20,4},{-12,4}},color={0,0,127}));
    connect(cooTow[i].PFan,PFan[i])
      annotation (Line(points={{11,8},{20,8},{20,60},{110,60}},color={0,0,127}));
    connect(cooTow[i].port_b, senTem.port_a)
      annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  end for;
  connect(on,booToRea.u)
    annotation (Line(points={{-120,60},{-92,60}},color={255,0,255}));
  connect(senTem.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(senTem.T, TLvg)
    annotation (Line(points={{50,11},{50,30},{110,30}}, color={0,0,127}));
  connect(booToRea.y, val.y)
    annotation (Line(points={{-68,60},{-50,60},{-50,12}}, color={0,0,127}));
  annotation (
    defaultComponentName="cooTowPar",
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-30,80},{30,6}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,74},{0,66}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,74},{22,66}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{16,56},{22,44}},
          color={255,0,0}),
        Line(
          points={{0,56},{6,44}},
          color={255,0,0}),
        Line(
          points={{0,56},{-6,44}},
          color={255,0,0}),
        Line(
          points={{16,56},{10,44}},
          color={255,0,0}),
        Rectangle(
          extent={{-30,-6},{30,-80}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-22,-12},{0,-20}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,-12},{22,-20}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,-30},{-22,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-16,-30},{-10,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-30},{-6,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-30},{6,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{16,-30},{10,-42}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{16,-30},{22,-42}},
          color={255,0,0},
          thickness=0.5),
        Rectangle(
          extent={{30,10},{60,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,-76},{60,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{62,2},{92,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,-80},{62,10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,2},{-60,-2}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,-30},{-60,60}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-26},{16,-30}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{16,56}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,56},{-22,44}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-16,56},{-10,44}},
          color={255,0,0},
          thickness=0.5)}),
    Documentation(
      revisions="<html>
<ul>
<li>
November 16, 2022, by Michael Wetter:<br/>
Changed rise time of valve to 30 seconds so that it is the same as the one for the pumps.
</li>
<li>
May 19, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>This model implements a parallel cooling tower system with <code>num</code>
identical cooling towers. </p>
<p>The cooling tower type is replaceable.
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a> is currently used in
this model. </p>
</html>"),
    __Dymola_Commands);
end CoolingTowersParallel;
