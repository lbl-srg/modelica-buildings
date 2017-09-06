within Buildings.Fluid.HeatExchangers.Ground.Boreholes.Examples;
model UTube "Model that tests the borehole model"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water;
 Buildings.Fluid.HeatExchangers.Ground.Boreholes.UTube borHol(
    redeclare package Medium = Medium,
    hBor=150,
    dp_nominal=10000,
    dT_dz=0.0015,
    samplePeriod=604800,
    m_flow_nominal=0.3,
    redeclare parameter
      Buildings.HeatTransfer.Data.BoreholeFillings.Bentonite matFil,
    redeclare parameter Buildings.HeatTransfer.Data.Soil.Sandstone matSoi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=283.15,
    TFil0_start=283.15) "Borehole heat exchanger"
    annotation (Placement(transformation(extent={{-16,-16},{16,16}})));
  Sources.Boundary_ph sin(
    redeclare package Medium = Medium,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{56,-10},{36,10}})));
  Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true,
    T=298.15) "Source"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=0.3,
    period=365*86400,
    startTime=365*86400/4)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
equation
  connect(sou.ports[1], borHol.port_a)       annotation (Line(
      points={{-30,0},{-16,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(borHol.port_b, sin.ports[1])      annotation (Line(
      points={{16,0},{36,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pulse.y, sou.m_flow_in)       annotation (Line(
      points={{-69,0},{-60,0},{-60,8},{-50,8}},
      color={0,0,127},
      smooth=Smooth.None));
 annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Ground/Boreholes/Examples/UTube.mos"
        "Simulate and plot"),
                  Documentation(info="<html>
<p>
This example models a borehole heat exchanger with two pipes that are
symmetrically spaced.
The simulation period is 5 years.
From the 4th to the 10th months, the mass flow source switches on the
flow rate through the borehole. The leaving
water of the mass flow source is <i>25</i>&deg;C,
and the water that returns from the borehole is between
<i>20.5</i>&deg;C
and
<i>21.5</i>&deg;C.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
September 27, 2013, by Michael Wetter:<br/>
Corrected <code>StopTime</code> annotation.
</li>
<li>
August 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=157680000,
      Tolerance=1e-6));
end UTube;
