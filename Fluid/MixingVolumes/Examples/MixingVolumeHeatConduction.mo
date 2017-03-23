within Buildings.Fluid.MixingVolumes.Examples;
model MixingVolumeHeatConduction "Test model for heat transfer to volume"
  extends Modelica.Icons.Example;
    package Medium = Modelica.Media.Air.SimpleAir;
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10)
    "Thermal conductor"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAmb(T=293.15)
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=313.15,
    nPorts=1) "Flow source and sink"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Fluid.Sources.FixedBoundary bou(
    redeclare package Medium = Medium,
    T=303.15,
    nPorts=1) "Boundary condition"                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-10})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    V=1,
    redeclare package Medium = Medium,
    m_flow_nominal=0.01,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=true,
    prescribedHeatFlowRate=false,
    nPorts=2) annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    offset=1,
    height=-2)
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Math.Gain gain(k=0.01)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(TAmb.port, theCon.port_a)           annotation (Line(
      points={{-60,30},{-50,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo.port_b, vol.heatPort)            annotation (Line(
      points={{20,30},{30,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ramp.y, gain.u) annotation (Line(
      points={{-69,-10},{-62,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, sou.m_flow_in) annotation (Line(
      points={{-39,-10},{-31.5,-10},{-31.5,-2},{-20,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theCon.port_b, heaFlo.port_a) annotation (Line(
      points={{-30,30},{0,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.ports[1], vol.ports[1]) annotation (Line(
      points={{0,-10},{38,-10},{38,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], bou.ports[1]) annotation (Line(
      points={{42,20},{42,-10},{60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(
        info="<html>
<p>
This model demonstrates the use of the mixing volume with heat conduction to the ambient.
The mixing volume is configured as a steady-state model.
</p>
</html>", revisions="<html>
<ul>
<li>
October 12, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumeHeatConduction.mos"
        "Simulate and plot"),
    Diagram(graphics));
end MixingVolumeHeatConduction;
