within Buildings.Fluid.Storage.Plant.Examples;
model ClosedDualSource
  "District system model with two sources and three users"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource(
    netCon(perPumSup(pressure(V_flow=nomPla2.m_flow_nominal/1.2*{0,2},
                              dp=nomPla2.dp_nominal*{2,0}))),
    bou(p=300000));

  parameter Modelica.Units.SI.AbsolutePressure p_Pressurisation(
    final displayUnit="Pa")=
     300000
    "Pressurisation point";

    annotation (
              __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/ClosedDualSource.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=3600),
        Diagram(coordinateSystem(extent={{-180,-220},{160,260}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This model is the closed-tank version of the district system described in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource\">
Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource</a>.
The system is pressurised before the supply pump <code>pumSup1</code>
which is before the first chiller <code>chi1</code>.
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
end ClosedDualSource;
