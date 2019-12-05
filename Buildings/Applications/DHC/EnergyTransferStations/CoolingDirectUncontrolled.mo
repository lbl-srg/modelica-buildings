within Buildings.Applications.DHC.EnergyTransferStations;
model CoolingDirectUncontrolled
  "Direct cooling ETS model for district energy systems without in-building pumping or deltaT control"
  extends Buildings.Fluid.Interfaces.PartialFourPort(redeclare package Medium2 =
        Medium, redeclare package Medium1 = Medium);

 final package Medium = Buildings.Media.Water;

 parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";

  // mass flow rate
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0,start=0.5)
    "Nominal mass flow rate of primary (district) district cooling side";

  // pressure drops
  parameter Modelica.SIunits.PressureDifference dpSup=50
  "Pressure drop in the ETS supply side";

  parameter Modelica.SIunits.PressureDifference dpRet=50
  "Pressure drop in the ETS return side";

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="Power",
    final unit="W",
    displayUnit="kW")
    "Measured power demand at the ETS"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));

  Modelica.Blocks.Interfaces.RealOutput Q(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    dp_nominal=dpSup)
    "Supply pipe"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    dp_nominal=dpRet)
    "Return pipe"
    annotation (Placement(transformation(extent={{20,-70},{0,-50}})));

  Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal)
    "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Fluid.Sensors.TemperatureTwoPort senTDisRet(redeclare package Medium = Medium,
      m_flow_nominal=m1_flow_nominal)
    "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  Modelica.Blocks.Sources.RealExpression powCal(
    y=senMasFlo.m_flow*cp*(senTDisRet.T - senTDisSup.T))
    "Calculated power demand"
    annotation (Placement(transformation(extent={{-44,120},{36,140}})));

  Modelica.Blocks.Continuous.Integrator int(k=1) "Integration"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

equation

  connect(port_a1, senTDisSup.port_a)
    annotation (Line(points={{-100,60},{-90,60}}, color={0,127,255}));
  connect(senTDisSup.port_b, senMasFlo.port_a) annotation (Line(points={{-70,60},
          {-64,60},{-64,60},{-60,60}}, color={0,127,255}));
  connect(senMasFlo.port_b, pipSup.port_a)
    annotation (Line(points={{-40,60},{0,60}}, color={0,127,255}));
  connect(pipSup.port_b, port_b1)
    annotation (Line(points={{20,60},{100,60}}, color={0,127,255}));
  connect(port_b2, senTDisRet.port_a)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(senTDisRet.port_b, pipRet.port_b)
    annotation (Line(points={{-70,-60},{0,-60}}, color={0,127,255}));
  connect(pipRet.port_a, port_a2)
    annotation (Line(points={{20,-60},{100,-60}}, color={0,127,255}));
  connect(powCal.y, Q_flow)
    annotation (Line(points={{40,130},{110,130}}, color={0,0,127}));
  connect(powCal.y, int.u) annotation (Line(points={{40,130},{50,130},{50,110},
          {58,110}}, color={0,0,127}));
  connect(int.y, Q)
    annotation (Line(points={{81,110},{110,110}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
        Text(
          extent={{-52,40},{54,-40}},
          lineColor={0,0,0},
          fillColor={35,138,255},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="ETS")}), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,140}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Direct cooling energy transfer station (ETS) model without in-building pumping or deltaT control.
The design is based on a typical district cooling ETS described in ASHRAE's 
<a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">
District Cooling Guide</a>.  
As shown in the figure below, the district and building piping are hydronically coupled. This direct 
ETS connections relies on individual thermostatic control valves at each individual in-building 
terminal unit for control. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/CoolingDirectUncontrolled.PNG\"/>
</p>
<h4>Reference</h4>
<p>
American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2013). Chapter 5: End User Interface. In <i>District Cooling Guide</i>. 1st Edition. 
</p>
</html>", revisions="<html>
<ul>
<li>November 13, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end CoolingDirectUncontrolled;
