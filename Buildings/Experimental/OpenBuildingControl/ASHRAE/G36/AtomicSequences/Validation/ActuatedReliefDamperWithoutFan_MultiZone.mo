within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model ActuatedReliefDamperWithoutFan_MultiZone
  "Validate the model of control actuated relief damper without fan"
  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.ActuatedReliefDamperWithoutFan_MultiZone
    relDamPos
    "Block of controlling actuated relief damper without fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Constant supFan(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-52},{-60,-32}})));
  CDL.Sources.Ramp meaBuiPre(
    height=8,
    duration=1200,
    offset=8,
    startTime=0) "Measured indoor building static pressure"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

equation
  connect(meaBuiPre.y, relDamPos.uBuiPre) annotation (Line(points={{-59,40},{
          -59,40},{-40,40},{-40,6},{-11,6}},
                                         color={0,0,127}));
  connect(supFan.y, relDamPos.uSupFan) annotation (Line(points={{-59,-42},{-40,
          -42},{-40,-6},{-11,-6}}, color={255,0,255}));
  annotation (
experiment(StopTime=1200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/ActuatedReliefDamperWithoutFan_MultiZone.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.ActuatedReliefDamperWithoutFan_MultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.ActuatedReliefDamperWithoutFan_MultiZone</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActuatedReliefDamperWithoutFan_MultiZone;
