within Buildings.Fluid.Storage.Examples;
model ExpansionVessel "Test model for expansion vessel"
  import Buildings;

  annotation (
  Commands(file="ExpansionVessel.mos" "run"),
  Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),  graphics),
                      Commands(file="Stratified.mos" "run"),
    Documentation(info="<html>
This model tests a pressure expansion vessel. The medium model that is used in this
example changes its density as a function of temperature.
To see the effect of the expansion vessel, delete the connecting line between
the volume and the expansion vessel and check how much more the pressure increases
as the fluid is heated.
</html>"),
    experiment(StopTime=7200),
    experimentSetupOutput);
 package Medium = Modelica.Media.Water.WaterIF97OnePhase_ph "Medium model";
// package Medium = Buildings.Media.ConstantPropertyLiquidWaterCompressible "Medium model";

  inner Modelica.Fluid.System system(p_ambient=400000, massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial) 
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Fluid.Storage.ExpansionVessel expVes(
    redeclare package Medium = Medium, VTot=0.1) "Expansion vessel" 
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    V=1,
    nPorts=1) "Volume of water" 
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=20,
    period=3600,
    offset=293.15) 
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem 
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000) 
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(pulse.y, preTem.T) annotation (Line(
      points={{-59,0},{-42,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preTem.port, theCon.port_a) annotation (Line(
      points={{-20,0},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{20,0},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.ports[1], expVes.port_a) annotation (Line(
      points={{40,-10},{40,-20},{70,-20},{70,-10}},
      color={0,127,255},
      smooth=Smooth.None));
end ExpansionVessel;
