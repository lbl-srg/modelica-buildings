within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model ActuatedReliefDamperWithoutFan
  "Validate the model of control actuated relief damper without fan"
  extends Modelica.Icons.Example;

  parameter Integer numOfZon1 = 1 "Total number of zones that the system serves";
  parameter Integer numOfZon2 = 5 "Total number of zones that the system serves";
  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.ActuatedReliefDamperWithoutFan
    relDamMulZon(numOfZon=numOfZon2)
    "Block of controlling actuated relief damper without fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.ActuatedReliefDamperWithoutFan
    relDamSinZon(numOfZon=numOfZon1)
    "Block of controlling actuated relief damper without fan"
    annotation (Placement(transformation(extent={{-10,26},{10,46}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Constant supFan(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-52},{-60,-32}})));
  CDL.Sources.Ramp meaBuiPre(
    height=8,
    duration=1200,
    offset=8,
    startTime=0) "Measured indoor building static pressure"
    annotation (Placement(transformation(extent={{-80,32},{-60,52}})));
  CDL.Sources.Ramp outDamPos(
    duration=1200,
    startTime=0,
    height=-0.5,
    offset=0.9) "Economizer damper position"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

equation
  connect(meaBuiPre.y,relDamMulZon. uBuiPre) annotation (Line(points={{-59,42},{
          -59,42},{-40,42},{-40,6},{-12,6}}, color={0,0,127}));
  connect(supFan.y,relDamMulZon. uSupFan) annotation (Line(points={{-59,-42},{-28,
          -42},{-28,-6},{-12,-6}}, color={255,0,255}));
  connect(outDamPos.y,relDamMulZon. uOutDamPos)
    annotation (Line(points={{-59,0},{-36,0},{-12,0}},
                                               color={0,0,127}));
  connect(supFan.y, relDamSinZon.uSupFan) annotation (Line(points={{-59,-42},{-59,
          -42},{-28,-42},{-28,30},{-12,30}}, color={255,0,255}));
  connect(outDamPos.y, relDamSinZon.uOutDamPos) annotation (Line(points={{-59,0},
          {-34,0},{-34,36},{-12,36}}, color={0,0,127}));
  connect(meaBuiPre.y, relDamSinZon.uBuiPre)
    annotation (Line(points={{-59,42},{-12,42}}, color={0,0,127}));
  annotation (
experiment(StopTime=1200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/ActuatedReliefDamperWithoutFan.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.ActuatedReliefDamperWithoutFan\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.ActuatedReliefDamperWithoutFan</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActuatedReliefDamperWithoutFan;
