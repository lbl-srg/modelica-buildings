within Buildings.Fluid.Storage;
model Stratified "Model of a stratified tank for thermal energy storage"
  extends Buildings.Fluid.Storage.BaseClasses.PartialStratified(vol(each nPorts=3));

  Modelica.Fluid.Interfaces.FluidPort_a fluPorVol[nSeg](
    redeclare each final package Medium = Medium)
    "Fluid port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}}),
        iconTransformation(extent={{-36,-10},{-16,10}})));
equation
  connect(port_a, vol[1].ports[1]) annotation (Line(points={{-100,0},{-88,0},{
          -88,-20},{16,-20},{16,-16}}, color={0,127,255}));
  connect(vol[nSeg].ports[2], port_b) annotation (Line(points={{16,-16},{20,-16},
          {20,-20},{90,-20},{90,0},{100,0}}, color={0,127,255}));
  for i in 1:(nSeg-1) loop
    connect(vol[i].ports[2], vol[i + 1].ports[1]) annotation (Line(points={{16,-16},
            {16,-32},{14,-32},{14,-16},{16,-16}}, color={0,127,255}));
  end for;
  for i in 1:nSeg loop
    connect(fluPorVol[i], vol[i].ports[3]) annotation (Line(points={{-20,0},{-20,-36},
          {16,-36},{16,-16}}, color={0,127,255}));
  end for;
  annotation (
defaultComponentName="tan",
Documentation(info="<html>
<p>
This is a model of a stratified storage tank.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Storage.UsersGuide\">
Buildings.Fluid.Storage.UsersGuide</a>
for more information.
</p>
<p>
For a model with enhanced stratification, use
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 7, 2018 by Filip Jorissen:<br/>
Copied model from Buildings and update the model accordingly.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/314\">#314</a>.
</li>
<li>
June 1, 2018, by Michael Wetter:<br/>
Refactored model to allow a fluid port in the tank that do not have
the enhanced stratification model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1182\">
issue 1182</a>.
</li>
<li>
July 29, 2017, by Michael Wetter:<br/>
Removed medium declaration, which is not needed and inconsistent with
the declaration in the base class.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/544\">
issue 544</a>.
</li>
<li>
March 28, 2015, by Filip Jorissen:<br/>
Propagated <code>allowFlowReversal</code> and <code>m_flow_small</code>
and set <code>mSenFac=1</code>.
</li>
<li>
January 26, 2015, by Michael Wetter:<br/>
Renamed
<code>hA_flow</code> to <code>H_a_flow</code>,
<code>hB_flow</code> to <code>H_b_flow</code> and
<code>hVol_flow</code> to <code>H_vol_flow</code>
as they output enthalpy flow rate, and not specific enthalpy.
Made various models <code>protected</code>.
</li>
<li>
January 25, 2015, by Michael Wetter:<br/>
Added <code>final</code> to <code>tau = 0</code> in <code>EnthalpyFlowRate</code>.
These sensors do not need dynamics as the enthalpy flow rate
is used to compute a heat flow which is then added to the volume of the tank.
Thus, if there were high frequency oscillations of small mass flow rates,
then they have a small effect on <code>H_flow</code>, and they are
not used in any control loop. Rather, the oscillations are further damped
by the differential equation of the fluid volume.
</li>
<li>
January 25, 2015, by Filip Jorissen:<br/>
Set <code>tau = 0</code> in <code>EnthalpyFlowRate</code>
sensors for increased simulation speed.
</li>
<li>
August 29, 2014, by Michael Wetter:<br/>
Replaced the use of <code>Medium.lambda_const</code> with
<code>Medium.thermalConductivity(sta_default)</code> as
<code>lambda_const</code> is not declared for all media.
This avoids a translation error if certain media are used.
</li>
<li>
June 18, 2014, by Michael Wetter:<br/>
Changed the default value for the energy balance initialization to avoid
a dependency on the global <code>system</code> declaration.
</li>
<li>
July 29, 2011, by Michael Wetter:<br/>
Removed <code>use_T_start</code> and <code>h_start</code>.
</li>
<li>
February 18, 2011, by Michael Wetter:<br/>
Changed default start values for temperature and pressure.
</li>
<li>
October 25, 2009 by Michael Wetter:<br/>
Changed computation of heat transfer through top (and bottom) of tank. Now,
the thermal resistance of the fluid is not taken into account, i.e., the
top (and bottom) element is assumed to be mixed.
</li>
<li>
October 23, 2009 by Michael Wetter:<br/>
Fixed bug in computing heat conduction of top and bottom segment.
In the previous version,
for computing the heat conduction between the top (or bottom) segment and
the outside,
the whole thickness of the water volume was used
instead of only half the thickness.
</li>
<li>
February 19, 2009 by Michael Wetter:<br/>
Changed declaration that constrains the medium. The earlier
declaration caused the medium model to be not shown in the parameter
window.
</li>
<li>
October 31, 2008 by Michael Wetter:<br/>
Added heat conduction.
</li>
<li>
October 23, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Rectangle(
          extent={{-40,60},{40,20}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-20},{40,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,2},{-90,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,84},{-80,80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,84},{-80,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,0},{78,-86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,84},{-4,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,-84},{2,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-60},{2,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{92,2},{78,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{40,-20}},
          lineColor={255,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.CrossDiag),
        Text(
          extent={{100,106},{134,74}},
          lineColor={0,0,127},
          textString="QLoss"),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{50,68},{40,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,66},{-50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,68},{50,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,-60},{50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{26,72},{102,72},{100,72}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{56,6},{56,72},{58,72}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{22,-74},{70,-74},{70,72}},
          color={127,0,0},
          pattern=LinePattern.Dot)}));
end Stratified;
