within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.Validation;
block FanSpeed
  "Validation model for fan speed subsequence"

  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed fanSpe(
      have_coolingCoil=true, have_heatingCoil=true)
    "Instance demonstrating variation of heating loop signal"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed fanSpe2(
      have_coolingCoil=true, have_heatingCoil=true)
    "Instance demonstrating variation of operating mode"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed fanSpe1(
      have_coolingCoil=true, have_heatingCoil=true)
    "Instance demonstrating variation of cooling loop signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=6,
    final duration=70,
    final offset=1) "Operating mode signal"
              annotation (Placement(transformation(extent={{20,160},{40,180}})));
  CDL.Conversions.RealToInteger reaToInt "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-70,160},{-50,180}})));
  CDL.Logical.Sources.Pulse booPul(final period=100) "Fan proven on signal"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  CDL.Continuous.Sources.Sine sin(final freqHz=1/50) "Heating loop signal"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  CDL.Continuous.Abs abs "Convert negative loop signal to positive"
    annotation (Placement(transformation(extent={{-70,100},{-50,120}})));
  CDL.Continuous.Sources.Constant con(final k=0) "Cooling loop signal"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  CDL.Continuous.Sources.Constant con1(final k=1) "Operating mode signal"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));

  CDL.Conversions.RealToInteger reaToInt1 "Real to Integer conversion"
    annotation (Placement(transformation(extent={{50,160},{70,180}})));
  CDL.Logical.Sources.Pulse booPul1(final period=100) "Fan proven on signal"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  CDL.Continuous.Sources.Constant con2(final k=0) "Cooling loop signal"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  CDL.Conversions.RealToInteger reaToInt2 "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  CDL.Logical.Sources.Pulse booPul2(final period=100) "Fan proven on signal"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  CDL.Continuous.Sources.Sine sin2(final freqHz=1/50) "Cooling loop signal"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  CDL.Continuous.Abs abs2 "Convert negative loop signal to positive"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  CDL.Continuous.Sources.Constant con3(final k=0) "Heating loop signal"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  CDL.Continuous.Sources.Constant con4(final k=1) "Operating mode signal"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  CDL.Continuous.Sources.Constant con5(final k=0.75) "Heating loop signal"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed fanSpe3(
      have_coolingCoil=true, have_heatingCoil=false)
    "Instance demonstrating variation of cooling loop signal with no heating coil"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  CDL.Conversions.RealToInteger reaToInt3 "Real to Integer conversion"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  CDL.Logical.Sources.Pulse booPul3(final period=100) "Fan proven on signal"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Continuous.Sources.Sine sin1(final freqHz=1/50) "Cooling loop signal"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  CDL.Continuous.Abs abs1 "Convert negative loop signal to positive"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  CDL.Continuous.Sources.Constant con7(final k=1) "Operating mode signal"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed fanSpe4(
      have_coolingCoil=false, have_heatingCoil=true)
    "Instance demonstrating variation of heating loop signal with no cooling coil"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  CDL.Conversions.RealToInteger reaToInt4
                                         "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-70,-100},{-50,-80}})));
  CDL.Logical.Sources.Pulse booPul4(final period=100)
                                                     "Fan proven on signal"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  CDL.Continuous.Sources.Sine sin3(final freqHz=1/50)
                                                     "Heating loop signal"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  CDL.Continuous.Abs abs3
                         "Convert negative loop signal to positive"
    annotation (Placement(transformation(extent={{-70,-160},{-50,-140}})));
  CDL.Continuous.Sources.Constant con8(final k=1) "Operating mode signal"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed fanSpe5(
      have_coolingCoil=false, have_heatingCoil=false)
    "Instance demonstrating variation of operating mode with no heating and cooling coils"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  CDL.Continuous.Sources.Ramp                        ram1(
    final height=6,
    final duration=70,
    final offset=1) "Operating mode signal"
              annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  CDL.Conversions.RealToInteger reaToInt5 "Real to Integer conversion"
    annotation (Placement(transformation(extent={{50,-100},{70,-80}})));
  CDL.Logical.Sources.Pulse booPul5(final period=100) "Fan proven on signal"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
equation
  connect(reaToInt.y, fanSpe.opeMod) annotation (Line(points={{-48,170},{-46,170},
          {-46,138},{-42,138}},
                              color={255,127,0}));
  connect(booPul.y, fanSpe.uFanPro) annotation (Line(points={{-78,140},{-50,140},
          {-50,134},{-42,134}},
                             color={255,0,255}));
  connect(sin.y, abs.u)
    annotation (Line(points={{-78,110},{-72,110}},
                                                 color={0,0,127}));
  connect(abs.y, fanSpe.uHea) annotation (Line(points={{-48,110},{-46,110},{-46,
          128},{-42,128}},
                     color={0,0,127}));
  connect(con.y, fanSpe.uCoo) annotation (Line(points={{-78,80},{-44,80},{-44,124},
          {-42,124}},color={0,0,127}));
  connect(con1.y, reaToInt.u)
    annotation (Line(points={{-78,170},{-72,170}}, color={0,0,127}));
  connect(reaToInt1.y, fanSpe2.opeMod) annotation (Line(points={{72,170},{74,
          170},{74,138},{78,138}}, color={255,127,0}));
  connect(booPul1.y, fanSpe2.uFanPro) annotation (Line(points={{42,140},{70,140},
          {70,134},{78,134}}, color={255,0,255}));
  connect(con2.y, fanSpe2.uCoo) annotation (Line(points={{42,80},{76,80},{76,
          124},{78,124}}, color={0,0,127}));
  connect(ram.y, reaToInt1.u)
    annotation (Line(points={{42,170},{48,170}}, color={0,0,127}));
  connect(reaToInt2.y,fanSpe1. opeMod) annotation (Line(points={{-48,40},{-46,40},
          {-46,8},{-42,8}},     color={255,127,0}));
  connect(booPul2.y,fanSpe1. uFanPro) annotation (Line(points={{-78,10},{-50,10},
          {-50,4},{-42,4}},     color={255,0,255}));
  connect(sin2.y, abs2.u)
    annotation (Line(points={{-78,-50},{-72,-50}},   color={0,0,127}));
  connect(con4.y, reaToInt2.u)
    annotation (Line(points={{-78,40},{-72,40}},   color={0,0,127}));
  connect(con3.y,fanSpe1. uHea) annotation (Line(points={{-78,-20},{-56,-20},{-56,
          -2},{-42,-2}},   color={0,0,127}));
  connect(abs2.y,fanSpe1. uCoo) annotation (Line(points={{-48,-50},{-46,-50},{-46,
          -6},{-42,-6}},       color={0,0,127}));
  connect(con5.y, fanSpe2.uHea) annotation (Line(points={{42,110},{60,110},{60,
          128},{78,128}}, color={0,0,127}));
  connect(reaToInt3.y,fanSpe3. opeMod) annotation (Line(points={{72,40},{74,40},
          {74,8},{78,8}},       color={255,127,0}));
  connect(booPul3.y,fanSpe3. uFanPro) annotation (Line(points={{42,10},{70,10},{
          70,4},{78,4}},        color={255,0,255}));
  connect(sin1.y,abs1. u)
    annotation (Line(points={{42,-20},{48,-20}},     color={0,0,127}));
  connect(con7.y,reaToInt3. u)
    annotation (Line(points={{42,40},{48,40}},     color={0,0,127}));
  connect(abs1.y,fanSpe3. uCoo) annotation (Line(points={{72,-20},{74,-20},{74,-6},
          {78,-6}},            color={0,0,127}));
  connect(reaToInt4.y, fanSpe4.opeMod) annotation (Line(points={{-48,-90},{-46,
          -90},{-46,-122},{-42,-122}},
                                color={255,127,0}));
  connect(booPul4.y, fanSpe4.uFanPro) annotation (Line(points={{-78,-120},{-50,
          -120},{-50,-126},{-42,-126}},
                                color={255,0,255}));
  connect(sin3.y, abs3.u)
    annotation (Line(points={{-78,-150},{-72,-150}}, color={0,0,127}));
  connect(abs3.y, fanSpe4.uHea) annotation (Line(points={{-48,-150},{-46,-150},
          {-46,-132},{-42,-132}},
                            color={0,0,127}));
  connect(con8.y, reaToInt4.u)
    annotation (Line(points={{-78,-90},{-72,-90}}, color={0,0,127}));
  connect(reaToInt5.y, fanSpe5.opeMod) annotation (Line(points={{72,-90},{74,
          -90},{74,-122},{78,-122}}, color={255,127,0}));
  connect(booPul5.y, fanSpe5.uFanPro) annotation (Line(points={{42,-120},{70,
          -120},{70,-126},{78,-126}}, color={255,0,255}));
  connect(ram1.y, reaToInt5.u)
    annotation (Line(points={{42,-90},{48,-90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-200},{120,200}})),
    experiment(
      StopTime=100,
      Interval=1,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/FanCoilUnit/Subsequences/Validation/FanSpeed.mos"
    "Simulate and plot"));
end FanSpeed;
