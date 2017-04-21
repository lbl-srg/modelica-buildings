within Buildings.Fluid.Sensors;
model MassFractionTwoPort "Ideal two port mass fraction sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases);
  extends Buildings.Fluid.BaseClasses.IndexMassFraction(substanceName = "water");
  extends Modelica.Icons.RotationalSensor;

  parameter Medium.MassFraction X_start=Medium.X_default[i_x]
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

  Modelica.Blocks.Interfaces.RealOutput X(min=-1e-3,
                                          max=1.001,
                                          start=X_start,
                                          final unit="kg/kg")
    "Mass fraction of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));

protected
  Medium.MassFraction XMed(start=X_start)
    "Mass fraction to which the sensor is exposed";
  Medium.MassFraction XiVec[Medium.nXi](
    final quantity=Medium.substanceNames[1:Medium.nXi])
    "Mass fraction vector, needed because indexed argument for the operator inStream is not supported";
initial equation
  // Assign initial conditions
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(X) = 0;
     elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      X = X_start;
    end if;
  end if;
equation
  if allowFlowReversal then
    XiVec = Modelica.Fluid.Utilities.regStep(
              x=port_a.m_flow,
              y1=port_b.Xi_outflow,
              y2=port_a.Xi_outflow,
              x_small=m_flow_small);
  else
    XiVec = port_b.Xi_outflow;
  end if;
  XMed = if i_x > Medium.nXi then (1-sum(XiVec)) else XiVec[i_x];
  // Output signal of sensor
  if dynamic then
    der(X)  = (XMed-X)*k*tauInv;
  else
    X = XMed;
  end if;
annotation (defaultComponentName="senMasFra",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(
          extent={{94,122},{0,92}},
          lineColor={0,0,0},
          textString="X"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<html>
<p>
This model outputs the mass fraction of the passing fluid.
The sensor is ideal, i.e. it does not influence the fluid.
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation.
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 26, 2016, by Michael Wetter:<br/>
Corrected wrong assignment
<code>XiVec[Medium.nXi](quantity=Medium.extraPropertiesNames)</code>
to
<code>XiVec[Medium.nXi](quantity=Medium.substanceNames[1:Medium.nXi])</code>.<br/>
Changed unit of output signal from <code>1</code> to <code>kg/kg</code>
to indicate that it is a mass fraction, and declared the assignment final.
</li>
<li>
January 18, 2016 by Filip Jorissen:<br/>
Using parameter <code>tauInv</code>
since this now exists in
<a href=\"modelica://Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor\">Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor</a>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">#372</a>.
</li>
<li>
September 10, 2013, by Michael Wetter:<br/>
Changed <code>min</code> and <code>max</code> values for
output signals to allow for numerical approximation error
without violating these bounds.<br/>
Changed medium declaration in the <code>extends</code> statement
to <code>replaceable</code> to avoid a translation error in
OpenModelica.
</li>
<li>
August 31, 2013, by Michael Wetter:<br/>
Revised model to use base class
<a href=\"modelica://Buildings.Fluid.BaseClasses.IndexMassFraction\">
Buildings.Fluid.BaseClasses.IndexMassFraction</a>.
</li>
<li>
November 3, 2011, by Michael Wetter:<br/>
Moved <code>der(X) := 0;</code> from the initial algorithm section to
the initial equation section
as this assignment does not conform to the Modelica specification.
</li>
<li>
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
February 22, by Michael Wetter:<br/>
Improved code that searches for index of the substance name in the medium model.
</li>
<li>
Feb. 8, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassFractionTwoPort;
