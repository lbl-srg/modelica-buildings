within Buildings.Fluid.SolarCollectors;
model ASHRAE93 "Model of a flat plate solar thermal collector"
  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(final perPar=per);
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per
    "Performance data" annotation(choicesAllMatching=true,
    Placement(transformation(extent={{60,-80},{80,-60}})));

  BaseClasses.ASHRAESolarGain solGai(
    final B0=per.B0,
    final B1=per.B1,
    final shaCoe=shaCoe,
    final til=til,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final use_shaCoe_in=use_shaCoe_in,
    final A_c=TotalArea_internal,
    redeclare package Medium = Medium)
    "Identifies heat gained from the sun using standard ASHRAE93 calculations"
             annotation (Placement(transformation(extent={{-20,38},{0,58}})));

  BaseClasses.ASHRAEHeatLoss heaLos(
    final nSeg=nSeg,
    final slope=per.slope,
    final y_intercept=per.y_intercept,
    redeclare package Medium = Medium,
    final G_nominal=per.G_nominal,
    dT_nominal=per.dT_nominal,
    final A_c=TotalArea_internal,
    m_flow_nominal=per.mperA_flow_nominal*per.A*nPanels_internal,
    final cp_default=cp_default)
    "Calculates the heat lost to the surroundings using the ASHRAE93 standard calculations"
        annotation (Placement(transformation(extent={{-20,6},{0,26}})));

equation
  // Make sure the model is only used with the ASHRAE ratings data, and slope < 0
  assert(per.slope < 0,
    "The heat loss coefficient from the ASHRAE ratings data must be strictly negative. Obtained slope = " + String(per.slope));

  connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
      points={{-100,96},{-88,96},{-88,22},{-22,22}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTil.inc, solGai.incAng)    annotation (Line(
      points={{-59,48},{-54,48},{-54,46},{-22,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solGai.HDirTil)    annotation (Line(
      points={{-59,52},{-52,52},{-52,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HGroDifTil, solGai.HGroDifTil) annotation (Line(
      points={{-59,74},{-50,74},{-50,52.8},{-22,52.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HSkyDifTil, solGai.HSkyDifTil) annotation (Line(
      points={{-59,86},{-48,86},{-48,56},{-22,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe_in, solGai.shaCoe_in) annotation (Line(
      points={{-120,26},{-54,26},{-54,43},{-22,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solGai.QSol_flow, heaGai.Q_flow) annotation (Line(
      points={{1,48},{50,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, heaLos.TFlu) annotation (Line(
      points={{-8,-16},{-32,-16},{-32,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, solGai.TFlu) annotation (Line(
      points={{-8,-16},{-32,-16},{-32,40},{-22,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
      points={{1,16},{50,16}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics={
        Rectangle(
          extent={{-84,100},{84,-100}},
          lineColor={27,0,55},
          fillColor={26,0,55},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-76,0},{-76,-90},{66,-90},{66,-60},{-64,-60},{-64,
              -30},{66,-30},{66,0},{-64,0},{-64,28},{66,28},{66,60},{-64,60},{
              -64,86},{78,86},{78,0},{98,0},{100,0}},
          color={0,128,255},
          thickness=1,
          smooth=Smooth.None),
        Ellipse(
          extent={{-24,26},{28,-26}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-6,-6},{8,8}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-24,30},
          rotation=90),
        Line(
          points={{-50,0},{-30,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-36,-40},{-20,-24}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-10,0},{10,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={2,-40},
          rotation=90),
        Line(
          points={{-8,-8},{6,6}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={30,-30},
          rotation=90),
        Line(
          points={{32,0},{52,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-8,-8},{6,6}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={28,32},
          rotation=180),
        Line(
          points={{-10,0},{10,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={0,40},
          rotation=90)}),
  defaultComponentName="solCol",
  Documentation(info="<html>
<p>
This component models a solar thermal collector according to the ASHRAE93
test standard.
</p>
<h4>Notice</h4>
<ul>
<li>
As mentioned in EnergyPlus 7.0.0 Engineering Reference, the SRCC
incident angle modifier equation coefficients are only valid for
incident angles of 60 degrees or less. Because these curves behave
poorly for angles greater than 60 degrees the model does not
calculate either direct or diffuse solar radiation gains when the
incidence angle is greater than 60 degrees.
</li>
<li>
By default, the estimated heat capacity of the collector without
fluid is calculated based on the dry mass and the specific heat
capacity of copper.
</li>
</ul>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011. <br/>
</p>
</html>", revisions="<html>
<ul>
<li>
December 11, 2023, by Michael Wetter:<br/>
Corrected implementation of pressure drop calculation for the situation where the collectors are in parallel,
e.g., if <code>sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3597\">Buildings, #3597</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Changed <code>lat</code> from being a parameter to an input from weather bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
December 17, 2017, by Michael Wetter:<br/>
Revised computation of heat loss.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1100\">
issue 1100</a>.
</li>
<li>
November 21, 2017, by Michael Wetter:<br/>
Corrected error in heat loss calculations that did not scale correctly with <code>nPanels</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1073\">issue 1073</a>.
</li>
<li>
October 18, 2013, by Michael Wetter:<br/>
Removed duplicate connection.
</li>
<li>
January 4, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end ASHRAE93;
