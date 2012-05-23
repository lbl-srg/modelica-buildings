within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model TrimAndRespond "Test model for TrimAndRespond"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine act3(freqHz=0.002, offset=0.2)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Pulse act1(period=500)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine act2(freqHz=0.001, offset=0.3)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespond triAndRes(
    n=3,
    uTri=0.9,
    yEqu0=0.1,
    yMax=1,
    yMin=0,
    nActDec=0,
    nActInc=1,
    yDec=-0.01,
    yInc=0.02,
    tSam=20) annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.BooleanPulse equSta(width=50, period=5000)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  connect(act1.y, triAndRes.u[1]) annotation (Line(
      points={{-59,70},{-50,70},{-50,35.7778},{-1.33333,35.7778}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(act2.y, triAndRes.u[2]) annotation (Line(
      points={{-59,30},{-50,30},{-50,36.6667},{-1.33333,36.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(act3.y, triAndRes.u[3]) annotation (Line(
      points={{-59,-10},{-50,-10},{-50,37.5556},{-1.33333,37.5556}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(triAndRes.sta, equSta.y) annotation (Line(
      points={{-1.33333,23.3333},{-14,23.3333},{-14,-10},{-19,-10}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/TrimAndRespond.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
July 21, 2011, by Wangda Zuo:<br>
Merge to library.
</li>
<li>
January 6 2011, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end TrimAndRespond;
