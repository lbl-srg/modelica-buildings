within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite;
model OnHold

  Buildings.Experimental.OpenBuildingControl.CDL.Interfaces.BooleanOutput y
    annotation (Placement(transformation(extent={{280,-70},{300,-50}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Less les1
    annotation (Placement(transformation(extent={{-146,-160},{-126,-140}})));
  GreaterEqual                                                   gre
    annotation (Placement(transformation(extent={{-124,18},{-104,38}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal equ
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant ifZero(k=0)
    annotation (Placement(transformation(extent={{-180,72},{-160,92}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant timeOn(k=3600)
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant con2(k=3600)
    annotation (Placement(transformation(extent={{-240,-160},{-220,-140}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Or  and1
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.And and3
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Timer timer
    annotation (Placement(transformation(extent={{208,-118},{228,-98}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Or and4
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));

  Modelica.Blocks.Logical.Pre pre1
    annotation (Placement(transformation(extent={{-74,-198},{-54,-178}})));
  Modelica.Blocks.Logical.Pre pre2
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul(period=8000)
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.And and5
    annotation (Placement(transformation(extent={{-120,-198},{-100,-178}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant ifZero1(
                                                                            k=0)
    annotation (Placement(transformation(extent={{-240,-200},{-220,-180}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal equ1
    annotation (Placement(transformation(extent={{-198,-200},{-178,-180}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  Modelica.Blocks.Logical.Pre pre3
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
equation
  connect(ifZero.y, equ.u2) annotation (Line(points={{-159,82},{-159,82},{-122,82}},
                          color={0,0,127}));
  connect(timeOn.y, gre.u2) annotation (Line(points={{-159,20},{-159,20},{-126,20}},
                      color={0,0,127}));
  connect(con2.y, les1.u2) annotation (Line(points={{-219,-150},{-150,-150},{-150,-158},{-148,
          -158}},             color={0,0,127}));
  connect(and1.y, or2.u2) annotation (Line(points={{-39,-130},{-32,-130},{-32,-58},{58,-58}},
                      color={255,0,255}));
  connect(or2.y, y) annotation (Line(points={{81,-50},{140,-50},{140,-60},{290,-60}},
        color={255,0,255}));
  connect(timer.y, les1.u1) annotation (Line(points={{229,-108},{120,-108},{120,-140},{120,
          -170},{-162,-170},{-162,-150},{-148,-150}},      color={0,0,127}));
  connect(timer.y, equ.u1) annotation (Line(points={{229,-108},{100,-108},{100,120},{-140,120},
          {-140,90},{-122,90}},            color={0,0,127}));
  connect(and4.y, or2.u1) annotation (Line(points={{19,0},{19,0},{20,0},{40,0},{40,-50},{58,
          -50}},      color={255,0,255}));
  connect(and3.y, and4.u1) annotation (Line(points={{-39,10},{-30,10},{-30,0},{-4,0}},
                      color={255,0,255}));
  connect(pre1.y, and1.u2) annotation (Line(points={{-53,-188},{-52,-188},{-52,-146},{-52,-138},
          {-58,-138},{-62,-138}},
                             color={255,0,255}));
  connect(equ.y, pre2.u) annotation (Line(points={{-99,90},{-99,78},{-102,78},{-102,50}},
        color={255,0,255}));
  connect(timer.y, gre.u1) annotation (Line(points={{229,-108},{-232,-108},{-232,60},{-140,
          60},{-140,28},{-126,28}},
                                color={0,0,127}));
  connect(booPul.y, and1.u1) annotation (Line(points={{-199,-30},{-130,-30},{-130,-130},{-62,
          -130}}, color={255,0,255}));
  connect(and3.u2, booPul.y) annotation (Line(points={{-62,2},{-122,2},{-122,-30},{-199,-30}},
        color={255,0,255}));
  connect(pre2.y, and3.u1) annotation (Line(points={{-79,50},{-72,50},{-72,10},{-62,10}},
        color={255,0,255}));
  connect(and5.y, pre1.u)
    annotation (Line(points={{-99,-188},{-88,-188},{-76,-188}}, color={255,0,255}));
  connect(les1.y, and5.u1) annotation (Line(points={{-125,-150},{-124,-150},{-124,-188},{-122,
          -188}}, color={255,0,255}));
  connect(ifZero1.y, equ1.u1)
    annotation (Line(points={{-219,-190},{-200,-190}}, color={0,0,127}));
  connect(equ1.y, not1.u) annotation (Line(points={{-177,-190},{-170,-190},{-162,-190}},
        color={255,0,255}));
  connect(and5.u2, not1.y) annotation (Line(points={{-122,-196},{-130,-196},{-130,-190},{-139,
          -190}}, color={255,0,255}));
  connect(timer.y, equ1.u2) annotation (Line(points={{229,-108},{138,-108},{138,-218},{-212,
          -218},{-212,-198},{-200,-198}}, color={0,0,127}));
  connect(booPul.y, and4.u2) annotation (Line(points={{-199,-30},{-102,-30},{-102,-8},{-4,-8}},
        color={255,0,255}));
  connect(gre.y, pre3.u) annotation (Line(points={{-103,28},{-98,28},{-98,-30},{-92,-30}},
        color={255,0,255}));
  connect(pre3.y, not2.u)
    annotation (Line(points={{-69,-30},{-42,-30}}, color={255,0,255}));
  connect(not2.y, and2.u1) annotation (Line(points={{-19,-30},{20,-30},{20,-80},{58,-80}},
        color={255,0,255}));
  connect(or2.y, and2.u2) annotation (Line(points={{81,-50},{124,-50},{124,-96},{48,-96},{48,
          -88},{58,-88}}, color={255,0,255}));
  connect(timer.u, and2.y) annotation (Line(points={{206,-108},{98,-108},{98,-80},{81,-80}},
        color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
  annotation (Documentation(info="<html>
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
