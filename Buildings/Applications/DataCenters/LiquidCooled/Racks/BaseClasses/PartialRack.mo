within Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses;
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

  parameter Modelica.Units.SI.HeatFlowRate P_nominal(min=0)
    "Design heat flow rate at u=1, also called Thermal Design Power (TDP)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  // Flow resistance
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Real n "Flow exponent, n=1 for laminar, n=2 for turbulent";
  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
                  Dialog(group = "Transition to laminar",
                         enable = not linearized));

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

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

  Modelica.Blocks.Interfaces.RealInput u(final unit="1", min=0)
    "Normalized utilization, equal to actual power use over P_nominal" annotation (Placement(transformation(extent={{-140,30},
            {-100,70}}),     iconTransformation(extent={{-120,50},{-100,70}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W")
    "Electrical power consumed by IT"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,70},{120,90}})));

  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final n=n) "Flow resistance"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Delays.DelayFirstOrder vol(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final prescribedHeatFlowRate=true,
    nPorts=1)       "Fluid control volume"
    annotation (Placement(transformation(extent={{50,0},{70,20}})));

  Modelica.Units.SI.MassFlowRate m_flow = port_a.m_flow
    "Mass flow rate from port_a to port_b";

  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa") = preDro.dp
    "Pressure difference between port_a and port_b";
protected
  Modelica.Blocks.Math.Gain Q_flow(final k=P_nominal)
    "Gain to compute actual heat flow rate"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea(final alpha=0)
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
equation
  connect(Q_flow.u, u) annotation (Line(points={{-82,50},{-120,50}},
                color={0,0,127}));
  connect(preHea.port,vol. heatPort) annotation (Line(points={{40,10},{50,10}},
                        color={191,0,0}));
  connect(port_a, preDro.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(port_b, vol.ports[2])
    annotation (Line(points={{100,0},{60,0}}, color={0,127,255}));
annotation (
  Documentation(
    info="<html>
<p>
Partial model of an IT rack.
</p>
<h4>Electrical and fluid characterization</h4>
<p>
The model takes as a parameter the thermal design power (TDB) <code>P_nominal</code>
and as an input the utilization <code>u</code>.
The heat added to the coolant fluid is then calculated as
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q_flow = u P_nominal.
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
          textString="u"),
        Line(
          points={{-60,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-40,60},
          rotation=360),
        Text(
          extent={{78,90},{92,70}},
          textColor={0,0,127},
          textString="P")}));
end PartialRack;
