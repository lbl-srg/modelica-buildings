within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model TrimAndRespond "Test model for TrimAndRespond"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine act3(f=0.002, offset=0.2)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Pulse act1(period=500)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine act2(f=0.001, offset=0.3)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespond triAndRes[3](
    each uTri=0.9,
    each yEqu0=0.1,
    each yDec=-0.01,
    each yInc=0.02,
    each samplePeriod=20) annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  connect(act1.y, triAndRes[1].u) annotation (Line(
      points={{-59,70},{-30,70},{-30,30},{-2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(act2.y, triAndRes[2].u) annotation (Line(
      points={{-59,30},{-2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(act3.y, triAndRes[3].u) annotation (Line(
      points={{-59,-10},{-30,-10},{-30,30},{-2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/TrimAndRespond.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-6),
    Documentation(revisions="<html>
<ul>
<li>
October 17, 2012, by Wangda Zuo:<br/>
Revised the example according to the new control.
</li>
<li>
July 21, 2011, by Wangda Zuo:<br/>
Merged to library.
</li>
<li>
January 6, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrimAndRespond;
