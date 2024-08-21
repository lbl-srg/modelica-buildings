within Buildings.Electrical.DC.Sources;
model PVSimpleOriented "Simple PV model with orientation"
  extends Buildings.Electrical.Interfaces.PartialPVOriented(
    redeclare package PhaseSystem = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_p terminal,
    redeclare Buildings.Electrical.DC.Sources.PVSimple panel(V_nominal=V_nominal));

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{-90,0},{-59,0}}, color={0,0,0}),
        Text(
          extent={{-150,61},{-50,11}},
          textColor={0,0,0},
          textString="+"),
        Text(
          extent={{-150,-12},{-50,-62}},
          textColor={0,0,0},
          textString="-")}),
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2022, by Michael Wetter:<br/>
Corrected documentation string for parameter <code>A</code>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>",
info="<html>
<p>
Model of a simple photovoltaic array.
</p>
<p>
This model computes the power as
</p>

<p align=\"center\" style=\"font-style:italic;\">
P=A &nbsp; f<sub>act</sub> &nbsp; &eta; &nbsp; G
</p>

<p>
where <i>A</i> is the panel area,
<i>f<sub>act</sub></i> is the fraction of the aperture area,
<i>&eta;</i> is the panel efficiency and
<i>G</i> is the total solar irradiation, which is the sum
of direct and diffuse irradiation.
The model takes into account the location and the orientation of the PV panel,
specified by the surface tilt, latitude and azimuth.
</p>
<p>
This power is equal to <i>P = v &nbsp; i</i>,
where <i>v</i> is the voltage across the panel and
<i>i</i> is the current that flows through the panel.
</p>
<p>
To avoid a large voltage drop the panel electric connector,
it is recommended to use this model together
with a model that prescribes the voltage.
See
<a href=\"modelica://Buildings.Electrical.DC.Sources.Examples.PVSimpleOriented\">
Buildings.Electrical.DC.Sources.Examples.PVSimpleOriented</a>.
</p>
<p>
This model takes as an input the direct and diffuse solar radiation from
the weather data bus.
</p>
</html>"));
end PVSimpleOriented;
