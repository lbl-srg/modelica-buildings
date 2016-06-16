within Buildings.Fluid.FMI.ExportContainers;
partial block HVACConvectiveSingleZone
  "Partial block to export an HVAC system that has no radiative component and that serves multiple zones as an FMU"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  // Set allowFlowReversal = false to remove the backward connector.
  // This is done to avoid that we get the same zone states multiple times.
  Interfaces.Outlet fluPor[size(hvacAda.fluPor, 1)](
    redeclare each final package Medium = Medium,
    each final use_p_in=false,
    each final allowFlowReversal=false) "Fluid connector"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));

  Modelica.Blocks.Interfaces.RealInput TAirZon(
    final unit="K",
    displayUnit="degC") "Zone air temperature"
    annotation (Placement(transformation(extent={{200,80},{160,120}}),
        iconTransformation(extent={{180,100},{160,120}})));

  Modelica.Blocks.Interfaces.RealInput TRadZon(
    final unit="K",
    displayUnit="degC") "Radiative temperature of the zone"
    annotation (Placement(transformation(
          extent={{200,50},{160,90}}),  iconTransformation(extent={{180,70},{160,
            90}})));

  Modelica.Blocks.Interfaces.RealInput X_wZon(
    final unit = "kg/kg") if
    Medium.nXi > 0 "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{200,20},{160,60}}),
        iconTransformation(extent={{180,40},{160,60}})),
        visible=Medium.nXi > 0);

  Modelica.Blocks.Interfaces.RealInput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{200,-10},{160,30}}),
        iconTransformation(extent={{180,10},{160,30}})),
        visible=Medium.nC > 0);

  Modelica.Blocks.Interfaces.RealOutput QGaiRad_flow(final unit="W")
    "Radiant heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiCon_flow(final unit="W")
    "Convective sensible heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-110},{200,-70}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiLat_flow(final unit="W")
    "Latent heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-160},{200,-120}})));

  Adaptors.HVACConvective hvacAda(redeclare final package Medium = Medium)
    "Adapter between the HVAC supply and return air, and its connectors for the FMU"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));

equation
  connect(TAirZon, hvacAda.TAirZon) annotation (Line(points={{180,100},{156,100},
          {156,110},{141,110}}, color={0,0,127}));
  connect(X_wZon, hvacAda.X_wZon) annotation (Line(points={{180,40},{152,40},{
          152,106},{141,106}}, color={0,0,127}));
  connect(CZon, hvacAda.CZon) annotation (Line(points={{180,10},{148,10},{148,
          102},{141,102}}, color={0,0,127}));
  connect(hvacAda.fluPor, fluPor) annotation (Line(points={{141,117},{150,117},
          {150,140},{170,140}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
            {160,160}}), graphics={Rectangle(
          extent={{-160,160},{160,-160}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          lineColor={0,0,0}),
        Text(
          extent={{100,90},{150,70}},
          lineColor={0,0,127},
          textString="TRad",
          horizontalAlignment=TextAlignment.Left),
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
        Line(points={{-88,66},{-124,-56}}, color={0,0,0}),
        Text(
          extent={{100,30},{150,10}},
          lineColor={0,0,127},
          textString="C",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{102,62},{152,42}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="X_w"),
        Text(
          extent={{100,120},{150,100}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="TAir")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
    Documentation(info="<html>
<p>
Model that is used as a container for an HVAC system that is
to be exported as an FMU and that serves a single zone.
</p>
<h4>Typical use and important parameters</h4>
<p>
To use this model as a container for an FMU, extend
from this model, rather than instantiate it,
and add your HVAC system. By extending from this model, the top-level
signal connectors on the right stay at the top-level, and hence
will be visible at the FMI interface.
The example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveSingleZone\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveSingleZone</a>
shows how a simple HVAC system can be implemented and exported as
an FMU.
The example
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective\">
Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective</a>
shows how such an FMU can be connected
to a room model that has signal flow.
</p>
<p>
The conversion between the fluid ports and signal ports is done
in the thermal zone adapter <code>theZonAda</code>.
This adapter has a vector of fluid ports called <code>ports</code>.
The supply and return air ducts, including any resistance model for the inlet
diffusor or exhaust grill, need to be connected to these ports.
Also, if a thermal zone has interzonal air exchange or air infiltration,
these flows need to be connected to <code>ports</code>.
This model outputs at the port <code>fluPor</code> the mass flow rate for
each flow that is connected to <code>ports</code>, together with its
temperature, water vapor mass fraction per total mass of the air (not per kg dry
air), and trace substances. These quantities are always as if the flow
enters the room, even if the flow is zero or negative.
If a medium has no moisture, e.g., if <code>Medium.nXi=0</code>, or
if it has no trace substances, e.g., if <code>Medium.nC=0</code>, then
the output signal for these properties are removed.
These quantities are always as if the flow
enters the room, even if the flow is zero or negative.
Thus, a thermal zone model that uses these signals to compute the
heat added by the HVAC system need to implement an equation such as
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>sen</sub> = max(0, &#7745;<sub>sup</sub>) &nbsp; c<sub>p</sub> &nbsp; (T<sub>sup</sub> - T<sub>air,zon</sub>),
</p>
<p>
where
<i>Q<sub>sen</sub></i> is the sensible heat flow rate added to the thermal zone,
<i>&#7745;<sub>sup</sub></i> is the supply air mass flow rate from
the port <code>fluPor</code> (which is negative if it is an exhaust),
<i>c<sub>p</sub></i> is the specific heat capacity at constant pressure,
<i>T<sub>sup</sub></i> is the supply air temperature and
<i>T<sub>air,zon</sub></i> is the zone air temperature.
Note that without the <i>max(&middot;, &middot;)</i>, the energy
balance would be wrong.
</p>
<p>
The input signals of this model are the zone air temperature,
the water vapor mass fraction per total mass of the air (unless <code>Medium.nXi=0</code>)
and trace substances (unless <code>Medium.nC=0</code>).
The outflowing fluid stream(s) at the port <code>ports</code> will be at this
state. All fluid streams at port <code>ports</code> are at the same
pressure.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveSingleZone\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveSingleZone</a>
for a model that uses this model.
</p>
<p>
For models that multiple thermal zones connected to the HVAC system,
use the model
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACConvectiveMultipleZones\">
Buildings.Fluid.FMI.ExportContainers.HVACConvectiveMultipleZones</a>.
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
of an air diffuser or of an exhaust grill needs to be modelled
in models that are connected to <code>ports</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 15, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HVACConvectiveSingleZone;
