within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
model OnOffHold "The block makes sure that the signal does not change values unless a defined time period has elapsed."

  LessThreshold                                               les1(threshold=
        holdOnDuration)
    annotation (Placement(transformation(extent={{-20,-38},{0,-18}})));
  Continuous.Constant Zero(final k=0)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Timer                                                        timer
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Logical.Pre pre
    annotation (Placement(transformation(extent={{50,40},{70,60}})));
  Not not1
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Equal                                                        equ1
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  Or or2 annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  And and2 annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Interfaces.BooleanOutput                                                y
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Interfaces.BooleanInput u
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  parameter Real holdOnDuration(unit="s") = 3600 "Time duration of the ON hold.";
equation

  connect(timer.u,pre. y) annotation (Line(points={{18,20},{12,20},{12,0},{80,0},
          {80,50},{71,50}},
                      color={255,0,255}));
  connect(timer.y,equ1. u2) annotation (Line(points={{41,20},{64,20},{64,-50},{-28,
          -50},{-72,-50},{-72,-38}},                              color={0,0,
          127}));
  connect(u, or2.u1) annotation (Line(points={{-120,-10},{-90,-10},{-90,70},{-22,
          70}},
        color={255,0,255}));
  connect(les1.y, and2.u2) annotation (Line(points={{1,-28},{10,-28},{10,42},{18,
          42}},      color={255,0,255}));
  connect(and2.y, pre.u) annotation (Line(points={{41,50},{48,50}},
                 color={255,0,255}));
  connect(or2.y, y) annotation (Line(points={{1,70},{1,70},{90,70},{90,0},{110,0}},
        color={255,0,255}));
  connect(timer.y, les1.u) annotation (Line(points={{41,20},{50,20},{50,-50},{-30,
          -50},{-30,-28},{-22,-28}},          color={0,0,127}));
  connect(or2.y, and2.u1) annotation (Line(points={{1,70},{10,70},{10,50},{18,50}},
        color={255,0,255}));
  connect(equ1.u1, Zero.y)
    annotation (Line(points={{-72,-30},{-72,-30},{-79,-30}}, color={0,0,127}));
  connect(equ1.y, not1.u) annotation (Line(points={{-49,-30},{-40,-30},{-40,20},
          {-70,20},{-70,50},{-62,50}}, color={255,0,255}));
  connect(not1.y, or2.u2) annotation (Line(points={{-39,50},{-30,50},{-30,62},{-22,
          62}}, color={255,0,255}));
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
