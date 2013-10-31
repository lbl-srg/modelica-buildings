within Buildings.Electrical.DC.Sources;
model PVSimpleOriented "Simple PV model with orientation"
  extends Buildings.Electrical.Interfaces.PartialPVOriented(redeclare package
      PhaseSystem = PhaseSystems.TwoConductor, redeclare Interfaces.Terminal_p
      terminal, redeclare Buildings.Electrical.DC.Sources.PVSimple panel);

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{-90,0},{-59,0}}, color={0,0,0}),
        Text(
          extent={{-150,61},{-50,11}},
          lineColor={0,0,255},
          textString="+"),
        Text(
          extent={{-150,-12},{-50,-62}},
          lineColor={0,0,255},
          textString="-")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(revisions="<html>
<ul>
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
This model takes as an input the information provided by the weather bus: direct and diffuse solar radiation.
The electrical connector is a DC interfaces.
</p>
<p>
This model computes the power as <i>P=A &nbsp; f<sub>act</sub> &nbsp; &eta; &nbsp; G</i>,
where <i>A</i> is the panel area,
<i>f<sub>act</sub></i> is the fraction of the aperture area,
<i>&eta;</i> is the panel efficiency and
<i>G</i> is the total solar irradiation (direct + diffuse). The model takes into account the location and the orientation of the PV panel, specified by the surface tilt, latitude and azimith.
</p>
<p>
This power is equal to <i>P = v &nbsp; i</i>,
where <i>v</i> is the voltage across the panel and 
<i>i</i> is the current that flows through the panel.
</p>
<p>
To avoid a large voltage across the panel, it is recommended to use this model together
with a model that prescribes the voltage.
See
<a href=\"modelica://Buildings.Electrical.DC.Sources.Examples.PVSimple\">
Buildings.Electrical.DC.Sources.Examples.PVSimple</a>.
</p>
</html>"));
end PVSimpleOriented;
