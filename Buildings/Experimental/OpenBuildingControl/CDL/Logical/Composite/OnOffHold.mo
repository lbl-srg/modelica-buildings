within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
model OnOffHold "The block makes sure that the signal does not change values unless a defined time period has elapsed."

  Continuous.Constant Zero(final k=0)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Timer                                                        timer
    annotation (Placement(transformation(extent={{-60,-112},{-40,-92}})));
  Modelica.Blocks.Logical.Pre pre
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Not not1
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Equal                                                        equ1
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Or  and2 annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Interfaces.BooleanOutput                                                y
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  And andBeforeTimerAndSwitch
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  GreaterThreshold greThr(threshold=changeSignalOffset)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Equal equ2 annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Change cha1
             annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Not not3 annotation (Placement(transformation(extent={{52,-60},{72,-40}})));
  parameter Real changeSignalOffset(unit="s") = 900 "Time duration of the ON/OFF offset";
equation

  connect(equ1.y, and2.u1) annotation (Line(points={{-39,-20},{-32,-20},{-22,-20}},
        color={255,0,255}));
  connect(and2.y, andBeforeTimerAndSwitch.u2) annotation (Line(points={{1,-20},{
          10,-20},{10,52},{18,52}}, color={255,0,255}));
  connect(andBeforeTimerAndSwitch.y, logSwi.u2) annotation (Line(points={{41,60},
          {42,60},{42,60},{42,60},{50,60},{50,30},{58,30}}, color={255,0,255}));
  connect(u, logSwi.u1) annotation (Line(points={{-120,-10},{-70,-10},{-70,8},{0,
          8},{0,36},{0,38},{58,38}},
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
  connect(pre.y, not1.u) annotation (Line(points={{61,-10},{96,-10},{96,88},{96,
          88},{96,88},{-96,88},{-96,70},{-92,70}},
                color={255,0,255}));
  connect(Zero.y, equ1.u2) annotation (Line(points={{-79,-30},{-72,-30},{-72,-28},
          {-62,-28}}, color={0,0,127}));
  connect(and2.u2, greThr.y) annotation (Line(points={{-22,-28},{-30,-28},{-30,-50},
          {-39,-50}},      color={255,0,255}));
  connect(andBeforeTimerAndSwitch.u1, equ2.y)
    annotation (Line(points={{18,60},{10,60},{1,60}}, color={255,0,255}));
  connect(not1.y, booToRea.u) annotation (Line(points={{-69,70},{-62,70}},
                         color={255,0,255}));
  connect(equ2.u1, booToRea.y) annotation (Line(points={{-22,60},{-30,60},{-30,70},
          {-39,70}},     color={0,0,127}));
  connect(u, booToRea1.u) annotation (Line(points={{-120,-10},{-80,-10},{-80,30},
          {-62,30}}, color={255,0,255}));
  connect(booToRea1.y, equ2.u2) annotation (Line(points={{-39,30},{-30,30},{-30,
          52},{-22,52}}, color={0,0,127}));
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},
            {100,100}},
        initialScale=0.1), graphics={
                                 Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
          Line(points={{-72,22},{-48,22},{-48,66},{52,66},{52,22},{80,22}},
              color={255,0,255}),
          Line(points={{-68,-62},{-48,-62},{-48,-18},{22,-18},{22,-62},{78,-62}})}),
                                                                 Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-120},{100,100}})),
              Documentation(info="<html>
    <p>
    Block that holds an on or off signal constant for at least a defined time period.
    </p>
    <p>
    The block outputs a Boolean signal <code>y</code> based on the 
    Boolean input <code>u</code> such that the output never switches from on to
    off faster than the provided on-off time delay. After that time period has 
    elapsed, the signal becomes equal to the input signal. If at that moment the
    input signal causes a rising or a falling edge of the output, the output
    remains constant for the mentioned time delay.
    </p>

    <p>
    fixme - Simulation results of a typical example with a on off hold time of [fixme]
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
end OnOffHold;
