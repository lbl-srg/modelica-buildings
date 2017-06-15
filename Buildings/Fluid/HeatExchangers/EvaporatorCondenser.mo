within Buildings.Fluid.HeatExchangers;
model EvaporatorCondenser
  "Evaporator or condenser with refrigerant experiencing constant temperature phase change"
  extends Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol(
       final prescribedHeatFlowRate=false));

  parameter Modelica.SIunits.ThermalConductance UA
    "Thermal conductance of heat exchanger";
  parameter Modelica.SIunits.ThermalConductance UA_small=UA/10
    "Small thermal conductance for regularisation of heat transfer "
    annotation(Dialog(tab = "Advanced"));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat added to the fluid"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput T(unit="K") "Medium temperature"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_ref
    "Temperature and heat flow from the refrigerant"
    annotation (Placement(transformation(extent={{-5,-55},{5,-65}}),
        iconTransformation(extent={{-5,-55},{5,-65}})));


  Modelica.SIunits.Efficiency NTU = UA /
    (Buildings.Utilities.Math.Functions.smoothMax(abs(port_a.m_flow),m_flow_small,m_flow_small)*cp_default)
   "Number of transfer units of heat exchanger";

  Modelica.SIunits.Efficiency eps=
    Buildings.Utilities.Math.Functions.smoothMin(
      Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
      NTU,
      0,
      Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange)),
      0.999,
      1.0e-4)
    "Effectiveness of heat exchanger";

  Modelica.Blocks.Sources.RealExpression UAeff(
    final y=Buildings.Utilities.Math.Functions.smoothMax(
      x1=UA,
      x2=eps*cp_default*abs(port_a.m_flow)/(1 - eps),
      deltaX=UA_small))
    "Effective heat transfer coefficient"
    annotation (Placement(transformation(extent={{-88,-80},{-68,-60}})));

protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
     "Density, used to compute fluid volume";

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
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    "Temperature sensor"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  connect(heaFlo.port_b, vol.heatPort) annotation (Line(points={{-36,-30},{-36,
          -30},{-36,-10},{-9,-10}}, color={191,0,0}));
  connect(heaFlo.Q_flow, Q_flow) annotation (Line(points={{-26,-40},{-20,-40},{
          60,-40},{60,40},{110,40}}, color={0,0,127}));
  connect(port_ref, con.solid) annotation (Line(points={{0,-60},{0,-90},{-36,-90},
          {-36,-80}}, color={191,0,0}));
  connect(con.fluid, heaFlo.port_a)
    annotation (Line(points={{-36,-60},{-36,-56},{-36,-50}}, color={191,0,0}));
  connect(UAeff.y, con.Gc) annotation (Line(points={{-67,-70},{-46,-70}},
                 color={0,0,127}));
  connect(senTem.port, vol.heatPort)
    annotation (Line(points={{0,30},{-9,30},{-9,-10}}, color={191,0,0}));
  connect(senTem.T, T) annotation (Line(points={{20,30},{40,30},{40,80},{110,80}},
        color={0,0,127}));
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
Model for a constant temperature evaporator or condenser based on a &epsilon;-NTU
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
</html>",
revisions="<html>
<ul>
<li>
May 27, 2017, by Filip Jorissen:<br/>
Regularised heat transfer around zero flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/769\">#769</a>.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
Corrected invalid syntax for computing the specific heat capacity.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/707\">#707</a>.
</li>
<li>
October 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end EvaporatorCondenser;
