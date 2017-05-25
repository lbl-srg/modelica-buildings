within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
model OnHold

  LessThreshold                                               les1(threshold=
        holdOnDuration)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Continuous.Constant Zero(final k=0)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Timer                                                        timer
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Logical.Pre pre
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Not not1
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Equal                                                        equ1
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Or or2 annotation (Placement(transformation(extent={{-18,80},{2,100}})));
  And and2 annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Interfaces.BooleanOutput                                                y
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  parameter Real holdOnDuration(unit="s") = 3600 "Time duration of the ON hold.";
equation

  connect(timer.u,pre. y) annotation (Line(points={{18,-30},{18,40},{61,40}},
                      color={255,0,255}));
  connect(Zero.y,equ1. u1) annotation (Line(points={{-59,-70},{-8,-70},{-8,-28},
          {-72,-28},{-72,30}},color={0,0,127}));
  connect(timer.y,equ1. u2) annotation (Line(points={{41,-30},{64,-30},{64,-40},
          {-36,-40},{-36,0},{-54,0},{-54,22},{-72,22}},           color={0,0,
          127}));
  connect(equ1.y,not1. u) annotation (Line(points={{-49,30},{-90,30},{-90,40},{
          -42,40}},              color={255,0,255}));
  connect(u, or2.u1) annotation (Line(points={{-120,-10},{-78,-10},{-78,86},{
          -50,86},{-50,90},{-20,90}},
        color={255,0,255}));
  connect(or2.y, and2.u1) annotation (Line(points={{3,90},{-12,90},{-12,60},{-2,
          60}},     color={255,0,255}));
  connect(les1.y, and2.u2) annotation (Line(points={{1,10},{-12,10},{-12,52},{
          -2,52}},   color={255,0,255}));
  connect(and2.y, pre.u) annotation (Line(points={{21,60},{30,60},{30,40},{38,
          40}},  color={255,0,255}));
  connect(or2.y, y) annotation (Line(points={{3,90},{40,90},{40,72},{78,72},{78,
          0},{78,0},{78,0},{110,0},{110,0}},
        color={255,0,255}));
  connect(timer.y, les1.u) annotation (Line(points={{41,-30},{41,-22},{-70,-22},
          {-70,10},{-22,10}},                 color={0,0,127}));
  connect(or2.u2, not1.y) annotation (Line(points={{-20,82},{-50,82},{-50,40},{
          -19,40}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}},
        initialScale=0.1), graphics={
                                 Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
          Line(points={{-72,22},{-48,22},{-48,66},{52,66},{52,22},{80,22}},
              color={255,0,255}),
          Line(points={{-68,-62},{-48,-62},{-48,-18},{22,-18},{22,-62},{78,-62}}),

        Line(
          points={{-48,38},{-4,38}},
          color={28,108,200},
          arrow={Arrow.Filled,Arrow.None}),
        Line(
          points={{10,38},{52,38}},
          color={28,108,200},
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{0,42},{6,36}},
          lineColor={28,108,200},
          fontSize=12,
          textString="t")}),                                     Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
              Documentation(info="<html>
    <p>
    Block that holds an on signal for a defined time period.
    </p>
    <p>
    A rising edge of the Boolean input <code>u</code> starts a timer and
    the Boolean output <code>y</code> output stays true until the time
    period provided as a parameter has elapsed. After that
    the block evaluates the Boolean input <code>u</code> and if the input is true,
    the timer gets started again, but if the input is false, the output is also
    false. If the output value is false, it will become true with the first rising
    edge of the inputs signal.
    </p>

    <p>
    fixme - Simulation results of a typical example with a hold time of [fixme]
    is shown in the next figure.
    </p>

    <p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Logical/fixme.png\"
         alt=\"fixme.png\" />
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
