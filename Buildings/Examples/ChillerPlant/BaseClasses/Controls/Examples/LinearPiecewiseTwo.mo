within Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples;
model LinearPiecewiseTwo "Test model for LinearPiecewiseTwo"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine pulse(
    f=0.001,
    amplitude=0.5,
    offset=0.5,
    phase=-1.5707963267949)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.LinearPiecewiseTwo
    linPieTwo(
    x0=0,
    x1=0.5,
    x2=1,
    y10=5,
    y11=15,
    y20=55,
    y21=42) annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(pulse.y, linPieTwo.u) annotation (Line(
      points={{-59,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/BaseClasses/Controls/Examples/LinearPiecewiseTwo.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-6),
    Documentation(revisions="<html>
<ul>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Added <code>.mos</code> file and merged to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end LinearPiecewiseTwo;
