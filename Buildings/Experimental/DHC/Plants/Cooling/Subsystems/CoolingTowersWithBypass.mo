within Buildings.Experimental.DHC.Plants.Cooling.Subsystems;
model CoolingTowersWithBypass
  "Cooling tower system with bypass valve"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare replaceable package Medium=Buildings.Media.Water);
  parameter Integer num(
    final min=1)=2
    "Number of cooling towers";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation (Dialog(tab="Dynamics",group="Filtered opening"));
  parameter Modelica.Units.SI.Time riseTime=30
    "Pump rise time of the filter (time to reach 99.6 % of the speed)" annotation (
      Dialog(
      tab="Dynamics",
      enable=use_inputFilter));
  parameter Modelica.Units.SI.Pressure dp_nominal
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
  parameter Modelica.Units.SI.TemperatureDifference dTApp=3
    "Approach temperature" annotation (Dialog(group="Control Settings"));
  parameter Modelica.Units.SI.Temperature TMin
    "Minimum allowed water temperature entering chiller"
    annotation (Dialog(group="Control Settings"));
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of fan speed controller"
    annotation (Dialog(group="Control Settings"));
  parameter Real k(
    final unit="1",
    final min=0)=1
    "Gain of the tower PID controller"
    annotation (Dialog(group="Control Settings"));
  parameter Modelica.Units.SI.Time Ti(final min=Modelica.Constants.small) = 60
    "Integrator time constant of the tower PID controller"
    annotation (Dialog(enable=(enableTi), group="Control Settings"));
  parameter Modelica.Units.SI.Time Td(final min=0) = 0.1
    "Derivative time constant of the tower PID controller"
    annotation (Dialog(enable=(enableTd), group="Control Settings"));
  Modelica.Blocks.Interfaces.BooleanInput on[num]
    "On signal for cooling towers"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final unit="K",
    displayUnit="degC")
    "Entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
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
  Buildings.Experimental.DHC.Plants.Cooling.Subsystems.CoolingTowersParallel cooTowSys(
    redeclare final package Medium=Medium,
    final use_inputFilter=false,
    final num=num,
    final show_T=show_T,
    final m_flow_small=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal/num,
    final dpValve_nominal=dpValve_nominal,
    final dp_nominal=dp_nominal,
    final ratWatAir_nominal=ratWatAir_nominal,
    final TAirInWB_nominal=TAirInWB_nominal,
    final TWatIn_nominal=TWatIn_nominal,
    final dT_nominal=dT_nominal,
    final PFan_nominal=PFan_nominal,
    final energyDynamics=energyDynamics)
    "Cooling tower system"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    final dpValve_nominal=dpValve_nominal,
    final riseTime=riseTime,
    final use_inputFilter=use_inputFilter)
    "Condenser water bypass valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},origin={0,-40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWSup(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_nominal,
    final T_start=Medium.T_default)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetByp(
    final k=TMin)
    "Bypass loop temperature setpoint"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset bypValCon(
    u_s(
      final unit="K",
      displayUnit="degC"),
    u_m(
      final unit="K",
      displayUnit="degC"),
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    final y_reset=0)
    "Bypass valve controller"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Reals.PID cooTowSpeCon(
    u_s(
      final unit="K",
      displayUnit="degC"),
    u_m(
      final unit="K",
      displayUnit="degC"),
    final reverseActing=false,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti)
    "Cooling tower fan speed controller"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Output the input of higher value"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    uLow=TMin-0.1,
    uHigh=TMin+0.1)
    "Compare if (TWetBul+dTApp) is greater than TMin"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    p=dTApp)
    "Add approach temperature on top of wetbulb temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Fluid.FixedResistances.Junction jun(
  redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal .* {1,-1,-1},
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Upstream mixing point of cooTowSys and valByp"
    annotation (Placement(transformation(extent={{-34,-4},{-26,4}})));
protected
  parameter Boolean enableTi=
    controllerType == Modelica.Blocks.Types.SimpleController.PI or
    controllerType == Modelica.Blocks.Types.SimpleController.PID
    "Flag to enable controller parameter Ti";
  parameter Boolean enableTd=
    controllerType == Modelica.Blocks.Types.SimpleController.PD or
    controllerType == Modelica.Blocks.Types.SimpleController.PID
    "Flag to enable controller parameter Td";
equation
  connect(cooTowSys.TWetBul,TWetBul)
    annotation (Line(points={{-12,-6},{-40,-6},{-40,-20},{-120,-20}},color={0,0,127}));
  connect(cooTowSys.port_b,senTCWSup.port_a)
    annotation (Line(points={{10,0},{60,0}},color={0,127,255}));
  connect(senTCWSup.port_b,port_b)
    annotation (Line(points={{80,0},{100,0}},color={0,127,255}));
  connect(TSetByp.y,bypValCon.u_s)
    annotation (Line(points={{-68,-50},{-62,-50}},color={0,0,127}));
  connect(senTCWSup.T,bypValCon.u_m)
    annotation (Line(points={{70,11},{70,30},{54,30},{54,-80},{-50,-80},{-50,-62}},
                                                                    color={0,0,127}));
  connect(valByp.port_b,senTCWSup.port_a)
    annotation (Line(points={{10,-40},{30,-40},{30,0},{60,0}},color={0,127,255}));
  connect(cooTowSpeCon.y,cooTowSys.uFanSpe)
    annotation (Line(points={{12,50},{16,50},{16,14},{-18,14},{-18,2},{-12,2}},
      color={0,0,127}));
  connect(cooTowSys.PFan,PFan)
    annotation (Line(points={{11,6},{40,6},{40,60},{110,60}},color={0,0,127}));
  connect(bypValCon.y,valByp.y)
    annotation (Line(points={{-38,-50},{-20,-50},{-20,-20},{0,-20},{0,-28}},
      color={0,0,127}));
  connect(senTCWSup.T,cooTowSpeCon.u_m)
    annotation (Line(points={{70,11},{70,30},{0,30},{0,38}},
                      color={0,0,127}));
  connect(hys.y, swi.u2)
    annotation (Line(points={{-48,50},{-42,50}}, color={255,0,255}));
  connect(cooTowSpeCon.u_s,swi.y)
    annotation (Line(points={{-12,50},{-18,50}},color={0,0,127}));
  connect(TSetByp.y,swi.u3)
    annotation (Line(points={{-68,-50},{-66,-50},{-66,34},{-46,34},{-46,42},{-42,
          42}},          color={0,0,127}));
  connect(TWetBul,addPar.u)
    annotation (Line(points={{-120,-20},{-86,-20},{-86,80},{-82,80}},
      color={0,0,127}));
  connect(addPar.y,swi.u1)
    annotation (Line(points={{-58,80},{-46,80},{-46,64},{-42,64},{-42,58}},
      color={0,0,127}));
  connect(on,cooTowSys.on)
    annotation (Line(points={{-120,40},{-80,40},{-80,6},{-12,6}},
      color={255,0,255}));
  connect(on[1],bypValCon.trigger)
    annotation (Line(points={{-120,30},{-80,30},{-80,-28},{-94,-28},{-94,-80},{-56,
          -80},{-56,-62}},
      color={255,0,255}));
  connect(port_a, jun.port_1)
    annotation (Line(points={{-100,0},{-34,0}}, color={0,127,255}));
  connect(cooTowSys.port_a, jun.port_2)
    annotation (Line(points={{-10,0},{-26,0}}, color={0,127,255}));
  connect(valByp.port_a, jun.port_3)
    annotation (Line(points={{-10,-40},{-30,-40},{-30,-4}}, color={0,127,255}));
  connect(addPar.y, hys.u)
    annotation (Line(points={{-58,80},{-46,80},{-46,64},{-78,64},{-78,50},{-72,50}},
      color={0,0,127}));
  connect(senTCWSup.T, TLvg)
    annotation (Line(points={{70,11},{70,30},{110,30}},
      color={0,0,127}));
  annotation (
    defaultComponentName="cooTowWitByp",
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Polygon(
          points={{0,-80},{-10,-72},{-10,-88},{0,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-80},{10,-72},{10,-88},{0,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-30,94},{30,20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,88},{0,80}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,88},{22,80}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{16,70},{22,58}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,70},{6,58}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,70},{-6,58}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{16,70},{10,58}},
          color={255,0,0},
          thickness=0.5),
        Rectangle(
          extent={{-30,8},{30,-66}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,2},{0,-6}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,2},{22,-6}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,-16},{-22,-28}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-16,-16},{-10,-28}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-16},{-6,-28}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-16},{6,-28}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{16,-16},{10,-28}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{16,-16},{22,-28}},
          color={255,0,0},
          thickness=0.5),
        Rectangle(
          extent={{30,24},{60,20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,-62},{60,-66}},
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
          extent={{58,-80},{62,24}},
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
          extent={{-64,-82},{-60,74}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-12},{16,-16}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,74},{16,70}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,70},{-22,58}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-16,70},{-10,58}},
          color={255,0,0},
          thickness=0.5),
        Rectangle(
          extent={{-60,-78},{-10,-82}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-78},{62,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(
      revisions="<html>
<ul>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
Set <code>dp_fixed = 0</code> for the bypass valve because the pressure drop in this leg
will be significantly less than the cooling towers.<br/>
Propagated <code>riseTime</code> for the valve signal filters.
</li>
<li>
November 16, 2022, by Michael Wetter:<br/>
Changed rise time of valve to 30 seconds so that it is the same as the one for the pumps,
and set <code>use_inputFilter = false</code> for shut-off valve in cooling tower.
This avoids a sharp rise in pressure near <i>t=35</i> seconds.
</li>
<li>May 19, 2020 by Jing Wang:<br/>First implementation. </li>
</ul>
</html>",
      info="<html>
<p>This model simulates parallel connected cooling tower subsystem with a bypass
valve. </p>
<p>The bypass valve is controlled to enforce that the leaving condenser water
temperature does not drop below the minimum temperature <code>TMin</code>.</p>
<p>By default, the condenser water setpoint is the ambient wet bulb temperature
<code>TWetBul</code> plus the approach temperature <code>dTApp</code>. </p>
<p>Inside the model, a cooling tower fan speed controller is also implemented to
maintain the condenser water at its setpoint.</p>
</html>"));
end CoolingTowersWithBypass;
