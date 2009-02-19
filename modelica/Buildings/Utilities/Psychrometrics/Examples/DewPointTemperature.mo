within Buildings.Utilities.Psychrometrics.Examples;
model DewPointTemperature "Unit test for dew point temperature calculation"
  annotation(Commands(file="DewPointTemperature.mos" "run"), Diagram(graphics));
   package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  Buildings.Utilities.Psychrometrics.DewPointTemperature TDewPoi 
    annotation (Placement(transformation(extent={{-60,40},{-40,60}}, rotation=0)));
  Buildings.Utilities.Psychrometrics.HumidityRatioPressure humRat 
    annotation (Placement(transformation(extent={{-20,0},{0,20}}, rotation=0)));
  annotation (Diagram);
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.01 - 0.1),
    offset=0.1) "Humidity concentration" 
                 annotation (Placement(transformation(extent={{-80,-40},{-60,
            -20}}, rotation=0)));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure" 
                                    annotation (Placement(transformation(extent=
           {{-80,0},{-60,20}}, rotation=0)));
equation
  connect(humRat.p_w, TDewPoi.p_w) annotation (Line(points={{-19,17},{-32,17},{
          -32,50},{-39,50}}, color={0,0,0}));
  connect(p.y, humRat.p) annotation (Line(points={{-59,10},{-19,10}}, color={0,
          0,127}));
  connect(XHum.y, humRat.XWat) annotation (Line(points={{-59,-30},{-40,-30},{
          -40,3},{-19,3}}, color={0,0,127}));
end DewPointTemperature;
