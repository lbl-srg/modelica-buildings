within Buildings.Applications.DHC.CentralPlants.Subsystems;
model CoolingTowerWithBypass
  "Cooling tower system with bypass valve"
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

  CoolingTowerParellel cooTowSys(
    redeclare package MediumCW = MediumCW,
    P_nominal=P_nominal,
    dTCW_nominal=dTCW_nominal,
    dP_nominal=dP_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    GaiPi=GaiPi,
    tIntPi=tIntPi,
    v_flow_rate=v_flow_rate,
    TCW_start=TCW_start,
    dTApp_nominal=dTApp_nominal,
    TWetBul_nominal=TWetBul_nominal,
    eta=eta) "Cooling tower system"
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
        origin={-20,-40})));
  Fluid.Sensors.MassFlowRate           senMasFloTow(redeclare package Medium =
        MediumCW)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Sensors.MassFlowRate           senMasFloByp(redeclare package Medium =
        MediumCW)                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={20,-40})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Sources.Constant TSetByPas(k=TSet)
    "Minimum allowed condenser water temperature"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60) annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Controls.CoolingTowerSpeed cooTowSpeCon "Cooling tower speed controllers"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
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
  connect(port_a, senMasFloTow.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(senMasFloTow.port_b, cooTowSys.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
  connect(TSetByPas.y, conPID.u_s)
    annotation (Line(points={{-59,-70},{-42,-70}}, color={0,0,127}));
  connect(conPID.y, valByp.y) annotation (Line(points={{-19,-70},{-4,-70},{-4,
          -20},{-20,-20},{-20,-28}}, color={0,0,127}));
  connect(senTCWEntChi.T, conPID.u_m) annotation (Line(points={{70,-11},{70,-90},
          {-30,-90},{-30,-82}}, color={0,0,127}));
  connect(TCWSet.y, cooTowSpeCon.TCWSet) annotation (Line(points={{-39,60},{-26,
          60},{-26,54},{-12,54}}, color={0,0,127}));
  connect(cooTowSpeCon.y, cooTowSys.speFan) annotation (Line(points={{11,50},{
          20,50},{20,20},{-26,20},{-26,2},{-12,2}}, color={0,0,127}));
  connect(valByp.port_a, cooTowSys.port_a) annotation (Line(points={{-30,-40},{
          -34,-40},{-34,0},{-10,0}}, color={0,127,255}));
  connect(valByp.port_b, senMasFloByp.port_a)
    annotation (Line(points={{-10,-40},{10,-40}}, color={0,127,255}));
  connect(senMasFloByp.port_b, senTCWEntChi.port_a) annotation (Line(points={{
          30,-40},{34,-40},{34,0},{60,0}}, color={0,127,255}));
  connect(senTCWEntChi.T, cooTowSpeCon.TCWMea) annotation (Line(points={{70,-11},
          {70,-20},{50,-20},{50,34},{-26,34},{-26,46},{-12,46}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-30,84},{30,24}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,98},{24,84}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,92},{0,88}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,92},{18,88}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,74},{-22,62}},
          color={255,0,0}),
        Line(
          points={{16,74},{22,62}},
          color={255,0,0}),
        Line(
          points={{-60,74},{16,74}},
          color={255,0,0}),
        Line(
          points={{0,74},{6,62}},
          color={255,0,0}),
        Line(
          points={{-16,74},{-10,62}},
          color={255,0,0}),
        Line(
          points={{0,74},{-6,62}},
          color={255,0,0}),
        Line(
          points={{16,74},{10,62}},
          color={255,0,0}),
        Rectangle(
          extent={{-30,0},{30,-60}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,14},{24,0}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,8},{0,4}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,8},{18,4}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,-10},{-22,-22}},
          color={255,0,0}),
        Line(
          points={{16,-10},{22,-22}},
          color={255,0,0}),
        Line(
          points={{-60,-10},{16,-10}},
          color={255,0,0}),
        Line(
          points={{0,-10},{6,-22}},
          color={255,0,0}),
        Line(
          points={{-16,-10},{-10,-22}},
          color={255,0,0}),
        Line(
          points={{0,-10},{-6,-22}},
          color={255,0,0}),
        Line(
          points={{16,-10},{10,-22}},
          color={255,0,0}),
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
        Line(points={{-100,0},{-60,0},{-60,74}}, color={238,46,47}),
        Line(points={{-60,0},{-60,-10}}, color={238,46,47}),
        Line(points={{30,24},{60,24},{60,0},{100,0}}, color={28,108,200}),
        Line(points={{30,-60},{60,-60},{60,0}}, color={28,108,200}),
        Line(points={{-60,-10},{-60,-80},{-10,-80}}, color={238,46,47}),
        Line(points={{10,-80},{60,-80},{60,-60}}, color={238,46,47}),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(revisions="<html>
<ul>
<li>
March 30, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowerWithBypass;
