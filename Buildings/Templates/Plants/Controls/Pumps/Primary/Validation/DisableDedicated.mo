within Buildings.Templates.Plants.Controls.Pumps.Primary.Validation;
model DisableDedicated
  "Validation model for dedicated primary pump disable logic"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse y1(
    period=60 * 30)
    "Lead pump enable"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.DisableDedicated enaDed
    "Command dedicated pumps – Without flow request"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.DisableDedicated enaDedReq(
      have_reqFlo=true) "Command dedicated pumps – With flow request"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse y1ReqEquLea(
    period=y1EquLea.period + 4 * 60,
    shift=y1EquLea.shift)
    "Lead equipment flow request"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse y1EquLea(
    period=y1.period,
    shift=60)
    "Lead equipment enable"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse y1EquLea_actual(
    period=y1EquLea.period,
    shift=y1EquLea.shift + 60)
    "Lead equipment status"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(y1.y,enaDed. u1)
    annotation (Line(points={{-58,60},{0,60},{0,48},{38,48}},color={255,0,255}));
  connect(y1.y,enaDedReq. u1)
    annotation (Line(points={{-58,60},{0,60},{0,-32},{38,-32}},color={255,0,255}));
  connect(y1ReqEquLea.y,enaDedReq. u1ReqFlo) annotation (Line(points={{-58,-60},
          {20,-60},{20,-44},{38,-44}}, color={255,0,255}));
  connect(y1EquLea.y,enaDed. u1Equ) annotation (Line(points={{-58,20},{20,20},{
          20,44},{38,44}},
                        color={255,0,255}));
  connect(y1EquLea.y,enaDedReq. u1Equ) annotation (Line(points={{-58,20},{20,20},
          {20,-36},{38,-36}},color={255,0,255}));
  connect(y1EquLea_actual.y,enaDedReq. u1Equ_actual)
    annotation (Line(points={{-58,-20},{30,-20},{30,-40},{38,-40}},
                                                  color={255,0,255}));
  connect(y1EquLea_actual.y,enaDed. u1Equ_actual) annotation (Line(points={{-58,-20},
          {30,-20},{30,40},{38,40}},      color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Pumps/Primary/Validation/DisableDedicated.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Primary.DisableDedicated\">
Buildings.Templates.Plants.Controls.Pumps.Primary.DisableDedicated</a>
in a configuration with a flow request software point or not.
</p>
</html>",
      revisions="<html>
<ul>
<li>
XXXX, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      graphics={
        Polygon(
          points={{214,66},{214,66}},
          lineColor={28,108,200})}));
end DisableDedicated;
