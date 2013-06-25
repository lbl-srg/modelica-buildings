within Buildings.Fluid.SolarCollectors;
model Tubular "Model of a tubular solar collector"
  extends SolarCollectors.BaseClasses.PartialSolarCollector(final perPar=per);
    parameter SolarCollectors.Data.GenericSolarCollector per "Performance data"
                        annotation (choicesAllMatching=true);
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
  BaseClasses.ASHRAESolarGain solHeaGai(
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final B0=per.B0,
    final B1=per.B1,
    final shaCoe=shaCoe,
    final A_c=per.A,
    final til=til,
    use_shaCoe_in=use_shaCoe_in)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  BaseClasses.ASHRAEHeatLoss heaLos(
    final A_c=per.A,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final slope=per.slope,
    final G_nominal=G_nominal,
    final TIn_nominal=TIn_nominal,
    final TEnv_nominal=TEnv_nominal,
    m_flow_nominal=per.mperA_flow_nominal*per.A,
    redeclare package Medium = Medium)
    "Calculates the heat lost to the surroundings using the standard ASHRAE calculations"
    annotation (Placement(transformation(extent={{-12,20},{8,40}})));

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
      points={{-4,-16},{-20,-16},{-20,24},{-14,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
      points={{-100,78},{-88,78},{-88,36},{-14,36}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTil.inc, solHeaGai.incAng) annotation (Line(
      points={{-59,52},{-50,52},{-50,66},{-12,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solHeaGai.HDirTil) annotation (Line(
      points={{-59,56},{-52,56},{-52,72},{-12,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HGroDifTil, solHeaGai.HGroDifTil) annotation (Line(
      points={{-59,76},{-52,76},{-52,74.8},{-12,74.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HSkyDifTil, solHeaGai.HSkyDifTil) annotation (Line(
      points={{-59,88},{-52,88},{-52,78},{-12,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
      points={{9,30},{38,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHeaGai.QSol_flow, heaGai.Q_flow) annotation (Line(
      points={{11,70},{38,70}},
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
 </html>"));
end Tubular;
