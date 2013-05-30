within Buildings.Fluid.SolarCollectors;
model Concentrating "Model of a concentrating solar collector"
extends SolarCollectors.BaseClasses.PartialSolarCollector(final perPar=per);
    parameter SolarCollectors.Data.GenericSolarCollector per "Performance data"
                        annotation (choicesAllMatching=true);

  BaseClasses.EN12975SolarGain solHeaGai(
    final A_c=TotalArea_internal,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final B0=per.B0,
    final B1=per.B1,
    final shaCoe=shaCoe,
    final til=til,
    final iamDiff=per.IAMDiff,
    final use_shaCoe_in=use_shaCoe_in)
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  BaseClasses.EN12975HeatLoss heaLos(
    final A_c=TotalArea_internal,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final C1=per.C1,
    final C2=per.C2,
    redeclare package Medium = Medium,
    final G_nominal=per.G_nominal,
    final dT_nominal=per.dT_nominal,
    final m_flow_nominal=per.mperA_flow_nominal*TotalArea_internal)
    "Calculates the heat lost to the surroundings using the EN12975 standard calculations"
           annotation (Placement(transformation(extent={{0,20},{20,40}})));

equation
  connect(shaCoe_internal,solHeaGai.shaCoe_in);

  connect(temSen.T, heaLos.TFlu) annotation (Line(
      points={{-4,-16},{-16,-16},{-16,24},{-2,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
      points={{-100,96},{-88,96},{-88,36},{-2,36}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTil.inc, solHeaGai.incAng) annotation (Line(
      points={{-59,52},{-50,52},{-50,67.4},{-2,67.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solHeaGai.HDirTil) annotation (Line(
      points={{-59,56},{-54,56},{-54,72.6},{-2,72.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHeaGai.QSol_flow, heaGai.Q_flow) annotation (Line(
      points={{21,70},{38,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
      points={{21,30},{38,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.H, solHeaGai.HSkyDifTil) annotation (Line(
      points={{-59,82},{-50,82},{-50,78},{-2,78}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
      defaultComponentName="solCol",
     Documentation(info="<html>
 <h4>Overview</h4>
 <p>
 This component models a concentrating solar thermal collector. 
 The concentrating model uses ratings data based on EN12975.
 Peformance data can be imported from the data library
 <a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.Concentrating\"> 
 Buildings.Fluid.SolarCollectors.Data.Concentrating</a>.
 </p>
 <h4>Notice</h4>
 <p>
 <ul>
 <li>
 As mentioned in EnergyPlus 7.0.0 Engineering Reference, the SRCC incident angle modifier equation coefficients 
 are only valid for incident angles of 60 degrees or less. 
 Because these curves behave poorly for angles greater than 60 degrees 
 the model does not calculate either direct or diffuse solar radiation gains
 when the incidence angle is greater than 60 degrees. 
 </li>
 <li>
 By default, the estimated heat capacity of the collector without fluid is calculated based 
 on the dry mass and the specific heat capacity of copper.
 </li>
 </ul>
 </p>
 <h4>References</h4>
 <p>
 <a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.<br>
 </p>
 </html>", revisions="<html>
 <ul>
 <li>
 January 4, 2013, by Peter Grant:<br>
 First implementation.
 </li>
 </ul>
 </html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-50,50},{50,-50}},
          lineColor={27,0,55},
          fillColor={26,0,55},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,50},{-70,70},{-70,-72},{-50,-50},{-50,-50},{-50,50}},
          lineColor={0,0,0},
          lineThickness=1,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,50},{50,50},{70,70},{-70,70},{-70,70},{-50,50}},
          lineColor={0,0,0},
          lineThickness=1,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,-72},{70,-72},{50,-50},{-50,-50},{-50,-50},{-70,-72}},
          lineColor={0,0,0},
          lineThickness=1,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{70,-72},{70,70},{50,50},{50,-50},{50,-50},{70,-72}},
          lineColor={0,0,0},
          lineThickness=1,
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,26},{28,-26}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,0},{-30,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-6,-6},{8,8}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-24,30},
          rotation=90),
        Line(
          points={{-10,0},{10,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={0,40},
          rotation=90),
        Line(
          points={{-8,-8},{6,6}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={28,32},
          rotation=180),
        Line(
          points={{32,0},{52,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-8,-8},{6,6}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={30,-30},
          rotation=90),
        Line(
          points={{-10,0},{10,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={2,-40},
          rotation=90),
        Line(
          points={{-36,-40},{-20,-24}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1)}));
end Concentrating;
