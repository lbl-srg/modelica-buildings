within Buildings.Controls.OBC.CDL.Logical;
block VariablePulse
  "Generate boolean pulse with the width specified by input"

  parameter Real samplePeriod(unit="s")
    "Sample period of the width input";
  parameter Real period(unit="s")
    "Time for one pulse period";
  parameter Real chaWidHys=0.05
    "Hysteresis for checking if the width input is changed. It is the ratio of the value change to the original value"
    annotation (Dialog(tab="Advanced"));
  parameter Real zerWidHys=0.01
    "Hysteresis for checking if the width input is greater than zero"
    annotation (Dialog(tab="Advanced"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uWid(
    final min=0,
    final max=1,
    final unit="1")
    "Ratio of the period that the output should be true"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Boolean pulse when the input is greater than zero"
    annotation (Placement(transformation(extent={{140,-130},{180,-90}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(
    final samplePeriod=samplePeriod)
    "Sample the input and use it to check the input value change"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
    "Check the difference before and after sampling"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Find the absolute value change"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=chaWidHys,
    final h=0.5*chaWidHys)
    "Check if there is input value change"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "If there is input value change, use the new value"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=zerWidHys,
    final h=0.5*zerWidHys)
    "Check if the input is greater than zero"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Boolean pulse when the width input is greater than zero"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant swi2(
    final k=false)
    "Remain false output"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if there is width change"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Relative width change"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3
    "Original width"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge when the width becomes positive"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Rising edge when there is width change"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Cycle cycOut(
    final period=period) "Produce boolean pulse output"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

  block Cycle
    "Generate boolean pulse with the width specified by input"
    parameter Real period(
      final quantity="Time",
      final unit="s",
      final min=Constants.small)
      "Time for one pulse period";
    Buildings.Controls.OBC.CDL.Interfaces.BooleanInput go
      "True: cycle the output"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
          iconTransformation(extent={{-140,-100},{-100,-60}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput uWid
      "Ratio of the period that the output should be true"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
      "Cycling boolean output"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));

    discrete Real t0(
      final quantity="Time",
      final unit="s",
      fixed=false)
      "Time instant when output begins cycling";
    Real t_sta(
      final quantity="Time",
      final unit="s",
      fixed=false)
      "Begin time instant of one period";
    Real t_end(
      final quantity="Time",
      final unit="s",
      fixed=false)
      "End time instant of one period";

  initial equation
    pre(t0)=time;

  equation
    when go then
      t0 = time;
    end when;

    t_sta = Buildings.Utilities.Math.Functions.round(
      x=integer((time-t0)/period)*period, n=6)+t0;
    t_end = t_sta + uWid*period;

    if (time>=t_sta) and (time<t_end) then
      y = true;
    else
      y = false;
    end if;

  annotation (Icon(
        graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Text(
            extent={{-100,140},{100,100}},
            textString="%name",
            textColor={0,0,255})}));
  end Cycle;

equation
  connect(uWid, sam.u) annotation (Line(points={{-160,0},{-130,0},{-130,140},{-122,
          140}}, color={0,0,127}));
  connect(sam.y, sub.u1) annotation (Line(points={{-98,140},{-90,140},{-90,126},
          {-62,126}}, color={0,0,127}));
  connect(uWid, sub.u2) annotation (Line(points={{-160,0},{-130,0},{-130,114},{-62,
          114}},color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{-38,120},{-22,120}}, color={0,0,127}));
  connect(sam.y, swi.u3) annotation (Line(points={{-98,140},{-90,140},{-90,22},{
          98,22}}, color={0,0,127}));
  connect(uWid, swi.u1) annotation (Line(points={{-160,0},{-130,0},{-130,38},{98,
          38}}, color={0,0,127}));
  connect(uWid, greThr1.u) annotation (Line(points={{-160,0},{-130,0},{-130,-110},
          {-122,-110}}, color={0,0,127}));
  connect(cycOut.y, swi1.u1) annotation (Line(points={{62,-80},{80,-80},{80,-102},
          {98,-102}},color={255,0,255}));
  connect(greThr1.y, swi1.u2)
    annotation (Line(points={{-98,-110},{98,-110}}, color={255,0,255}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{62,-140},{80,-140},{80,-118},
          {98,-118}}, color={255,0,255}));
  connect(swi1.y, y)
    annotation (Line(points={{122,-110},{160,-110}}, color={255,0,255}));
  connect(swi.y, cycOut.uWid) annotation (Line(points={{122,30},{130,30},{130,
          -40},{30,-40},{30,-80},{38,-80}},
                                       color={0,0,127}));
  connect(or2.y, cycOut.go)
    annotation (Line(points={{2,-20},{20,-20},{20,-88},{38,-88}}, color={255,0,255}));
  connect(abs1.y, div1.u1) annotation (Line(points={{2,120},{10,120},{10,106},{18,
          106}},color={0,0,127}));
  connect(swi3.y, div1.u2) annotation (Line(points={{2,80},{10,80},{10,94},{18,94}},
        color={0,0,127}));
  connect(uWid, swi3.u1) annotation (Line(points={{-160,0},{-130,0},{-130,88},{-22,
          88}}, color={0,0,127}));
  connect(greThr1.y, swi3.u2) annotation (Line(points={{-98,-110},{-80,-110},{-80,
          80},{-22,80}}, color={255,0,255}));
  connect(con.y, swi3.u3) annotation (Line(points={{-38,60},{-30,60},{-30,72},{-22,
          72}}, color={0,0,127}));
  connect(div1.y, greThr.u)
    annotation (Line(points={{42,100},{58,100}}, color={0,0,127}));
  connect(greThr.y, swi.u2) annotation (Line(points={{82,100},{90,100},{90,30},{
          98,30}}, color={255,0,255}));
  connect(greThr1.y, edg1.u) annotation (Line(points={{-98,-110},{-80,-110},{-80,
          -60},{-62,-60}}, color={255,0,255}));
  connect(edg1.y, or2.u2) annotation (Line(points={{-38,-60},{-30,-60},{-30,-28},
          {-22,-28}}, color={255,0,255}));
  connect(greThr.y, edg2.u) annotation (Line(points={{82,100},{90,100},{90,30},{
          -70,30},{-70,-20},{-62,-20}}, color={255,0,255}));
  connect(edg2.y, or2.u1)
    annotation (Line(points={{-38,-20},{-22,-20}}, color={255,0,255}));
annotation (
    defaultComponentName="varPul",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-150,-140},{150,-110}},
          textColor={0,0,0},
          textString="%period"),
        Polygon(
          points={{-80,0},{-88,-22},{-72,-22},{-80,0}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-6},{-80,-92}},
          color={255,0,255}),
        Line(
          points={{-90,-80},{72,-80}},
          color={255,0,255}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-46,-12},{-14,-30}},
          textColor={135,135,135},
          textString="%period"),
        Polygon(
          points={{0,-30},{-8,-28},{-8,-32},{0,-30}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-60,-30},{0,-30}},
          color={135,135,135}),
        Polygon(
          points={{-60,-30},{-52,-28},{-52,-32},{-60,-30}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(points={{-80,20},{-60,20},{-60,60},{60,60}}, color={0,0,127}),
        Line(points={{-80,-80},{-60,-80}}, color={0,0,0}),
        Line(points={{-60,-40},{-30,-40},{-30,-80}}, color={0,0,0}),
        Line(points={{0,-40},{30,-40},{30,-80}}, color={0,0,0}),
        Line(points={{0,-40},{0,-80}}, color={0,0,0}),
        Text(
          extent={{-54,76},{-30,62}},
          textColor={135,135,135},
          textString="%width"),
        Line(
          points={{-90,20},{72,20}},
          color={0,0,127}),
        Polygon(
          points={{90,20},{68,28},{68,12},{90,20}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,94},{-80,16}},
          color={0,0,127}),
        Polygon(
          points={{-80,94},{-88,72},{-72,72},{-80,94}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Line(points={{-60,-40},{-60,-80}}, color={0,0,0}),
        Line(points={{-30,-80},{0,-80}}, color={0,0,0}),
        Line(points={{30,-80},{60,-80}}, color={0,0,0})}),
    Documentation(
      info="<html>
<p>
Block that produces boolean output according to the specified period of the pulse
(<code>period</code>) and the value of the input <code>uWid</code>, which indicates
the percentage of the period that the output should be true.
</p>
<ul>
<li>
If the input <code>uWid</code> is zero, the output <code>y</code> remains false.
</li>
<li>
If the input <code>uWid</code> is greater than zero, the output <code>y</code> will be
a boolean pulse with the period specified by the parameter <code>period</code> and
the width specified by the input <code>uWid</code>.
</li>
<li>
At the moment when the input <code>uWid</code> changes to a new value, the output
will immediately change to a new pulse with the width specified by the new value.
</li>
</ul>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/VariablePulse.png\"
     alt=\"VariablePulse.png\" />
</p>
</html>",
revisions="<html>
<ul>
<li>
August 11, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-160},{140,160}})));
end VariablePulse;
