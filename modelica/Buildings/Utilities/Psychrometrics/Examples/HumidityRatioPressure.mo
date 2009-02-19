within Buildings.Utilities.Psychrometrics.Examples;
model HumidityRatioPressure "Unit test for humidity ratio model"
 annotation(Commands(file="HumidityRatioPressure.mos" "run"), Diagram(graphics));
 package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  Buildings.Utilities.Psychrometrics.HumidityRatioPressure humRat
    "Model for humidity ratio" 
                          annotation (Placement(transformation(extent={{0,20},{
            20,40}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.0133 - 0.2),
    offset=0.2) "Humidity concentration" 
                 annotation (Placement(transformation(extent={{-60,-20},{-40,0}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure" 
                                    annotation (Placement(transformation(extent=
           {{-60,20},{-40,40}}, rotation=0)));
  annotation (Diagram);
equation
  connect(p.y, humRat.p) annotation (Line(points={{-39,30},{1,30}}, color={0,0,
          127}));
  connect(XHum.y, humRat.XWat) annotation (Line(points={{-39,-10},{-20,-10},{
          -20,23},{1,23}}, color={0,0,127}));
end HumidityRatioPressure;
