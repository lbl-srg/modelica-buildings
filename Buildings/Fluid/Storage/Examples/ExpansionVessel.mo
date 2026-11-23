within Buildings.Fluid.Storage.Examples;
model ExpansionVessel "Test model for expansion vessel"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Medium model";

  Buildings.Fluid.Storage.ExpansionVessel expVes(
    redeclare package Medium = Medium,
    V_start=1)
    "Expansion vessel"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V=1,
    nPorts=1,
    m_flow_nominal=0.001,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Volume of water"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=20,
    period=3600,
    offset=293.15)
    "Pulse signal for temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature source"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000)
    "Thermal conductor to heat and cool the water volume"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(pulse.y, preTem.T)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(preTem.port, theCon.port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={191,0,0}));
  connect(theCon.port_b, vol.heatPort)
    annotation (Line(points={{20,0},{30,0}}, color={191,0,0}));
  connect(vol.ports[1], expVes.port_a)
    annotation (Line(points={{40,-10},{40,-20},{70,-20},{70,-10}}, color={0,127,255}));

  annotation (
    experiment(
      StopTime=7200,
      Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Examples/ExpansionVessel.mos"
      "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(
      info="<html>
<p>
This model tests a pressure expansion vessel connected to a heated and cooled
water volume.
</p>
<p>
The medium model computes water density as a function of temperature.
As the water in <code>vol</code> is heated and cooled, liquid flows into and out
of <code>expVes</code>, which changes the gas volume and pressure in the vessel.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 23, 2026, by Michael Wetter:<br/>
Changed medium to
<a href=\"modelica://Buildings.Media.Specialized.Water.TemperatureDependentDensity\">
Buildings.Media.Specialized.Water.TemperatureDependentDensity</a>
to exercise thermal expansion and pressure variation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2220\">IBPSA, #2220</a>.
</li>
<li>
December 19, 2022 by Hongxiang Fu:<br/>
Deleted outdated comment in documentation regarding compressible fluid.
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3198\">#3198</a>.
</li>
</ul>
</html>"));
end ExpansionVessel;