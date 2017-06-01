within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
block OnOffHold "The block introduces a minimal offset between the input signal rising and falling edge"

  parameter Modelica.SIunits.Time changeSignalOffset = 900 "Time duration of the ON/OFF offset";

  Interfaces.BooleanInput u "Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-122,-10},{-102,10}})));
  Interfaces.BooleanOutput y "Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Continuous.Constant Zero(final k=0) "Constant equal to zero"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Logical.Timer timer "Timer to measure time elapsed after the output signal edge"
    annotation (Placement(transformation(extent={{-60,-112},{-40,-92}})));
  Modelica.Blocks.Logical.Pre pre "Introduces infinitesimally small time delay"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Logical.Not not1 "Not block"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Logical.Equal equ1 "Equal block"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Logical.Or  and2 annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Logical.And andBeforeTimerAndSwitch "And block"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Logical.LogicalSwitch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Logical.GreaterThreshold greThr(final threshold=changeSignalOffset)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Logical.Change cha1 "Change block"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Logical.Not not3 "Not block" annotation (Placement(transformation(extent={{52,-60},{72,-40}})));

  Logical.Xor xor annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Logical.Not not2 annotation (Placement(transformation(extent={{-20,50},{0,70}})));
equation

  connect(equ1.y, and2.u1) annotation (Line(points={{-39,-20},{-32,-20},{-22,-20}},
        color={255,0,255}));
  connect(and2.y, andBeforeTimerAndSwitch.u2) annotation (Line(points={{1,-20},{
          10,-20},{10,52},{18,52}}, color={255,0,255}));
  connect(andBeforeTimerAndSwitch.y, logSwi.u2) annotation (Line(points={{41,60},
          {42,60},{42,60},{42,60},{50,60},{50,30},{58,30}}, color={255,0,255}));
  connect(u, logSwi.u1) annotation (Line(points={{-120,0},{-70,0},{-70,20},{0,20},
          {0,20},{0,38},{58,38}},
                   color={255,0,255}));
  connect(logSwi.y, y) annotation (Line(points={{81,30},{82,30},{82,30},{90,30},
          {100,30},{100,0},{110,0}},
        color={255,0,255}));
  connect(logSwi.y, pre.u) annotation (Line(points={{81,30},{90,30},{90,10},{30,
          10},{30,-10},{38,-10}},
                 color={255,0,255}));
  connect(logSwi.u3, pre.y) annotation (Line(points={{58,22},{20,22},{20,-28},{70,
          -28},{70,-10},{61,-10}},
                 color={255,0,255}));
  connect(pre.y, not1.u) annotation (Line(points={{61,-10},{96,-10},{96,88},{-88,
          88},{-88,70},{-82,70}},
                color={255,0,255}));
  connect(Zero.y, equ1.u2) annotation (Line(points={{-79,-30},{-72,-30},{-72,-28},
          {-62,-28}}, color={0,0,127}));
  connect(and2.u2, greThr.y) annotation (Line(points={{-22,-28},{-30,-28},{-30,-50},
          {-39,-50}},      color={255,0,255}));
  connect(timer.y, greThr.u) annotation (Line(points={{-39,-102},{-30,-102},{-30,
          -70},{-70,-70},{-70,-50},{-62,-50}}, color={0,0,127}));
  connect(timer.y, equ1.u1) annotation (Line(points={{-39,-102},{-30,-102},{-30,
          -70},{-70,-70},{-70,-20},{-62,-20}}, color={0,0,127}));
  connect(pre.y, cha1.u) annotation (Line(points={{61,-10},{80,-10},{80,-32},{10,
          -32},{10,-50},{18,-50}}, color={255,0,255}));
  connect(timer.u, not3.y) annotation (Line(points={{-62,-102},{-70,-102},{-70,-80},
          {80,-80},{80,-68},{80,-50},{73,-50}}, color={255,0,255}));
  connect(cha1.y, not3.u)
    annotation (Line(points={{41,-50},{50,-50}}, color={255,0,255}));
  connect(not1.y, xor.u1) annotation (Line(points={{-59,70},{-56,70},{-56,60},{-52,
          60}}, color={255,0,255}));
  connect(u, xor.u2) annotation (Line(points={{-120,0},{-80,0},{-80,52},{-52,52}},
        color={255,0,255}));
  connect(xor.y, not2.u)
    annotation (Line(points={{-29,60},{-29,60},{-22,60}}, color={255,0,255}));
  connect(andBeforeTimerAndSwitch.u1, not2.y)
    annotation (Line(points={{18,60},{1,60}}, color={255,0,255}));
  annotation (Icon(graphics={    Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised,
          lineColor={0,0,0}),
          Line(points={{-78,22},{-44,22},{-44,66},{-12,66},{-12,22},{-12,22}},
              color={255,0,255}),
          Line(points={{-78,-62},{-48,-62},{-48,-18},{-24,-18},{-24,-62},{-24,-62}}),
          Line(points={{-24,-62},{6,-62},{6,-18},{44,-18},{44,-62},{74,-62}}),
          Line(points={{-12,22},{20,22},{20,66},{52,66},{52,22},{72,22}},
              color={255,0,255}),
        Text(
          extent={{-70,46},{-56,40}},
          lineColor={28,108,200},
          fontSize=12,
          textString="offset"),
        Text(
          extent={{-34,46},{-20,40}},
          lineColor={28,108,200},
          fontSize=12,
          textString="offset"),
        Text(
          extent={{28,46},{42,40}},
          lineColor={28,108,200},
          fontSize=12,
          textString="offset"),
        Text(
          extent={{-2,46},{12,40}},
          lineColor={28,108,200},
          fontSize=12,
          textString="offset")}),                                Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-120},{100,100}})),
              Documentation(info="<html>
    <p>
    Block that holds an on or off signal constant for at least a defined time period.
    </p>
    <p>
    The block outputs a Boolean signal <code>y</code> based on the 
    Boolean input <code>u</code> such that the output signal remains constant 
    for the defined time period after a signal change. After that time period has 
    elapsed, the signal becomes equal to the input signal. The purpose of the 
    block is to disable quick changes in the output signal.
    </p>

    <p>
    Simulation results of a typical example with the block default 
    on off hold time of 15 min is shown in the next figure.
    </p>

    <p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Logical/Composite/OnOffHold.png\"
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
end OnOffHold;
