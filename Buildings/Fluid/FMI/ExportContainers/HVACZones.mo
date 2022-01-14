within Buildings.Fluid.FMI.ExportContainers;
partial block HVACZones
  "Partial block to export an HVAC system that has no radiative component and that serves multiple zones as an FMU"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));
  parameter Integer nZon(min=1)
    "Number of thermal zones served by the HVAC system";

  parameter Integer nPorts(min=2)
    "Number of fluid ports for each zone (must be the same for every zone)";

  // Set allowFlowReversal = true to get access to the states of the zone.
  Interfaces.Outlet fluPor[nZon, nPorts](
    redeclare each final package Medium = Medium,
    each final use_p_in = false,
    each final allowFlowReversal = true) "Fluid connectors"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));

  Modelica.Blocks.Interfaces.RealInput TRadZon[nZon](
    each final unit="K",
    each displayUnit="degC") "Radiative temperature of the zone"
    annotation (Placement(transformation(
          extent={{200,32},{160,72}}),  iconTransformation(extent={{180,52},{160,
            72}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiRad_flow[nZon](each final unit="W")
    "Radiant heat input into the zones (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}}),
        iconTransformation(extent={{160,-50},{180,-30}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiSenCon_flow[nZon](each final unit="W")
    "Convective sensible heat input into the zones (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-110},{200,-70}}),
        iconTransformation(extent={{160,-100},{180,-80}})));

  Modelica.Blocks.Interfaces.RealOutput QGaiLat_flow[nZon](each final unit="W")
    "Latent heat input into the zones (positive if heat gain)"
    annotation (Placement(transformation(extent={{160,-160},{200,-120}}),
        iconTransformation(extent={{160,-150},{180,-130}})));

  Adaptors.HVAC hvacAda[nZon](redeclare each final package Medium =
        Medium, each final nPorts=nPorts)
    "Adapter between the HVAC supply and return air, and its connectors for the FMU"
    annotation (Placement(transformation(extent={{120,130},{140,150}})));

equation
  for iZon in 1:nZon loop
    for iPor in 1:nPorts loop
      connect(hvacAda[iZon].fluPor[iPor], fluPor[iZon, iPor]) annotation (Line(
            points={{141,140},{154,140},{170,140}},           color={0,0,255}));
    end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
            {160,160}}), graphics={Rectangle(
          extent={{-160,160},{160,-160}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          lineColor={0,0,0}),
        Text(
          extent={{104,76},{154,56}},
          textColor={0,0,127},
          textString="TRad"),
        Text(
          extent={{100,-28},{150,-48}},
          textColor={0,0,127},
          textString="QRad"),
        Text(
          extent={{100,-78},{150,-98}},
          textColor={0,0,127},
          textString="QCon"),
        Text(
          extent={{106,-128},{156,-148}},
          textColor={0,0,127},
          textString="QLat"),
        Text(
          extent={{-72,252},{70,146}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-144,-24},{80,-32}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-68,-4},{-16,-56}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-146,46},{80,38}},
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
        Rectangle(
          extent={{30,72},{80,64}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{30,22},{80,14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{30,0},{80,-8}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{30,-48},{80,-56}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-28,4},{28,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={32,-28},
          rotation=90),
        Rectangle(
          extent={{-29,4},{29,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={32,43},
          rotation=90)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}}),
        graphics={Text(
          extent={{104,152},{118,146}},
          textColor={0,0,127},
          textString="[%nZon, %nPorts]")}),
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
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones</a>
shows how a simple HVAC system that serves two rooms can be implemented and exported as
an FMU.
The example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Validation.RoomHVAC\">
Buildings.Fluid.FMI.ExportContainers.Validation.RoomHVAC</a>
shows how such an FMU can be connected
to a room model that has signal flow.
</p>
<p>
The following two parameters need to be assigned by the user:
Set <code>nZon</code> to the number of thermal zones to which the
FMU will be connected.
Set <code>nPorts</code> to the largest number of fluid ports
that the thermal zones has. For example,
if <code>nZon=2</code> and zone <i>1</i> has one inlet and one outlet
(hence it has 2 ports),
and zone <i>2</i> has one inlets and two outlets
(hence it has 3 ports), then
set <code>nPorts=3</code>. This will add more fluid ports than are needed
for zone <i>1</i>, but this causes no overhead if they are not connected.
</p>
<p>
The conversion between the fluid ports and signal ports is done
in the HVAC adapter <code>hvacAda</code>.
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
The input signals of this model are the radiative temperature of each zone.
The the zone air temperatures,
the water vapor mass fractions per total mass of the air (unless <code>Medium.nXi=0</code>)
and trace substances (unless <code>Medium.nC=0</code>) are obtained from the connector
<code>fluPor.backward</code>.
The outflowing fluid stream(s) at the port <code>ports</code> will be at the
states obtained from <code>fluPor.backward</code>.
For any given <i>i<sub>zon</sub> &isin; {1, ..., n<sub>zon</sub>}</i>,
for each <i>i<sub>ports</sub> &isin; {1, ..., n<sub>ports</sub>}</i>
all fluid streams at port <code>ports[i<sub>zon</sub>, i<sub>ports</sub>]</code> are at the same
pressure.
For convenience, the instance <code>hvacAda</code> also outputs the
properties obtained from <code>fluPor.backward</code>. These can be used
to connect a controller. The properties are available for each flow path in
<code>fluPor.backward</code>. For a thermal zone with mixed air, these are
all equal, while for a stratified room model, they can be different.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones</a>
for a model that uses this model.
</p>
<p>
For models that only have one thermal zone connected to the HVAC system,
use the simpler model
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACZone\">
Buildings.Fluid.FMI.ExportContainers.HVACZone</a>.
</p>
<h4>Assumption and limitations</h4>
<p>
The mass flow rates at <code>ports</code> sum to zero, hence this
model conserves mass for each thermal zone.
</p>
<p>
This model does not impose any pressure, other than,
for any given <i>i<sub>zon</sub> &isin; {1, ..., n<sub>zon</sub>}</i> and
for each <i>j,k &isin; {1, ..., n<sub>ports</sub>}</i>,
setting the pressure of <code>ports[i<sub>zon</sub>, j].p = ports[i<sub>zon</sub>, k].p</code>
to be the same.
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
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to moist air only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
May 25, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HVACZones;
