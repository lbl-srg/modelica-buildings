within Buildings.Fluid.Storage.Plant.Examples;
model ClosedDualSource
  "(Draft) District system model with two sources and three users"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource;

  parameter Modelica.Units.SI.AbsolutePressure p_Pressurisation(
    final displayUnit="Pa")=
     300000
    "Pressurisation point";

  Buildings.Fluid.Sources.Boundary_pT sou_p1(
    redeclare final package Medium = MediumCHW,
    final p=p_Pressurisation,
    final T=T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,20})));
equation

  connect(sou_p1.ports[1], pumSup1.port_a) annotation (Line(points={{-160,20},{-54,
          20},{-54,40},{-60,40}}, color={0,127,255}));
    annotation (
              __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/ClosedDualSource.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=3600,__Dymola_Algorithm="Dassl"),
        Diagram(coordinateSystem(extent={{-180,-120},{140,140}})), Icon(
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
