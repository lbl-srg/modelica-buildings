within Buildings.Fluid.FMI.Adaptors;
model Inlet "Adaptor for connecting a fluid inlet to the FMI interface"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water")));

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in = true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  Buildings.Fluid.FMI.Interfaces.Inlet inlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Fluid inlet"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium) "Fluid port"
                annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},
            {110,10}})));
  Buildings.Fluid.FMI.Interfaces.PressureOutput p
  if use_p_in "Pressure"
  annotation (
      Placement(
      transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
protected
  input Buildings.Fluid.FMI.Interfaces.FluidProperties bacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow";
  Buildings.Fluid.FMI.Interfaces.PressureOutput p_in_internal
    "Internal connector for pressure";
  output Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w_in_internal
    "Internal connector for mass fraction of forward flow properties";
  output Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w_out_internal
    "Internal connector for mass fraction of backward flow properties";
initial equation
   assert(Medium.nXi < 2,
   "The medium must have zero or one independent mass fraction Medium.nXi.");
equation
  // To locally balance the model, the pressure is only imposed at the
  // outlet model.
  // The sign is negative because inlet.m_flow > 0
  // means that fluid flows out of this component
  -port_b.m_flow     = inlet.m_flow;

  port_b.h_outflow  = Medium.specificEnthalpy_pTX(
                        p = p_in_internal,
                        T = inlet.forward.T,
                        X = if Medium.nXi == 1 then cat(1, {X_w_in_internal}, {1-X_w_in_internal}) else zeros(Medium.nX));

  port_b.C_outflow  = inlet.forward.C;

  // Conditional connector for mass fraction for forward flow
  if Medium.nXi == 0 then
    X_w_in_internal = 0;
  else
    connect(X_w_in_internal, inlet.forward.X_w);
  end if;
  port_b.Xi_outflow = fill(X_w_in_internal, Medium.nXi);

  // Conditional connector for flow reversal
  connect(inlet.backward, bacPro_internal);

  // Mass fraction for reverse flow
  X_w_out_internal = if Medium.nXi > 0 and allowFlowReversal then inStream(port_b.Xi_outflow[1]) else 0;
  connect(bacPro_internal.X_w, X_w_out_internal);

  if allowFlowReversal then
    bacPro_internal.T  = Medium.temperature_phX(
                           p = p_in_internal,
                           h = inStream(port_b.h_outflow),
                           X = cat(1, inStream(port_b.Xi_outflow), {1-sum(inStream(port_b.Xi_outflow))}));
    bacPro_internal.C  = inStream(port_b.C_outflow);
  else
    bacPro_internal.T  = Medium.T_default;
    bacPro_internal.C  = fill(0, Medium.nC);
  end if;

  // Conditional connectors for pressure
  if use_p_in then
  connect(inlet.p, p_in_internal);
  else
    p_in_internal = Medium.p_default;
  end if;
  connect(p, p_in_internal);

  annotation (defaultComponentName="bouInl",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-100,0},{-60,0}},
          color={0,0,255}),
        Ellipse(
          extent={{-34,30},{26,-30}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,20},{100,-21}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{-18,26},{26,0},{-18,-26},{-18,26}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-20,6},{14,-12}},
          textColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{-6,8},{-2,4}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,34},{-98,16}},
          textColor={0,0,255},
          textString="inlet"),
        Line(
          points={{0,-100},{0,-60}},
          color={0,127,127}),
        Text(
          extent={{2,-76},{24,-94}},
          textColor={0,127,127},
          visible=use_p_in,
          textString="p")}),
    Documentation(info="<html>
<p>
Model that is used to connect an input signal to a fluid port.
The model needs to be used in conjunction with an instance of
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Outlet\">
Buildings.Fluid.FMI.Adaptors.Outlet</a> in order for
fluid mass flow rate and pressure to be properly assigned to
the acausal fluid models.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.PartialTwoPort\">
Buildings.Fluid.FMI.ExportContainers.PartialTwoPort</a>
or
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ResistanceVolume\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ResistanceVolume</a>
for how to use this model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 18, 2024, by Michael Wetter:<br/>
Added causality.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1853\">IBPSA, #1853</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to moist air and water.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
November 8, 2016, by Michael Wetter:<br/>
Corrected wrong argument type in function call of <code>Medium.temperature_phX</code> and
<code>Medium.specificEnthalpy_pTX</code>.
</li>
<li>
October 23, 2016, by Michael Wetter:<br/>
Changed type of pressure output connector.
</li>
<li>
April 29, 2015, by Michael Wetter:<br/>
Redesigned to conditionally remove the pressure connector
if <code>use_p_in=false</code>.
</li>
<li>
April 15, 2015 by Michael Wetter:<br/>
Changed connector variable to be temperature instead of
specific enthalpy.
</li>
<li>
January 21, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Inlet;
