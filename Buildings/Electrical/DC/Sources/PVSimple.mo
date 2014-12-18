within Buildings.Electrical.DC.Sources;
model PVSimple "Simple PV model"
  extends Buildings.Electrical.Interfaces.PartialPV(
    redeclare package PhaseSystem = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_p terminal);
protected
   Loads.Conductor con(
    mode=Types.Load.VariableZ_P_input,
    P_nominal=0,
    V_nominal=V_nominal)
    "Conductor, used to interface power with electrical circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(con.terminal, terminal)  annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(solarPower.y, con.Pow) annotation (Line(
      points={{70,0},{10,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{-90,0},{-59,0}}, color={0,0,0}),
        Text(
          extent={{-150,61},{-50,11}},
          lineColor={0,0,0},
          textString="+"),
        Text(
          extent={{-150,-12},{-50,-62}},
          lineColor={0,0,0},
          textString="-")}),
    Documentation(revisions="<html>
<ul>
<li>
January 4, 2013, by Michael Wetter:<br/>
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
where <i>A</i> is the panel area, <i>f<sub>act</sub></i> is the fraction of the aperture area,
<i>&eta;</i> is the panel efficiency and <i>G</i> is the total solar irradiation.
This power is equal to <i>P = v &nbsp; i</i>, where <i>v</i> is the voltage across the panel and
<i>i</i> is the current that flows through the panel.
</p>
<p>
To avoid a large voltage drop the panel electric connector, it is recommended to use this model together
with a model that prescribes the voltage.
See
<a href=\"modelica://Buildings.Electrical.DC.Sources.Examples.PVSimple\">
Buildings.Electrical.DC.Sources.Examples.PVSimple</a>.
</p>
<p>
<b>Note:</b> This model takes as input the total solar irradiation on the panel. This has to be
computed converting the incoming radiation to take tilt and azimuth into account.
</p>
</html>"));
end PVSimple;
