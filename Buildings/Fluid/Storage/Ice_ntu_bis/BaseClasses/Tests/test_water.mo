within Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses.Tests;
model test_water

package Medium = Modelica.Media.Water.WaterIF97_pT;

  Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium "Water",
    m_flow=5,
    T=268.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Sources.Boundary_pT bou(redeclare package Medium = Medium "Water",
      nPorts=1)
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium "Water",
    m_flow_nominal=2,
    V=1,
    nPorts=2) annotation (Placement(transformation(extent={{-20,10},{0,30}})));
equation
  connect(boundary.ports[1], vol.ports[1]) annotation (Line(points={{-40,-10},{-11,
          -10},{-11,10}}, color={0,127,255}));
  connect(bou.ports[1], vol.ports[2])
    annotation (Line(points={{20,-10},{-9,-10},{-9,10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_water;
