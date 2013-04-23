within Buildings.Fluid.SolarCollectors;
model Concentrating "Model of a concentrating solar collector"
extends SolarCollectors.BaseClasses.PartialSolarCollector(final perPar=per);
    parameter SolarCollectors.Data.Concentrating.Generic per "Performance data"
                        annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.Temperature TMean_nominal
    "Inlet temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
  BaseClasses.EN12975SolarGain solHeaGaiNom(
    final A_c=per.A,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final B0=per.B0,
    final B1=per.B1,
    final shaCoe=shaCoe,
    final til=til,
    final iamDiff=per.IAMDiff)
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  BaseClasses.EN12975HeatLoss heaLos(
    final A_c=per.A,
    final nSeg=nSeg,
    final y_intercept=per.y_intercept,
    final C1=per.C1,
    final C2=per.C2,
    final I_nominal=I_nominal,
    final TMean_nominal=TMean_nominal,
    final TEnv_nominal=TEnv_nominal,
    final Cp=Cp,
    m_flow_nominal=rho*per.VperA_flow_nominal*per.A)
    "Calculates the heat lost to the surroundings using the EN12975 standard calculations"
           annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Math.Add add
    "Combines HSkyDifTil and HGroDifTil to be a single HDif value"
    annotation (Placement(transformation(extent={{-42,74},{-34,82}})));
equation
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
  connect(HDirTil.inc, solHeaGaiNom.incAng) annotation (Line(
      points={{-59,52},{-50,52},{-50,67.4},{-2,67.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solHeaGaiNom.HDirTil) annotation (Line(
      points={{-59,56},{-54,56},{-54,72.6},{-2,72.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, solHeaGaiNom.HSkyDifTil) annotation (Line(
      points={{-33.6,78},{-2,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HGroDifTil, add.u2) annotation (Line(
      points={{-59,76},{-54,76},{-54,75.6},{-42.8,75.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.HSkyDifTil, add.u1) annotation (Line(
      points={{-59,88},{-54,88},{-54,80.4},{-42.8,80.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHeaGaiNom.QSol_flow, heaGai.Q_flow) annotation (Line(
      points={{21,70},{38,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
      points={{21,30},{38,30}},
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
 the model does not calculatue either direct or diffuse solar radiation gains
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
 </html>"));
end Concentrating;
