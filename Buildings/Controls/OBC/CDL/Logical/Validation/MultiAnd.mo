within Buildings.Controls.OBC.CDL.Logical.Validation;
model MultiAnd "Model to validate the application of MultiAnd block"

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd0
    "Logical and with multiple inputs: 0 input"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(nu=1)
    "Logical 'MultiAnd': 1 input connection y=u"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd2(nu=2)
    "Logical 'MultiAnd': 2 input connections y=and(u1, u2)"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd5(nu=5)
    "Logical 'MultiAnd': 5 input connections y=and(u1, u2, ..., u5)"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
      width=0.5, period=1) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
      width=0.5, period=2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
      width=0.5, period=3) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
      width=0.5, period=4) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul5(
      width=0.5, period=5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

equation
  connect(booPul1.y, mulAnd5.u[1]) annotation (Line(points={{-38,60},{-38,60},{
          20,60},{20,-24.4},{38,-24.4}},
                                      color={255,0,255}));
  connect(booPul2.y, mulAnd5.u[2]) annotation (Line(points={{-38,30},{14,30},{
          14,-27.2},{38,-27.2}},
                              color={255,0,255}));
  connect(booPul3.y, mulAnd5.u[3]) annotation (Line(points={{-38,0},{0,0},{0,
          -30},{38,-30}},
                     color={255,0,255}));
  connect(booPul4.y, mulAnd5.u[4]) annotation (Line(points={{-38,-30},{-38,-30},
          {-4,-30},{-4,-32},{-4,-32},{-4,-32.8},{38,-32.8}}, color={255,0,255}));
  connect(booPul5.y, mulAnd5.u[5]) annotation (Line(points={{-38,-60},{-38,-60},
          {20,-60},{20,-35.6},{38,-35.6}}, color={255,0,255}));
  connect(booPul1.y, mulAnd2.u[1]) annotation (Line(points={{-38,60},{-38,60},{
          20,60},{20,3.5},{38,3.5}},
                                  color={255,0,255}));
  connect(booPul2.y, mulAnd2.u[2]) annotation (Line(points={{-38,30},{-38,30},{
          14,30},{14,-3.5},{38,-3.5}},
                                    color={255,0,255}));
  connect(booPul1.y, mulAnd1.u[1]) annotation (Line(points={{-38,60},{20,60},{
          20,30},{38,30}},
                        color={255,0,255}));
  annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/MultiAnd.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.MultiAnd\">
Buildings.Controls.OBC.CDL.Logical.MultiAnd</a>.
</p>
<p>
The input signals are configured as follows:</p>
<ul>
<li>input <i>u<sub>1</sub></i> has a period of <i>1</i> s and a width of
<i>0.5</i> s.</li>
<li>input <i>u<sub>2</sub></i> has a period of <i>2</i> s and a width of
<i>0.5</i> s.</li>
<li>input <i>u<sub>3</sub></i> has a period of <i>3</i> s and a width of
<i>0.5</i> s.</li>
<li>input <i>u<sub>4</sub></i> has a period of <i>4</i> s and a width of
<i>0.5</i> s.</li>
<li>input <i>u<sub>5</sub></i> has a period of <i>5</i> s and a width of
<i>0.5</i> s.</li>
</ul>

</html>", revisions="<html>
<ul>
<li>
June 28, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end MultiAnd;
