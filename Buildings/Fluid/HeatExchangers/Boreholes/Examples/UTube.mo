within Buildings.Fluid.HeatExchangers.Boreholes.Examples;
model UTube "Model that tests the borehole model"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  Buildings.Fluid.HeatExchangers.Boreholes.UTube borHol(
    redeclare each package Medium = Medium,
    hBor=150,
    dp_nominal=10000,
    dT_dz=0.0015,
    samplePeriod=604800,
    m_flow_nominal=0.3,
    redeclare each parameter
      Buildings.HeatTransfer.Data.BoreholeFillings.Bentonite matFil,
    redeclare parameter Buildings.HeatTransfer.Data.Soil.Sandstone matSoi,
    TExt0_start=283.15,
    TFil0_start=283.15) "Borehole heat exchanger"
    annotation (Placement(transformation(extent={{-16,-36},{16,-4}},rotation=0)));
      inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Sources.Boundary_ph sin(nPorts=1, redeclare package Medium = Medium) "Sink"
    annotation (Placement(transformation(extent={{56,-30},{36,-10}})));
  Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=298.15) "Source"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=0.3,
    period=365*86400,
    startTime=365*86400/4)
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
equation
  connect(sou.ports[1], borHol.port_a)       annotation (Line(
      points={{-30,-20},{-16,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(borHol.port_b, sin.ports[1])      annotation (Line(
      points={{16,-20},{36,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pulse.y, sou.m_flow_in)       annotation (Line(
      points={{-69,-20},{-60,-20},{-60,-12},{-50,-12}},
      color={0,0,127},
      smooth=Smooth.None));
 annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot"),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}})),
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
      Tolerance=1e-05));
end UTube;
