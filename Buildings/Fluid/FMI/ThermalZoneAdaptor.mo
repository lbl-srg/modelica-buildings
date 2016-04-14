within Buildings.Fluid.FMI;
model ThermalZoneAdaptor
  "Model for exposing a room supply and return of an HVAC system to the FMI interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in = true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a sup(
    redeclare final package Medium = Medium) "Fluid port for supply air"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b ret(
    redeclare final package Medium = Medium) "Fluid port for return air"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));

  Interfaces.Outlet supAir(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Supply air connector"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Buildings.Fluid.FMI.Interfaces.Inlet retAir(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Return air connector"
    annotation (Placement(transformation(extent={{120,-50},{100,-30}})));

  Modelica.Blocks.Interfaces.RealOutput TZon(unit="K",
                                             displayUnit="degC")
   "Temperature of room air in thermal zone" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
protected
  Buildings.Fluid.FMI.Interfaces.FluidProperties supBacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow of supply air";
  Buildings.Fluid.FMI.Interfaces.FluidProperties retBacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow of return air";
  Buildings.Fluid.FMI.Interfaces.MassFractionConnector supX_w_in_internal
    "Internal connector for mass fraction of forward flow properties at supply air";
  Buildings.Fluid.FMI.Interfaces.MassFractionConnector supX_w_out_internal
    "Internal connector for mass fraction of backward flow properties at supply air";
  Buildings.Fluid.FMI.Interfaces.MassFractionConnector retX_w_in_internal
    "Internal connector for mass fraction of forward flow properties at return air";
  Buildings.Fluid.FMI.Interfaces.MassFractionConnector retX_w_out_internal
    "Internal connector for mass fraction of backward flow properties at return air";
  Buildings.Fluid.FMI.Interfaces.PressureOutput supP_in_internal
    "Internal connector for pressure of supply air";
  Buildings.Fluid.FMI.Interfaces.PressureOutput retP_in_internal
    "Internal connector for pressure of return air";
initial equation
   assert(Medium.nXi < 2,
   "The medium must have zero or one independent mass fraction Medium.nXi.");
equation
  ///////////////////////////////////////////////////////////////////////////
  // Equations for supply air
  // To locally balance the model, the pressure is only imposed at the
  // supplyAir model.
  // The sign is negative because inlet.m_flow > 0
  // means that fluid flows out of this component
  sup.m_flow = supAir.m_flow;

  supAir.forward.T = Medium.temperature_phX(
    p = sup.p,
    h = inStream(sup.h_outflow),
    X = inStream(sup.Xi_outflow));
  inStream(sup.C_outflow) = supAir.forward.C;

  // Mass fraction for forward flow
  supX_w_in_internal =if Medium.nXi > 0 then inStream(sup.Xi_outflow[1]) else 0;
  connect(supAir.forward.X_w, supX_w_in_internal);

  // Conditional connector for mass fraction for backward flow
  if Medium.nXi > 0 and allowFlowReversal then
    connect(supX_w_out_internal, supAir.backward.X_w);
  else
    supX_w_out_internal = 0;
  end if;
  sup.Xi_outflow = fill(supX_w_out_internal, Medium.nXi);

  // Conditional connector for flow reversal
  connect(supAir.backward, supBacPro_internal);
  if not allowFlowReversal then
    supBacPro_internal.T = Medium.T_default;
    supBacPro_internal.C = fill(0, Medium.nC);
    if Medium.nXi > 0 then
      // This test for nXi is needed for Buildings.Fluid.FMI.Examples.HeaterFan_noReverseFlow
      // to work with Buildings.Media.Water
      connect(supBacPro_internal.X_w, supX_w_out_internal);
    end if;
  end if;
  supBacPro_internal.T = Medium.temperature_phX(
    p=sup.p,
    h=sup.h_outflow,
    X=sup.Xi_outflow);
  supBacPro_internal.C = sup.C_outflow;

  // Conditional connectors for pressure
  if use_p_in then
    connect(supP_in_internal, supAir.p);
  end if;
  sup.p = supP_in_internal;

  ///////////////////////////////////////////////////////////////////////////
  // Equations for return air

  // To locally balance the model, the pressure is only imposed at the
  // supplyAir model.
  // The sign is negative because inlet.m_flow > 0
  // means that fluid flows out of this component
  -ret.m_flow = retAir.m_flow;

  ret.h_outflow = Medium.specificEnthalpy_pTX(
    p = ret.p,
    T = retAir.forward.T,
    X = fill(retX_w_in_internal, Medium.nXi));
  ret.C_outflow = retAir.forward.C;

  // Conditional connector for mass fraction for forward flow
  if Medium.nXi == 0 then
    retX_w_in_internal = 0;
  else
    connect(retX_w_in_internal, retAir.forward.X_w);
  end if;
  ret.Xi_outflow = fill(retX_w_in_internal, Medium.nXi);

  // Conditional connector for flow reversal
  connect(retAir.backward, retBacPro_internal);

  // Mass fraction for reverse flow
  retX_w_out_internal =if Medium.nXi > 0 and allowFlowReversal then inStream(ret.Xi_outflow[
    1]) else 0;
  connect(retBacPro_internal.X_w, retX_w_out_internal);

  if allowFlowReversal then
    retBacPro_internal.T = Medium.temperature_phX(
      p=ret.p,
      h=inStream(ret.h_outflow),
      X=inStream(ret.Xi_outflow));
    retBacPro_internal.C = inStream(ret.C_outflow);
  else
    retBacPro_internal.T = Medium.T_default;
    retBacPro_internal.C = fill(0, Medium.nC);
  end if;

  ///////////////////////////////////////////////////////////////////////////
  // Conditional connectors for pressure
  if use_p_in then
    // Take the pressure from the FMI interface
    connect(retP_in_internal, retAir.p);
  else
    // Set the return air pressure to be equal to the supply air pressure.
    // This allows to not propagate the pressure to the room model, and
    // nevertheless implement an HVAC system that has no return fan, e.g.,
    // an HVAC system where the building static pressure moves the air
    // through the return duct.
    retP_in_internal =sup.p;
  end if;
  ret.p = retP_in_internal;

  ///////////////////////////////////////////////////////////////////////////
  // Assign temperature to output connector TZon.
  // This propagates the room air temperature, which is useful
  // to connect a controller.
  TZon =retAir.forward.T;

  annotation (defaultComponentName="theZonAda",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
                                   Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-100,64},{100,56}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Text(
          extent={{2,-76},{24,-94}},
          lineColor={0,0,255},
          textString="T"),
        Line(
          points={{0,-100},{0,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Rectangle(
          extent={{-100,-36},{100,-44}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Line(
          points={{80,-60},{0,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{100,-40},{80,-60}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>
Model that is used to connect an HVAC system to a thermal zone.
</p>
<p>
The model has two fluid ports <code>sup</code> and <code>ret</code>
for the supply and the return air. These quantities are
converted to the FMI ports <code>supAir</code> and <code>retAir</code>.
The model also outputs the air temperature of the zone, as obtained
from the connector <code>retAir</code>. This will always be the
zone air temperature, even if the return air mass flow rate is
zero or negative.
</p>
<h4>Assumption and limitations</h4>
<p>
The model has no pressure drop. Hence, the pressure drop
of an air diffuser or of an exhaust grill need to be modelled
in models that are connected to the ports <code>sup</code>
or <code>ret</code>.
</p>
<h4>Typical use and important parameters</h4>
<p>
Set <code>allowFlowReversal = true </code> if the HVAC system
should model reverse flow. The setting of <code>allowFlowReversal</code>
affects what quantities are exposed in the FMI interface at the connectors
<code>supAir</code> and <code>retAir</code>. See also
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Inlet\">
Buildings.Fluid.FMI.Interfaces.Inlet</a>
and
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Outlet\">
Buildings.Fluid.FMI.Interfaces.Outlet</a>.
</p>
<p>
Also, if <code>allowFlowReversal = false</code>, then the fluid properties
for the backward flowing medium at the port <code>sup</code> will be
set to the default values of the medium.
</p>
<p>
If the parameter <code>use_p_in = true</code>, then the pressure
is sent to the FMI interface for the supply air, and read from the FMI interface
for the return air.
If <code>use_p_in = false</code>, then the pressure of the return
air port <code>ret</code> is set to be the same as the pressure of
the supply air port <code>sup</code>.
Setting these equal allows for example to model a pressurized room,
and also to model systems in which the supply air fan provides the pressure
needed for the return and exhaust air.
</p>
<p>
See 
<a href=\"modelica://Buildings.Fluid.FMI.xxx\">
Buildings.Fluid.FMI.xxx</a>
for how to use this model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end ThermalZoneAdaptor;
