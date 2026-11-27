within Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples;
model CDU_epsNTU "Example model of a CDU with varying load on the IT side"
  extends Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU;

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSet(
    k=50000)
    "Set point for head"
    annotation(Placement(transformation(extent={{-100,40},{-80,60}})));

equation
  connect(dpSet.y, cdu.dpSet)
    annotation(Line(points={{-78,50},{-26,50},{-26,24},{-12,24}}, color={0,0,127}));
  connect(TSetRacIn.y, cdu.TSet)
    annotation(Line(points={{-78,80},{-24,80},{-24,28},{-12,28}}, color={0,0,127}));

  annotation(
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenters/CDUs/LiquidToLiquid/Examples/CDU_epsNTU.mos"
      "Simulate and plot"),
    Diagram(
      coordinateSystem(extent={{-120,-120},{120,140}})),
    Icon(
      coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(
      info="<html>
<p>
This example models a liquid-to-liquid coolant distribution unit (CDU) that
serves liquid-cooled racks using the built-in CDU controllers.
</p>
<p>
The model extends
<a href=\"modelica://Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU\">
Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU</a>,
which defines the IT load, propylene glycol rack loop, chilled water boundary
conditions, and CDU instance <code>cdu</code>.
Internal PI controllers in <code>cdu</code> regulate the chilled water valve to
track the rack supply temperature set point <code>TSetRacIn</code> and regulate
the pump speed to track the differential pressure set point <code>dpSet</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 24, 2026, by Michael Wetter:<br/>
Refactored to extend
<a href=\"modelica://Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU\">
Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU</a>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4905\">Buildings, #4905</a>.
</li>
<li>
November 13, 2026, by Michael Wetter:<br/>
Aligned <code>dpSet</code> with <code>dpRac_nominal</code>, updated <code>MediumRac</code>
reference temperatures, and used <code>datCDU.rhoRac_default</code> and a realistic
pump head curve in <code>datCDU</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
December 23, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CDU_epsNTU;
