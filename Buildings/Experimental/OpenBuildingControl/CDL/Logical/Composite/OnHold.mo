within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
block OnHold "Block that holds a signal on for a requested time period"

  parameter Modelica.SIunits.Time holdOnDuration = 3600 "Time duration of the ON hold.";

  Interfaces.BooleanInput u "Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Interfaces.BooleanOutput y "Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Logical.LessThreshold les1(final threshold=holdOnDuration) "Less than threshold"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Continuous.Constant Zero(final k=0) "Constant equals zero"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Logical.Timer timer "Timer to measure time elapsed after the output signal rising edge"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Logical.Pre pre "Introduces infinitesimally small time delay"
    annotation (Placement(transformation(extent={{50,40},{70,60}})));
  Logical.Not not1 "Not block"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Logical.Equal equ1 "Equal block"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Logical.Or or2 "Or block" annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Logical.And and2 "And block" annotation (Placement(transformation(extent={{20,40},{40,60}})));

equation
  connect(timer.u,pre. y) annotation (Line(points={{18,20},{12,20},{12,0},{80,0},
          {80,50},{71,50}},
                      color={255,0,255}));
  connect(timer.y,equ1. u2) annotation (Line(points={{41,20},{60,20},{60,-50},{
          -70,-50},{-70,-38},{-62,-38}},                          color={0,0,
          127}));
  connect(u, or2.u1) annotation (Line(points={{-120,0},{-90,0},{-90,70},{-22,70}},
        color={255,0,255}));
  connect(les1.y, and2.u2) annotation (Line(points={{1,-30},{10,-30},{10,42},{18,
          42}},      color={255,0,255}));
  connect(and2.y, pre.u) annotation (Line(points={{41,50},{48,50}},
                 color={255,0,255}));
  connect(or2.y, y) annotation (Line(points={{1,70},{1,70},{90,70},{90,0},{110,0}},
        color={255,0,255}));
  connect(timer.y, les1.u) annotation (Line(points={{41,20},{60,20},{60,-50},{
          -30,-50},{-30,-30},{-22,-30}},      color={0,0,127}));
  connect(or2.y, and2.u1) annotation (Line(points={{1,70},{10,70},{10,50},{18,50}},
        color={255,0,255}));
  connect(equ1.u1, Zero.y)
    annotation (Line(points={{-62,-30},{-62,-30},{-79,-30}}, color={0,0,127}));
  connect(equ1.y, not1.u) annotation (Line(points={{-39,-30},{-32,-30},{-32,20},
          {-70,20},{-70,50},{-62,50}}, color={255,0,255}));
  connect(not1.y, or2.u2) annotation (Line(points={{-39,50},{-30,50},{-30,62},{-22,
          62}}, color={255,0,255}));
  annotation (Icon(graphics={    Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
          Line(points={{-72,22},{-48,22},{-48,66},{52,66},{52,22},{80,22}},
              color={255,0,255}),
          Line(points={{-68,-62},{-48,-62},{-48,-18},{22,-18},{22,-62},{78,-62}}),
        Text(
          extent={{-8,46},{14,40}},
          lineColor={28,108,200},
          fontSize=12,
          textString="hold on time")}),                          Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
              Documentation(info="<html>
    <p>
    Block that holds a true signal for a defined time period.
    </p>
    <p>
    A rising edge of the Boolean input <code>u</code> starts a timer and
    the Boolean output <code>y</code> stays <code>true</code> for the time
    period provided as a parameter. After that the block evaluates the Boolean
    input <code>u</code> and if the input is <code>true</code>,
    the timer gets started again, but if the input is <code>false</code>, the output becomes
    <code>false</code>. If the output value is <code>false</code>, it will become 
    <code>true</code> with the first rising edge of the inputs signal. In other words, 
    any <code>true</code> signal is evaluated either at the rising edge time of the input or at 
    the rising edge time plus the time period. The output can only be <code>false</code> 
    if at the end of the time period the input is <code>false</code>.
    </p>
    <p>
    Simulation results of a typical example with a hold time of 1 hour
    is shown in the next figure.
    </p>

    <p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Logical/Composite/OnHold.png\"/>
    </p>

    </html>", revisions="<html>
    <ul>
    <li>
    May 24, 2017, by Milica Grahovac:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end OnHold;
