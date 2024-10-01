within Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses.Tests;
model test_cp
  Sources.MassFlowSource_T boundary(
    redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    m_flow=5,
    nPorts=1)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Sources.Boundary_pT bou(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction", nPorts=1)
    annotation (Placement(transformation(extent={{0,-10},{-20,10}})));

package Medium =
        Buildings.Media.PropyleneGlycolWater (X_a=0.3);
        Modelica.Units.SI.SpecificHeatCapacity cp;
        Modelica.Units.SI.SpecificHeatCapacity cp1;
Real T;

equation
  T = min(273.15 - 10 + time/2, 273.15+20);
  cp = Buildings.Media.Antifreeze.Validation.BaseClasses.PropyleneGlycolWater.testSpecificHeatCapacityCp_TX_a(T=T, X_a=0.3);
  cp1 = Buildings.Media.Antifreeze.PropyleneGlycolWater.specificHeatCapacityCp_TX_a(T=T, X_a=0.3);
  connect(boundary.ports[1], bou.ports[1])
    annotation (Line(points={{-80,0},{-20,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_cp;
