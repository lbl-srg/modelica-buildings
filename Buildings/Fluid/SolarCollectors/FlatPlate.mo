within Buildings.Fluid.SolarCollectors;
model FlatPlate "Model of a flat plate solar thermal collector"
  extends SolarCollectors.BaseClasses.PartialSolarCollector(final perPar=per);
  parameter SolarCollectors.Data.GenericSolarCollector per
    annotation(choicesAllMatching=true);
  parameter Modelica.SIunits.Temperature TIn_nominal
    "Inlet temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean use_shaCoe_in = false
    "Enables an input connector for shaCoe"
    annotation(Dialog(group="Shading"));
  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "Shading coefficient. 0.0: no shading, 1.0: full shading"
    annotation(Dialog(enable = not use_shaCoe_in, group = "Shading"));
  BaseClasses.ASHRAESolarGain                 solHeaGai(
    final B0=per.B0,
    final B1=per.B1,
    final shaCoe=shaCoe,
    final til=til,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final A_c=per.A,
    use_shaCoe_in=use_shaCoe_in)
             annotation (Placement(transformation(extent={{0,60},{20,80}})));

  SolarCollectors.BaseClasses.ASHRAEHeatLoss heaLos(
    final nSeg=nSeg,
    final G_nominal=G_nominal,
    final TEnv_nominal=TEnv_nominal,
    final A_c=per.A,
    final TIn_nominal=TIn_nominal,
    final slope=per.slope,
    final y_intercept=per.y_intercept,
    m_flow_nominal=per.mperA_flow_nominal*per.A,
    redeclare package Medium = Medium)
    "Calculates the heat lost to the surroundings using the ASHRAE93 standard calculations"
        annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Shading coefficient"
  annotation(Placement(transformation(extent={{-140,60},{-100,20}},   rotation=0)));

protected
  Modelica.Blocks.Interfaces.RealInput shaCoe_internal
    "Internally used shading coefficient";

equation
  connect(shaCoe_internal,shaCoe_in);
  connect(shaCoe_internal,solHeaGai.shaCoe_in);

  if not use_shaCoe_in then
    shaCoe_internal=shaCoe;
  end if;

  connect(temSen.T, heaLos.TFlu) annotation (Line(
      points={{-4,-16},{-16,-16},{-16,24},{-2,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
      points={{-100,78},{-88,78},{-88,36},{-2,36}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTil.inc, solHeaGai.incAng) annotation (Line(
      points={{-59,52},{-32,52},{-32,66},{-2,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solHeaGai.HDirTil) annotation (Line(
      points={{-59,56},{-40,56},{-40,72},{-2,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HSkyDifTil, solHeaGai.HSkyDifTil) annotation (Line(
      points={{-59,88},{-18,88},{-18,78},{-2,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HGroDifTil, solHeaGai.HGroDifTil) annotation (Line(
      points={{-59,76},{-32,76},{-32,74.8},{-2,74.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
      points={{21,30},{38,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHeaGai.QSol_flow, heaGai.Q_flow) annotation (Line(
      points={{21,70},{38,70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    Icon(graphics={
        Rectangle(
          extent={{-86,100},{88,-100}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,80},{10,-100}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,80},{50,-100}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,80},{-28,-100}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,100},{60,80}},
          lineColor={215,215,215},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,28},{28,-24}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-48,2},{-28,2}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{34,2},{54,2}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-8,-8},{6,6}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={30,34},
          rotation=180),
        Line(
          points={{-34,-38},{-18,-22}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-8,-8},{6,6}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={32,-28},
          rotation=90),
        Line(
          points={{-6,-6},{8,8}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={-22,32},
          rotation=90),
        Line(
          points={{-10,0},{10,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={4,-38},
          rotation=90),
        Line(
          points={{-10,0},{10,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=1,
          origin={2,42},
          rotation=90)}),
    defaultComponentName="solCol",
    Documentation(info="<html>
<h4>Overview</h4>
<p>
This component models the flat plate solar thermal collector. 
By default this model uses ASHRAE 93 ratings data.
Peformance data can be imported from the data library
<a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate\"> 
Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate</a>.
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
 <a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011. <br/>
 </p>
 </html>", revisions="<html>
<ul>
<li>
January 4, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlatPlate;
