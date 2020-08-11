within Buildings.Applications.DHC.EnergyTransferStations.Cooling;
model CoolingDirectUncontrolled
  "Direct cooling ETS model for district energy systems without in-building 
  pumping or deltaT control"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m1_flow_nominal = m_flow_nominal,
    final m2_flow_nominal = m_flow_nominal,
    show_T = true);

 replaceable package Medium =
   Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate";

  // pressure drops
  parameter Modelica.SIunits.PressureDifference dpSup(
    final min=0,
    displayUnit="Pa")=5000
  "Pressure drop in the ETS supply side";

  parameter Modelica.SIunits.PressureDifference dpRet(
    final min=0,
    displayUnit="Pa")=5000
  "Pressure drop in the ETS return side";

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="Power",
    final unit="W",
    displayUnit="kW")
    "Measured power demand at the ETS"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));

  Modelica.Blocks.Interfaces.RealOutput Q(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpSup)
    "Supply pipe"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipRet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpRet)
    "Return pipe"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium)
    "District supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    "District supply temperature sensor"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    "District return temperature sensor"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));

  Modelica.Blocks.Continuous.Integrator int(final k=1)
    "Integration"
    annotation (Placement(transformation(extent={{70,100},{90,120}})));

  Modelica.Blocks.Math.Add dTDis(
    final k1=-1,
    final k2=+1)
    "Temperature difference on the district side"
    annotation (Placement(transformation(extent={{-48,106},{-28,126}})));

  Modelica.Blocks.Math.Product pro
    "Product"
    annotation (Placement(transformation(extent={{-10,100},{10,120}})));

  Modelica.Blocks.Math.Gain cp(final k=cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{30,100},{50,120}})));

protected
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default) "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

equation
  connect(port_a1, senTDisSup.port_a)
    annotation (Line(points={{-100,60},{-90,60}}, color={0,127,255}));
  connect(senTDisSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-70,60},{-50,60}}, color={0,127,255}));
  connect(senMasFlo.port_b, pipSup.port_a)
    annotation (Line(points={{-30,60},{-10,60}}, color={0,127,255}));
  connect(pipSup.port_b, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(port_b2, senTDisRet.port_a)
    annotation (Line(points={{-100,-60},{-70,-60}}, color={0,127,255}));
  connect(senTDisRet.port_b, pipRet.port_b)
    annotation (Line(points={{-50,-60},{-10,-60}}, color={0,127,255}));
  connect(pipRet.port_a, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  connect(int.y, Q)
    annotation (Line(points={{91,110},{110,110}}, color={0,0,127}));
  connect(senTDisSup.T, dTDis.u1)
    annotation (Line(points={{-80,71},{-80,122},{-50,122}}, color={0,0,127}));
  connect(senTDisRet.T, dTDis.u2)
    annotation (Line(points={{-60,-49},{-60,110},{-50,110}}, color={0,0,127}));
  connect(senMasFlo.m_flow, pro.u2)
    annotation (Line(points={{-40,71},{-40,104},{-12,104}}, color={0,0,127}));
  connect(dTDis.y, pro.u1)
    annotation (Line(points={{-27,116},{-12,116}}, color={0,0,127}));
  connect(pro.y, cp.u)
    annotation (Line(points={{11,110},{28,110}}, color={0,0,127}));
  connect(cp.y, int.u)
    annotation (Line(points={{51,110},{68,110}}, color={0,0,127}));
  connect(cp.y, Q_flow)
    annotation (Line(points={{51,110},{60,110},{60,150},{110,150}}, color={0,0,127}));

  annotation (defaultComponentName="coo",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-56},{100,-64}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,64},{100,56}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={175,175,175},
          fillColor={35,138,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,68},{80,52}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-52},{80,-68}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,160}})),
        Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Direct cooling energy transfer station (ETS) model without in-building pumping 
or deltaT control. The design is based on a typical district cooling ETS 
described in ASHRAE's 
<a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">
District Cooling Guide</a>.  
As shown in the figure below, the district and building piping are hydronically 
coupled. This direct ETS connection relies on individual thermostatic control 
valves at each individual in-building terminal unit for control. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/CoolingDirectUncontrolled.PNG\" alt=\"DHC.ETS.CoolingDirectUncontrolled\"/>
</p>
<h4>Reference</h4>
<p>
American Society of Heating, Refrigeration and Air-Conditioning Engineers. 
(2013). Chapter 5: End User Interface. In <i>District Cooling Guide</i>. 1st Edition. 
</p>
</html>", revisions="<html>
<ul>
<li>November 13, 2019, by Kathryn Hinkelman:<br/>First implementation. </li>
</ul>
</html>"));
end CoolingDirectUncontrolled;

