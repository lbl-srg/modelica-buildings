within Buildings.Fluid.FMI.Conversion;
block InletToAir
  "Conversion from real signals for a fluid to an Inlet connector"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  Modelica.Blocks.Interfaces.RealOutput m_flow(
    final unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{100,60},{140,100}})));

  Modelica.Blocks.Interfaces.RealOutput T(final unit="K") "Temperature"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));

  Modelica.Blocks.Interfaces.RealOutput X_w(final unit="kg/kg")
    "Water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));

  Modelica.Blocks.Interfaces.RealOutput C[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));

  Interfaces.Inlet inlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=false,
    final use_p_in=false) "Fluid outlet"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

protected
  Modelica.Blocks.Interfaces.RealInput X_w_internal(
    final unit = "kg/kg")
    "Internal connector for water vapor concentration in kg/kg total air";

equation
  // Conditional connectors
  connect(X_w_internal, X_w);
  if Medium.nXi == 0 then
    X_w_internal = 0.0;
  end if;

  // Xi internal has 1 or zero components, hence we can use the sum.
  //X_w_internal = sum(Xi_internal);

  // Vapor concentration
  connect(inlet.forward.X_w,  X_w_internal);

  // Mass flow rate
  m_flow = inlet.m_flow;

  // Temperature
  T = inlet.forward.T;

  // Species concentration
  C = inlet.forward.C;

  annotation (defaultComponentName = "con",
    Documentation(info="<html>
<p>
Block that takes an inlet connector of type 
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Inlet\">
Buildings.Fluid.FMI.Interfaces.Inlet
</a> 
and converts 
it to real outputs for properties of an air-based 
HVAC system.
</p>
<p>
See 
<a href=\"modelica://Buildings.Fluid.FMI.HVACAdaptor\">
Buildings.Fluid.FMI.HVACAdaptor
</a> 
for its usage.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-98,52},{-66,26}},
          lineColor={0,0,127},
          textString="T"),
        Text(
          extent={{-92,94},{-28,68}},
          lineColor={0,0,127},
          textString="m_flow"),
        Text(
          extent={{-104,-26},{-40,-52}},
          lineColor={0,0,127},
          textString="X_w"),
        Text(
          extent={{-104,-64},{-40,-90}},
          lineColor={0,0,127},
          textString="C"),
        Line(points={{-80,0},{40,0}}, color={191,0,0}),
        Polygon(
          points={{100,0},{40,20},{40,-20},{100,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}));
end InletToAir;
