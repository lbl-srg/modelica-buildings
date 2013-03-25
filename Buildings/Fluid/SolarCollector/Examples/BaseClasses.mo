within Buildings.Fluid.SolarCollector.Examples;
package BaseClasses
  extends Modelica.Icons.BasesPackage;
  model FlatPlateValidation "Model of a flat plate solar thermal collector"
    import Buildings;
    extends Buildings.Fluid.SolarCollector.BaseClasses.PartialSolarCollector;
      Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate.GenericGlazedFlatPlate
                                                                                 per
      "Performance data"  annotation (choicesAllMatching=true);
    parameter Modelica.SIunits.Temperature TIn_nominal
      "Inlet temperature at nominal condition";
    Buildings.Fluid.SolarCollector.BaseClasses.ASHRAESolarGain
      solHeaGai(
      B0=per.B0,
      B1=per.B1,
      shaCoe=shaCoe,
      til=til,
      nSeg=nSeg,
      y_intercept=per.y_intercept,
      A_c=per.A)
               annotation (Placement(transformation(extent={{12,60},{32,80}})));
  public
    Buildings.Fluid.SolarCollector.BaseClasses.EN12975HeatLoss heaLos(
      Cp=Cp,
      nSeg=nSeg,
      I_nominal=I_nominal,
      TEnv_nominal=TEnv_nominal,
      A_c=per.A,
      y_intercept=per.y_intercept,
      m_flow_nominal=rho*per.VperA_flow_nominal*per.A,
      C1=3.611111,
      C2=0.07,
      TMean_nominal=TIn_nominal)
          annotation (Placement(transformation(extent={{0,20},{20,40}})));

  equation
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
    connect(HDirTil.H, solHeaGai.HDirTil) annotation (Line(
        points={{-59,56},{-40,56},{-40,72},{10,72}},
        color={0,0,127},
        smooth=Smooth.None));

    connect(HDifTilIso.HGroDifTil, solHeaGai.HGroDifTil) annotation (Line(
        points={{-59,76},{-32,76},{-32,74.8},{10,74.8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDifTilIso.HSkyDifTil, solHeaGai.HSkyDifTil) annotation (Line(
        points={{-59,88},{-16,88},{-16,78},{10,78}},
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
    connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
        points={{21,30},{38,30}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}),
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
This component models the flat plate solar thermal collector. By default this model uses ASHRAE 93 ratings data and references the glazed flat plate data library.
</p>
<h4>Notice</h4>
<p>
1. As metioned in the reference, the SRCC incident angle modifier equation coefficients are only valid for incident angles of 60 degrees or less. 
Because these curves can be valid yet behave poorly for angles greater than 60 degrees the model cuts off collectors' gains of both direct and diffuse solar radiation for incident angles greater than 60 degrees. 
<br>
2. By default, the esitimated heat capacity of the collector without fluid is calculated based on the dry mass and the specific heat capacity of copper.
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
<br>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
</p>
</html>",   revisions="<html>
<ul>
<li>
January 4, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"));
  end FlatPlateValidation;
end BaseClasses;
