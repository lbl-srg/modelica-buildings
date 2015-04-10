within Buildings.Fluid.Actuators.Valves;
model TwoWayTable "Two way valve with linear flow characteristics"
  extends BaseClasses.PartialTwoWayValveKv(
    phi=phiLooUp.y[1],
    final l = phiLooUp.table[1, 2]);
  parameter Data.Generic flowCharacteristics "Table with flow characteristics"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-80,
            60},{-60,80}})));

  // Since the flow model Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow computes
  // 1/k^2, the flowCharacteristics.phi[1] must not be zero.
  // We therefore set a lower bound.
protected
  Modelica.Blocks.Tables.CombiTable1D phiLooUp(
    final tableOnFile=false,
    final table=[flowCharacteristics.y, cat(
        1,
        {max(flowCharacteristics.phi[1], 1E-8)},
        {flowCharacteristics.phi[i] for i in 2:size(flowCharacteristics.phi, 1)})],
    final columns=2:2,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Normalized mass flow rate for the given valve position under the assumption of a constant pressure"
    annotation (Placement(transformation(extent={{70,60},{90,80}})));

initial equation
  assert(flowCharacteristics.y[1] == 0, "flowCharateristics.y[1] must be 0.");
  assert(flowCharacteristics.y[size(flowCharacteristics.y, 1)] == 1, "flowCharateristics.y[end] must be 1.");
  assert(flowCharacteristics.phi[size(flowCharacteristics.phi, 1)] == 1, "flowCharateristics.phi[end] must be 1.");

  // Assert that the sequences are strictly monotonic increasing
  assert(Buildings.Utilities.Math.Functions.isMonotonic(
           x=flowCharacteristics.y,
           strict=true),
         "The values for y in flowCharacteristics must be strictly monotone increasing.");
  assert(Buildings.Utilities.Math.Functions.isMonotonic(
           x=flowCharacteristics.phi,
           strict=true),
         "The values for phi in flowCharacteristics must be strictly monotone increasing.");

equation
  connect(phiLooUp.u[1], y_actual) annotation (Line(
      points={{68,70},{50,70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="val",
    Documentation(info="<html>
<p>
Two way valve with opening characteristic that is configured through
a table.
</p>
<p>
The mass flow rate for the fully open valve is determined based
on the value of the parameter <code>CvData</code>.
For the different valve positions <i>y &isin; [0, 1]</i>, this nominal flow rate is
scaled by the values of the parameter
<code>flowCharacteristics</code>.
The parameter <code>flowCharacteristics</code> declares a table of the form
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
 flowCharacteristics(y={0,1}, phi={0.0001,1})
 </pre>
<p>
Note, however, that
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayLinear\">
Buildings.Fluid.Actuators.Valves.TwoWayLinear</a> provides a more
efficient implementation for this simple case.
</p>
<p>
The parameter <code>flowCharacteristics</code> must meet the following
requirements, otherwise the model stops with an error:
</p>
<ul>
<li>
The arrays in
<code>flowCharacteristics.y</code> and <code>flowCharacteristics.phi</code>
must be strictly monotonic increasing.
</li>
<li>
The first value must satisfy
<code>flowCharacteristics.y[1]=0</code>, and
<code>flowCharacteristics.phi[1]</code> must be equal to the
leakage flow rate, which must be bigger than zero.
Otherwise, a default value of <code>1E-8</code> is used.
</li>
<li>
The last values must satisfy
<code>flowCharacteristics.y[end]=1</code> and
<code>flowCharacteristics.phi[end]=1</code>.
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
</html>", revisions="<html>
<ul>
<li>
August 12, 2014, by Michael Wetter:<br/>
Removed the <code>end</code> keyword when accessing array elements,
as this language construct caused an error in OpenModelica.
</li>
<li>
April 4, 2014, by Michael Wetter:<br/>
Moved the assignment of the flow function <code>phi</code>
to the model instantiation because in its base class,
the keyword <code>input</code>
has been added to the variable <code>phi</code>.
</li>
<li>
March 26, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          origin={-70,83},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-12,-11},{12,11}},
          radius=5.0),
        Line(
          points={{-70,94},{-70,72}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-82,86},{-58,86}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-82,78},{-58,78}},
          color={0,0,0},
          smooth=Smooth.None)}));
end TwoWayTable;
