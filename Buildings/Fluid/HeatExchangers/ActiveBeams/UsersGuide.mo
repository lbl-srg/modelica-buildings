within Buildings.Fluid.HeatExchangers.ActiveBeams;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains models of active beams.
Active beams are devices used for heating, cooling and ventilation of spaces.
A schematic diagram of an active beam unit is given below.
</p>
<p align=\"center\" >
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/ActiveBeams/schematicAB.png\" border=\"1\"/>
</p>
<p>
The active beam unit consists of a primary air plenum, a mixing chamber, a heat exchanger (coil) and several nozzles.
Typically, an air-handling unit supplies primary air to the active beams.
The primary air is discharged to the mixing chamber through the nozzles.
This generates a low-pressure region which induces air from the room up through the heat exchanger,
where hot or cold water is circulating.
The conditioned induced air is then mixed with primary air, and the mixture descents back to the space.
</p>
<p>
This package contains two models. The model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling\">
Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling</a>
is for cooling only, while the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating\">
Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating</a>
has two water streams, one for heating and one for cooling.
</p>

<h4>Model equations for cooling</h4>
<p>
The performance of the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling\">
Buildings.Fluid.HeatExchangers.ActiveBeams.Cooling</a>
is computed based on manufacturer data
specified in the package
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Data\">
Buildings.Fluid.HeatExchangers.ActiveBeams.Data</a>.
</p>
<p>
For off-design conditions, the performance is adjusted using modification factors
that account for changes in water flow rate,
primary air flow rate and temperature difference.
The total heat flow rate of the active beam unit is the sum of the heat flow rate provided by the primary air supply
<i>Q<sub>sa</sub></i> and the cooling heat flow rate provided by the beam convector <i>Q<sub>c,Beam</sub></i>
which injects room air and mixes it with the primary air.
</p>
<p>
The heat flow rate
<i>Q<sub>sa</sub> </i> is delivered to a thermal zone
through the fluid ports, while the heat flow rate from the convector <i>Q<sub>c,Beam</sub></i>
is coupled directly to the heat port.
See for example
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.Examples.CoolingOnly\">
Buildings.Fluid.HeatExchangers.ActiveBeams.Examples.CoolingOnly</a>
for how to connect these heat flow rates to a control volume.
</p>
<p>
The primary air contribution is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q<sub>sa</sub> = &#7745;<sub>sa</sub> c<sub>p,sa</sub> (T<sub>sa</sub>-T<sub>z</sub>)
</p>
<p>
where <i>&#7745;<sub>sa</sub></i> is the primary air mass flow rate,
<i>c<sub>p,sa</sub></i> is the air specific heat capacity,
<i>T<sub>sa</sub></i> is the primary air temperature
and <i>T<sub>z</sub></i> is the zone air temperature.
</p>
<p>
The heat flow rate of the beam convector <i>Q<sub>c,Beam</sub></i> is determined using
the rated capacity which is modified by three separate functions as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q<sub>c,Beam</sub> = Q<sub>c,nominal</sub>
f<sub>&#916;T</sub> ( &#916;T<sub>c</sub> &frasl; &#916;T<sub>c,nominal</sub> )
f<sub>sa</sub>( &#7745;<sub>sa</sub> &frasl; &#7745;<sub>sa,nominal</sub> )
f<sub>w</sub>( &#7745;<sub>c,w</sub> ),
</p>
<p>
the modification factors are as follows:
The modification factor <i>f<sub>&#916;T</sub>(&middot;)</i>
describes how the capacity is adjusted to account for the temperature difference
between the zone air and the water entering the convector.
The independent variable is the ratio between the current temperature difference
<i>&#916;T<sub>c</sub></i> and the temperature difference used to rate beam performance <i>&#916;T<sub>c,nominal</sub></i>.
The temperature difference is
</p>
<p align=\"center\" style=\"font-style:italic;\">
    &#916;T<sub>c</sub> = T<sub>cw</sub>-T<sub>z</sub>,
</p>
<p>
where <i>T<sub>cw</sub></i> is the chilled water temperature entering the convector.

The modification factor <i>f<sub>sa</sub>(&middot;)</i> adjusts the cooling capacity to account for varying primary air flow rate.
The independent variable is the ratio between the current primary air flow rate <i>&#7745;<sub>sa</sub></i>
and the nominal air flow rate used to rate the beam performance.

The modification factor <i>f<sub>w</sub>(&middot;)</i> adjusts the cooling capacity for changes in water flow rate through the convector.
The independent variable is the ratio between the current water flow rate <i>&#7745;<sub>w</sub></i>
and the nominal water flow rate used to rate the beam performance.
</p>

<h4>Model equations for heating</h4>
<p>
The performance of the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating\">
Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingAndHeating</a>
is computed identical to the above described model that only provides cooling,
with the exception that this model contains an additional water stream that
can be used to provide heating.
</p>
<p>
For the heating water stream, the temperature difference <i><code>&#916;</code>T<sub>h</sub></i>
used for the calculation of the modification factor <i>f<sub><code>&#916;</code>T</sub>(&middot;)</i> is
</p>
<p align=\"center\" style=\"font-style:italic;\">
&#916;T<sub>h</sub> = T<sub>hw</sub>-T<sub>z</sub>,
</p>
<p>
where <i>T<sub>hw</sub></i> is the hot water temperature entering the convector in heating mode
and <i>T<sub>z</sub></i> is the zone air temperature.
</p>

<h4>Dynamics</h4>
<p>
The model can be configured to be steady-state or dynamic.
If configured as dynamic, then a dynamic conservation equation is applied to the water streams
for heating and for cooling.
However, because the capacity of the beam depends on its inlet temperature, and is independent of the
outlet temperature, the heat transferred
to the room at the port <code>heaPor.Q_flow</code>, as well as the heat added to or removed from the
water streams, will instantaneously change.
The only dynamic responses are the water outlet temperatures, which change with a first
order response, parameterized with the time constant <code>tau</code>.
</p>

<h4>Energy balance</h4>
<p>
All heat flow rate that is added to or extracted from the room is transmitted through the heat port
<code>heaPor</code>. Hence, this model does not cool the supply air between the ports
<code>air_a</code> and <code>air_b</code>. Rather, it adds this heat flow rate
to the heat port <code>heaPor</code>.
The rationale for this implementation is that the beam transfers heat by convection directly to the room, and
by induction of room air into the supply air. As this split of heat flow rate is generally not known,
and because the amount of inducted air is also unknown,
it was decided to transfer all heat through the heat port <code>heaPor</code>.
This also avoids having to add an extra air flow path for the air induced from the room.
</p>
</html>"));
end UsersGuide;
