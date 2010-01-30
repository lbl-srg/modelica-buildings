within Buildings.Utilities.Psychrometrics.Examples;
model HumidityRatioPressure "Unit test for humidity ratio model"
 annotation(Commands(file="HumidityRatioPressure.mos" "run"), Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                                      graphics));
 package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  VaporPressure_X vapPre(use_p_in=true) "Model for humidity ratio" 
                          annotation (Placement(transformation(extent={{0,0},{
            20,20}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp XHumDryAir(
    duration=1,
    height=(0.0133 - 0.2),
    offset=0.2) "Humidity concentration in [kg/kg dry air]" 
                 annotation (Placement(transformation(extent={{-80,-20},{-60,0}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure" 
                                    annotation (Placement(transformation(extent={{-80,20},
            {-60,40}},          rotation=0)));
  annotation (Diagram);
  HumidityRatio_pWat humRat(use_p_in=true) 
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Diagnostics.AssertEquality assertEquality(threShold=1E-5)
    "Checks that model and its inverse implementation are correct" 
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  ToTotalAir toTotalAir 
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  connect(vapPre.p_w, humRat.p_w) annotation (Line(
      points={{21,10},{39,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(humRat.XWat, assertEquality.u1) annotation (Line(
      points={{61,10},{70,10},{70,-24},{78,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, humRat.p_in) annotation (Line(
      points={{-59,30},{30,30},{30,16},{39,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, vapPre.p_in) annotation (Line(
      points={{-59,30},{-20,30},{-20,16},{-1,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XHumDryAir.y, toTotalAir.XiDry) annotation (Line(
      points={{-59,-10},{-41,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toTotalAir.XiTotalAir, vapPre.XWat) annotation (Line(
      points={{-19,-10},{-12,-10},{-12,10},{-1,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toTotalAir.XiTotalAir, assertEquality.u2) annotation (Line(
      points={{-19,-10},{24,-10},{24,-36},{78,-36}},
      color={0,0,127},
      smooth=Smooth.None));
end HumidityRatioPressure;
