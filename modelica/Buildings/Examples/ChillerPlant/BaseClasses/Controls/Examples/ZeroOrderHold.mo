within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model ZeroOrderHold "Test model for ZeroOrderHold"
  extends Modelica.Icons.Example;
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.ZeroOrderHold zeoOrdHol(
      samplePeriod=50)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.BooleanPulse booPul(period=200)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(booPul.y, zeoOrdHol.u) annotation (Line(
      points={{-39,10},{-2,10}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/ZeroOrderHold.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
July 21, 2011, by Wangda Zuo:<br>
Merge to library.
</li>
<li>
January 6, 2011, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end ZeroOrderHold;
