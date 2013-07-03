within Buildings.Fluid.Sensors;
model MassFractionTwoPort "Ideal two port mass fraction sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  parameter String substanceName = "water" "Name of species substance";
  Modelica.Blocks.Interfaces.RealOutput X(min=0, max=1, start=X_start)
    "Mass fraction of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  parameter Medium.MassFraction X_start=Medium.X_default[ind]
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));
  Medium.MassFraction XMed(start=X_start)
    "Mass fraction to which the sensor is exposed";
protected
  parameter Integer ind(fixed=false)
    "Index of species in vector of auxiliary substances";
  Medium.MassFraction XiVec[Medium.nXi](
      quantity=Medium.extraPropertiesNames)
    "Trace substances vector, needed because indexed argument for the operator inStream is not supported";
initial algorithm
  // Compute the index of the element in the substance vector
  ind:= -1;
  for i in 1:Medium.nX loop
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2=substanceName,
                                            caseSensitive=false)) then
      ind := i;
    end if;
  end for;
  assert(ind > 0, "Species with name '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
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
    XiVec = Modelica.Fluid.Utilities.regStep(port_a.m_flow,
         port_b.Xi_outflow, port_a.Xi_outflow, m_flow_small);
  else
    XiVec = port_b.Xi_outflow;
  end if;
  XMed = if ind > Medium.nXi then (1-sum(XiVec)) else XiVec[ind];
  // Output signal of sensor
  if dynamic then
    der(X)  = (XMed-X)*k/tau;
  else
    X = XMed;
  end if;
annotation (defaultComponentName="senMasFra",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}},
        grid={1,1}),
          graphics),
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
This component monitors the mass fraction of the passing fluid. 
The sensor is ideal, i.e. it does not influence the fluid.
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation. 
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>
", revisions="<html>
<ul>
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
