within Buildings.Fluid.Storage.Plant.Examples;
model OpenDualSource
  "District system model with two sources and three users"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource(
    netCon(perPumSup(pressure(V_flow=nomPla2.m_flow_nominal/1.2*{0,2},
                              dp=nomPla2.dp_nominal*{2,0}))),
    bou(p=101325));

equation
  connect(tanBra.mTan_flow, conRemCha.mTan_flow)
    annotation (Line(points={{-106,-79},{-106,-26},{-61,-26}},
                                                             color={0,0,127}));
    annotation (
              __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/OpenDualSource.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=3600),
        Diagram(coordinateSystem(extent={{-180,-220},{160,260}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This model is the open-tank version of the district system described in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource\">
Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource</a>.
Because the tank in <code>tanBra</code> is exposed to the atmosphere,
it also serves as the pressurisation point of the system.
</p>
</html>", revisions="<html>
<ul>
<li>
May 16, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end OpenDualSource;
