within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model RequestCounter "Test model for RequestCounter"
  extends Modelica.Icons.Example;
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.RequestCounter reqCou(
      nAct=3, uTri=0.8)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant act3(k=0.95)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Pulse act1(period=10)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Sine act2(f=0.3, offset=1)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(act1.y, reqCou.uAct[1]) annotation (Line(
      points={{-59,50},{-40,50},{-40,8.66667},{-22,8.66667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(act2.y, reqCou.uAct[2]) annotation (Line(
      points={{-59,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(act3.y, reqCou.uAct[3]) annotation (Line(
      points={{-59,-30},{-40,-30},{-40,11.3333},{-22,11.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/RequestCounter.mos"
        "Simulate and plot"),
    experiment(
      StopTime=600,
      Tolerance=1e-6),
    Documentation(revisions="<html>
<ul>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Merged to library.
</li>
<li>
January 6, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end RequestCounter;
