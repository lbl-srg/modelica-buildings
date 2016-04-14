within Buildings.Fluid.FMI;
partial block HVACConvective
  "Partial block to export an HVAC system that has no radiative component as an FMU"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in = true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput TRadZon(final unit="K")
    "Radiative temperature of the zone" annotation (Placement(transformation(
          extent={{200,-20},{160,20}})));

  Interfaces.Outlet supplyAir(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in)
    "Connector that is the inlet into the thermal zone" annotation (Placement(
        transformation(extent={{160,110},{180,130}})));
  Interfaces.Inlet returnAir(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Return air"
    annotation (Placement(transformation(extent={{180,50},{160,70}}),
        iconTransformation(extent={{180,50},{160,70}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiRad_flow(final unit="W")
    "Radiant heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiCon_flow(final unit="W")
    "Convective sensible heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-110},{200,-70}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiLat_flow(final unit="W")
    "Latent heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-160},{200,-120}})));

protected
  ThermalZoneAdaptor theZonAda(
    redeclare final package Medium = Medium,
    final use_p_in = use_p_in)
    "Adapter between the HVAC supply and return air, and its connectors for the FMU"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
equation
  connect(theZonAda.supAir, supplyAir) annotation (Line(points={{141,96},{150,96},
          {150,120},{170,120}}, color={0,0,255}));
  connect(theZonAda.retAir, returnAir) annotation (Line(points={{141,86},{150,86},
          {150,60},{170,60}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
            {160,160}}), graphics={Rectangle(
          extent={{-160,160},{160,-160}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          lineColor={0,0,0}),
        Text(
          extent={{100,12},{150,-8}},
          lineColor={0,0,127},
          textString="TRadZon"),
        Text(
          extent={{100,-28},{150,-48}},
          lineColor={0,0,127},
          textString="QRad"),
        Text(
          extent={{100,-78},{150,-98}},
          lineColor={0,0,127},
          textString="QCon"),
        Text(
          extent={{100,-128},{150,-148}},
          lineColor={0,0,127},
          textString="QLat"),
        Rectangle(
          extent={{100,64},{160,56}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{100,124},{160,116}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder)}),         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})));
end HVACConvective;
