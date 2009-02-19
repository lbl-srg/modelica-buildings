within Buildings.Controls.Discrete.Examples;
model BooleanDelay "Example model"
 annotation (Diagram(graphics),
                      Commands(file="BooleanDelay.mos" "run"));
  Buildings.Controls.Discrete.BooleanDelay del annotation (Placement(
        transformation(extent={{0,-20},{20,0}}, rotation=0)));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=0.25) 
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}}, rotation=0)));
equation
  connect(booleanPulse.y, del.u) annotation (Line(points={{-39,-10},{-2,-10}},
        color={255,0,255}));
end BooleanDelay;
