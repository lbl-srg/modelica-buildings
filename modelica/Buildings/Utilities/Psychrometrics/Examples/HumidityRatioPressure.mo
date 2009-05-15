within Buildings.Utilities.Psychrometrics.Examples;
model HumidityRatioPressure "Unit test for humidity ratio model"
 annotation(Commands(file="HumidityRatioPressure.mos" "run"), Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                                      graphics));
 package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  VaporPressure_X vapPre(use_p_in=true) "Model for humidity ratio" 
                          annotation (Placement(transformation(extent={{-20,0},
            {0,20}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.0133 - 0.2),
    offset=0.2) "Humidity concentration" 
                 annotation (Placement(transformation(extent={{-80,-20},{-60,0}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure" 
                                    annotation (Placement(transformation(extent={{-80,20},
            {-60,40}},          rotation=0)));
  annotation (Diagram);
  HumidityRatio_pWat humRat(use_p_in=true) 
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Diagnostics.AssertEquality assertEquality(threShold=1E-5)
    "Checks that model and its inverse implementation are correct" 
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
equation
  connect(XHum.y,vapPre. XWat) annotation (Line(points={{-59,-10},{-40,-10},{
          -40,10},{-21,10}},
                           color={0,0,127}));
  connect(vapPre.p_w, humRat.p_w) annotation (Line(
      points={{1,10},{19,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(humRat.XWat, assertEquality.u1) annotation (Line(
      points={{41,10},{50,10},{50,-24},{58,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XHum.y, assertEquality.u2) annotation (Line(
      points={{-59,-10},{30,-10},{30,-36},{58,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, humRat.p_in) annotation (Line(
      points={{-59,30},{10,30},{10,16},{19,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, vapPre.p_in) annotation (Line(
      points={{-59,30},{-40,30},{-40,16},{-21,16}},
      color={0,0,127},
      smooth=Smooth.None));
end HumidityRatioPressure;
