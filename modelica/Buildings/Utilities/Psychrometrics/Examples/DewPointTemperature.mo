within Buildings.Utilities.Psychrometrics.Examples;
model DewPointTemperature "Unit test for dew point temperature calculation"
  annotation(Commands(file="DewPointTemperature.mos" "run"), Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                                     graphics));
   package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  Buildings.Utilities.Psychrometrics.DewPointTemperature_pWat watVapPre 
    annotation (Placement(transformation(extent={{40,0},{60,20}},    rotation=0)));
  annotation (Diagram);
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.01 - 0.1),
    offset=0.1) "Humidity concentration" 
                 annotation (Placement(transformation(extent={{-80,0},{-60,20}},
                   rotation=0)));
  VaporPressure_X humRat(use_p_in=false) 
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  VaporPressure_TDP TDewPoi 
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(XHum.y, humRat.XWat) annotation (Line(
      points={{-59,10},{-41,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(humRat.p_w, TDewPoi.p_w) annotation (Line(
      points={{-19,10},{-1,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TDewPoi.T, watVapPre.T) annotation (Line(
      points={{21,10},{39,10}},
      color={0,0,127},
      smooth=Smooth.None));
end DewPointTemperature;
