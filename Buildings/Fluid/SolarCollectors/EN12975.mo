within Buildings.Fluid.SolarCollectors;
model EN12975 "Model of a concentrating solar collector"
extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(final perPar=per);
  parameter
    Buildings.Fluid.SolarCollectors.Data.GenericEN12975 per
    "Performance data" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{60,-80},{80,-60}})));

  BaseClasses.EN12975SolarGain solGai(
    redeclare package Medium = Medium,
    final A_c=TotalArea_internal,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final B0=per.B0,
    final B1=per.B1,
    final shaCoe=shaCoe,
    final iamDiff=per.IAMDiff,
    final use_shaCoe_in=use_shaCoe_in)
    "Identifies heat gained from the sun using standard EN12975 calculations"
     annotation (Placement(transformation(extent={{-20,38},{0,58}})));
  BaseClasses.EN12975HeatLoss heaLos(
    redeclare package Medium = Medium,
    final A_c=TotalArea_internal,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final C1=per.C1,
    final C2=per.C2,
    final G_nominal=per.G_nominal,
    final dT_nominal=per.dT_nominal,
    final m_flow_nominal=per.mperA_flow_nominal*per.A*nPanels_internal,
    final cp_default=cp_default)
    "Calculates the heat lost to the surroundings using the EN12975 standard calculations"
      annotation (Placement(transformation(extent={{-20,6},{0,26}})));

equation
  // Make sure the model is only used with the EN ratings data, and hence C1 > 0
  assert(per.C1 > 0,
    "The heat loss coefficient from the EN 12975 ratings data must be strictly positive. Obtained C1 = " + String(per.C1));
  connect(shaCoe_internal, solGai.shaCoe_in);

  connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
      points={{-99.95,96.05},{-88,96.05},{-88,22},{-22,22}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTil.inc, solGai.incAng)    annotation (Line(
      points={{-59,48},{-22,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.H, solGai.HSkyDifTil) annotation (Line(
      points={{-59,80},{-50,80},{-50,56},{-22,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solGai.HDirTil) annotation (Line(
      points={{-59,52},{-22,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe_in, solGai.shaCoe_in) annotation (Line(
      points={{-120,26},{-50,26},{-50,44},{-22,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.TFlu, temSen.T) annotation (Line(
      points={{-22,10},{-28,10},{-28,-16},{-9,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
      points={{1,16},{50,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solGai.QSol_flow, heaGai.Q_flow) annotation (Line(
      points={{1,48},{50,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, solGai.TFlu) annotation (Line(
      points={{-9,-16},{-28,-16},{-28,40},{-22,40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="solCol",
  Documentation(info="<html>
<p>
This component models a solar thermal collector according
to the EN12975 test standard.
</p>
<h4>Notice</h4>
<ul>
<li>
By default, the estimated heat capacity of the collector without
fluid is calculated based on the dry mass and the specific heat
capacity of copper.
</li>
</ul>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.<br/>
</p>
</html>", revisions="<html>
<ul>
<li>
December 11, 2023, by Michael Wetter:<br/>
Corrected implementation of pressure drop calculation for the situation where the collectors are in parallel,
e.g., if <code>sysConfig == Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel</code>.<br/>
Changed assignment of <code>computeFlowResistance</code> to <code>final</code> based on
<code>dp_nominal</code>.<br/>
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
January 4, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
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
          rotation=90)}));
end EN12975;
