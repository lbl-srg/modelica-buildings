within Buildings.Examples.VAVReheat.Controls;
model SystemHysteresis
  "Block that applies hysteresis and a minimum on timer to a control signal"

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u "Control signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum
    "Control signal for pump" annotation (Placement(transformation(extent={{100,
            -90},{140,-50}}), iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    t=0.1,
    h=0.09)
    "Threshold to switch on system"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Switch for control signal"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0)
    "Zero output signal"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Switch for pump control signal"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    trueHoldDuration(displayUnit="h") = 14400,
    final falseHoldDuration=0)
        "Keep pump running at least for trueHoldDuration"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation
  connect(greThr.u, u)
    annotation (Line(points={{-62,0},{-120,0}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{82,0},{98,0},{98,0},{120,0}},
                                                              color={0,0,127}));
  connect(swi.u1, u) annotation (Line(points={{58,8},{20,8},{20,20},{-80,20},{-80,
          0},{-120,0}}, color={0,0,127}));
  connect(con.y, swi.u3) annotation (Line(points={{22,-30},{52,-30},{52,-8},{58,
          -8}}, color={0,0,127}));
  connect(booToRea.y, yPum) annotation (Line(points={{82,-70},{80,-70},{80,-70},
          {120,-70}}, color={0,0,127}));
  connect(greThr.y, truFalHol1.u) annotation (Line(points={{-38,0},{-22,0}},
                         color={255,0,255}));
  connect(truFalHol1.y, swi.u2)
    annotation (Line(points={{2,0},{58,0}}, color={255,0,255}));
  connect(truFalHol1.y, booToRea.u) annotation (Line(points={{2,0},{40,0},{40,
          -70},{58,-70}}, color={255,0,255}));
  annotation (
    defaultComponentName="sysHys",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-48,154},{42,100}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised,
          lineColor={0,0,0}),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if truFalHol.y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if truFalHol.y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235},
            if truFalHol.u then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if truFalHol.u then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-32,30},{38,-18}},
          lineColor={0,0,0},
          textString="y = %y")}),
    Documentation(info="<html>
<p>
Block that ensure that the system runs for a minimum time once it is switched on.
</p>
</html>", revisions="<html>
<ul>
<li>
August 24, 2021, by Michael Wetter:<br/>
First version.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">issue #2594</a>.
</li>
</ul>
</html>"));
end SystemHysteresis;
