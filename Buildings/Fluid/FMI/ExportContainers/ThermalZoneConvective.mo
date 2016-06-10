within Buildings.Fluid.FMI.ExportContainers;
partial block ThermalZoneConvective
  "Partial block to export a model of a thermal zone as an FMU"

      replaceable package Medium =
          Modelica.Media.Interfaces.PartialMedium
    "Medium model within the source"
         annotation (choicesAllMatching=true);
  parameter Integer nFluPor( min = 1) "Number of fluid ports.";

    model InletAdaptor "Model for exposing a fluid inlet to the FMI interface"
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
      Modelica.Blocks.Interfaces.RealOutput p(unit="Pa") if
         use_p_in "Pressure"
      annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-110})));
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
      // To locally balance the model, the pressure is only imposed at the
      // outlet model.
      // The sign is negative because inlet.m_flow > 0
      // means that fluid flows out of this component
      -port_b.m_flow     = inlet.m_flow;

      port_b.h_outflow  = Medium.specificEnthalpy_pTX(
                            p = p_in_internal,
                            T = inlet.forward.T,
                            X = fill(X_w_in_internal, Medium.nXi));

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
                               X = inStream(port_b.Xi_outflow));
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
              lineColor={0,0,255}),
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
              lineColor={255,0,0},
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
              lineColor={0,0,255},
              textString="inlet"),
            Line(
              points={{0,-100},{0,-60}},
              color={0,0,255},
              smooth=Smooth.None),
            Text(
              extent={{2,-76},{24,-94}},
              lineColor={0,0,255},
              textString="p")}),
        Documentation(info="<html>
<p>
Model that is used to connect an input signal to a fluid port.
The model needs to be used in conjunction with an instance of
<a href=\"modelica://Buildings.Fluid.FMI.OutletAdaptor\">
Buildings.Fluid.FMI.OutletAdaptor</a> in order for
fluid mass flow rate and pressure to be properly assigned to
the acausal fluid models.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.PartialTwoPortComponent\">
Buildings.Fluid.FMI.ExportContainers.PartialTwoPortComponent</a>
or
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ResistanceVolume\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ResistanceVolume</a>
for how to use this model.
</p>
</html>",     revisions="<html>
<ul>
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
</html>"),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics));
    end InletAdaptor;

  // Set allowFlowReversal = false to remove the backward connector.
  // This is done to avoid that we get the same zone states multiple times.
   Interfaces.Inlet fluPor[nFluPor](
     redeclare each final package Medium = Medium,
     each final use_p_in=false,
     each final allowFlowReversal=false) "Fluid connector"
     annotation (Placement(transformation(extent={{-180,150},{-160,170}}),
        iconTransformation(extent={{-180,150},{-160,170}})));

  Modelica.Blocks.Interfaces.RealOutput TAirZon(final unit="K", displayUnit="degC")
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-160,100},{-200,140}}),
        iconTransformation(extent={{-160,100},{-200,140}})));
  Modelica.Blocks.Interfaces.RealOutput X_wZon(
    each final unit = "kg/kg") if
       Medium.nXi > 0 "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{-160,60},{-200,100}}),
        iconTransformation(extent={{-160,60},{-200,100}})));
  Modelica.Blocks.Interfaces.RealOutput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-160,20},{-200,60}})));

  Modelica.Blocks.Interfaces.RealOutput TRadZon(
    final unit="K",
    displayUnit="degC") "Radiative temperature of the zone"
    annotation (Placement(transformation(
          extent={{-160,-20},{-200,20}}), iconTransformation(extent={{-160,-20},
            {-200,20}})));

  Modelica.Blocks.Interfaces.RealInput QGaiRad_flow(final unit="W")
    "Radiant heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-200,-60},{-160,-20}})));

  Modelica.Blocks.Interfaces.RealInput QGaiCon_flow(final unit="W")
    "Convective sensible heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
        iconTransformation(extent={{-200,-100},{-160,-60}})));

  Modelica.Blocks.Interfaces.RealInput QGaiLat_flow(final unit="W")
    "Latent heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
        iconTransformation(extent={{-200,-140},{-160,-100}})));

  Buildings.Fluid.FMI.Adaptors.ThermalZone theHvaAda(
    redeclare final package Medium = Medium,
    nFluPor=nFluPor)
    "Adapter between the HVAC supply and return air, and its connectors for the FMU"
    annotation (Placement(transformation(extent={{-60,140},{-80,160}})));

equation
  connect(TAirZon, theHvaAda.TZonAir) annotation (Line(points={{-180,120},{-180,
          120},{-136,120},{-136,155},{-81.4286,155}}, color={0,0,127}));
  connect(X_wZon, theHvaAda.X_wZon) annotation (Line(points={{-180,80},{-180,80},
          {-130,80},{-130,152.5},{-81.4286,152.5}},
                                            color={0,0,127}));
  connect(CZon, theHvaAda.CZon) annotation (Line(points={{-180,40},{-180,40},{
          -124,40},{-124,150},{-81.4286,150}},color={0,0,127}));
  connect(TRadZon, theHvaAda.TZonRad) annotation (Line(points={{-180,0},{-180,0},
          {-120,0},{-120,147.5},{-81.4286,147.5}}, color={0,0,127}));
  connect(QGaiRad_flow, theHvaAda.QGaiRad_flow) annotation (Line(points={{-180,
          -40},{-65.7143,-40},{-65.7143,138.75}},
                                      color={0,0,127}));
  connect(QGaiCon_flow, theHvaAda.QGaiCon_flow) annotation (Line(points={{-180,
          -80},{-70,-80},{-70,138.75}},color={0,0,127}));
  connect(QGaiLat_flow, theHvaAda.QGaiLat_flow) annotation (Line(points={{-180,
          -120},{-74.2857,-120},{-74.2857,138.75}},
                                       color={0,0,127}));
  connect(theHvaAda.fluPor, fluPor) annotation (Line(points={{-80.7143,157.5},{
          -130.5,157.5},{-130.5,160},{-170,160}},
                                             color={0,0,255}));
  connect(X_wZon, X_wZon)
    annotation (Line(points={{-180,80},{-180,80},{-180,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,180}}), graphics={Rectangle(
          extent={{-160,180},{160,-140}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          lineColor={0,0,0}),
        Text(
          extent={{-154,6},{-104,-14}},
          lineColor={0,0,127},
          textString="TRadZon"),
        Text(
          extent={{-150,-30},{-100,-50}},
          lineColor={0,0,127},
          textString="QRad"),
        Text(
          extent={{-150,-70},{-100,-90}},
          lineColor={0,0,127},
          textString="QCon"),
        Text(
          extent={{-154,-108},{-104,-128}},
          lineColor={0,0,127},
          textString="QLat"),
        Text(
          extent={{-156,48},{-106,28}},
          lineColor={0,0,127},
          textString="CZon"),
        Text(
          extent={{-152,90},{-102,70}},
          lineColor={0,0,127},
          textString="X_wZon"),
        Text(
          extent={{-154,130},{-104,110}},
          lineColor={0,0,127},
          textString="TAirZon"),
        Text(
          extent={{-64,270},{78,164}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,180}})),
    Documentation(info="<html>
<p>
Model that is used as a container for a thermal
zone that is to be exported as an FMU.
</p>
<h4>Typical use and important parameters</h4>
This model has a user-defined parameter <code>nFluPor</code>
which sets the number of fluid ports.
<p>
To use this model, all <code>nFluPor</code>
<code>ports</code> need to be connected as described in example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective
</a>.
</p>
<p>
To use this model as a container for an FMU, simply extend from this model,
rather than instantiate it, and add your thermal zone. By extending from this model,
the top-level signal connectors on the left stay at the top-level,
and hence will be visible at the FMI interface.The example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective
</a>
shows how a simple convective thermal zone system can be implemented
and exported as an FMU.
The example
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective\">
Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective
</a>
shows conceptually how such an FMU can then be connected to a HVAC system
that has signal flow.
</p>
<p>
The conversion between the fluid ports and signal ports is done in the HVAC
adapter <code>theHvaAda</code>.
</p>
<h4>Assumption and limitations</h4>
<p>
The mass flow rates at <code>ports</code> sum to zero, hence this
model conserves mass.
</p>
<p>
This model does not impose any pressure, other than setting the pressure
of all fluid connections to <code>ports</code> to be equal.
The reason is that setting a pressure can lead to non-physical system models,
for example if a mass flow rate is imposed and the thermal zone is connected
to a model that sets a pressure boundary condition such as
<a href=\"modelica://Buildings.Fluid.Sources.Outside\">
Buildings.Fluid.Sources.Outside
</a>.
</p>
<h4>Typical use and important parameters</h4>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective
</a>
for a model that uses this model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZoneConvective;
