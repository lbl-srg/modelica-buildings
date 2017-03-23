within Buildings.Fluid.Sensors;
model TraceSubstancesTwoPort "Ideal two port sensor for trace substance"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput C(min=0,
                                          start=C_start)
    "Trace substance of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  parameter String substanceName = "CO2" "Name of trace substance";
  parameter Real C_start(min=0) = 0
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

protected
  Real CMed(min=0, start=C_start, nominal=sum(Medium.C_nominal))
    "Medium trace substance to which the sensor is exposed";
  parameter Real s[Medium.nC](each fixed=false)
    "Vector with zero everywhere except where the trace substance is";
initial algorithm
  for i in 1:Medium.nC loop
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i],
                                            string2=substanceName,
                                            caseSensitive=false)) then
      s[i] :=1;
    else
      s[i] :=0;
    end if;
  end for;
  assert(abs(1-sum(s))<1E-4, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(C) = 0;
     elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      C = C_start;
    end if;
  end if;
equation
  if allowFlowReversal then
     CMed = Modelica.Fluid.Utilities.regStep(
              x=port_a.m_flow,
              y1=s*port_b.C_outflow,
              y2=s*port_a.C_outflow,
              x_small=m_flow_small);
  else
     CMed = s*inStream(port_b.C_outflow);
  end if;
  // Output signal of sensor
  if dynamic then
    der(C) = (CMed-C)*k/tau;
  else
    C = CMed;
  end if;
annotation (defaultComponentName="senTraSub",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}})),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{82,122},{0,92}},
          lineColor={0,0,0},
          textString="C"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<html>
<p>
This model outputs the trace substance of the passing fluid. 
The sensor is ideal, i.e., it does not influence the fluid.
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
September 10, 2013, by Michael Wetter:<br/>
Corrected syntax errors in setting nominal value for output signal
and for state variable.
This eliminates a compilation error in OpenModelica.
</li>
<li>
August 30, 2013, by Michael Wetter:<br/>
Added default value <code>C_start=0</code>.
</li>
<li>
November 3, 2011, by Michael Wetter:<br/>
Moved <code>der(C) := 0;</code> from the initial algorithm section to 
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
Improved code that searches for index of trace substance in medium model.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TraceSubstancesTwoPort;
