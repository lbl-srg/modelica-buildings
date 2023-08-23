within Buildings.Fluid.FMI.Adaptors;
model Outlet "Adaptor for connecting a fluid outlet to the FMI interface"

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

  Buildings.Fluid.FMI.Interfaces.Outlet outlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Fluid outlet"
                   annotation (Placement(transformation(extent={{
            100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium=Medium) "Fluid port"
                annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}),
          iconTransformation(extent={{-110,
            -10},{-90,10}})));
  Buildings.Fluid.FMI.Interfaces.PressureInput p
    if use_p_in "Pressure to be sent to outlet"
              annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
protected
  Buildings.Fluid.FMI.Interfaces.FluidProperties bacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow";
  Buildings.Fluid.FMI.Interfaces.PressureOutput p_in_internal
    "Internal connector for pressure";

  Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w_in_internal
    "Internal connector for mass fraction of forward flow properties";
  Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w_out_internal
    "Internal connector for mass fraction of backward flow properties";
initial equation
   assert(Medium.nXi < 2,
   "The medium must have zero or one independent mass fraction Medium.nXi.");
equation
  port_a.m_flow = outlet.m_flow;

  outlet.forward.T = Medium.temperature_phX(
    p = p_in_internal,
    h = inStream(port_a.h_outflow),
    X = cat(1, inStream(port_a.Xi_outflow), {1-sum(inStream(port_a.Xi_outflow))}));

  inStream(port_a.C_outflow)  = outlet.forward.C;

  // Mass fraction for forward flow
  X_w_in_internal = if Medium.nXi > 0 then inStream(port_a.Xi_outflow[1]) else 0;
  connect(outlet.forward.X_w, X_w_in_internal);

  // Conditional connector for mass fraction for backward flow
  if Medium.nXi > 0 and allowFlowReversal then
    connect(X_w_out_internal, outlet.backward.X_w);
  else
    X_w_out_internal = 0;
  end if;
  port_a.Xi_outflow = fill(X_w_out_internal, Medium.nXi);

  // Conditional connector for flow reversal
  connect(outlet.backward, bacPro_internal);
  if not allowFlowReversal then
    bacPro_internal.T  = Medium.T_default;
    bacPro_internal.C  = fill(0, Medium.nC);
    if Medium.nXi > 0 then
      // This test for nXi is needed for Buildings.Fluid.FMI.Validation.HeaterFan_noReverseFlow
      // to work with Buildings.Media.Water
      connect(bacPro_internal.X_w, X_w_out_internal);
    end if;
  end if;
  bacPro_internal.T  = Medium.temperature_phX(
    p = p_in_internal,
    h = port_a.h_outflow,
    X = cat(1, port_a.Xi_outflow, {1-sum(port_a.Xi_outflow)}));
  bacPro_internal.C  = port_a.C_outflow;

  // Conditional connectors for pressure
  if use_p_in then
    connect(outlet.p, p_in_internal);
  else
    p_in_internal = Medium.p_default;
  end if;
  connect(p, p_in_internal);
  port_a.p = p_in_internal;

    annotation (defaultComponentName="bouOut",
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
          points={{60,0},{100,0}},
          color={0,0,255}),
        Rectangle(
          extent={{-100,20},{-60,-21}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Text(
          extent={{66,40},{100,0}},
          textColor={0,0,255},
          textString="outlet"),
        Line(
          points={{0,-60},{0,-100}},
          color={0,0,255},
          smooth=Smooth.None,
          visible=use_p_in),
        Text(
          extent={{10,-64},{44,-104}},
          textColor={0,0,255},
          textString="p",
          visible=use_p_in)}),
    Documentation(info="<html>
<p>
Model that is used to connect a fluid port with an output signal.
The model needs to be used in conjunction with an instance of
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Inlet\">
Buildings.Fluid.FMI.Adaptors.Inlet</a> in order for
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
June 29, 2023, by Michael Wetter:<br/>
Corrected dimension of <code>X</code> in function call.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1768\">#1768</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to moist air and water.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
November 8, 2016, by Michael Wetter:<br/>
Corrected wrong argument type in function call of <code>Medium.temperature_phX</code>.
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
end Outlet;
