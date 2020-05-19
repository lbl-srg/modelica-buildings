within Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Subsystems;
model CoolingTowerWithBypass "Cooling tower system with bypass valve"
  replaceable package MediumCW =
      Buildings.Media.Water
    "Medium condenser water side";
  parameter Modelica.SIunits.Temperature TSet
    "The lower temperatre limit of condenser water entering the chiller plant";
  parameter Modelica.SIunits.Power P_nominal "Nominal tower power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTCW_nominal
    "Temperature difference between the outlet and inlet of the tower";
  parameter Modelica.SIunits.TemperatureDifference dTApp_nominal
    "Nominal approach temperature";
  parameter Modelica.SIunits.Temperature TWetBul_nominal
    "Nominal wet bulb temperature";
  parameter Modelica.SIunits.Pressure dP_nominal
    "Pressure difference between the outlet and inlet of the tower ";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal
    "Nominal mass flow rate at condenser water wide";
  parameter Real GaiPi "Gain of the tower PI controller";
  parameter Real tIntPi "Integration time of the tower PI controller";
  parameter Real v_flow_rate[:] "Volume flow rate rate";
  parameter Real eta[:] "Fan efficiency";
  parameter Modelica.SIunits.Pressure dPByp_nominal
    "Pressure difference between the outlet and inlet of the bypass valve ";
  parameter Modelica.SIunits.Temperature TCW_start
    "The start temperature of condenser water side";

  CoolingTowerParellel cooTowSys "Cooling tower system"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput on[2] "On signal for cooling towers"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWEntChi(
      redeclare package Medium = MediumCW, m_flow_nominal=3*mCW_flow_nominal,
    T_start=TCW_start)
    annotation (Placement(transformation(extent={{60,10},{80,-10}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul
    "Entering air wet bulb temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Sources.RealExpression TCWSet(y=froDegC.Celsius + dTApp)
    "Condenser water setpoint"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage           valByp(
    redeclare package Medium = MediumCW,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dPByp_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={0,-40})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.Constant TSetByPas(k=TSet)
    "Minimum allowed condenser water temperature"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.Continuous.LimPID valBypCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60) "Bypass valve controller"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Buildings.Controls.Continuous.LimPID cooTowSpeCon(
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    k=GaiPi,
    Ti=tIntPi,
    reset=Buildings.Types.Reset.Disabled) "Cooling tower fan speed controller"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
equation
  connect(cooTowSys.TWetBul, TWetBul) annotation (Line(points={{-12,-6},{-40,-6},
          {-40,-40},{-120,-40}}, color={0,0,127}));
  connect(on, cooTowSys.on) annotation (Line(points={{-120,40},{-40,40},{-40,6},
          {-12,6}},   color={0,0,127}));
  connect(cooTowSys.port_b, senTCWEntChi.port_a)
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(senTCWEntChi.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, port_a)
    annotation (Line(points={{-100,0},{-100,0}}, color={0,127,255}));
  connect(TSetByPas.y, valBypCon.u_s)
    annotation (Line(points={{-19,-70},{-12,-70}}, color={0,0,127}));
  connect(valBypCon.y, valByp.y) annotation (Line(points={{11,-70},{20,-70},{20,
          -20},{0,-20},{0,-28}}, color={0,0,127}));
  connect(senTCWEntChi.T, valBypCon.u_m) annotation (Line(points={{70,-11},{70,
          -90},{0,-90},{0,-82}}, color={0,0,127}));
  connect(valByp.port_a, cooTowSys.port_a) annotation (Line(points={{-10,-40},{
          -30,-40},{-30,0},{-10,0}}, color={0,127,255}));
  connect(TCWSet.y, cooTowSpeCon.u_s)
    annotation (Line(points={{-39,60},{-12,60}}, color={0,0,127}));
  connect(senTCWEntChi.T, cooTowSpeCon.u_m) annotation (Line(points={{70,-11},{
          70,-20},{50,-20},{50,40},{0,40},{0,48}}, color={0,0,127}));
  connect(cooTowSpeCon.y, cooTowSys.speFan) annotation (Line(points={{11,60},{
          20,60},{20,20},{-20,20},{-20,2},{-12,2}}, color={0,0,127}));
  connect(port_a, cooTowSys.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(valByp.port_b, senTCWEntChi.port_a) annotation (Line(points={{10,-40},
          {30,-40},{30,0},{60,0}}, color={0,127,255}));
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
<li>
March 30, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowerWithBypass;
