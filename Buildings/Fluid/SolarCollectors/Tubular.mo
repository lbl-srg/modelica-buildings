within Buildings.Fluid.SolarCollectors;
model Tubular "Model of a tubular solar collector"
  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(final perPar=per);
    parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per
    "Performance data"  annotation (choicesAllMatching=true);

  BaseClasses.ASHRAESolarGain solGai(
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final B0=per.B0,
    final B1=per.B1,
    final shaCoe=shaCoe,
    final A_c=TotalArea_internal,
    final til=til,
    use_shaCoe_in=use_shaCoe_in)
    "Identifies heat gained from the sun using standard ASHRAE93 calculations"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  BaseClasses.ASHRAEHeatLoss heaLos(
    final A_c=TotalArea_internal,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final slope=per.slope,
    redeclare package Medium = Medium,
    final G_nominal=per.G_nominal,
    dT_nominal=per.dT_nominal,
    m_flow_nominal=per.mperA_flow_nominal*per.A)
    "Calculates the heat lost to the surroundings using the standard ASHRAE calculations"
    annotation (Placement(transformation(extent={{-12,20},{8,40}})));

equation
  connect(shaCoe_internal, solGai.shaCoe_in);

  connect(temSen.T, heaLos.TFlu) annotation (Line(
      points={{-4,-16},{-20,-16},{-20,24},{-14,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
      points={{-100,96},{-88,96},{-88,36},{-14,36}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTil.inc, solGai.incAng)    annotation (Line(
      points={{-59,52},{-50,52},{-50,66},{-12,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solGai.HDirTil)    annotation (Line(
      points={{-59,56},{-52,56},{-52,72},{-12,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
      points={{9,30},{38,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solGai.QSol_flow, heaGai.Q_flow)    annotation (Line(
      points={{11,70},{38,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HGroDifTil, solGai.HGroDifTil) annotation (Line(
      points={{-59,76},{-52,76},{-52,74.8},{-12,74.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HSkyDifTil, solGai.HSkyDifTil) annotation (Line(
      points={{-59,88},{-50,88},{-50,78},{-12,78}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
       defaultComponentName="solCol",
     Documentation(info="<html>
 <h4>Overview</h4>
 <p>
 This component models the tubular solar thermal collector. 
 By default this model uses ASHRAE 93 ratings data.
 Peformance data can be imported from the data library
 <a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.Tubular\"> 
 Buildings.Fluid.SolarCollectors.Data.Tubular</a>.
 </p>
 <h4>Notice</h4>
 <ul>
 <li>
 As mentioned in EnergyPlus 7.0.0 Engineering Reference, the SRCC incident angle modifier 
 equation coefficients are only valid for incident angles of 60 degrees or less. 
 Because these curves behave poorly for angles greater than 60 degrees 
 the model does not calculate either direct or diffuse solar radiation gains
 when the incidence angle is greater than 60 degrees.  
 </li>
 <li>
 By default, the estimated heat capacity of the collector without fluid is calculated based 
 on the dry mass and the specific heat capacity of copper.
 </li>
 </ul>
 <h4>References</h4>
 <p>
 <a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.<br/>
 </p>
 </html>", revisions="<html>
 <ul>
 <li>
 January 4, 2013, by Peter Grant:<br/>
 First implementation.
 </li>
 </ul>
 </html>"),
    Icon(graphics={
        Rectangle(
          extent={{-86,100},{88,-100}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,80},{-32,-100}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,80},{6,-100}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,80},{46,-100}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,100},{56,80}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-30,24},{22,-28}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-56,-2},{-36,-2}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-6,-6},{8,8}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-30,28},
          rotation=90),
        Line(
          points={{-10,0},{10,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-6,38},
          rotation=90),
        Line(
          points={{-8,-8},{6,6}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={22,30},
          rotation=180),
        Line(
          points={{26,-2},{46,-2}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-8,-8},{6,6}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={24,-32},
          rotation=90),
        Line(
          points={{-10,0},{10,0}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-4,-42},
          rotation=90),
        Line(
          points={{-42,-42},{-26,-26}},
          color={255,255,0},
          smooth=Smooth.None,
          thickness=1)}));
end Tubular;
