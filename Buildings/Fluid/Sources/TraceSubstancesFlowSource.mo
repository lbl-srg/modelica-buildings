within Buildings.Fluid.Sources;
model TraceSubstancesFlowSource
  "Source with mass flow that does not take part in medium mass balance (such as CO2)"

  replaceable package Medium =
    Buildings.Media.Air(extraPropertiesNames={"CO2"}) "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}) "Moist air with CO2")));

  parameter Integer nPorts=0 "Number of ports" annotation(Dialog(connectorSizing=true));

  parameter String substanceName = "CO2" "Name of trace substance";
  parameter Boolean use_m_flow_in = false
    "Get the trace substance mass flow rate from the input connector"
    annotation(Evaluate=true, HideResult=true);

  parameter Modelica.Units.SI.MassFlowRate m_flow=0
    "Fixed mass flow rate going out of the fluid port"
    annotation (Dialog(enable=not use_m_flow_in));
  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s")
    if use_m_flow_in "Prescribed mass flow rate for extra property"
    annotation (Placement(transformation(extent={{-141,-20},{-101,20}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nPorts](
    redeclare each package Medium = Medium)
    "Connector for fluid ports"
    annotation (Placement(transformation(extent={{90,40},{110,-40}})));

protected
  parameter Medium.ExtraProperty C_in_internal[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=
     {if (Modelica.Utilities.Strings.isEqual(string1=Medium.extraPropertiesNames[i],
                                             string2=substanceName,
                                             caseSensitive=false)) then 1 else 0
                                             for i in 1:Medium.nC}
     "Boundary trace substances"
     annotation(Evaluate=true);
  Modelica.Blocks.Interfaces.RealInput m_flow_in_internal(final unit="kg/s")
    "Needed to connect to conditional connector";

  Modelica.Units.SI.SpecificEnthalpy h_default=Medium.specificEnthalpy(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Enthalpy of outstreaming medium";

initial equation
  assert(sum(C_in_internal) > 1E-4, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check source parameter and medium model.");

  // Only one connection allowed to a port to avoid unwanted ideal mixing
  for i in 1:nPorts loop
    assert(cardinality(ports[i]) <= 1,"
Each ports[i] of boundary shall at most be connected to one component.
If two or more connections are present, ideal mixing takes
place in these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
");
  end for;

equation
  sum(ports.m_flow) = -m_flow_in_internal;

  connect(m_flow_in, m_flow_in_internal);
  if not use_m_flow_in then
    m_flow_in_internal = m_flow;
  end if;

  assert(m_flow_in_internal >= 0, "Reverse flow for species source is not yet implemented.");

  for i in 2:nPorts loop
    ports[1].p = ports[i].p;
  end for;

  ports.C_outflow = fill(C_in_internal, nPorts);
  ports.h_outflow = fill(h_default, nPorts);
  ports.Xi_outflow = fill(Medium.X_default[1:Medium.nXi], nPorts);

  annotation (
defaultComponentName="souTraSub",
Documentation(info="<html>
<p>
This model can be used to inject trace substances into a system.
The model adds a mass flow rate to its port with a
trace substance concentration of <i>1</i>.
</p>
<h4>Typical use and important parameters</h4>
<p>
A typical use of this model is to add carbon dioxide to room air, since the
carbon dioxide concentration is typically so small that it need not be
added to the room mass balance, and since the mass flow rate can be
made small compared to the room volume if the medium that leaves this
component has a carbon dioxide concentration of <i>1</i>.
The parameter <code>substanceName</code> must be set to the name of the substance
that is injected into the fluid.
</p>
<p>
Note however that mixing volumes from the package
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">Buildings.Fluid.MixingVolumes</a>
allow to directly add a trace substance mass flow rate,
which is more efficient than using this model.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2019, by Michael Wetter:<br/>
Rewrote assignment of <code>C_in_internal</code> to avoid an initial algorithm section.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1250\">#1250</a>.
</li>
<li>
January 23, 2019, by Michael Wetter:<br/>
Refactored implementation to provide default medium choice.
This refactoring removes the dependency of the base class but is
compatible with the previous implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
January 19, 2016, by Michael Wetter:<br/>
Updated documentation due to the addition of an input for trace substance
in the mixing volume.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">
issue 372</a>.
</li>
<li>
October 30, 2015, by Matthis Thorade:<br/>
Removed <code>nPorts=1</code> in extension of the base class
as the default must be <i>0</i>.
This avoids a warning in the pedantic model check of Dymola 2016.
</li>
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
          textColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{-26,30},{-18,22}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-212,62},{-72,30}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=use_m_flow_in,
          textString="m_flow"),
        Text(
          extent={{-100,14},{-60,-20}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C"),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end TraceSubstancesFlowSource;
