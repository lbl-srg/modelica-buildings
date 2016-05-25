within Buildings.Fluid.FMI.ExportContainers;
partial block HVACConvectiveMultipleZones
  "Partial block to export an HVAC system that has no radiative component and that serves multiple zones as an FMU"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Integer nZon(min=1)
    "Number of thermal zones served by the HVAC system";

  // Set allowFlowReversal = false to remove the backward connector.
  // This is done to avoid that we get the same zone states multiple times.
  Interfaces.Outlet fluPor[nZon, size(theZonAda.fluPor, 1)](
    redeclare each final package Medium = Medium,
    each final use_p_in = false,
    each final allowFlowReversal = false) "Fluid connector"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));

  Modelica.Blocks.Interfaces.RealInput TAirZon[nZon](
    each final unit="K",
    each displayUnit="degC") "Zone air temperatures"
    annotation (Placement(transformation(extent={{200,80},{160,120}})));

  Modelica.Blocks.Interfaces.RealInput TRadZon[nZon](
    each final unit="K",
    each displayUnit="degC") "Radiative temperature of the zones"
    annotation (Placement(transformation(
          extent={{200,-20},{160,20}})));

  Modelica.Blocks.Interfaces.RealInput X_wZon[nZon](
    each final unit = "kg/kg") if
       Medium.nXi > 0 "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{200,50},{160,90}})));

  Modelica.Blocks.Interfaces.RealInput CZon[nZon, Medium.nC](
    each final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{200,20},{160,60}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiRad_flow[nZon](each final unit="W")
    "Radiant heat input into the zones (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiCon_flow[nZon](each final unit="W")
    "Convective sensible heat input into the zones (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-110},{200,-70}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiLat_flow[nZon](each final unit="W")
    "Latent heat input into the zones (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-160},{200,-120}})));

  Buildings.Fluid.FMI.Adaptors.ThermalZoneConvective theZonAda[nZon](
    redeclare each final package Medium = Medium)
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
        Text(
          extent={{-72,252},{70,146}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-144,-24},{36,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-68,-4},{-16,-56}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-146,46},{32,36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-68,68},{-16,16}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-56,64},{-16,42},{-56,20},{-56,64}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-28,-8},{-68,-30},{-28,-52},{-28,-8}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-124,66},{-88,-56}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-88,66},{-112,8}}, pattern=LinePattern.None),
        Line(points={{-88,66},{-124,-56}}, color={0,0,0})}),     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
    Documentation(info="<html>
<p>
Model that is used as a container for an HVAC system that is
to be exported as an FMU and that serves multiple zones.
</p>
<h4>Typical use and important parameters</h4>
<p>
To use this model as a container for an FMU, simply extend
from this model, rather than instantiate it,
and add your HVAC system. By extending from this model, the top-level
signal connectors on the right stay at the top-level, and hence
will be visible at the FMI interface.
The example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveSingleZone\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveSingleZone</a>
xxxx (update link)
shows how a simple HVAC system can be implemented and exported as
an FMU.
The example
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective\">
Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective</a>
xxx (update link)
shows how such an FMU can be connected
to a room model that has signal flow.
</p>
<p>
The conversion between the fluid ports and signal ports is done
in the thermal zone adapter <code>theZonAda</code>.
This adapter is vectorized as each component serves one thermal zone.
This adapter has a vector of fluid ports called <code>ports</code>.
The supply and return air ducts need to be connected to these ports.
The first index is for the number of the thermal zone, and the second
index is for the number of fluid inlet or outlet of the thermal zone.
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
Inputs to this container are, for each thermal zone,
the zone air temperature, water vapor mass fraction
per total mass of the air and trace substances.
The outflowing fluid stream(s) at port <code>ports</code> will be at this
state. For each thermal zone, all fluid streams at port <code>ports</code> are at the same
pressure, hence, for example, <code>ports[1, 1].p = porst[1, 2].p = ... </code>.
However, <code>ports[1, 1].p</code> need not be at the same pressure as
<code>porst[2, 1].p</code>
</p>
<h4>Assumption and limitations</h4>
<p>
The mass flow rates at <code>ports</code> sum to zero, hence this
model conserves mass for each thermal zone.
</p>
<p>
This model does not impose any pressure, other than setting the pressure
of all fluid connections to <code>ports[i, :]</code> to be equal.
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
of an air diffuser or of an exhaust grill needs to be modelled
in models that are connected to <code>ports</code>.
</p>
<h4>Typical use and important parameters</h4>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveSingleZone\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveSingleZone</a>
for a model that uses this model.
</p>
<p>
For models that only have one thermal zone connected to the HVAC system,
use the simpler model
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACConvectiveSingleZone\">
Buildings.Fluid.FMI.ExportContainers.HVACConvectiveSingleZone</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 25, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HVACConvectiveMultipleZones;
