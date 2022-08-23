within Buildings.Controls.OBC.CDL.Logical;
block VariablePulse
  "Produce output that cycles on and off according to the specified pulse period and width input"

  parameter Real samplePeriod(
    final quantity="Time",
    final unit="s",
    min=1E-3)
    "Sample period of component";
  parameter Real period(
    final quantity="Time",
    final unit="s",
    final min=Constants.small)
    "Time for one period";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uWid(
    final min=0,
    final max=1,
    final unit="1")
    "Ratio of the cycle time that the output should be on"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(
    final samplePeriod=samplePeriod)
    "Sample the input and use it to check the input value change"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
    "Check the difference before and after sampling"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Find the absolute value change"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr
    "Check if there is input value change"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "If there is input value change, use the new value"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1
    "Check if the input is greater than zero"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Produce cycling output when the pulse width is greater than zero"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant swi2(
    final k=false)
    "Remain false output"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
protected
  Cycle cycOut(final period=period) "Produce cycling output"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  block Cycle "Produce output that cycles on and off according to the specified pulse period and width input"
    parameter Real period
      "Time for one period";
    Interfaces.BooleanInput go
      "True: cycle the output"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
          iconTransformation(extent={{-140,-100},{-100,-60}})));
    Interfaces.RealInput uWid
      "Ratio of the cycle time that the output should be on"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));
    Interfaces.BooleanOutput y
      "Connector of Boolean output signal"
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
  connect(uWid, sam.u) annotation (Line(points={{-120,0},{-90,0},{-90,80},{-82,80}},
        color={0,0,127}));
  connect(sam.y, sub.u1) annotation (Line(points={{-58,80},{-50,80},{-50,66},{-42,
          66}}, color={0,0,127}));
  connect(greThr.y, swi.u2) annotation (Line(points={{42,60},{50,60},{50,30},{58,
          30}}, color={255,0,255}));
  connect(uWid, sub.u2) annotation (Line(points={{-120,0},{-90,0},{-90,54},{-42,
          54}}, color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{-18,60},{-12,60}}, color={0,0,127}));
  connect(abs1.y, greThr.u)
    annotation (Line(points={{12,60},{18,60}}, color={0,0,127}));
  connect(sam.y, swi.u3) annotation (Line(points={{-58,80},{-50,80},{-50,22},{58,
          22}}, color={0,0,127}));
  connect(uWid, swi.u1) annotation (Line(points={{-120,0},{-90,0},{-90,38},{58,38}},
        color={0,0,127}));
  connect(uWid, greThr1.u) annotation (Line(points={{-120,0},{-90,0},{-90,-40},{
          -82,-40}}, color={0,0,127}));
  connect(greThr1.y, cycOut.go) annotation (Line(points={{-58,-40},{-20,-40},{
          -20,-18},{-2,-18}}, color={255,0,255}));
  connect(cycOut.y, swi1.u1) annotation (Line(points={{22,-10},{40,-10},{40,-32},
          {58,-32}}, color={255,0,255}));
  connect(greThr1.y, swi1.u2)
    annotation (Line(points={{-58,-40},{58,-40}}, color={255,0,255}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{22,-70},{40,-70},{40,-48},{
          58,-48}}, color={255,0,255}));
  connect(swi1.y, y)
    annotation (Line(points={{82,-40},{120,-40}}, color={255,0,255}));
  connect(swi.y, cycOut.uWid) annotation (Line(points={{82,30},{90,30},{90,10},{
          -20,10},{-20,-10},{-2,-10}}, color={0,0,127}));
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
Block that produces an output that cycles true and false according to the specified
length of time (<code>period</code>) for the cycle and the value of the
input <code>uWid</code>, which indicates the percentage of the cycle time the
output should be true.
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
</html>"));
end VariablePulse;
