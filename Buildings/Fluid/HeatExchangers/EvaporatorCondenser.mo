within Buildings.Fluid.HeatExchangers;
model EvaporatorCondenser
  "Evaporator / condenser with refrigerant experiencing constant temperature phase change"
  extends Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol(
       prescribedHeatFlowRate=false));

  parameter Modelica.SIunits.ThermalConductance UA
    "Thermal conductance of heat exchanger";

  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat added to the fluid"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ref
    "Temperature and heat flow from the refrigerant"
    annotation (Placement(transformation(extent={{-5,-55},{5,-65}}),
        iconTransformation(extent={{-5,-55},{5,-65}})));

  Modelica.SIunits.SpecificHeatCapacityAtConstantPressure
    cp = vol.Medium.cp_const "Specific heat capacity of the fluid";
  Modelica.SIunits.Efficiency NTU = UA /
    (Buildings.Utilities.Math.Functions.smoothMax(abs(port_a.m_flow),m_flow_small,m_flow_small)*cp)
  "Number of transfer units of heat exchanger";
  Modelica.SIunits.Efficiency
    eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
      NTU, 0, Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange))
    "Effectiveness of heat exchanger";
  Modelica.Blocks.Sources.RealExpression UAeff(y=eps*cp*abs(port_a.m_flow)/(1 - eps))
    annotation (Placement(transformation(extent={{-88,-80},{-68,-60}})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo
    "Heat flow sensor"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-36,-40})));
  Modelica.Thermal.HeatTransfer.Components.Convection con
    "Convective heat transfer"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-36,-70})));
equation
  connect(heaFlo.port_b, vol.heatPort) annotation (Line(points={{-36,-30},{-36,
          -30},{-36,-10},{-9,-10}}, color={191,0,0}));
  connect(heaFlo.Q_flow, Q_flow) annotation (Line(points={{-26,-40},{-20,-40},{
          60,-40},{60,60},{110,60}}, color={0,0,127}));
  connect(port_ref, con.solid) annotation (Line(points={{0,-60},{0,-90},{-36,-90},
          {-36,-80}}, color={191,0,0}));
  connect(con.fluid, heaFlo.port_a)
    annotation (Line(points={{-36,-60},{-36,-50}},           color={191,0,0}));
  connect(UAeff.y, con.Gc) annotation (Line(points={{-67,-70},{-56.5,-70},{-46,
          -70}}, color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{70,60},{100,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{72,94},{116,66}},
          lineColor={0,0,127},
          textString="Q_flow")}),
defaultComponentName="evaCon",
Documentation(info="<html>
<p>
Model for a constant temperature evaporator / condenser based on a epsilon-NTU
heat exchanger model.
</p>
<p>
The heat exchanger effectiveness is calculated from the number of transfer units
(NTU):
</p>
<p align=\"center\" style=\"font-style:italic;\">
&epsilon; = 1 - exp(UA &frasl; (m&#775; c<sub>p</sub>))
</p>
<p>
Optionally, this model can have a flow resistance.
If no flow resistance is requested, set <code>dp_nominal=0</code>.
</p>
<h4>Limitations</h4>
<p>
This model does not consider any superheating or supercooling on the refrigerant
side. The refrigerant is considered to exchange heat at a constant temperature
throughout the heat exchanger.
</p>
<h4>Validation</h4>
<p>
The model has been validated against the analytical solution in
the example
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.EvaporatorCondenser\">
Buildings.Fluid.HeatExchangers.Validation.EvaporatorCondenser</a>.
fixme: update documentation.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end EvaporatorCondenser;
