within Buildings.Controls.Continuous.Examples;
model OffTimer "Example model"
  extends Modelica.Icons.Example;
  import Buildings;

  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=0.2)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.Continuous.OffTimer offTim1
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.Continuous.OffTimer offTim2
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(booleanPulse.y, offTim1.u) annotation (Line(
      points={{-59,10},{-2,10}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanPulse.y, not1.u) annotation (Line(
      points={{-59,10},{-50,10},{-50,-30},{-42,-30}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(offTim2.u, not1.y) annotation (Line(
      points={{-2,-30},{-19,-30}},
      color={255,0,255},
      smooth=Smooth.None));
 annotation (Commands(file="OffTimer.mos" "run"),
              Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics));
end OffTimer;
