within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO;
block PIIntegralTime "Identify the integral time of a PI controller"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput L(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time delay of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Ti(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant for the integral term"
    annotation (Placement(transformation(extent={{100,-22},{140,18}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Calculate the sum of the output of mul3 and the output of gai1"
    annotation (Placement(transformation(extent={{0,44},{20,64}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Calculate the sum of 0.35 and the output of div"
    annotation (Placement(transformation(extent={{60,-12},{80,8}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3
    "Calculate the sum of the output of add1 and the output of mul2"
    annotation (Placement(transformation(extent={{60,-54},{80,-34}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "Calculate the output of gai3 divided by the output of add3"
    annotation (Placement(transformation(extent={{0,-6},{20,14}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(final k=12)
    "Mutiple the time delay by 12"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(final k=7)
    "Mutiple the time delay by 7"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(final k=13)
    "Mutiple the output of mul3 by 13"
    annotation (Placement(transformation(extent={{-20,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai4(final k=0.35)
    "Mutiple the time delay by 0.35"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Calculate the product of the input time constant and the output of gai1"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    "Calculate the product of the time delay and the output of gai2"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3
    "Calculate the square value of the input time constant"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul4
    "Calculate the product of the output of the gai3 and the time delay"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

equation
  connect(add2.y, Ti)
    annotation (Line(points={{82,-2},{120,-2}}, color={0,0,127}));
  connect(gai4.u, L) annotation (Line(points={{-82,-20},{-92,-20},{-92,-60},{-120,
          -60}},      color={0,0,127}));
  connect(mul3.u1, T) annotation (Line(points={{-62,66},{-90,66},{-90,60},{-120,
          60}}, color={0,0,127}));
  connect(mul3.u2, T) annotation (Line(points={{-62,54},{-90,54},{-90,60},{-120,
          60}}, color={0,0,127}));
  connect(gai1.u, L)
    annotation (Line(points={{-42,-60},{-120,-60}}, color={0,0,127}));
  connect(gai1.y, mul1.u2) annotation (Line(points={{-18,-60},{-12,-60},{-12,14},
          {-48,14},{-48,24},{-42,24}}, color={0,0,127}));
  connect(mul1.u1, T) annotation (Line(points={{-42,36},{-90,36},{-90,60},{-120,
          60}}, color={0,0,127}));
  connect(gai2.u, L) annotation (Line(points={{-82,-80},{-92,-80},{-92,-60},{
          -120,-60}}, color={0,0,127}));
  connect(gai2.y, mul2.u2) annotation (Line(points={{-58,-80},{-6,-80},{-6,-56},
          {-2,-56}}, color={0,0,127}));
  connect(mul2.u1, L) annotation (Line(points={{-2,-44},{-92,-44},{-92,-60},{-120,
          -60}},                          color={0,0,127}));
  connect(gai3.u, mul3.y) annotation (Line(points={{-18,80},{-12,80},{-12,60},{
          -38,60}}, color={0,0,127}));
  connect(add1.u1, mul3.y) annotation (Line(points={{-2,60},{-38,60}},
                    color={0,0,127}));
  connect(mul1.y, add1.u2) annotation (Line(points={{-18,30},{-10,30},{-10,48},
          {-2,48}}, color={0,0,127}));
  connect(mul2.y, add3.u2) annotation (Line(points={{22,-50},{58,-50}},
                     color={0,0,127}));
  connect(add3.u1, add1.y) annotation (Line(points={{58,-38},{32,-38},{32,54},{
          22,54}}, color={0,0,127}));
  connect(add3.y, div.u2) annotation (Line(points={{82,-44},{90,-44},{90,-24},{
          -8,-24},{-8,-2},{-2,-2}},
                                 color={0,0,127}));
  connect(div.y, add2.u1)
    annotation (Line(points={{22,4},{58,4}},                 color={0,0,127}));
  connect(add2.u2, gai4.y) annotation (Line(points={{58,-8},{48,-8},{48,-20},{
          -58,-20}}, color={0,0,127}));
  connect(mul4.u2, L) annotation (Line(points={{-82,4},{-92,4},{-92,-60},{-120,-60}},
                 color={0,0,127}));
  connect(gai3.y, mul4.u1) annotation (Line(points={{-42,80},{-94,80},{-94,16},{
          -82,16}},                    color={0,0,127}));
  connect(mul4.y, div.u1) annotation (Line(points={{-58,10},{-2,10}},
                color={0,0,127}));
  annotation (defaultComponentName = "PIIntTim",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-154,148},{146,108}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>This block calculates the integral time of a PI model</p>
<h4>Main equations</h4>
<p align=\"center\" style=\"font-style:italic;\">
T<sub>i</sub> = 0.35L + 13LT<sup>2</sup>/(T<sup>2</sup> + 12LT + 7L<sup>2</sup>),
</p>
<p>
where <code>T</code> is the time constant of the first-order time-delayed model
and <code>L</code> is the time delay of the first-order time-delayed model.
</p>
<h4>Validation</h4>
<p>
This block was validated analytically, see
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.Validation.PIIntegralTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.Validation.PIIntegralTime</a>.
</p>
<h4>References</h4>
<p>
Garpinger, Olof, Tore Hägglund, and Karl Johan Åström (2014) 
\"Performance and robustness trade-offs in PID control.\"
Journal of Process Control 24.5 (2014): 568-577.
</p>
</html>"));
end PIIntegralTime;
