within Districts.Electrical.DC.Sources;
model PVSimple "Simple PV model"
  extends Districts.Electrical.DC.Interfaces.OnePort;
  parameter Modelica.SIunits.Area A "Net surface area";
  parameter Real fAct(min=0, max=1, unit="1") = 0.9
    "Fraction of surface area with active solar cells";
  parameter Real eta(min=0, max=1, unit="1") = 0.12
    "Module conversion efficiency";
  Modelica.Blocks.Interfaces.RealInput G(unit="W/m2")
    "Total solar irradiation per unit area"
     annotation (Placement(transformation(
        origin={0,70},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

  Modelica.SIunits.Power P "Generated electrical power";
equation
  P = A*fAct*eta*G;
  P = -v*i;
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{-90,0},{-59,0}}, color={0,0,0}),
        Text(
          extent={{-150,-104},{150,-64}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-150,70},{-50,20}},
          lineColor={0,0,255},
          textString="+"),
        Text(
          extent={{51,68},{151,18}},
          lineColor={0,0,255},
          textString="-"),
        Polygon(
          points={{-80,-52},{-32,63},{78,63},{29,-52},{-80,-52}},
          smooth=Smooth.None,
          fillColor={205,203,203},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-69,-45},{-57,-19},{-34,-19},{-45,-45},{-69,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-5,100},{98,136}},
          lineColor={0,0,255},
          textString="G"),
        Polygon(
          points={{-53,-9},{-41,17},{-18,17},{-29,-9},{-53,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-38,27},{-26,53},{-3,53},{-14,27},{-38,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-36,-45},{-24,-19},{-1,-19},{-12,-45},{-36,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-20,-9},{-8,17},{15,17},{4,-9},{-20,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-5,27},{7,53},{30,53},{19,27},{-5,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-3,-45},{9,-19},{32,-19},{21,-45},{-3,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{13,-9},{25,17},{48,17},{37,-9},{13,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{28,27},{40,53},{63,53},{52,27},{28,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Ellipse(
          extent={{-30,30},{30,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-50,0},{50,0}}, color={0,0,0})}),
    Documentation(revisions="<html>
<ul>
<li>
January 4, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>
Model of a simple photovoltaic array.
fixme: Convert incoming radiation to take tilt and azimuth into account.
</p>
<p>
This model takes as an input the total solar irradiation on the panel.
The electrical connectors are direct current pins.
</p>
<p>
This model computes the power as <i>P=A &nbsp; f<sub>act</sub> &nbsp; &eta; &nbsp; G</i>,
where <i>A</i> is the panel area,
<i>f<sub>act</sub></i> is the fraction of the aperture area,
<i>&eta;</i> is the panel efficiency and
<i>G</i> is the total solar irradiation.
This power is equal to <i>P = v &nbsp; i</i>,
where <i>v</i> is the voltage across the panel and 
<i>i</i> is the current that flows through the panel.
</p>
<p>
To avoid a large voltage across the panel, it is recommended to use this model together
with a model that prescribes the voltage.
See
<a href=\"modelica://Districts.Electrical.DC.Sources.Examples.PVSimple\">
Districts.Electrical.DC.Sources.Examples.PVSimple</a>.
</p>
</html>"));
end PVSimple;
