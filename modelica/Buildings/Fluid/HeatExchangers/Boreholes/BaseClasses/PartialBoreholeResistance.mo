within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
partial model PartialBoreholeResistance
  "Partial model for thermal resistance of the borehole"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Radius rTub "Radius of the tubes"
    annotation (Dialog(group="Pipes"));
  parameter Modelica.SIunits.ThermalConductivity kTub=4
    "Thermal conductivity of the tubes" annotation (Dialog(group="Pipes"));
  parameter Modelica.SIunits.Length eTub=0.002 "Thickness of the tubes"
    annotation (Dialog(group="Pipes"));
  parameter Modelica.SIunits.Radius rBor "Radius of the borehole";
  parameter Modelica.SIunits.ThermalConductivity kFil;
  parameter Modelica.SIunits.Height hSeg "Height of the segment";
  parameter Real B0=17.44268 "Shape coefficient for grout resistance";
  parameter Real B1=-0.60515 "Shape coefficient for grout resistance";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput m_flow(unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Modelica.SIunits.ThermalConductance G "Thermal conductance";
  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate from port_a to port_b";
  Modelica.SIunits.TemperatureDifference dT "= port_a.T - port_b.T";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation (
      Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation (
      Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));

protected
  parameter Modelica.SIunits.SpecificHeatCapacity cpFluid=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.SIunits.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.SIunits.DynamicViscosity mueMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";
  Modelica.SIunits.ThermalResistance Rb "Borehole thermal resistance";
equation
  dT = port_a.T - port_b.T;
  port_a.Q_flow = Q_flow;
  port_b.Q_flow = -Q_flow;
  Q_flow = G*dT;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-90,70},{90,-70}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-90,70},{-90,-70}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{90,70},{90,-70}},
          color={0,0,0},
          thickness=0.5),
        Text(
          extent={{-150,115},{150,75}},
          textString="%name",
          lineColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Line(
          points={{-80,0},{80,0}},
          color={255,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-26,-10},{27,-39}},
          lineColor={255,0,0},
          textString="Q_flow"),
        Text(
          extent={{-80,50},{80,20}},
          lineColor={0,0,0},
          textString="dT = port_a.T - port_b.T")}),
    Documentation(info="<html>
<p>
Partial model for the thermal resistance of the borehole.
</p>
</html>", revisions="<html>
<ul>
<li>
September 9 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialBoreholeResistance;
