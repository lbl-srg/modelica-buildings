within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconEnableDisable_TSup
  "Validation model for disabling the economizer if the supply temperature remains below a predefined limit for longer than a predefined time duration."
  extends Modelica.Icons.Example;

  EconEnableDisable econEnableDisable
    annotation (Placement(transformation(extent={{-20,-6},{0,24}})));
  CDL.Logical.Constant FreezestatStatus(k=false)
    "Keep freezestat alarm off for this validation test"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Constant EcoDamPosMax(k=0.9)
    "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-52},{-60,-32}})));
  CDL.Continuous.Constant EcoDamPosMin(k=0.1)
    "Minimum allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-86},{-60,-66}})));
  CDL.Continuous.Constant TOut(k=297)
    "Outdoor air temperature, constant below example 75 F"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=-10,
    offset=280,
    duration=1500)
    "TSup falls below 38 F and remains there for longer than 5 min. "
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(FreezestatStatus.y, econEnableDisable.uFre) annotation (Line(
        points={{-59,-10},{-40,-10},{-40,9.6},{-22,9.6}}, color={255,0,255}));
  connect(EcoDamPosMax.y, econEnableDisable.uEcoDamPosMin) annotation (Line(
        points={{-59,-42},{-36,-42},{-36,5.4},{-22,5.4}}, color={0,0,127}));
  connect(EcoDamPosMin.y, econEnableDisable.uEcoDamPosMax) annotation (Line(
        points={{-59,-76},{-32,-76},{-32,0.6},{-22,0.6}}, color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false)));
  connect(TOut.y, econEnableDisable.TOut) annotation (Line(points={{-59,70},{
          -34,70},{-34,19.4},{-22,19.4}}, color={0,0,127}));
  connect(TSup.y, econEnableDisable.TSup) annotation (Line(points={{-59,30},{
          -42,30},{-42,14.4},{-22,14.4}}, color={0,0,127}));
  annotation (
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
  //fixme - turn into proper test and uncomment
  //__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Validation/fixme.mos"
  //     "Simulate and plot"),
end EconEnableDisable_TSup;
