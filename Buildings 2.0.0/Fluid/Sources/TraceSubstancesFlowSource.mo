within Buildings.Fluid.Sources;
model TraceSubstancesFlowSource
  "Source with mass flow that does not take part in medium mass balance (such as CO2)"
  extends Modelica.Fluid.Sources.BaseClasses.PartialSource(nPorts=1);

  parameter String substanceName = "CO2" "Name of trace substance";
  parameter Boolean use_m_flow_in = false
    "Get the trace substance mass flow rate from the input connector"
    annotation(Evaluate=true, HideResult=true);

  parameter Modelica.SIunits.MassFlowRate m_flow = 0
    "Fixed mass flow rate going out of the fluid port"
    annotation (Dialog(enable = not use_m_flow_in));
  Modelica.Blocks.Interfaces.RealInput m_flow_in if
       use_m_flow_in "Prescribed mass flow rate for extra property"
    annotation (Placement(transformation(extent={{-141,-20},{-101,20}})));

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_in_internal
    "Needed to connect to conditional connector";
  parameter Medium.ExtraProperty C_in_internal[Medium.nC](
       each fixed=false,
       quantity=Medium.extraPropertiesNames) "Boundary trace substances"
    annotation (Dialog(enable = Medium.nC > 0));
initial algorithm
  for i in 1:Medium.nC loop
    if ( Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i],
                                            string2=substanceName,
                                            caseSensitive=false)) then
      C_in_internal[i] := 1;
    else
      C_in_internal[i] := 0;
    end if;
  end for;
  assert(sum(C_in_internal) > 1E-4, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check source parameter and medium model.");
equation
  connect(m_flow_in, m_flow_in_internal);
  if not use_m_flow_in then
    m_flow_in_internal = m_flow;
  end if;

  assert(m_flow_in_internal >= 0, "Reverse flow for species source is not yet implemented.");
  sum(ports.m_flow) = -m_flow_in_internal;
  medium.T = Medium.T_default;
  medium.Xi = Medium.X_default[1:Medium.nXi];
  ports.C_outflow = fill(C_in_internal, nPorts);
  annotation (
defaultComponentName="souTraSub",
Documentation(info="<html>
This model can be used to inject trace substances into a system.
The model adds a mass flow rate to its port with a
trace substance concentration of <i>1</i>.
<p>
A typical use of this model is to add carbon dioxide to room air, since the
carbon dioxide concentration is typically so small that it need not be
added to the room mass balance, and since the mass flow rate can be
made small compared to the room volume if the medium that leaves this
component has a carbon dioxide concentration of <i>1</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
September 10, 2013, by Michael Wetter:<br/>
Added missing <code>each</code> in declaration of
<code>C_in_internal</code>.
This eliminates a compilation error in OpenModelica.
</li>
<li>
March 27, 2013, by Michael Wetter:<br/>
Removed binding for <code>C_in_internal</code> to allow pedantic check in Dymola 2014.
</li>
<li>
February 22, by Michael Wetter:<br/>
Improved code that searches for the index of the trace substance in the medium model.
</li>
<li>
September 18, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{20,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{38,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-100,80},{60,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,70},{60,0},{-60,-68},{-60,70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,32},{16,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{-26,30},{-18,22}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-210,102},{-70,70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Text(
          extent={{-100,14},{-60,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C")}));
end TraceSubstancesFlowSource;
