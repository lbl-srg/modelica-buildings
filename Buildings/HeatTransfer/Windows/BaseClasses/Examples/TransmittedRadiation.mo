within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model TransmittedRadiation
  "Test model for transmitted radiation through window"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Angle azi=0 "Surface azimuth";
  parameter Modelica.Units.SI.Angle til=1.5707963267949 "Surface tilt";

  parameter Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    UFra=2,
    haveExteriorShade=false,
    haveInteriorShade=true) "Parameters for glazing system"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    til=til,
    azi=azi) "Direct irradiation on the tilted surface"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-38,0},{-18,20}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));

  BoundaryConditions.SolarIrradiation.DiffuseIsotropic HDifTilIso(
     til=til) "Diffuse isotropic irradiation"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Sources.Constant shaCon(k=if (glaSys.haveShade) then 0.5 else
              0)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.HeatTransfer.Windows.BaseClasses.TransmittedRadiation winTra(
    AWin=1,
    N=size(glaSys.glass, 1),
    tauGlaSol=glaSys.glass.tauSol,
    rhoGlaSol_a=glaSys.glass.rhoSol_a,
    rhoGlaSol_b=glaSys.glass.rhoSol_b,
    xGla=glaSys.glass.x,
    tauShaSol_a=glaSys.shade.tauSol_a,
    tauShaSol_b=glaSys.shade.tauSol_b,
    rhoShaSol_a=glaSys.shade.rhoSol_a,
    rhoShaSol_b=glaSys.shade.rhoSol_b,
    haveExteriorShade=glaSys.haveExteriorShade,
    haveInteriorShade=glaSys.haveInteriorShade)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-50,10},{-28,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(HDirTil.weaBus, weaBus) annotation (Line(
      points={{20,10},{-28,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus, HDifTilIso.weaBus) annotation (Line(
      points={{-28,10},{6,10},{6,50},{20,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(shaCon.y,winTra. uSha) annotation (Line(
      points={{81,-30},{90,-30},{90,-10},{69.8,-10},{69.8,-1.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(winTra.HDir, HDirTil.H) annotation (Line(
      points={{58.5,14},{46,14},{46,10},{41,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTilIso.H,winTra. HDif) annotation (Line(
      points={{41,50},{48,50},{48,18},{58.5,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.inc,winTra. incAng) annotation (Line(
      points={{41,6},{46,6},{46,9},{58.5,9}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=864000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/TransmittedRadiation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example illustrates modeling of window transmittance.
</html>", revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model to avoid a translation error
in OpenModelica.
</li>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
<li>
December 12, 2011, by Wangda Zuo:<br/>
Add glass thickness as a parameter for winTra. It is needed by the claculation of property for uncoated glass.
</li>
<li>
December 15, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end TransmittedRadiation;
