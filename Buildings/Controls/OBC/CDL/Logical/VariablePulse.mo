within Buildings.Controls.OBC.CDL.Logical;
block VariablePulse "Generate boolean pulse with the width specified by input"

  parameter Real period(unit="s")
    "Time for one pulse period";
  parameter Real minTruFalHol(
    final quantity="Time",
    final unit="s",
    final min=Constants.small)=1
    "Minimum time to hold true or false";
  final parameter Real uMin=minTruFalHol/period
    "Minimum value of the input below which the output remains always false"
    annotation (Dialog(tab="Advanced"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
    final min=0,
    final max=1,
    final unit="1")
    "Ratio of the period that the output should be true"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Boolean pulse when the input is greater than zero"
    annotation (Placement(transformation(extent={{180,-40},{220,0}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Sample the input when there is value change"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
    "Output the difference before and after sampling"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Output the absolute value change"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(final t=uMin,
      final h=0.5*uMin)
    "Check if there is input value change"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Rising edge when there is width change"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preBre
    "Break loop"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Cycle cycOut(
    final period=period,
    final minTruFalHol=minTruFalHol)
    "Produce boolean pulse output"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=minTruFalHol,
    final falseHoldDuration=minTruFalHol)
    "Ensure the minimum holding time"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));

  block Cycle
    "Generate boolean pulse with the width specified by input"
    parameter Real period(
      final quantity="Time",
      final unit="s",
      final min=Constants.small)
      "Time for one pulse period";
    parameter Real minTruFalHol(
      final quantity="Time",
      final unit="s",
      final min=Constants.small)
      "Minimum time to hold true or false";

    Buildings.Controls.OBC.CDL.Interfaces.BooleanInput go
      "True: cycle the output"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
          iconTransformation(extent={{-140,-100},{-100,-60}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput u
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
    t_end = t_sta + u*period;

    if ((time>=t_sta) and (time<t_end)) then
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

initial equation
  assert(period >= minTruFalHol*2,
      "In " + getInstanceName() + ": The pulse period must be greater than 2 times of the minimum true and false holding time.");

equation
  connect(u, triSam.u) annotation (Line(points={{-200,0},{-170,0},{-170,100},{-162,
          100}}, color={0,0,127}));
  connect(triSam.y, sub.u1) annotation (Line(points={{-138,100},{-130,100},{-130,
          66},{-102,66}}, color={0,0,127}));
  connect(u, sub.u2) annotation (Line(points={{-200,0},{-170,0},{-170,54},{-102,
          54}},  color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{-78,60},{-62,60}}, color={0,0,127}));
  connect(greThr.y, edg2.u) annotation (Line(points={{42,40},{50,40},{50,0},{-40,
          0},{-40,-50},{-22,-50}}, color={255,0,255}));
  connect(greThr.y, preBre.u)
    annotation (Line(points={{42,40},{78,40}},   color={255,0,255}));
  connect(preBre.y, triSam.trigger) annotation (Line(points={{102,40},{120,40},{
          120,80},{-150,80},{-150,88}},   color={255,0,255}));
  connect(u, cycOut.u) annotation (Line(points={{-200,0},{-170,0},{-170,-20},{98,
          -20}},     color={0,0,127}));
  connect(cycOut.y, truFalHol.u)
    annotation (Line(points={{122,-20},{138,-20}}, color={255,0,255}));
  connect(truFalHol.y, y)
    annotation (Line(points={{162,-20},{200,-20}}, color={255,0,255}));
  connect(abs1.y, greThr.u) annotation (Line(points={{-38,60},{0,60},{0,40},{18,
          40}}, color={0,0,127}));
  connect(edg2.y, cycOut.go) annotation (Line(points={{2,-50},{80,-50},{80,-28},
          {98,-28}}, color={255,0,255}));
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
Block that outputs a boolean pulse.
</p>
<p>
The output of this block is a pulse with a constant period
and a width as obtained from the input connector <code>u</code>.
The input <code>0 &le; u &le; 1</code> is the width relative to the period.
</p>
<p>
The block produces the following ouputs:
</p>
<ul>
<li>
If <code>u = 0</code>, the output <code>y</code> remains <code>false</code>.
</li>
<li>
If <code>0 &lt; u &lt; 1</code>, the output <code>y</code> will be
a boolean pulse with the period specified by the parameter <code>period</code> and
the width set to <code>u period</code>.
</li>
<li>
If <code>u = 1</code>, the output <code>y</code> remains <code>true</code>.
</li>
</ul>
<p>
When the input <code>u</code> changes by more than <code>chaWidThr</code> and the output
has been holding constant for more than minimum holding time
<code>minTruFalHol</code>, the output will change to a new pulse with the
width specified by the new value of <code>u</code>.
</p>
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
    Diagram(coordinateSystem(extent={{-180,-120},{180,120}})));
end VariablePulse;
