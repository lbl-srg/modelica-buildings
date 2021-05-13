within Buildings.Fluid.MixingVolumes.BaseClasses.Validation;
model MixingVolumeHeatPortWater
  "Validation model for setting the initialization of the pressure for water"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium model";

  parameter Integer nEle(min=2)= 3 "Number of volumes"
    annotation(Evaluate=true);

  replaceable Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort vol[nEle]
    constrainedby Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort(
    redeclare each package Medium = Medium,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final initialize_p={(i == 1 and not Medium.singleState) for i in 1:nEle},
    each m_flow_nominal=1,
    each V=1,
    each nPorts=2) "Mixing volume"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1000) "Pressure drop"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1)
    "Boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,0})));

  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1000) "Pressure drop"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));

  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    nPorts=1)
    "Boundary condition"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,0})));
equation
  connect(bou.ports[1], res.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(res.port_b, vol[1].ports[1])
    annotation (Line(points={{-20,0},{0,0},{0,20}}, color={0,127,255}));
  for i in 1:nEle-1 loop
    connect(vol[i].ports[2], vol[i+1].ports[1]);
  end for;
  connect(res1.port_b, vol[nEle].ports[2]) annotation (Line(points={{20,0},{0,0},
          {0,20}},            color={0,127,255}));
  connect(bou1.ports[1], res1.port_a)
    annotation (Line(points={{60,1.33227e-15},{46,1.33227e-15},{46,0},{40,0}},
                                                   color={0,127,255}));

  annotation (Documentation(info="<html>
<p>
Model that validates that the initial conditions are uniquely set
and not overdetermined.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2017 by Michael Wetter:<br/>
Corrected medium for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/850\">issue 850</a>.
</li>
<li>
October 23, 2017 by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
</ul>
</html>"),
experiment(Tolerance=1E-6, StopTime=1.0),
__Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/BaseClasses/Validation/MixingVolumeHeatPortWater.mos"
  "Simulate and plot"));
end MixingVolumeHeatPortWater;
