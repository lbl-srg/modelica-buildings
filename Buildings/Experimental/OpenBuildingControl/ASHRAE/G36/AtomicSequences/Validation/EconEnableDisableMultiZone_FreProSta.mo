within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconEnableDisableMultiZone_FreProSta
  "Validation model to disable the economizer if any of the freeze protection stages 1 through 3 are activated"
  extends Modelica.Icons.Example;

  parameter Real TOutBelowThreshold(min=273.15, max=((273.15+23.85) - 2), unit="K", displayUnit="degC")=(273.15+15.85) "Constant output value";

  EconEnableDisableMultiZone econEnableDisable
    annotation (Placement(transformation(extent={{2,-6},{20,12}})));
  CDL.Continuous.Constant outDamPosMax(k=0.9)
    "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-74},{-60,-54}})));
  CDL.Continuous.Constant outDamPosMin(k=0.1)
    "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-36},{-60,-16}})));
  CDL.Continuous.Constant TOut(k=TOutBelowThreshold)
    "Outdoor air temperature, constant below example 75 F"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  CDL.Continuous.ConstantStatus freezeProtectionStage(refSta=Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage2)
    "Economizer is expected to remain disabled if any of the freeze protection stages 1 through 3 is activated. "
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(TOut.y, econEnableDisable.TOut) annotation (Line(points={{-59,70},{
          -32,70},{-32,12},{1.1,12}},     color={0,0,127}));
  connect(freezeProtectionStage.yFreProSta, econEnableDisable.uFreezeProtectionStatus)
    annotation (Line(points={{-59,30},{-48,30},{-36,30},{-36,6},{0.2,6}}, color=
         {255,85,85}));
  connect(outDamPosMin.y, econEnableDisable.uOutDamPosMin) annotation (Line(
        points={{-59,-26},{-46,-26},{-36,-26},{-36,0.3},{1.1,0.3}},
                                                                color={0,0,127}));
  connect(outDamPosMax.y, econEnableDisable.uOutDamPosMax) annotation (Line(
        points={{-59,-64},{-44,-64},{-32,-64},{-32,-1.5},{1.1,-1.5}},
                                                                  color={0,0,127}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconEnableDisable_FreProSta.mos"
    "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
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
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconEnableDisable\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.EconEnableDisable</a>
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
end EconEnableDisableMultiZone_FreProSta;
