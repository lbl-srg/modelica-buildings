within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model ActuatedReliefDamperWithoutFan_SingleZone
  "Validate the model of control actuated relief damper without fan"
  extends Modelica.Icons.Example;
  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.ActuatedReliefDamperWithoutFan_SingleZone
    relDamPos "Block of controlling actuated relief damper without fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Constant supFan(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-52},{-60,-32}})));
  CDL.Sources.Ramp outDamPos(
    duration=1200,
    startTime=0,
    height=0.6,
    offset=0.4) "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

equation
  connect(supFan.y, relDamPos.uSupFan) annotation (Line(points={{-59,-42},{-40,-42},
          {-40,-6},{-11,-6}},      color={255,0,255}));
  connect(outDamPos.y, relDamPos.uOutDamPos) annotation (Line(points={{-59,40},{
          -40,40},{-40,6},{-11,6}},  color={0,0,127}));
  annotation (
experiment(StopTime=1200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/ActuatedReliefDamperWithoutFan_SingleZone.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.ActuatedReliefDamperWithoutFan_SingleZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.ActuatedReliefDamperWithoutFan_SingleZone</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActuatedReliefDamperWithoutFan_SingleZone;
