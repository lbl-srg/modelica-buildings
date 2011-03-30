within Buildings.Utilities.Math.Examples;
model Bicubic "Test model for bicubic function"
  import Buildings;
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Constant x1(k=1)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}}, rotation=0)));
  Modelica.Blocks.Sources.Constant x2(k=2)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}}, rotation=0)));
  Buildings.Utilities.Math.Bicubic bicubic(a={1,2,3,4,5,6,7,8,9,10})
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation

  connect(x1.y, bicubic.u1) annotation (Line(
      points={{-59,70},{-52,70},{-52,56},{-42,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(x2.y, bicubic.u2) annotation (Line(
      points={{-59,30},{-50,30},{-50,44},{-42,44}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),
                     graphics),
                      Commands(file="Bicubic.mos" "run"));
end Bicubic;
