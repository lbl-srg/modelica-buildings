within Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Subsystems;
model CoolingTowerParellel
  "Multipul cooling towers in parallel connection"
  replaceable package MediumCW =
      Buildings.Media.Water
    "Medium in the  condenser water side";
  parameter Modelica.SIunits.Power P_nominal
    "Nominal cooling tower power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTCW_nominal
    "Temperature difference between the outlet and inlet of the tower ";
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
  parameter Real v_flow_rate[:] "Air volume flow rate ratio";
  parameter Real eta[:] "Fan efficiency";
  parameter Modelica.SIunits.Temperature TCW_start
    "The start temperature of condenser water side";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumCW)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumCW)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul
    "Entering air wet bulb temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Fluid.HeatExchangers.CoolingTowers.Merkel cooTow1 "Cooling tower 1"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=dP_nominal) "Cooling tower 1 valve"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Fluid.HeatExchangers.CoolingTowers.Merkel cooTow2 "Cooling tower 1"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=dP_nominal) "Cooling tower 1 valve"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Interfaces.RealInput on[2] "On signal for cooling towers"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput speFan "Fan speed control signal"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealOutput PFan[2]
    "Electric power consumed by fan"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput TLvg[2]
                        "Leaving water temperature"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
equation
  connect(val1.port_b, cooTow1.port_a)
    annotation (Line(points={{-20,30},{20,30}}, color={0,127,255}));
  connect(cooTow1.port_b, port_b) annotation (Line(points={{40,30},{60,30},{60,0},
          {100,0}}, color={0,127,255}));
  connect(val1.port_a, port_a) annotation (Line(points={{-40,30},{-60,30},{-60,0},
          {-100,0}}, color={0,127,255}));
  connect(cooTow2.port_b, port_b) annotation (Line(points={{40,-30},{60,-30},{60,
          0},{100,0}}, color={0,127,255}));
  connect(val2.port_b, cooTow2.port_a)
    annotation (Line(points={{-20,-30},{20,-30}}, color={0,127,255}));
  connect(val2.port_a, port_a) annotation (Line(points={{-40,-30},{-60,-30},{-60,
          0},{-100,0}}, color={0,127,255}));
  connect(on[1], val1.y)
    annotation (Line(points={{-120,50},{-30,50},{-30,42}}, color={0,0,127}));
  connect(on[2], val2.y) annotation (Line(points={{-120,70},{-16,70},{-16,-12},
          {-30,-12},{-30,-18}}, color={0,0,127}));
  connect(speFan, cooTow1.y) annotation (Line(points={{-120,20},{-80,20},{-80,46},
          {12,46},{12,38},{18,38}}, color={0,0,127}));
  connect(speFan, cooTow2.y) annotation (Line(points={{-120,20},{-80,20},{-80,46},
          {12,46},{12,-22},{18,-22}}, color={0,0,127}));
  connect(TWetBul, cooTow2.TAir) annotation (Line(points={{-120,-60},{4,-60},{4,
          -26},{18,-26}}, color={0,0,127}));
  connect(TWetBul, cooTow1.TAir) annotation (Line(points={{-120,-60},{4,-60},{4,
          34},{18,34}}, color={0,0,127}));
  connect(cooTow2.PFan, PFan[2]) annotation (Line(points={{41,-22},{70,-22},{70,
          65},{110,65}}, color={0,0,127}));
  connect(cooTow1.PFan, PFan[1]) annotation (Line(points={{41,38},{70,38},{70,55},
          {110,55}}, color={0,0,127}));
  connect(cooTow2.TLvg, TLvg[2]) annotation (Line(points={{41,-36},{80,-36},{80,
          35},{110,35}}, color={0,0,127}));
  connect(cooTow1.TLvg, TLvg[1]) annotation (Line(points={{41,24},{80,24},{80,
          25},{110,25}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-30,66},{30,6}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,80},{24,66}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,74},{0,70}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,74},{18,70}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,56},{-22,44}},
          color={255,0,0}),
        Line(
          points={{16,56},{22,44}},
          color={255,0,0}),
        Line(
          points={{-60,56},{16,56}},
          color={255,0,0}),
        Line(
          points={{0,56},{6,44}},
          color={255,0,0}),
        Line(
          points={{-16,56},{-10,44}},
          color={255,0,0}),
        Line(
          points={{0,56},{-6,44}},
          color={255,0,0}),
        Line(
          points={{16,56},{10,44}},
          color={255,0,0}),
        Rectangle(
          extent={{-30,-20},{30,-80}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,-6},{24,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,-12},{0,-16}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,-12},{18,-16}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-16,-30},{-22,-42}},
          color={255,0,0}),
        Line(
          points={{16,-30},{22,-42}},
          color={255,0,0}),
        Line(
          points={{-60,-30},{16,-30}},
          color={255,0,0}),
        Line(
          points={{0,-30},{6,-42}},
          color={255,0,0}),
        Line(
          points={{-16,-30},{-10,-42}},
          color={255,0,0}),
        Line(
          points={{0,-30},{-6,-42}},
          color={255,0,0}),
        Line(
          points={{16,-30},{10,-42}},
          color={255,0,0}),
        Line(points={{-60,56},{-60,0},{-94,0}}, color={255,0,0}),
        Line(points={{-60,0},{-60,-30}}, color={255,0,0}),
        Line(points={{30,6},{60,6},{60,0},{96,0}}, color={28,108,200}),
        Line(points={{30,-80},{60,-80},{60,0}}, color={28,108,200}),
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
end CoolingTowerParellel;
