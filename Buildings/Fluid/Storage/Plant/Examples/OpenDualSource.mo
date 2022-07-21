within Buildings.Fluid.Storage.Plant.Examples;
model OpenDualSource
  "District system model with two sources and three users"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource(
    nomPla2(plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
    tanBra(tankIsOpen=true));
equation
  connect(tanBra.mTanTop_flow,conRemCha.mTanTop_flow)
    annotation (Line(points={{-96,-39},{-96,-6},{-81,-6}}, color={0,0,127}));
  connect(conRemCha.yPumRet, netCon.yPumRet)
    annotation (Line(points={{-64,-21},{-64,-39}}, color={0,0,127}));
  connect(netCon.yRet,conRemCha.yRet)  annotation (Line(points={{-60.2,-39},{-60.2,
          -30},{-60,-30},{-60,-21}}, color={0,0,127}));

    annotation (
              __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/OpenDualSource.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=3600,__Dymola_Algorithm="Dassl"),
        Diagram(coordinateSystem(extent={{-180,-120},{140,140}})), Icon(
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
