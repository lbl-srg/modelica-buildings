within Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses;
partial model PartialRack "Partial model of an IT rack, with utilization as input"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=303.15,
              X_a=0.25)
              "Propylene glycol water, 25% mass fraction")));

  replaceable parameter Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.Data.Generic dat
    "Performance data"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Modelica.Units.SI.Time tau=2
    "Time constant of fluid outlet temperature at nominal flow"
    annotation(Dialog(tab="Dynamics"));

  // Initialization
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));

  Modelica.Blocks.Interfaces.RealInput P(final unit="W", min=0)
    "Electrical power consumption"
    annotation (Placement(transformation(extent={{-140,30},
            {-100,70}}),     iconTransformation(extent={{-120,50},{-100,70}})));

  output Real utiIT(
    final unit="1",
    final min=0) = P / dat.PIT_nominal "IT utilization";

  Fluid.Delays.DelayFirstOrder vol(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final m_flow_nominal=dat.m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final prescribedHeatFlowRate=true)
    "Fluid control volume"
    annotation (Placement(transformation(extent={{50,0},{70,20}})));

  Modelica.Units.SI.MassFlowRate m_flow = port_a.m_flow
    "Mass flow rate from port_a to port_b";

protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
equation
  connect(preHea.port,vol. heatPort) annotation (Line(points={{40,10},{50,10}},
                        color={191,0,0}));
annotation (
  Documentation(
    info="<html>
<p>
Partial model of an IT rack.
</p>
<h4>Electrical and fluid characterization</h4>
<p>
The model takes as an input the electrical power consumption,
and assumes all is converted to the heat that needs to be rejected
through the fluid ports, e.g.,
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q_flow = P.
</p>
<p>
The fluid outlet temperature is computed using a first order delay to mimic
the transient effect. This first order delay is characterized by the user-configurable
time constant <code>tau</code>, set by default to <code>tau=2</code> seconds.
For exact transient response, this value should be identified based on measurements.
</p>
<p>
To compute the pressure drop, the model uses
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDropPartiallyTurbulent\">
Buildings.Fluid.FixedResistances.PressureDropPartiallyTurbulent</a>.
Therefore, the mass flow rate and pressure drop are related as
</p>
<p align=\"center\" style=\"font-style:italic;\">
m_flow &frasl; m_flow_nominal = (dp &frasl; dp_nominal)<sup>m</sup>,
</p>
<p>
where 
<code>m_flow_nominal</code> is a parameter for the design flow rate,
<code>dp</code> is the pressure difference between inlet and outlet,
<code>dp_nominal</code> is a parameter for the design pressure difference, and
<code>m</code> is a parameter for the flow exponent.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 26, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,62},{40,-58}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,50},{32,36}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,28},{32,14}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,8},{32,-6}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-34},{32,-48}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-12},{32,-26}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,82},{-82,62}},
          textColor={0,0,127},
          textString="P"),
        Line(
          points={{-60,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-40,60},
          rotation=360)}));
end PartialRack;
