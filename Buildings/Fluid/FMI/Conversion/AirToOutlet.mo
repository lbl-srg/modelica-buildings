within Buildings.Fluid.FMI.Conversion;
block AirToOutlet
  "Conversion from real signals for a fluid to an Outlet connector"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching = true);

  Modelica.Blocks.Interfaces.RealInput m_flow(
    final unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput h(final unit="J/kg")
    "Specific enthalpy"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput Xi[Medium.nXi](
    each final unit="kg/kg")
    "Water vapor concentration in kg/kg total air"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput C[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Interfaces.Outlet outlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=false,
    final use_p_in=false) "Fluid outlet"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Modelica.Blocks.Interfaces.RealInput Xi_internal[Medium.nXi](
    each final unit = "kg/kg")
    "Internal connector for water vapor concentration in kg/kg total air";

  Modelica.Blocks.Interfaces.RealInput X_w_internal(
    final unit = "kg/kg")
    "Internal connector for water vapor concentration in kg/kg total air";

equation
  // Conditional connectors
  connect(Xi_internal, Xi);
  if Medium.nXi == 0 then
    Xi_internal = zeros(Medium.nXi);
  end if;

  outlet.m_flow = m_flow;
  // If m_flow <= 0, output default properties.
  // This avoids that changes in state variables of the return
  // air are propagated to the room model which may trigger an
  // evaluation of the room ODE, even though Q=max(0, m_flow) c_p (TSup-TZon).
  connect(outlet.forward.X_w,  X_w_internal);

  if m_flow > 0 then
    outlet.forward.T = Medium.temperature_phX(
      p=Medium.p_default,
      h=h,
      X=Xi_internal);
    // Xi internal has 1 or zero components, hence we can use the sum.
    X_w_internal = sum(Xi_internal);
    outlet.forward.C = C;
  else
    outlet.forward.T = Medium.T_default;
    X_w_internal = Medium.X_default[1];
    outlet.forward.C  = zeros(Medium.nC);
  end if;
  annotation (defaultComponentName = "con",
    Documentation(info="<html>
<p>
Block that takes real inputs for properties of an air-based HVAC
system and converts them to an outlet connector of type
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Outlet\">
Buildings.Fluid.FMI.Interfaces.Outlet</a>.
</p>
<p>
See <a href=\"modelica://Buildings.Fluid.FMI.ThermalZoneAdaptor\">
Buildings.Fluid.FMI.ThermalZoneAdaptor</a>
for its usage.
</p>
</html>", revisions="<html>
<ul>
<li>
April 20, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-98,52},{-66,26}},
          lineColor={0,0,127},
          textString="h"),
        Text(
          extent={{-92,94},{-28,68}},
          lineColor={0,0,127},
          textString="m_flow"),
        Text(
          extent={{-104,-26},{-40,-52}},
          lineColor={0,0,127},
          textString="Xi"),
        Text(
          extent={{-104,-64},{-40,-90}},
          lineColor={0,0,127},
          textString="C"),
        Polygon(
          points={{90,0},{30,20},{30,-20},{90,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{30,0}}, color={191,0,0})}));
end AirToOutlet;
