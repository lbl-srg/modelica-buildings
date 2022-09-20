within Buildings.Fluid.Storage.Plant.Validation;
model ClosedRemote
  "Validation model of a storage plant with a closed tank and remote charging ability"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlantRemote(
    nom(
      plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote));
equation
  connect(netCon.port_bToChi, senMasFlo.port_a) annotation (Line(points={{0,-6},{
          -70,-6},{-70,30},{-60,30}},  color={0,127,255}));
  connect(senMasFlo.m_flow, conRemCha.mTan_flow)
    annotation (Line(points={{-50,41},{-50,54},{-1,54}}, color={0,0,127}));
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
