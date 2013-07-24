within Districts.Electrical.DC.Sources;
model PVSimple "Simple PV model"
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
  Modelica.Blocks.Interfaces.RealOutput P(unit="W") "Generated power"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Districts.Electrical.DC.Interfaces.Terminal_p
                                             terminal(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.TwoConductor)
    "Generalised terminal"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
protected
  Modelica.Blocks.Sources.RealExpression solarPower(y=-A*fAct*eta*G)
    annotation (Placement(transformation(extent={{91,-10},{71,10}})));
  Loads.Conductor con(mode=Districts.Electrical.Types.Assumption.VariableZ_P_input)
    "Conductor, used to interface power with electrical circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Gain gain(k=-1) "Gain to reverse sign"
    annotation (Placement(transformation(extent={{70,60},{90,80}})));
equation
  connect(con.terminal, terminal)  annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(solarPower.y, con.Pow) annotation (Line(
      points={{70,0},{42,0},{42,6.66134e-16},{10,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, P) annotation (Line(
      points={{91,70},{110,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solarPower.y, gain.u) annotation (Line(
      points={{70,6.66134e-16},{58,6.66134e-16},{58,0},{39,0},{39,70},{68,70}},
      color={0,0,127},
      smooth=Smooth.None));

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
          extent={{-150,-12},{-50,-62}},
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
          pattern=LinePattern.None),
        Text(
          extent={{102,107},{124,81}},
          lineColor={0,0,127},
          textString="P")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
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
