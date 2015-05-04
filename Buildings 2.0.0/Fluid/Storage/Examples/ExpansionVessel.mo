within Buildings.Fluid.Storage.Examples;
model ExpansionVessel "Test model for expansion vessel"
  extends Modelica.Icons.Example;

// package Medium = Modelica.Media.Water.WaterIF97OnePhase_ph "Medium model";
 package Medium = Buildings.Media.Water "Medium model";


  Buildings.Fluid.Storage.ExpansionVessel expVes(
    redeclare package Medium = Medium, V_start=1) "Expansion vessel"
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
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(pulse.y, preTem.T) annotation (Line(
      points={{-59,0},{-54.75,0},{-54.75,1.27676e-015},{-50.5,1.27676e-015},{-50.5,
          0},{-42,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preTem.port, theCon.port_a) annotation (Line(
      points={{-20,0},{-15,0},{-15,1.22125e-015},{-10,1.22125e-015},{-10,0},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{20,0},{22.5,0},{22.5,1.22125e-015},{25,1.22125e-015},{25,0},{30,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.ports[1], expVes.port_a) annotation (Line(
      points={{40,-10},{40,-20},{70,-20},{70,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Examples/ExpansionVessel.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This model tests a pressure expansion vessel. The medium model that is used in this
example changes its density as a function of temperature.
To see the effect of the expansion vessel, delete the connecting line between
the volume and the expansion vessel and check how much more the pressure increases
as the fluid is heated.
</html>"),
    experiment(StopTime=7200));
end ExpansionVessel;
