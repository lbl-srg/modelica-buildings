within Buildings.Utilities.Psychrometrics.Examples;
model DewPointTemperature "Unit test for dew point temperature calculation"
  extends Modelica.Icons.Example;
   package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);
  Buildings.Utilities.Psychrometrics.pW_TDewPoi watVapPre
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.01 - 0.1),
    offset=0.1) "Humidity concentration"
                 annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Utilities.Psychrometrics.pW_X humRat(
                         use_p_in=false)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewPoi
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(XHum.y, humRat.X_w) annotation (Line(
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
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/DewPointTemperature.mos"
        "Simulate and plot"));
end DewPointTemperature;
