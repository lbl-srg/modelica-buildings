within Buildings.Electrical.AC.OnePhase.Sources;
model PVSimpleOriented "Simple PV model with orientation"
  extends Buildings.Electrical.Interfaces.PartialAcDcParameters;
  extends Buildings.Electrical.Interfaces.PartialPVOriented(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
      V_nominal(start = 110),
      redeclare replaceable Interfaces.Terminal_p terminal,
      redeclare replaceable Buildings.Electrical.AC.OnePhase.Sources.PVSimple panel(
        pf=pf,
        eta_DCAC=eta_DCAC,
        V_nominal=V_nominal,
        linearized=linearized));
  parameter Boolean linearized=false "If =true, linearize the load";
  annotation (
defaultComponentName="pv",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{-90,0},{-59,0}}, color={0,0,0})}),
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
October 7, 2019, by Michael Wetter:<br/>
Corrected model to include DC/AC conversion in output <code>P</code>.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1577\">1577</a>.
</li>
<li>
January 30, 2019, by Michael Wetter:<br/>
Added <code>replaceable</code>.
</li>
<li>
September 4, 2014, by Michael Wetter:<br/>
Revised model.
</li>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised documentation.
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
This model takes as an input the direct and diffuse solar radiation from
the weather bus.
The electrical connector is an AC one phase interface.
</p>
<p>
This model computes the active power as
<p align=\"center\" style=\"font-style:italic;\">
P=A &nbsp; f<sub>act</sub> &nbsp; &eta; &nbsp; G &nbsp; &eta;<sub>DCAC</sub>,
</p>
<p>
where <i>A</i> is the panel area,
<i>f<sub>act</sub></i> is the fraction of the aperture area,
<i>&eta;</i> is the panel efficiency,
<i>G</i> is the total solar irradiation, which is the
sum of direct and diffuse irradiation, and
<i>&eta;<sub>DCAC</sub></i> is the efficiency of the conversion between DC and AC.
The model takes into account the location and the orientation of the PV panel,
specified by the surface tilt, latitude and azimuth.
</p>
<p>
This active power is equal to <i>P</i>, while the reactive power is equal to <i>Q = P &nbsp; tan(acos(pf))</i>,
where <i>pf</i> is the power factor.
</p>
</html>"));
end PVSimpleOriented;
