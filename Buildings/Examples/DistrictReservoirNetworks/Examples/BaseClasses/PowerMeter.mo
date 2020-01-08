within Buildings.Examples.DistrictReservoirNetworks.Examples.BaseClasses;
block PowerMeter
  "Block that sums input and integrates it from power to energy"
  extends Modelica.Blocks.Interfaces.PartialRealMISO(
   u(each unit="W"),
   y(unit="J"));

  final parameter String insNam = getInstanceName() "Instance name";
  Modelica.Blocks.Math.MultiSum multiSum(final nu=nu)
    annotation (Placement(transformation(extent={{-34,-6},{-22,6}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    final initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(multiSum.u, u)
    annotation (Line(points={{-34,0},{-100,0}}, color={0,0,127}));
  connect(multiSum.y, integrator.u)
    annotation (Line(points={{-20.98,0},{38,0}}, color={0,0,127}));
  connect(y, integrator.y)
    annotation (Line(points={{117,0},{61,0}}, color={0,0,127}));
  annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid)}));
end PowerMeter;
