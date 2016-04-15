within Buildings.Fluid.FMI;
partial block HVACConvective
  "Partial block to export an HVAC system that has no radiative component as an FMU"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  // Set allowFlowReversal = false to remove the backward connector.
  // This is done to avoid that we get the same zone states multiple times.
  Interfaces.Outlet supAir[size(theZonAda.supAir, 1)](
    redeclare each final package Medium = Medium,
    each final use_p_in = false,
    each final allowFlowReversal = false) "Supply air connector"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));

  Modelica.Blocks.Interfaces.RealInput TAirZon(
    final unit="K",
    displayUnit="degC")
    "Zone air temperature"
    annotation (Placement(transformation(extent={{200,80},{160,120}})));
  Modelica.Blocks.Interfaces.RealInput X_wZon(
    each final unit = "kg/kg") if
       Medium.nXi > 0
    "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{200,50},{160,90}})));
  Modelica.Blocks.Interfaces.RealInput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{200,20},{160,60}})));

  Modelica.Blocks.Interfaces.RealInput TRadZon(
    final unit="K",
    displayUnit="degC")
    "Radiative temperature of the zone" annotation (Placement(transformation(
          extent={{200,-20},{160,20}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiRad_flow(final unit="W")
    "Radiant heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiCon_flow(final unit="W")
    "Convective sensible heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-110},{200,-70}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiLat_flow(final unit="W")
    "Latent heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-160},{200,-120}})));

  ThermalZoneAdaptor theZonAda(
    redeclare final package Medium = Medium)
    "Adapter between the HVAC supply and return air, and its connectors for the FMU"
    annotation (Placement(transformation(extent={{110,90},{130,110}})));

equation
  connect(TAirZon, theZonAda.TZon) annotation (Line(points={{180,100},{150,100},
          {150,100},{132,100}}, color={0,0,127}));
  connect(X_wZon, theZonAda.X_wZon) annotation (Line(points={{180,70},{148,70},{
          148,96},{132,96}},  color={0,0,127}));
  connect(CZon, theZonAda.CZon) annotation (Line(points={{180,40},{144,40},{144,
          92},{132,92}}, color={0,0,127}));
  connect(theZonAda.supAir, supAir) annotation (Line(points={{131,107},{140,107},
          {140,140},{170,140}}, color={0,0,255}));
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
