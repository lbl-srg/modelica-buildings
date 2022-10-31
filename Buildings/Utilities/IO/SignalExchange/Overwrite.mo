within Buildings.Utilities.IO.SignalExchange;
block Overwrite "Block that allows a signal to overwritten by an FMU input"
  extends Modelica.Blocks.Interfaces.SISO;

  parameter String description "Description of the signal being overwritten";

  final parameter Boolean boptestOverwrite = true
    "Parameter that is used by tools to search for overwrite block in models";

  Modelica.Blocks.Logical.Switch swi
    "Switch between external signal and direct feedthrough signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression uExt "External input signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.BooleanExpression activate
    "Block to activate use of external signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(activate.y, swi.u2)
    annotation (Line(points={{-39,0},{-12,0}}, color={255,0,255}));
  connect(swi.u3, u) annotation (Line(points={{-12,-8},{-80,-8},{-80,0},{-120,
          0}}, color={0,0,127}));
  connect(uExt.y, swi.u1) annotation (Line(points={{-39,20},{-26,20},{-26,8},
          {-12,8}}, color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));

  annotation (Documentation(info="<html>
<p>
This block enables the overwriting of a control signal by an external program,
as well as reading of its meta-data, without the need to explicitly propogate
the external input or activation switch to a top-level model.
</p>
<h4>Typical use and important parameters</h4>
<p>
This block is typically used by the BOPTEST framework
(see <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>)
to identify and activate control signals that can be overwritten by test
controllers. It is used in combination with a dedicated parser to perform
this task (see <a href=\"https://github.com/ibpsa/project1-boptest/tree/master/parsing\">Parser Code</a>).
</p>
<p>
The input <code>u</code> is the signal to be overwritten. The output
<code>y</code> will be equal to the input signal if the <code>activate</code>
flag is <code>false</code> and will be equal to the external input signal <code>uExt</code>
if the flag is <code>true</code>.
</p>
<p>
It is important to add a brief description of the signal using the
<code>description</code> parameter and assign a <code>min</code>,
<code>max</code>, and <code>unit</code> to the input variable <code>u</code>
by modifying its attributes.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 17, 2022 by David Blum:<br/>
Made parameter <code>boptestOverwrite</code> unprotected.
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1585\">#1585</a>.
</li>
<li>
July 17, 2019 by Michael Wetter:<br/>
Changed parameter name from <code>Description</code> to <code>description</code>.
</li>
<li>
December 17, 2018 by David Blum:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1059\">#1059</a>.
</li>
</ul>
</html>"),Icon(graphics={
        Line(points={{100,0},{42,0}}, color={0,0,127}),
        Line(points={{42,0},{-20,60}},
        color={0,0,127}),
        Line(points={{42,0},{-20,0}},
        color = DynamicSelect({235,235,235}, if activate.y then {235,235,235}
                    else {0,0,0})),
        Line(points={{-100,0},{-20,0}}, color={0,0,127}),
        Line(points={{-62,60},{-20,60}},  color={0,0,127}),
        Polygon(
          points={{-58,70},{-28,60},{-58,50},{-58,70}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,62},{-18,58}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,2},{-18,-2}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{40,2},{44,-2}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-16,0},{16,0}},     color={0,0,127},
          origin={-62,60},
          rotation=90),
        Line(points={{-16,0},{16,0}},     color={0,0,127},
          origin={-66,60},
          rotation=90),
        Line(points={{-16,0},{16,0}},     color={0,0,127},
          origin={-70,60},
          rotation=90),
        Ellipse(
          extent={{-77,67},{-91,53}},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({235,235,235}, if activate.y then {0,255,0}
                    else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if activate.y then {0,255,0}
                    else {235,235,235}))}));
end Overwrite;
