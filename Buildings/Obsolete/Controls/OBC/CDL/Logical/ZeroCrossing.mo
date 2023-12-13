within Buildings.Obsolete.Controls.OBC.CDL.Logical;
block ZeroCrossing "Trigger zero crossing of input u"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput enable
    "Zero input crossing is triggered if the enable input signal is true"
    annotation (Placement(transformation(
        origin={0,-120},
        extent={{-20,-20},{20,20}},
        rotation=90)));

protected
  Boolean disable=not enable
    "Boolean not of enable input";
  Boolean u_pos
    "Positive real input";

initial equation
  pre(u_pos)=false;
  pre(enable)=false;
  pre(disable)=not pre(enable);

equation
  u_pos=enable and u >= 0;
  y=change(u_pos) and not edge(enable) and not edge(disable);
  annotation (
    defaultComponentName="zerCro",
    obsolete = "This model is obsolete",
    Documentation(
      info="<html>
<p>
Block that detects zero crossings.
</p>
<p>
The output <code>y</code> is <code>true</code> at the
time instant when the input <code>u</code> becomes
zero, provided the input <code>enable</code> is
<code>true</code>. At all other time instants,
the output <code>y</code> is <code>false</code>.
If the input <code>u</code> is zero at a time instant when
the <code>enable</code>
input changes its value, then the output <code>y</code> is <code>false</code>.
</p>
<p>
Note, that in the plot window of a Modelica simulator, the output of
this block is usually identically to <code>false</code>, because the output
may only be <code>true</code> at an event instant, but not during
continuous integration. In order to check that this component is
actually working as expected, one should connect its output to, e.g.,
component <i>Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler</i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 8, 2023, by Jianjun Hu:<br/>
Moved this model to the <code>Obsolete</code> package. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3595\">issue 3595</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
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
        Line(
          points={{-78,68},{-78,-80}},
          color={192,192,192}),
        Polygon(
          points={{-78,90},{-86,68},{-70,68},{-78,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-88,0},{62,0}},
          color={192,192,192}),
        Line(
          points={{-78,0},{-73.2,32.3},{-70,50.3},{-66.7,64.5},{-63.5,74.2},{-60.3,79.3},{-57.1,79.6},{-53.9,75.3},{-50.7,67.1},{-46.6,52.2},{-41,25.8},{-33,-13.9},{-28.2,-33.7},{-24.1,-45.9},{-20.1,-53.2},{-16.1,-55.3},{-12.1,-52.5},{-8.1,-45.3},{-3.23,-32.1},{10.44,13.7},{15.3,26.4},{20.1,34.8},{24.1,38},{28.9,37.2},{33.8,31.8},{40.2,19.4}},
          color={192,192,192},
          smooth=Smooth.Bezier),
        Line(
          points={{-36,-59},{-36,81}},
          color={255,0,255}),
        Line(
          points={{6,-59},{6,81}},
          color={255,0,255}),
        Line(
          points={{-78,0},{58,0}},
          color={255,0,255}),
        Polygon(
          points={{64,0},{42,8},{42,-8},{64,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name"),
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
          fillPattern=FillPattern.Solid)}));
end ZeroCrossing;
