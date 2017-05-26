within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
model OnOffHold "The block makes sure that the signal does not change values unless a defined time period has elapsed."

  Continuous.Constant Zero(final k=0)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Timer                                                        timer
    annotation (Placement(transformation(extent={{72,-88},{92,-68}})));
  Modelica.Blocks.Logical.Pre pre
    annotation (Placement(transformation(extent={{70,-54},{90,-34}})));
  Not not1
    annotation (Placement(transformation(extent={{-90,62},{-70,82}})));
  Equal                                                        equ1
    annotation (Placement(transformation(extent={{-68,-42},{-48,-22}})));
  Or  and2 annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Interfaces.BooleanOutput                                                y
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  parameter Real holdOnDuration(unit="s") = 900 "Time duration of the ON and  hold.";
  And and1 annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  GreaterThreshold greThr(threshold=900)
    annotation (Placement(transformation(extent={{-76,-94},{-56,-74}})));
  Equal equ2 annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-52,44},{-32,64}})));
  Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-72,14},{-52,34}})));
equation

  connect(equ1.y, and2.u1) annotation (Line(points={{-47,-32},{-42,-32},{-42,-30}},
        color={255,0,255}));
  connect(and2.y, and1.u2) annotation (Line(points={{-19,-30},{-10,-30},{-10,-18},
          {-2,-18}}, color={255,0,255}));
  connect(and1.y, logSwi.u2) annotation (Line(points={{21,-10},{30,-10},{30,10},
          {38,10}}, color={255,0,255}));
  connect(u, logSwi.u1) annotation (Line(points={{-120,-10},{-42,-10},{-42,18},{
          38,18}}, color={255,0,255}));
  connect(logSwi.y, y) annotation (Line(points={{61,10},{82,10},{82,0},{110,0}},
        color={255,0,255}));
  connect(logSwi.y, pre.u) annotation (Line(points={{61,10},{98,10},{98,-44},{68,
          -44}}, color={255,0,255}));
  connect(logSwi.u3, pre.y) annotation (Line(points={{38,2},{30,2},{30,-44},{91,
          -44}}, color={255,0,255}));
  connect(pre.y, not1.u) annotation (Line(points={{91,-44},{114,-44},{114,46},{
          66,46},{66,80},{-98,80},{-98,92},{-96,92},{-96,72},{-92,72}},
                color={255,0,255}));
  connect(pre.y, timer.u) annotation (Line(points={{91,-44},{80,-44},{80,-78},{70,
          -78}}, color={255,0,255}));
  connect(timer.y, equ1.u1) annotation (Line(points={{93,-78},{12,-78},{12,-32},
          {-70,-32}}, color={0,0,127}));
  connect(Zero.y, equ1.u2) annotation (Line(points={{-79,-30},{-74,-30},{-74,-40},
          {-70,-40}}, color={0,0,127}));
  connect(timer.y, greThr.u) annotation (Line(points={{93,-78},{18,-78},{18,-84},
          {-78,-84}}, color={0,0,127}));
  connect(and2.u2, greThr.y) annotation (Line(points={{-42,-38},{-38,-38},{-38,
          -84},{-55,-84}}, color={255,0,255}));
  connect(and1.u1, equ2.y) annotation (Line(points={{-2,-10},{0,-10},{0,50},{1,
          50}}, color={255,0,255}));
  connect(not1.y, booToRea.u) annotation (Line(points={{-69,72},{-62,72},{-62,
          54},{-54,54}}, color={255,0,255}));
  connect(equ2.u1, booToRea.y) annotation (Line(points={{-22,50},{-26,50},{-26,
          54},{-31,54}}, color={0,0,127}));
  connect(u, booToRea1.u) annotation (Line(points={{-120,-10},{-98,-10},{-98,24},
          {-74,24}}, color={255,0,255}));
  connect(booToRea1.y, equ2.u2) annotation (Line(points={{-51,24},{-38,24},{-38,
          42},{-22,42}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
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
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
