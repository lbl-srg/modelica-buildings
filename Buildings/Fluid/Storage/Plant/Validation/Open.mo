within Buildings.Fluid.Storage.Plant.Validation;
model Open
  "Validation model of a storage plant with an open tank and remote charging ability"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant(
      nom(
        plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
      netCon(
        perPumSup(pressure(dp=(300000 + nom.dp_nominal - 101325)*{2,0},
                           V_flow=nom.m_flow_nominal/1.2*{0,2})),
        perPumRet(pressure(dp=(300000 - 101325)*{2,0},
                           V_flow=nom.m_flow_nominal/1.2*{0,2}))));
  Buildings.Fluid.Sources.Boundary_pT atm(
    redeclare final package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    nPorts=1) "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation
  connect(conRemCha.yPumRet, netCon.yPumRet)
    annotation (Line(points={{-24,39},{-24,11}},
                                               color={0,0,127}));
  connect(conRemCha.yValRet, netCon.yValRet)
    annotation (Line(points={{-20,39},{-20,11}},
                                               color={0,0,127}));
  connect(senMasFlo.port_a, atm.ports[1]) annotation (Line(points={{-80,10},{-80,
          10},{-80,30},{-80,30}}, color={0,127,255}));
annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/Open.mos"
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
end Open;
