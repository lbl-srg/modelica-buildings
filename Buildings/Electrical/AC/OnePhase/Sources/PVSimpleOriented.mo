within Buildings.Electrical.AC.OnePhase.Sources;
model PVSimpleOriented "Simple PV model with orientation"
  extends Buildings.Electrical.Interfaces.PartialAcDcParameters;
  extends Buildings.Electrical.Interfaces.PartialPVOriented(redeclare package
      PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
      V_nominal = 110,
      redeclare Interfaces.Terminal_p terminal, redeclare
      Buildings.Electrical.AC.OnePhase.Sources.PVSimple panel(pf=pf, eta_DCAC=eta_DCAC,
      V_nominal=V_nominal,
      linear=linear));
  parameter Boolean linear=false
    "If =true introduce a linearization in the load";
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
The electrical connector is a AC one phase interfaces.
</p>
<p>
This model computes the active power as <i>P=A &nbsp; f<sub>act</sub> &nbsp; &eta; &nbsp; G &nbsp; &eta;<sub>DCAC</sub></i> ,
where <i>A</i> is the panel area,
<i>f<sub>act</sub></i> is the fraction of the aperture area,
<i>&eta;</i> is the panel efficiency,
<i>G</i> is the total solar irradiation,
<i>G</i> is the total solar irradiation, which is the
sum of direct and diffuse irradiation, and
<i>&eta;<sub>DCAC</sub></i> is the efficiency of the conversion between DC and AC.
The model takes into account the location and the orientation of the PV panel, specified by the surface tilt, latitude and azimuth.
</p>
<p>
This active power is equal to <i>P</i>, while the reactive power is equal to <i>Q = P &nbsp; tan(acos(pf)) </i>
where <i>pf</i> is the power factor.
</p>
</html>"));
end PVSimpleOriented;
