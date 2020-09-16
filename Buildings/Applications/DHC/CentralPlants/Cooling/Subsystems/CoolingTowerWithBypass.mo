within Buildings.Applications.DHC.CentralPlants.Cooling.Subsystems;
model CoolingTowerWithBypass "Cooling tower system with bypass valve"

  replaceable package Medium=Buildings.Media.Water
    "Condenser water medium";

  parameter Integer num(min=1)=2 "Number of cooling towers";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  parameter Boolean show_T = true
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Total nominal mass flow rate of condenser water"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Pressure dp_nominal
    "Nominal pressure difference of the tower"
    annotation (Dialog(group="Nominal condition"));

  parameter Real ratWatAir_nominal(min=0, unit="1")=0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Temperature TAirInWB_nominal
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));

  parameter Modelica.SIunits.Temperature TWatIn_nominal
    "Nominal water inlet temperature"
    annotation (Dialog(group="Heat transfer"));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal
    "Temperature difference between inlet and outlet of the tower"
     annotation (Dialog(group="Heat transfer"));

  parameter Modelica.SIunits.Power PFan_nominal
    "Fan power"
    annotation (Dialog(group="Fan"));

  parameter Modelica.SIunits.TemperatureDifference dTApp=3
    "Approach temperature"
    annotation (Dialog(group="Control Settings"));

  parameter Modelica.SIunits.Temperature TMin
    "Minimum allowed water temperature entering chiller"
    annotation (Dialog(group="Control Settings"));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of fan speed controller"
    annotation (Dialog(group="Control Settings"));

  parameter Real k(unit="1", min=0)=1
    "Gain of the tower PID controller"
    annotation (Dialog(group="Control Settings"));

  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=60
    "Integrator time constant of the tower PID controller"
    annotation (Dialog(enable=(
    controllerType == Modelica.Blocks.Types.SimpleController.PI or
    controllerType == Modelica.Blocks.Types.SimpleController.PID),
    group="Control Settings"));

  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Derivative time constant of the tower PID controller"
    annotation (Dialog(enable=(
    controllerType==Modelica.Blocks.Types.SimpleController.PD or
    controllerType==Modelica.Blocks.Types.SimpleController.PID),
    group="Control Settings"));

  Medium.ThermodynamicState sta_a=
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if
         show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if
          show_T "Medium properties in port_b";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium=Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput on[num](
    min=0, max=1, unit="1") "On signal for cooling towers"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final unit="K",
    displayUnit="degC")
    "Entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));

  Modelica.Blocks.Interfaces.RealOutput PFan[num](
    final quantity="Power",
    final unit="W")
    "Electric power consumed by fan"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Interfaces.RealOutput TLvg[num](
    final unit="K",
    displayUnit="degC")
    "Leaving water temperature"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Applications.DHC.CentralPlants.Cooling.Subsystems.CoolingTowerParellel
    cooTowSys(
    use_inputFilter=true,
    redeclare package Medium = Medium,
    num=num,
    show_T=show_T,
    m_flow_nominal=m_flow_nominal/num,
    dp_nominal=dp_nominal,
    ratWatAir_nominal=ratWatAir_nominal,
    TAirInWB_nominal=TAirInWB_nominal,
    TWatIn_nominal=TWatIn_nominal,
    dT_nominal=dT_nominal,
    PFan_nominal=PFan_nominal,
    energyDynamics=energyDynamics) "Cooling tower system"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*0.0001,
    dpValve_nominal=dp_nominal,
    use_inputFilter=false) "Condenser water bypass valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={0,-40})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=Medium.T_default)
    annotation (Placement(transformation(extent={{60,10},{80,-10}})));

  Modelica.Blocks.Sources.RealExpression TSetCWSup(y=max(TWetBul + dTApp, TMin))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Modelica.Blocks.Sources.Constant TSetByPas(k=TMin)
    "Bypass loop temperature setpoint"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

  Buildings.Controls.Continuous.LimPID bypValCon(
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"),
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
    "Bypass valve controller"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Controls.Continuous.LimPID cooTowSpeCon(
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"),
    final reverseActing=false,
    controllerType=controllerType,
    k=k,
    Ti=Ti) "Cooling tower fan speed controller"
    annotation (Placement(transformation(extent={{-12,50},{8,70}})));

  Modelica.Blocks.Sources.RealExpression TLvgCooTow(y=senTCWSup.T)
    "Condenser water temperature leaving the towers"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));

  Modelica.Blocks.Math.RealToBoolean reaToBoo "Real to boolean signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
equation
  connect(cooTowSys.TWetBul, TWetBul) annotation (Line(points={{-12,-6},{-40,-6},
          {-40,-20},{-120,-20}}, color={0,0,127}));
  connect(on, cooTowSys.on) annotation (Line(points={{-120,40},{-40,40},{-40,6},
          {-12,6}},   color={0,0,127}));
  connect(port_a, cooTowSys.port_a) annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(cooTowSys.port_b, senTCWSup.port_a) annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(senTCWSup.port_b, port_b) annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(TSetByPas.y, bypValCon.u_s) annotation (Line(points={{-69,-50},{-62,-50}}, color={0,0,127}));
  connect(senTCWSup.T, bypValCon.u_m) annotation (Line(points={{70,-11},{70,-80},
          {-50,-80},{-50,-62}},
                            color={0,0,127}));
  connect(valByp.port_a, cooTowSys.port_a) annotation (Line(points={{-10,-40},{-30,
          -40},{-30,0},{-10,0}}, color={0,127,255}));
  connect(valByp.port_b, senTCWSup.port_a) annotation (Line(points={{10,-40},{30,-40},{30,0},{60,0}}, color={0,127,255}));
  connect(TSetCWSup.y, cooTowSpeCon.u_s) annotation (Line(points={{-39,60},{-14,
          60}},                                                                       color={0,0,127}));
  connect(cooTowSpeCon.y, cooTowSys.speFan) annotation (Line(points={{9,60},{20,
          60},{20,20},{-20,20},{-20,2},{-12,2}}, color={0,0,127}));
  connect(cooTowSys.PFan, PFan) annotation (Line(points={{11,6},{40,6},{40,60},{
          110,60}}, color={0,0,127}));
  connect(cooTowSys.TLvg, TLvg) annotation (Line(points={{11,3},{44,3},{44,30},{
          110,30}}, color={0,0,127}));
  connect(bypValCon.y, valByp.y) annotation (Line(points={{-39,-50},{-20,-50},{-20,
          -20},{0,-20},{0,-28}}, color={0,0,127}));
  connect(TLvgCooTow.y, cooTowSpeCon.u_m) annotation (Line(points={{-9,40},{-2,40},{-2,48}},
                                                     color={0,0,127}));
  connect(reaToBoo.y, bypValCon.trigger) annotation (Line(points={{-69,-80},{
          -58,-80},{-58,-62}}, color={255,0,255}));
  connect(on[1], reaToBoo.u) annotation (Line(points={{-120,30},{-96,30},{-96,
          -80},{-92,-80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
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
          lineColor={0,0,255},
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
    Documentation(revisions="<html>
<ul>
<li>May 19, 2020 by Jing Wang:<br>First implementation. </li>
</ul>
</html>"));
end CoolingTowerWithBypass;
