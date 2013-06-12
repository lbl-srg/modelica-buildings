within Buildings.Fluid.SolarCollectors.Examples.BaseClasses;
model FlatPlateValidation "Model of a flat plate solar thermal collector"
  import Buildings;
  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(perPar=per);
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per
    "Performance data"  annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Temperature TIn_nominal
    "Inlet temperature at nominal condition";
  parameter Boolean use_shaCoe_in = false
    "Enables an input connector for shaCoe"
    annotation(Dialog(group="Shading"));
  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "Shading coefficient. 0.0: no shading, 1.0: full shading"
    annotation(Dialog(enable = not use_shaCoe_in, group = "Shading"));

  Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain
    solHeaGai(
    B0=per.B0,
    B1=per.B1,
    shaCoe=shaCoe,
    til=til,
    nSeg=nSeg,
    y_intercept=per.y_intercept,
    A_c=per.A,
    use_shaCoe_in=use_shaCoe_in)
    "Solar gain model calculated using standard ASHRAE calculations"
             annotation (Placement(transformation(extent={{12,60},{32,80}})));

  Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss  heaLos(
    nSeg=nSeg,
    A_c=per.A,
    y_intercept=per.y_intercept,
    m_flow_nominal=per.mperA_flow_nominal*per.A,
    redeclare package Medium = Medium,
    dT_nominal=per.dT_nominal,
    G_nominal=per.G_nominal,
    slope=per.slope)
    "Heat loss model calculated using standard ASHRAE calculations"
        annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Shading coefficient"
  annotation(Placement(transformation(extent={{-140,60},{-100,20}},   rotation=0)));

protected
  Modelica.Blocks.Interfaces.RealInput shaCoe_internal
    "Internally used shading coefficient";

equation
  connect(shaCoe_internal,solHeaGai.shaCoe_in);

  connect(solHeaGai.QSol_flow, heaGai.Q_flow) annotation (Line(
      points={{33,70},{38,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, heaLos.TFlu) annotation (Line(
      points={{-4,-16},{-16,-16},{-16,24},{-2,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.inc, solHeaGai.incAng) annotation (Line(
      points={{-59,52},{-32,52},{-32,66},{10,66}},
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
  connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
      points={{21,30},{38,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HSkyDifTil, solHeaGai.HSkyDifTil) annotation (Line(
      points={{-59,88},{-30,88},{-30,78},{10,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HGroDifTil, solHeaGai.HGroDifTil) annotation (Line(
      points={{-59,76},{-40,76},{-40,74.8},{10,74.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solHeaGai.HDirTil) annotation (Line(
      points={{-59,56},{-40,56},{-40,72},{10,72}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
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
    defaultComponentName="solColVal",
    Documentation(info="<html>
<p>
This component models the flat plate solar thermal collector. 
This model uses ASHRAE 93 ratings data and references 
<a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.TRNSYSValidation\">
Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.TRNSYSValidation</a>.
</p>
<h4>Notice</h4>
<p>
<ul>
<li>
As mentioned in the reference, the SRCC incident angle modifier equation coefficients 
are only valid for incident angles of 60 degrees or less. 
 Because these curves behave poorly for angles greater than 60 degrees 
 the model does not calculate either direct or diffuse solar radiation gains
 when the incidence angle is greater than 60 degrees.   
</li>
<li>
By default, the estimated heat capacity of the collector without fluid is calculated 
based on the dry mass and the specific heat capacity of copper.
</li>
</ul>
</p>
<h4>References</h4>
<p>
<ul>
<li>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 4, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlatPlateValidation;
