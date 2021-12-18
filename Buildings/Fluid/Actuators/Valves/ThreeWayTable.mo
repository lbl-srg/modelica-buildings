within Buildings.Fluid.Actuators.Valves;
model ThreeWayTable
  "Three way valve with table-specified characteristics"
    extends BaseClasses.PartialThreeWayValve(final l={0,0},
      redeclare TwoWayTable res1(final flowCharacteristics=flowCharacteristics1),
      redeclare TwoWayTable res3(final flowCharacteristics=flowCharacteristics3));

  parameter Data.Generic flowCharacteristics1
    "Table with flow characteristics for direct flow path at port_1"
     annotation (choicesAllMatching=true, Placement(transformation(extent={{-90,80},
            {-70,100}})));
  parameter Data.Generic flowCharacteristics3
    "Table with flow characteristics for bypass flow path at port_3"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-50,80},
            {-30,100}})));
equation
  connect(inv.y, res3.y)
  annotation (Line(points={{-62.6,46},{20,46},{20,-50},{12,-50}}, color={0,0,127}));
  connect(y_actual, inv.u2)
  annotation (Line(points={{50,70},{88,70},{88,34},{-68,34},{-68,41.2}}, color={0,0,127}));
  connect(y_actual, res1.y)
  annotation (Line(points={{50,70},{88,70},{88,34},{-50,34},{-50,12}}, color={0,0,127}));
  annotation (defaultComponentName="val",
Documentation(info="<html>
<p>
Three way valve with table-specified opening characteristics.
A separate characteristic for each flow path is used.
</p>
<p>
Each flow path uses an instance of the model
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayTable\">
Buildings.Fluid.Actuators.Valves.TwoWayTable</a>.
Therefore, this model needs to be parameterized the same way as
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayTable\">
Buildings.Fluid.Actuators.Valves.TwoWayTable</a>.
Specifically,
the mass flow rate for the fully open valve is determined based
on the value of the parameter <code>CvData</code>.
For the different valve positions <i>y &isin; [0, 1]</i>, this nominal flow rate is
scaled by the values of the parameter
<code>flowCharacteristics1</code> and <code>flowCharacteristics3</code>, respectively.
These parameters declare a table of the form
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<td><i>y</i></td>  <td>0</td>  <td>...</td>  <td>1</td>
</tr>
<tr>
<td><i>&phi;</i></td>  <td><i>l</i></td>  <td>...</td>  <td>1</td>
</tr>
</table>
<p>
where <i>l = K<sub>v</sub>(y=0)/K<sub>v</sub>(y=1) &gt; 0</i> is the valve leakage.
The first row is the valve opening, and the second row is the
mass flow rate, relative to the mass flow rate of the fully open
valve, under the assumption of a constant pressure difference across the
valve.
A suggested value for the valve leakage is <i>l=0.0001</i>.
If <i>l = 0</i>, then this model will replace it with
<i>l = 10<sup>-8</sup></i> for numerical reasons.
For example, if a valve has <i>K<sub>v</sub>=0.5</i> [m<sup>3</sup>/h/bar<sup>1/2</sup>] and
a linear opening characteristics and
a valve leakage of <i>l=0.0001</i>, then one would set
</p>
<pre>
 CvData=Buildings.Fluid.Types.CvTypes.Kv
 Kv = 0.5
 flowCharacteristics1(y={0,1}, phi={0.0001,1})
 flowCharacteristics3(y={0,1}, phi={0.0001,1})
</pre>
<p>
Note, however, that
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.ThreeWayLinear\">
Buildings.Fluid.Actuators.Valves.ThreeWayLinear</a> provides a more
efficient implementation for this simple case.
</p>
<p>
The parameters <code>flowCharacteristics1</code> and <code>flowCharacteristics3</code> must meet the following
requirements, otherwise the model stops with an error:
</p>
<ul>
<li>
Their arrays
<code>y</code> and <code>phi</code>
must be strictly monotonic increasing.
</li>
<li>
The first value must satisfy
<code>y[1]=0</code>, and
<code>phi[1]</code> must be equal to the
leakage flow rate, which must be bigger than zero.
Otherwise, a default value of <code>1E-8</code> is used.
</li>
<li>
The last values must satisfy
<code>y[end]=1</code> and
<code>phi[end]=1</code>.
</li>
</ul>
<p>
This model is based on the partial valve model
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>.
Check this model for more information, such
as the regularization near the origin.
</p>
<p>
For an example that specifies an opening characteristics, see
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.Examples.TwoWayValveTable\">
Buildings.Fluid.Actuators.Valves.Examples.TwoWayValveTable</a>.
</p>

</html>",
revisions="<html>
<ul>
<li>
June 10, 2021, by Michael Wetter:<br/>
Changed implementation of the filter and changed the parameter <code>order</code> to a constant
as most users need not change this value.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">#1498</a>.
</li>
<li>
November 28, 2019, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
November 15, 2019, by Alexander K&uuml;mpel:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          origin={-80,-79},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-12,-11},{12,11}},
          radius=5.0),
        Line(
          points={{-80,-68},{-80,-90}}),
        Line(
          points={{-92,-76},{-68,-76}}),
        Line(
          points={{-92,-84},{-68,-84}})}));
end ThreeWayTable;
