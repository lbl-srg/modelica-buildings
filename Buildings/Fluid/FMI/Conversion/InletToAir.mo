within Buildings.Fluid.FMI.Conversion;
block InletToAir
  "Conversion from real signals for a fluid to a Buildings.Fluid.FMI.Interfaces.Inlet connector"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Evaluate=true);

  Buildings.Fluid.FMI.Interfaces.Inlet inlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=false) "Fluid outlet"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Blocks.Interfaces.RealInput TAirZon(
    final unit="K",
    displayUnit="degC")
    if allowFlowReversal
    "Zone air temperature"
    annotation (Placement(
        visible=allowFloWReserval,
        transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
  Modelica.Blocks.Interfaces.RealInput X_wZon(
    final unit="kg/kg")
    if Medium.nXi > 0 and allowFlowReversal
    "Zone air water mass fraction per total air mass"
    annotation (Placement(
        visible=allowFloWReserval,
        transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Interfaces.RealInput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    if allowFlowReversal
    "Zone air trace substances"
    annotation (Placement(
        visible=allowFloWReserval,
        transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120})));

  Modelica.Blocks.Interfaces.RealOutput m_flow(
    final unit="kg/s") "Mass flow rate of the inlet"
    annotation (Placement(transformation(extent={{100,60},{140,100}})));

  Modelica.Blocks.Interfaces.RealOutput T(final unit="K") "Temperature of the inlet"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));

  Modelica.Blocks.Interfaces.RealOutput X_w(final unit="kg/kg")
    if Medium.nXi > 0
    "Water mass fraction per total air mass of the inlet"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));

  Modelica.Blocks.Interfaces.RealOutput C[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Trace substances of the inlet"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Fluid.FMI.Interfaces.FluidProperties bacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow";

  Modelica.Blocks.Interfaces.RealInput TAirZon_internal(
    final unit="K",
    displayUnit="degC")
    "Conditinal connector for zone air temperature";

  Modelica.Blocks.Interfaces.RealInput X_wZon_internal(
    final unit="kg/kg")
    "Internal connector for zone water vapor mass fraction";

  Modelica.Blocks.Interfaces.RealInput X_wZon_internal2(
    final unit="kg/kg") = 0
    if Medium.nXi == 0 or not allowFlowReversal
    "Internal connector for zone water vapor mass fraction, required if X_wZon is removed";
  Modelica.Blocks.Interfaces.RealInput CZon_internal[Medium.nC]
    "Internal connector for trace substances";
equation
  // Conditional connectors
  connect(TAirZon_internal, TAirZon);
  bacPro_internal.T = TAirZon_internal;

  connect(bacPro_internal.X_w, X_wZon_internal);
  connect(CZon_internal, CZon);

  bacPro_internal.C = CZon_internal;

  connect(X_wZon_internal, X_wZon);
  connect(X_wZon_internal, X_wZon_internal2);
  if not allowFlowReversal then
    TAirZon_internal = Medium.T_default;
    CZon_internal = zeros(Medium.nC);
  end if;

  connect(inlet.backward, bacPro_internal);

  // Mass flow rate
  m_flow = inlet.m_flow;

  // Temperature
  T = inlet.forward.T;

  // Vapor concentration
 // X_w_internal = inlet.forward.X_w;
  connect(inlet.forward.X_w, X_w);

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
The output signal <code>m_flow</code> is equal to
<code>inlet.m_flow</code>, whereas the output signals
<code>T</code>, <code>X_w</code> and <code>C</code>
are set the the properties
<code>inlet.forward</code>.
Similarly, the properties of
<code>inlet.backward</code> are set the the values
of the input signals
<code>TAirZon</code>, <code>X_wZon</code> and <code>CZon</code>.
</p>
<p>
If <code>allowFlowReversal = true</code>,
input signal connectors are enabled that are used
to set the fluid properties for backflow in the connector
<code>inlet.backward</code>.
This can be used if this block is used to connect an HVAC
system to a thermal zone, in which case the supply air
properties are in the connector
<code>inlet.forward</code>,
and the return air properties are in the connector
<code>inlet.backward</code>.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.ThermalZone\">
Buildings.Fluid.FMI.Adaptors.ThermalZone</a>
for its usage.
</p>
</html>", revisions="<html>
<ul>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to moist air only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
June 28, 2016, by Michael Wetter:<br/>
Revised implementation to allow flow out of the
thermal zone, for example to model the return
air flow.
</li>
<li>
April 27, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{58,60},{90,34}},
          textColor={0,0,127},
          textString="T"),
        Text(
          extent={{20,96},{84,70}},
          textColor={0,0,127},
          textString="m_flow"),
        Text(
          extent={{28,-26},{92,-52}},
          textColor={0,0,127},
          textString="X_w"),
        Text(
          extent={{36,-66},{100,-92}},
          textColor={0,0,127},
          textString="C"),
        Line(points={{-80,0},{40,0}}, color={191,0,0}),
        Polygon(
          points={{82,0},{22,20},{22,-20},{82,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          visible=allowFlowReversal,
          extent={{-78,-70},{-46,-96}},
          textColor={0,0,127},
          textString="T"),
        Text(
          visible=allowFlowReversal and Medium.nXi > 0,
          extent={{-28,-68},{36,-94}},
          textColor={0,0,127},
          textString="X_w"),
        Polygon(
          visible=allowFlowReversal,
          points={{30,0},{20,20},{8,0},{30,0}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-62,-8},
          rotation=180),
        Line(
          visible=allowFlowReversal,
          points={{-76,-16},{-34,-36},{-8,-66}},
          color={0,0,255},
          smooth=Smooth.Bezier)}));
end InletToAir;
