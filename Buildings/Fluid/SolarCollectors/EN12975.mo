within Buildings.Fluid.SolarCollectors;
model EN12975 "Model of a solar thermal collector according to the ASHRAE Standard 93"
  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(
    redeclare Buildings.Fluid.SolarCollectors.Data.GenericEN12975 per);

  Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain solGai(
    redeclare package Medium = Medium,
    final nSeg=nSeg,
    final incAngDat=per.incAngDat,
    final incAngModDat=per.incAngModDat,
    final iamDiff=per.IAMDiff,
    final eta0=per.eta0,
    final use_shaCoe_in=use_shaCoe_in,
    final shaCoe=shaCoe,
    final A_c=ATot_internal)
    "Identifies heat gained from the sun using the EN12975 standard calculations"
     annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss heaLos(
    redeclare package Medium = Medium,
    final nSeg=nSeg,
    final a1=per.a1,
    final a2=per.a2,
    final A_c=ATot_internal)
    "Calculates the heat lost to the surroundings using the EN12975 standard calculations"
      annotation (Placement(transformation(extent={{-20,10},{0,30}})));

equation
  // Make sure the model is only used with the EN ratings data, and hence a1 > 0
  assert(per.a1 > 0,
    "In " + getInstanceName() + ": The heat loss coefficient from the EN 12975 ratings data must be strictly positive. Obtained a1 = " + String(per.a1));
  connect(shaCoe_internal, solGai.shaCoe_in);

  connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
      points={{-99.95,80.05},{-90,80.05},{-90,26},{-22,26}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTil.inc, solGai.incAng)    annotation (Line(
      points={{-59,46},{-50,46},{-50,48},{-22,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.H, solGai.HSkyDifTil) annotation (Line(
      points={{-59,80},{-30,80},{-30,58},{-22,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solGai.HDirTil) annotation (Line(
      points={{-59,50},{-50,50},{-50,52},{-22,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe_in, solGai.shaCoe_in) annotation (Line(
      points={{-120,40},{-40,40},{-40,45},{-22,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.TFlu, temSen.T) annotation (Line(
      points={{-22,14},{-30,14},{-30,-20},{-11,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.QLos_flow, QLos.Q_flow) annotation (Line(
      points={{1,20},{50,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solGai.QSol_flow, QGai.Q_flow) annotation (Line(
      points={{1,50},{50,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, solGai.TFlu) annotation (Line(
      points={{-11,-20},{-30,-20},{-30,42},{-22,42}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="solCol",
  Documentation(info="<html>
<p>
This component models a solar thermal collector according to the EN12975
test standard.
</p>

<h4>References</h4>
<p>
CEN 2022, European Standard 12975:2022, European Committee for Standardization
</p>
<p>
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v23.2.0/EngineeringReference.pdf\">
EnergyPlus 23.2.0 Engineering Reference</a>
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 28, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
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
