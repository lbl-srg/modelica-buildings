within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.Validation;
block SupplyAirTemperature
  "Validation model for supply air temperature setpoint subsequence"

  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature
    TSupAir(have_coolingCoil=true, have_heatingCoil=true)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature
    TSupAir1(have_coolingCoil=true, have_heatingCoil=false)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature
    TSupAir2(have_coolingCoil=false, have_heatingCoil=true)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  CDL.Continuous.Sources.Sine sin(
    amplitude=273.15 + 10,
    freqHz=1/50,
    offset=273.15 + 25)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Continuous.Sources.Sine sin1(
    amplitude=0.5,
    freqHz=1/200,
    offset=0.5)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  CDL.Continuous.Sources.Sine sin2(
    amplitude=0.5,
    freqHz=1/100,
    offset=0.5)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  CDL.Continuous.Sources.Sine sin3(
    amplitude=273.15 + 10,
    freqHz=1/50,
    offset=273.15 + 25)
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  CDL.Continuous.Sources.Sine sin5(
    amplitude=0.5,
    freqHz=1/100,
    offset=0.5)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  CDL.Continuous.Sources.Sine sin6(
    amplitude=273.15 + 10,
    freqHz=1/50,
    offset=273.15 + 25)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Continuous.Sources.Sine sin8(
    amplitude=0.5,
    freqHz=1/100,
    offset=0.5)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature
    TSupAir3(have_coolingCoil=true, have_heatingCoil=true)
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  CDL.Continuous.Sources.Sine sin4(
    amplitude=273.15 + 10,
    freqHz=1/50,
    offset=273.15 + 25)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  CDL.Continuous.Sources.Sine sin7(
    amplitude=0.5,
    freqHz=1/200,
    offset=0.5)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  CDL.Continuous.Sources.Sine sin9(
    amplitude=0.5,
    freqHz=1/100,
    offset=0.5)
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
equation
  connect(sin.y, TSupAir.TAirSup)
    annotation (Line(points={{-58,50},{-42,50}}, color={0,0,127}));
  connect(sin2.y, TSupAir.uHea) annotation (Line(points={{-58,80},{-50,80},{-50,
          56},{-42,56}}, color={0,0,127}));
  connect(sin1.y, TSupAir.uCoo) annotation (Line(points={{-58,20},{-50,20},{-50,
          44},{-42,44}}, color={0,0,127}));
  connect(sin5.y, TSupAir1.TAirSup) annotation (Line(points={{42,-40},{50,-40},
          {50,-50},{58,-50}}, color={0,0,127}));
  connect(sin3.y, TSupAir1.uCoo) annotation (Line(points={{42,-70},{50,-70},{50,
          -56},{58,-56}}, color={0,0,127}));
  connect(sin6.y, TSupAir2.TAirSup)
    annotation (Line(points={{-58,-50},{-42,-50}}, color={0,0,127}));
  connect(sin8.y, TSupAir2.uHea) annotation (Line(points={{-58,-20},{-50,-20},{
          -50,-44},{-42,-44}}, color={0,0,127}));
  connect(sin4.y, TSupAir3.TAirSup)
    annotation (Line(points={{42,50},{58,50}}, color={0,0,127}));
  connect(sin9.y, TSupAir3.uHea) annotation (Line(points={{42,80},{50,80},{50,
          56},{58,56}}, color={0,0,127}));
  connect(sin7.y, TSupAir3.uCoo) annotation (Line(points={{42,20},{50,20},{50,
          44},{58,44}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end SupplyAirTemperature;
