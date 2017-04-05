within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconEnableDisable_TOut
  "Validation model for economizer high limit lockout based on the 
  outdoor air temperature limit, with hysteresis."
  extends Modelica.Icons.Example;

  EconEnableDisable econEnableDisable
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  CDL.Logical.Constant FreezestatStatus(k=false)
    "Keep freezestat alarm off for this validation test"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Constant EcoDamPosMax(k=0.9)
    "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Continuous.Constant EcoDamPosMin(k=0.1)
    "Minimum allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Continuous.Constant TSup(k=277.594)
    "Set TSup to a constant value above 38F"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp TOut(
    duration=1200,
    height=10,
    offset=293.15)      "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(FreezestatStatus.y, econEnableDisable.uFre) annotation (Line(
        points={{-59,-10},{-40,-10},{-40,10},{-22,10}},   color={255,0,255}));
  connect(EcoDamPosMax.y, econEnableDisable.uEcoDamPosMin) annotation (Line(
        points={{-59,-40},{-36,-40},{-36,6},{-22,6}},     color={0,0,127}));
  connect(EcoDamPosMin.y, econEnableDisable.uEcoDamPosMax) annotation (Line(
        points={{-59,-70},{-32,-70},{-32,2},{-22,2}},     color={0,0,127}));
  connect(TSup.y, econEnableDisable.TSup) annotation (Line(points={{-59,30},{
          -46,30},{-46,14},{-22,14}},      color={0,0,127}));
  connect(TOut.y, econEnableDisable.TOut) annotation (Line(points={{-59,70},{
          -42,70},{-42,18},{-22,18}},      color={0,0,127}));
  //fixme - turn into proper test and uncomment
  //__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Validation/fixme.mos"
  //     "Simulate and plot"),
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.EconEnableDisable\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.EconEnableDisable</a>
for different control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconEnableDisable_TOut;
