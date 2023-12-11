within Buildings.Obsolete.Controls.OBC.CDL.Logical;
block OnOffController "On-off controller"
  parameter Real bandwidth(
    min=0)
    "Bandwidth around reference signal";
  parameter Boolean pre_y_start=false
    "Value of pre(y) at initial time";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput reference
    "Connector of Real input signal used as reference signal"
    annotation (Placement(transformation(extent={{-140,80},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector of Real input signal used as measurement signal"
    annotation (Placement(transformation(extent={{-140,-40},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Connector of Real output signal used as actuator signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  pre(y)=pre_y_start;

equation
  y=pre(y) and
              (u < reference+bandwidth/2) or
                                            (u < reference-bandwidth/2);
  annotation (
    defaultComponentName="onOffCon",
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
          extent={{-92,74},{44,44}},
          lineThickness=0.5,
          textString="reference"),
        Text(
          extent={{-94,-52},{-34,-74}},
          textString="u"),
        Line(
          points={{-86,-32},{-78,-6},{-60,26},{-34,40},{-12,42},{6,36},{22,28},{38,12},{48,-6},{58,-28}},
          color={0,0,127}),
        Line(
          points={{-88,-2},{-16,18},{72,-12}},
          color={255,0,0}),
        Line(
          points={{-88,12},{-16,30},{72,0}}),
        Line(
          points={{-88,-16},{-16,4},{72,-26}}),
        Line(
          points={{-92,-18},{-66,-18},{-66,-40},{54,-40},{54,-20},{80,-20}},
          color={255,0,255}),
        Ellipse(
          extent={{73,7},{87,-7}},
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
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(
      info="<html>
<p>
Block that represents and on/off controller.
</p>
<p>
The block outputs <code>true</code> when
the input signal <code>u</code> falls below
the <code>reference</code> signal minus half of the bandwidth.
It sets the output signal to <code>false</code> when the input
signal <code>u</code> exceeds the <code>reference</code> signal
plus half of the bandwidth.
The parameter <code>pre_y_start</code> is used to initialize the
previous value of the output <code>pre(y)</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 11, 2023, by Jianjun Hu:<br/>
Moved this model to the <code>Obsolete</code> package. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3595\">issue 3595</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end OnOffController;
