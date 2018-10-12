within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block ConditionsForPositiveDisplacement
  "Stage change conditions for positive displacement chillers"

  parameter Integer numSta = 2
  "Number of stages";

  parameter Real staUpPlr(min = 0, max = 1, unit="1") = 0.8
  "Maximum operating part load ratio of the current stage before staging up";

  parameter Real staDowPlr(min = 0, max = 1, unit="1") = 0.8
  "Minimum operating part load ratio of the next lower stage before staging down";

  CDL.Interfaces.RealInput uCapReq(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
    iconTransformation(extent={{-160,-70},{-140,-50}})));

  CDL.Interfaces.RealInput uCapNomSta(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-160,20},{-140,40}})));

  CDL.Interfaces.RealInput uCapNomLowSta(final quantity="VolumeFlowRate",
      final unit="m3/s") "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-160,-10},{-140,10}})));

  CDL.Interfaces.IntegerOutput yChiStaCha(final max=1, final min=-1)
    "Chiller stage change" annotation (Placement(transformation(extent={{180,-10},
            {200,10}}), iconTransformation(extent={{200,-140},{220,-120}})));

  CDL.Interfaces.IntegerInput uChiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
        iconTransformation(extent={{-180,80},{-140,120}})));
  CDL.Continuous.Division opePlrSta
    "Operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  CDL.Continuous.Division opePlrLowSta
    "Operating part load ratio at the first lower stage"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  CDL.Logical.Switch swiDown "Checks if the stage should go down"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  CDL.Logical.Switch swiUp "Checks if the stage should go up"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Integers.Sources.Constant   stage1(k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  CDL.Integers.Sources.Constant stageMax(k=numSta) "Last stage"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  CDL.Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{92,-38},{112,-18}})));
  CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  CDL.Conversions.BooleanToInteger booToInt1
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  CDL.Integers.Add addInt(k2=-1)
    annotation (Placement(transformation(extent={{152,-10},{172,10}})));
protected
  CDL.Continuous.Sources.Constant staUpOpePlr(final k=staUpPlr)
    "Maximum operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
protected
  CDL.Continuous.Sources.Constant staDowOpePlr(final k=staDowPlr)
    "Minimum operating part load ratio of the first lower stage"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
protected
  CDL.Continuous.Sources.Constant firstAndLast(final k=1)
    "Operating part load ratio limit for lower and upper extremes"
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
equation
  connect(uCapNomSta, opePlrSta.u1) annotation (Line(points={{-160,20},{-86,20},
          {-86,56},{-22,56}}, color={0,0,127}));
  connect(uCapReq, opePlrSta.u2) annotation (Line(points={{-160,-80},{-80,-80},
          {-80,44},{-22,44}},
                           color={0,0,127}));
  connect(uCapNomLowSta, opePlrLowSta.u1) annotation (Line(points={{-160,-20},{
          -70,-20},{-70,-44},{-22,-44}},
                                     color={0,0,127}));
  connect(uCapReq, opePlrLowSta.u2) annotation (Line(points={{-160,-80},{-80,
          -80},{-80,-56},{-22,-56}},
                                color={0,0,127}));
  connect(uChiSta, intEqu.u1) annotation (Line(points={{-160,100},{-120,100},{
          -120,110},{-62,110}}, color={255,127,0}));
  connect(intEqu.u2, stage1.y) annotation (Line(points={{-62,102},{-70,102},{
          -70,90},{-79,90}}, color={255,127,0}));
  connect(uChiSta, intEqu1.u1) annotation (Line(points={{-160,100},{-130,100},{
          -130,30},{-76,30},{-76,10},{-62,10}}, color={255,127,0}));
  connect(stageMax.y, intEqu1.u2) annotation (Line(points={{-99,-50},{-90,-50},
          {-90,2},{-62,2}}, color={255,127,0}));
  connect(intEqu.y, swiDown.u2) annotation (Line(points={{-39,110},{20,110},{20,
          -70},{58,-70}}, color={255,0,255}));
  connect(swiDown.u1, firstAndLast.y) annotation (Line(points={{58,-62},{54,-62},
          {54,0},{49,0}}, color={0,0,127}));
  connect(swiDown.u3, staDowOpePlr.y) annotation (Line(points={{58,-78},{54,-78},
          {54,-110},{21,-110}}, color={0,0,127}));
  connect(intEqu1.y, swiUp.u2) annotation (Line(points={{-39,10},{-10,10},{-10,
          90},{-2,90}}, color={255,0,255}));
  connect(swiUp.u3, staUpOpePlr.y) annotation (Line(points={{-2,82},{-10,82},{
          -10,80},{-19,80}}, color={0,0,127}));
  connect(firstAndLast.y, swiUp.u1) annotation (Line(points={{49,0},{54,0},{54,
          108},{-6,108},{-6,98},{-2,98}}, color={0,0,127}));
  connect(swiDown.y, lesEqu.u2) annotation (Line(points={{81,-70},{86,-70},{86,
          -36},{90,-36}}, color={0,0,127}));
  connect(opePlrLowSta.y, lesEqu.u1) annotation (Line(points={{1,-50},{46,-50},
          {46,-28},{90,-28}}, color={0,0,127}));
  connect(swiUp.y, greEqu.u2) annotation (Line(points={{21,90},{40,90},{40,42},
          {58,42}}, color={0,0,127}));
  connect(opePlrSta.y, greEqu.u1)
    annotation (Line(points={{1,50},{58,50}}, color={0,0,127}));
  connect(greEqu.y, booToInt.u) annotation (Line(points={{81,50},{90,50},{90,30},
          {98,30}}, color={255,0,255}));
  connect(lesEqu.y, booToInt1.u) annotation (Line(points={{113,-28},{116,-28},{
          116,-30},{118,-30}}, color={255,0,255}));
  connect(booToInt.y, addInt.u1) annotation (Line(points={{121,30},{136,30},{
          136,6},{150,6}}, color={255,127,0}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{141,-30},{146,-30},
          {146,-6},{150,-6}}, color={255,127,0}));
  connect(yChiStaCha, addInt.y)
    annotation (Line(points={{190,0},{173,0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -140},{180,140}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{180,
            140}})));
end ConditionsForPositiveDisplacement;
