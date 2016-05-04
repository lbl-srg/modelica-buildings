within Buildings.Fluid.FMI;
partial block HVACConvective
  "Partial block to export an HVAC system that has no radiative component as an FMU"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  // Set allowFlowReversal = false to remove the backward connector.
  // This is done to avoid that we get the same zone states multiple times.
  Interfaces.Outlet fluPor[size(theZonAda.fluPor, 1)](
    redeclare each final package Medium = Medium,
    each final use_p_in = false,
    each final allowFlowReversal = false) "Supply air connector"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));

  Modelica.Blocks.Interfaces.RealInput TAirZon(
    final unit="K",
    displayUnit="degC") "Zone air temperature"
    annotation (Placement(transformation(extent={{200,80},{160,120}})));
  Modelica.Blocks.Interfaces.RealInput X_wZon(
    each final unit = "kg/kg") if
       Medium.nXi > 0 "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{200,50},{160,90}})));
  Modelica.Blocks.Interfaces.RealInput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{200,20},{160,60}})));

  Modelica.Blocks.Interfaces.RealInput TRadZon(
    final unit="K",
    displayUnit="degC") "Radiative temperature of the zone"
    annotation (Placement(transformation(
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
          {132,100}}, color={0,0,127}));
  connect(X_wZon, theZonAda.X_wZon) annotation (Line(points={{180,70},{148,70},{
          148,96},{132,96}},  color={0,0,127}));
  connect(CZon, theZonAda.CZon) annotation (Line(points={{180,40},{144,40},{144,
          92},{132,92}}, color={0,0,127}));
  connect(theZonAda.fluPor, fluPor) annotation (Line(points={{131,107},{140,107},
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
          fillPattern=FillPattern.HorizontalCylinder),
        Text(
          extent={{-70,60},{72,-46}},
          lineColor={28,108,200},
          textString="hvaCon")}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
    Documentation(info="<html>
<p>
Model that is used as a container for an HVAC system that is
to be exported as an FMU.
</p>
<h4>Typical use and important parameters</h4>
<p>
To use this model as a container for an FMU, simply extend
from this model, rather than instantiate it,
and add your HVAC system. By extending from this model, the top-level
signal connectors on the right stay at the top-level, and hence
will be visible at the FMI interface.
The example
<a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs.HVACCoolingOnlyConvective\">
Buildings.Fluid.FMI.Examples.FMUs.HVACCoolingOnlyConvective</a>
shows how a simple HVAC system can be implemented and exported as
an FMU.
The example xxxx shows conceptually how such an FMU can then be connected
to a room model that has signal flow.
</p>
<p>
The conversion between the fluid ports and signal ports is done
in the thermal zone adapter <code>theZonAda</code>.
This adapter has a vector of fluid ports called <code>ports</code>.
The supply and return air ducts need to be connected to these ports.
Also, if a thermal zone has interzonal air exchange or air infiltration,
these flows need also be connected to <code>ports</code>.
The model sends at the port <code>fluPor</code> the mass flow rate for
each flow that is connected to <code>ports</code>, together with its
temperature, water vapor mass fraction per total mass of the air (not per kg dry
air), and the trace substances. These quantities are always as if the flow
enters the room, even if the flow is zero or negative.
Thus, a thermal zone model that uses these signals to compute the
heat added by the HVAC system need to implement an equation such as
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>sen</sub> = max(0, &#7745;<sub>sup,air</sub>) &nbsp; c<sub>p</sub> &nbsp; (T<sub>sup,air</sub> - T<sub>zon</sub>),
</p>
<p>
where
<i>Q<sub>sen</sub></i> is the sensible heat flow rate added to the thermal zone,
<i>&#7745;<sub>sup,air</sub></i> is the supply air mass flow rate from
the port <code>fluPor</code> (which is negative if it is an exhaust),
<i>c<sub>p</sub></i> is the specific heat capacity at constant pressure,
<i>T<sub>sup,air</sub></i> is the supply air temperature and
<i>T<sub>zon</sub></i> is the zone air temperature.
Note that without the <i>max(&middot;, &middot;)</i>, the energy
balance would be wrong.
</p>
<p>
Inputs to this container are the zone air temperature, water vapor mass fraction
per total mass of the air and trace substances.
The outflowing fluid stream(s) at port <code>ports</code> will be at this
state. All fluid streams at port <code>ports</code> are at the same
pressure.
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
for example if a mass flow rate is imposed and the HVAC system is connected
to a model that sets a pressure boundary condition such as
<a href=\"modelica://Buildings.Fluid.Sources.Outside\">
Buildings.Fluid.Sources.Outside</a>.
Also, setting a pressure would make it impossible to use multiple instances
of this model (one for each thermal zone) and build in Modelica an airflow network
model with pressure driven mass flow rates.
</p>
<p>
The model has no pressure drop. Hence, the pressure drop
of an air diffuser or of an exhaust grill need to be modelled
in models that are connected to <code>ports</code>.
</p>
<h4>Typical use and important parameters</h4>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.HVACConvective\">
Buildings.Fluid.FMI.HVACConvective</a>
for a model that uses this model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 15, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HVACConvective;
