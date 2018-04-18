within Buildings.Fluid.MixingVolumes.Validation;
model CoupledVolumesWater
  "Validation model for two coupled volumes with water"
  import Buildings;
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    nPorts=2,
    m_flow_nominal=1,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-10,2},{10,22}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=1)
    annotation (Placement(transformation(extent={{30,2},{50,22}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-78,-20},{-58,0}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=100) "Resistance to decouple initialization of pressure state"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  connect(bou.ports[1], res.port_a)
    annotation (Line(points={{-58,-10},{-40,-10}}, color={0,127,255}));
  connect(res.port_b, vol.ports[1])
    annotation (Line(points={{-20,-10},{-2,-10},{-2,2}},   color={0,127,255}));
  connect(vol.ports[2], vol1.ports[1]) annotation (Line(points={{2,2},{2,-10},{
          40,-10},{40,2}},       color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Validation model for two directly coupled volumes.
</p>
<p>
This tests whether a Modelica translator can perform the index reduction.
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2018, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/910\">Buildings, issue 910</a>.
</li>
</ul>
</html>"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/CoupledVolumesWater.mos"
           "Simulate and plot"));
end CoupledVolumesWater;
