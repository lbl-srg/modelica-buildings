within Buildings.Controls.OBC.CDL.Logical.Validation;
model TrueDelay "Validation model for the TrueDelay block"
  import Buildings;
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      width=0.5, period=1.5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay(delayTime=0)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay1(delayTime=0.5)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay2(delayTime=0.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay3(
                                                       delayTime=0)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay4(delayTime=0.5)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay5(delayTime=0.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Negation of input signal"
    annotation (Placement(transformation(extent={{-32,-30},{-12,-10}})));
equation
  connect(booPul.y, onDelay.u)
    annotation (Line(points={{-59,70},{38,70}}, color={255,0,255}));
  connect(booPul.y, onDelay1.u)
    annotation (Line(points={{-59,70},{-20,70},{-20,40},{38,40}},
      color={255,0,255}));
  connect(booPul.y, onDelay2.u)
    annotation (Line(points={{-59,70},{-20,70},{-20,10},{38,10}},
      color={255,0,255}));

  connect(booPul.y, not1.u) annotation (Line(points={{-59,70},{-46,70},{-46,-20},
          {-34,-20}}, color={255,0,255}));
  connect(not1.y, onDelay3.u)
    annotation (Line(points={{-11,-20},{14,-20},{38,-20}}, color={255,0,255}));
  connect(not1.y, onDelay4.u) annotation (Line(points={{-11,-20},{10,-20},{10,
          -50},{38,-50}}, color={255,0,255}));
  connect(not1.y, onDelay5.u) annotation (Line(points={{-11,-20},{10,-20},{10,
          -80},{38,-80}}, color={255,0,255}));
annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TrueDelay.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueDelay\">
Buildings.Controls.OBC.CDL.Logical.TrueDelay</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end TrueDelay;
