within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses;
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
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Block that calculates the sum of the two inputs"
    annotation (Placement(transformation(extent={{0,44},{20,64}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Block that calculates the sum of the two inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3
    "Block that calculates the sum of the two inputs"
    annotation (Placement(transformation(extent={{60,-54},{80,-34}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "Block that calculates the input 1 divided by input 2"
    annotation (Placement(transformation(extent={{0,-4},{20,16}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(final k=12)
    "Block that mutiples the time delay by 12"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(final k=7)
    "Block that mutiples the time delay by 7"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(final k=13)
    "Block that mutiples the output of mul3 by 13"
    annotation (Placement(transformation(extent={{-20,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai4(final k=0.35)
    "Block that mutiples the time delay by 0.35"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Block that calculates the product of the two inputs"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    "Block that calculates the product of the two inputs"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3
    "Block that calculates the square value of the input time constant"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul4
    "Block that calculates the product of the two inputs"
    annotation (Placement(transformation(extent={{-80,2},{-60,22}})));

equation
  connect(add2.y, Ti)
    annotation (Line(points={{82,0},{120,0}},   color={0,0,127}));
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
          -8,-24},{-8,0},{-2,0}},color={0,0,127}));
  connect(div.y, add2.u1)
    annotation (Line(points={{22,6},{58,6}},                 color={0,0,127}));
  connect(add2.u2, gai4.y) annotation (Line(points={{58,-6},{48,-6},{48,-20},{
          -58,-20}}, color={0,0,127}));
  connect(mul4.u2, L) annotation (Line(points={{-82,6},{-92,6},{-92,-60},{-120,
          -60}}, color={0,0,127}));
  connect(gai3.y, mul4.u1) annotation (Line(points={{-42,80},{-94,80},{-94,18},
          {-82,18}},                   color={0,0,127}));
  connect(mul4.y, div.u1) annotation (Line(points={{-58,12},{-2,12}},
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
<p>
The main equation is
</p>
<p align=\"center\" style=\"font-style:italic;\">
T<sub>i</sub> = 0.35 L + 13 L T<sup>2</sup>/(T<sup>2</sup> + 12 L T + 7 L<sup>2</sup>),
</p>
<p>
where <code>T</code> is the time constant of the first-order time-delayed model
and <code>L</code> is the time delay of the first-order time-delayed model.
</p>
<h4>References</h4>
<p>
Garpinger, Olof, Tore Hägglund, and Karl Johan Åström (2014) 
\"Performance and robustness trade-offs in PID control.\"
Journal of Process Control 24.5 (2014): 568-577.
</p>
</html>"));
end PIIntegralTime;
