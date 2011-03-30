within Buildings.Utilities.Math.Examples;
model SmoothLimit "Test model for smooth limit"
  import Buildings;
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine sine(freqHz=8)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}},  rotation=0)));
  Buildings.Utilities.Math.SmoothLimit smoLim(
    deltaX=0.001,
    upper=0.5,
    lower=0) "Smooth limit"
             annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation

  connect(sine.y, smoLim.u)      annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),
                     graphics),
                      Commands(file="SmoothLimit.mos" "run"));
end SmoothLimit;
