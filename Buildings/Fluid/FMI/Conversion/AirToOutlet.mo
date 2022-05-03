within Buildings.Fluid.FMI.Conversion;
block AirToOutlet
  "Conversion from real signals for a fluid to a Buildings.Fluid.FMI.Interfaces.Outlet connector"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput m_flow(
    final unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput h(final unit="J/kg")
    "Specific enthalpy"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput Xi[Medium.nXi](
    each final unit="kg/kg")
    "Water vapor concentration in kg/kg total air"
    annotation (Placement(
                visible=Medium.nXi > 0,
               transformation(
            extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput C[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(
                visible=Medium.nC > 0,
                transformation(
                extent={{-140,-100},{-100,-60}})));

  Buildings.Fluid.FMI.Interfaces.Outlet outlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=false) "Fluid outlet"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput TAirZon(
    final unit="K",
    displayUnit="degC")
    if allowFlowReversal
    "Temperature of the backward flowing medium in the connector outlet"
    annotation (Placement(
        visible=allowFloWReserval,
        transformation(extent={{20,20},{-20,-20}},
        rotation=90,
        origin={-60,-120}),
        iconTransformation(
        extent={{20,20},{-20,-20}},
        rotation=90,
        origin={-60,-120})));
  Modelica.Blocks.Interfaces.RealOutput X_wZon(
    final unit="kg/kg")
    if Medium.nXi > 0 and allowFlowReversal
    "Water mass fraction per total air mass of the backward flowing medium in the connector outlet"
    annotation (Placement(
        visible=allowFloWReserval,
        transformation(extent={{20,20},{-20,-20}},
        rotation=90,
        origin={0,-120}),
        iconTransformation(
        extent={{20,20},{-20,-20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Interfaces.RealOutput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    if allowFlowReversal
    "Trace substances of the backward flowing medium in the connector outlet"
    annotation (Placement(
        visible=allowFloWReserval,
        transformation(extent={{20,20},{-20,-20}},
        rotation=90,
        origin={60,-120}),
        iconTransformation(
        extent={{20,20},{-20,-20}},
        rotation=90,
        origin={60,-120})));

protected
  Modelica.Blocks.Interfaces.RealInput Xi_internal[Medium.nXi](
    each final unit = "kg/kg")
    "Internal connector for water vapor concentration in kg/kg total air";

  Modelica.Blocks.Interfaces.RealInput X_w_internal(
    final unit = "kg/kg")
    "Internal connector for water vapor concentration in kg/kg total air";

   // Conditional connectors for the backward flowing medium
  Buildings.Fluid.FMI.Interfaces.FluidProperties bacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow";

  Modelica.Blocks.Interfaces.RealOutput TAirZon_internal(
    final unit="K",
    displayUnit="degC")
    "Conditinal connector for zone air temperature";

  Modelica.Blocks.Interfaces.RealOutput X_wZon_internal(
    final unit="kg/kg")
    "Internal connector for zone water vapor mass fraction";

  Modelica.Blocks.Interfaces.RealOutput X_wZon_internal2(
    final unit="kg/kg") = 0
    if Medium.nXi == 0 or not allowFlowReversal
    "Internal connector for zone water vapor mass fraction, required if X_wZon is removed";
  Modelica.Blocks.Interfaces.RealOutput CZon_internal[Medium.nC]
    "Internal connector for trace substances";
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

  if m_flow >= 0 then
    outlet.forward.T = Medium.temperature_phX(
    p=Medium.p_default,
    h=h,
    X=cat(1, Xi_internal, {1-sum(Xi_internal)}));
    // Xi internal has 1 or zero components, hence we can use the sum.
    X_w_internal = sum(Xi_internal);
    outlet.forward.C = C;
  else
    outlet.forward.T = Medium.T_default;
    X_w_internal = Medium.X_default[1];
    outlet.forward.C  = zeros(Medium.nC);
  end if;

  // Connectors for backward flow
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

  connect(outlet.backward, bacPro_internal);
  annotation (defaultComponentName = "con",
    Documentation(info="<html>
<p>
Block that takes real inputs for properties of an air-based HVAC
system and converts them to an outlet connector of type
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Outlet\">
Buildings.Fluid.FMI.Interfaces.Outlet</a>.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.HVAC\">
Buildings.Fluid.FMI.Adaptors.HVAC</a>
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
November 8, 2016, by Michael Wetter:<br/>
Corrected wrong argument type in function call of <code>Medium.temperature_phX</code>.
</li>
<li>
April 20, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-98,52},{-66,26}},
          textColor={0,0,127},
          textString="h"),
        Text(
          extent={{-92,94},{-28,68}},
          textColor={0,0,127},
          textString="m_flow"),
        Text(
          extent={{-104,-26},{-40,-52}},
          textColor={0,0,127},
          visible=Medium.nXi > 0,
          textString="Xi"),
        Text(
          extent={{-104,-64},{-40,-90}},
          textColor={0,0,127},
          visible=Medium.nC > 0,
          textString="C"),
        Polygon(
          points={{90,0},{30,20},{30,-20},{90,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{30,0}}, color={191,0,0}),
        Line(
          visible=allowFlowReversal,
          points={{-34,25},{11,-8},{35,-64}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={34,-39},
          rotation=90),
        Polygon(
          visible=allowFlowReversal,
          points={{30,6},{18,22},{10,4},{30,6}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-4,-58},
          rotation=270)}));
end AirToOutlet;
