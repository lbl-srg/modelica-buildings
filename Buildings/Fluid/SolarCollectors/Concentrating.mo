within Buildings.Fluid.SolarCollectors;
model Concentrating "Model of a concentrating solar collector"
extends SolarCollectors.BaseClasses.PartialSolarCollector(perPar=per);
    parameter SolarCollectors.Data.Concentrating.Generic per "Performance data"
                        annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.Temperature TMean_nominal
    "Inlet temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
  BaseClasses.EN12975SolarGain solHeaGaiNom(
    A_c=per.A,
    nSeg=nSeg,
    y_intercept=per.y_intercept,
    B0=per.B0,
    B1=per.B1,
    shaCoe=shaCoe,
    til=til,
    iamDiff=per.IAMDiff)
    "Calculates the heat gained from the sun using the EN12975 standard calculations"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  BaseClasses.EN12975HeatLoss heaLos(
    A_c=per.A,
    nSeg=nSeg,
    y_intercept=per.y_intercept,
    C1=per.C1,
    C2=per.C2,
    I_nominal=I_nominal,
    TMean_nominal=TMean_nominal,
    TEnv_nominal=TEnv_nominal,
    Cp=Cp,
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
      points={{-59,52},{-50,52},{-50,66},{-2,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, solHeaGaiNom.HDirTil) annotation (Line(
      points={{-59,56},{-54,56},{-54,72},{-2,72}},
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
 This component models a concentrating solar thermal collector. The concentrating model uses ratings data based on EN12975 and by default references the <a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.Concentrating\"> 
 Buildingds.Fluid.SolarCollectors.Data.Concentrating</a> data library.
 </p>
 <h4>Notice</h4>
 <p>
 1. As mentioned in EnergyPlus 7.0.0 Engineering Reference, the SRCC incident angle modifier equation coefficients are only valid for incident angles of 60 degrees or less. 
 Because these curves can be valid yet behave poorly for angles greater than 60 degrees, the model cuts off collectors' gains of both direct and diffuse solar radiation for incident angles greater than 60 degrees. 
 <br>
 2. By default, the estimated heat capacity of the collector without fluid is calculated based on the dry mass and the specific heat capacity of copper.
 </p>
 <h4>References</h4>
 <p>
 <a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
 <br>
 J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
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
