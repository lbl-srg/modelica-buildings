within Buildings.Fluid.Storage.Plant.Validation;
model Open
  "Validation model of a storage plant with an open tank and remote charging ability"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlantRemote(
      nom(
        plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
      netCon(
        perPumSup(pressure(dp=(pBouSup - 101325)*{2,0},
                           V_flow=nom.m_flow_nominal/1.2*{0,2})),
        perPumRet(pressure(dp=(pBouRet - 101325)*{2,0},
                           V_flow=nom.m_flow_nominal/1.2*{0,2}))));
  Buildings.Fluid.Sources.Boundary_pT atmSup(
    redeclare final package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    nPorts=1) "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Fluid.Sources.Boundary_pT atmRet(
    redeclare final package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    nPorts=1) "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloRet(
    redeclare final package Medium = Medium)
    "Mass flow rate to the return line"
    annotation (Placement(transformation(extent={{-40,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
equation
  connect(conRemCha.yPumRet, netCon.yPumRet)
    annotation (Line(points={{16,39},{16,11}}, color={0,0,127}));
  connect(conRemCha.yValRet, netCon.yValRet)
    annotation (Line(points={{20,39},{20,11}}, color={0,0,127}));
  connect(senMasFlo.port_a, atmSup.ports[1])
    annotation (Line(points={{-60,30},{-80,30}}, color={0,127,255}));
  connect(isRemCha.y, swi.u2) annotation (Line(points={{22,90},{28,90},{28,72},{
          -38,72},{-38,50},{-32,50}}, color={255,0,255}));
  connect(swi.y, conRemCha.mTan_flow) annotation (Line(points={{-8,50},{-4,50},{
          -4,54},{-1,54}}, color={0,0,127}));
  connect(senMasFloRet.m_flow, swi.u1) annotation (Line(points={{-50,-19},{-50,-10},
          {-70,-10},{-70,58},{-32,58}}, color={0,0,127}));
  connect(senMasFlo.m_flow, swi.u3)
    annotation (Line(points={{-50,41},{-50,42},{-32,42}}, color={0,0,127}));
  connect(senMasFloRet.port_a, netCon.port_bToChi) annotation (Line(points={{
          -40,-30},{-10,-30},{-10,-6},{0,-6}}, color={0,127,255}));
  connect(senMasFloRet.port_b, atmRet.ports[1])
    annotation (Line(points={{-60,-30},{-80,-30}}, color={0,127,255}));
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
