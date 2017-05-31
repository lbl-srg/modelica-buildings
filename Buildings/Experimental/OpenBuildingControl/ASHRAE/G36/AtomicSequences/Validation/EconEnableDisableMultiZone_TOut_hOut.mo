within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconEnableDisableMultiZone_TOut_hOut
  "Validation model for disabling the economizer if any of the outdoor air conditions are above the cutoff "
  extends Modelica.Icons.Example;

  parameter Real TOutAboveThreshold(min=(273.15+23.85) + 1, max=(273.15+76.85), unit="K", displayUnit="degC")=(273.15+26.85) "Constant output value";

  CDL.Continuous.Constant outDamPosMax(k=0.9)
    "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Continuous.Constant outDamPosMin(k=0.1)
    "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  CDL.Continuous.Constant freProtStage0(k=0)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  CDL.Continuous.Constant outDamPosMin1(k=300)
    "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  EconEnableDisableMultiZone econEnableDisableMultiZone
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
equation
  connect(freProtStage0.y, reaToInt.u)
    annotation (Line(points={{-59,30},{-52,30}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/AtomicSequences/Validation/EconEnableDisable_TOut.mos"
    "Simulate and plot"),
  Icon(graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}})),
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
end EconEnableDisableMultiZone_TOut_hOut;
