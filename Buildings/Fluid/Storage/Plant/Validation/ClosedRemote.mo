within Buildings.Fluid.Storage.Plant.Validation;
model ClosedRemote
  "Validation model of a storage plant with a closed tank and remote charging ability"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant(
    nom(
      plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote),
      netCon(perPumSup(pressure(V_flow=nom.m_flow_nominal/1.2*{0,2},
                                dp=nom.dp_nominal*{2,0}))));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = Medium,
    final p(displayUnit="Pa") = 300000,
    nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(extent={{100,-60},{80,-40}})));
equation
  connect(bou.ports[1], idePreSou.port_a) annotation (Line(points={{80,-50},{74,
          -50},{74,-14},{50,-14},{50,-10}}, color={0,127,255}));
annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/ClosedRemote.mos"
        "Simulate and plot"),
    Documentation(info="<html>
[]
</html>", revisions="<html>
<ul>
<li>
September 20, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end ClosedRemote;
