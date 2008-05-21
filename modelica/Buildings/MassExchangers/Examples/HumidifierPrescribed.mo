model HumidifierPrescribed 
  import Buildings;
  
  annotation(Diagram(Text(
        extent=[-196,-6; -4,-40],
        style(color=3, rgbcolor={0,0,255}),
        string="Same models as above, but flow is reversed"),
      Text(
        extent=[30,204; 158,162],
        style(color=3, rgbcolor={0,0,255}),
        string="Asserts for temperture check"),
      Text(
        extent=[210,204; 338,162],
        style(color=3, rgbcolor={0,0,255}),
        string="Asserts for humidity check")),
                      Commands(file="HumidifierPrescribed.mos" "run"),
Documentation(info="<html>
<p>
Model that tests the basic class that is used for the humidifier model.
It adds and removes water for forward and reverse flow.
The top and bottom models should give similar results, although 
the sign of the humidity difference over the components differ
because of the reverse flow.
The model uses assert statements that will be triggered if
results that are expected to be close to each other differ by more
than a prescribed threshold.</p>
</html>",
revisions="<html>
<ul>
<li>
April 18, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Coordsys(extent=[-200,-320; 360,200]));
 package Medium = Modelica.Media.Air.MoistAir;
 parameter Modelica.SIunits.MassFlowRate mWat0_flow = 0.001 
    "Nominal water mass flow rate";
  Buildings.MassExchangers.HumidifierPrescribed hea1(redeclare package Medium 
      = Medium, m0_flow=mWat0_flow) "Heater and cooler" 
                                                  annotation (extent=[-54,92; -34,
        112]);
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature" 
    annotation (extent=[-200,92; -180,112]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_1(
    T=293.15,
    redeclare package Medium = Medium,
    p=101335)             annotation (extent=[-168,92; -148,112]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_11(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[-100,92; -80,112]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_12(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[-100,134; -80,154],
                                                  rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_1(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,134; -148,154],
                                                             rotation=0);
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[-200,140; -180,160]);
    Modelica.Blocks.Sources.Ramp u(
    duration=1,
    startTime=0,
    height=1,
    offset=0) "Control signal" 
                 annotation (extent=[-148,174; -128,194]);
  Buildings.MassExchangers.HumidifierPrescribed hea2(
                                                 redeclare package Medium = 
        Medium, m0_flow=mWat0_flow) "Heater and cooler" 
                                                  annotation (extent=[-12,134; 8,154]);
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (extent=[-50,174; -30,194]);
  Buildings.MassExchangers.HumidifierPrescribed hea3(redeclare package Medium 
      = Medium, m0_flow=mWat0_flow) "Heater and cooler" 
                                                  annotation (extent=[-54,12; -34,32]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_2(
    T=293.15,
    redeclare package Medium = Medium,
    p=101335)             annotation (extent=[-168,12; -148,32]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[-100,12; -80,32]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_3(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[-100,54; -80,74],rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_2(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,54; -148,74],
                                                             rotation=0);
  Buildings.MassExchangers.HumidifierPrescribed hea4(
                                                 redeclare package Medium = 
        Medium, m0_flow=mWat0_flow) "Heater and cooler" 
                                                  annotation (extent=[-12,54; 8,74]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_4(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[10,30; 30,50],   rotation=90);
  Modelica_Fluid.Volumes.MixingVolume mix1(redeclare package Medium = Medium, V=
       0.000001) annotation (extent=[-22,12; -2,32]);
  Buildings.Utilities.Controls.AssertEquality ass1(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,140; 180,160]);
  Modelica.Blocks.Sources.RealExpression y1(y=hea2.medium_b.T_degC) 
    annotation (extent=[40,150; 140,170]);
  Modelica.Blocks.Sources.RealExpression y2(y=hea1.medium_b.T_degC) 
    annotation (extent=[40,130; 140,150]);
  Buildings.Utilities.Controls.AssertEquality ass2(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,100; 180,120]);
  Modelica.Blocks.Sources.RealExpression y3(y=hea2.medium_a.T_degC) 
    annotation (extent=[40,110; 140,130]);
  Modelica.Blocks.Sources.RealExpression y4(y=hea1.medium_a.T_degC) 
    annotation (extent=[40,90; 140,110]);
  Buildings.Utilities.Controls.AssertEquality ass3(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,38; 180,58]);
  Modelica.Blocks.Sources.RealExpression y5(y=hea4.medium_b.T_degC) 
    annotation (extent=[40,48; 140,68]);
  Modelica.Blocks.Sources.RealExpression y6(y=hea3.medium_b.T_degC) 
    annotation (extent=[40,28; 140,48]);
  Buildings.Utilities.Controls.AssertEquality ass4(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,-2; 180,18]);
  Modelica.Blocks.Sources.RealExpression y7(y=hea4.medium_a.T_degC) 
    annotation (extent=[40,8; 140,28]);
  Modelica.Blocks.Sources.RealExpression y8(y=hea3.medium_a.T_degC) 
    annotation (extent=[40,-12; 140,8]);
  Buildings.MassExchangers.HumidifierPrescribed hea5(redeclare package Medium 
      = Medium, m0_flow=mWat0_flow) "Heater and cooler" 
                                                  annotation (extent=[-54,-110;
        -34,-90]);
  Modelica.Blocks.Sources.Constant TDb1(
                                       k=293.15) "Drybulb temperature" 
    annotation (extent=[-200,-110; -180,-90]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_3(
    T=293.15,
    redeclare package Medium = Medium,
    p=101335)             annotation (extent=[-168,-110; -148,-90]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[-100,-110; -80,-90]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_5(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[-100,-68; -80,-48],
                                                  rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_3(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,-68; -148,-48],
                                                             rotation=0);
    Modelica.Blocks.Sources.Constant POut1(
                                          k=101325) 
      annotation (extent=[-200,-62; -180,-42]);
  Buildings.MassExchangers.HumidifierPrescribed hea6(
                                                 redeclare package Medium = 
        Medium, m0_flow=mWat0_flow) "Heater and cooler" 
                                                  annotation (extent=[-12,-68;
        8,-48]);
  Buildings.MassExchangers.HumidifierPrescribed hea7(redeclare package Medium 
      = Medium, m0_flow=mWat0_flow) "Heater and cooler" 
                                                  annotation (extent=[-54,-190;
        -34,-170]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_4(
    T=293.15,
    redeclare package Medium = Medium,
    p=101335)             annotation (extent=[-168,-190; -148,-170]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_6(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[-100,-190; -80,-170]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_7(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[-100,-148; -80,-128],
                                                  rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_4(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,-148; -148,-128],
                                                             rotation=0);
  Buildings.MassExchangers.HumidifierPrescribed hea8(
                                                 redeclare package Medium = 
        Medium, m0_flow=mWat0_flow) "Heater and cooler" 
                                                  annotation (extent=[-12,-148;
        8,-128]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_8(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[10,-172; 30,-152],
                                                  rotation=90);
  Modelica_Fluid.Volumes.MixingVolume mix2(redeclare package Medium = Medium, V=
       0.000001) annotation (extent=[-22,-190; -2,-170]);
  Buildings.Utilities.Controls.AssertEquality ass5(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,-62; 180,-42]);
  Modelica.Blocks.Sources.RealExpression y9(y=hea6.medium_b.T_degC) 
    annotation (extent=[40,-50; 140,-30]);
  Modelica.Blocks.Sources.RealExpression y10(
                                            y=hea5.medium_b.T_degC) 
    annotation (extent=[40,-72; 140,-52]);
  Buildings.Utilities.Controls.AssertEquality ass6(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,-102; 180,-82]);
  Modelica.Blocks.Sources.RealExpression y11(
                                            y=hea6.medium_a.T_degC) 
    annotation (extent=[40,-92; 140,-72]);
  Modelica.Blocks.Sources.RealExpression y12(
                                            y=hea5.medium_a.T_degC) 
    annotation (extent=[40,-112; 140,-92]);
  Buildings.Utilities.Controls.AssertEquality ass7(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,-164; 180,-144]);
  Modelica.Blocks.Sources.RealExpression y13(
                                            y=hea8.medium_b.T_degC) 
    annotation (extent=[40,-154; 140,-134]);
  Modelica.Blocks.Sources.RealExpression y14(
                                            y=hea7.medium_b.T_degC) 
    annotation (extent=[40,-174; 140,-154]);
  Buildings.Utilities.Controls.AssertEquality ass8(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,-204; 180,-184]);
  Modelica.Blocks.Sources.RealExpression y15(
                                            y=hea8.medium_a.T_degC) 
    annotation (extent=[40,-194; 140,-174]);
  Modelica.Blocks.Sources.RealExpression y16(
                                            y=hea7.medium_a.T_degC) 
    annotation (extent=[40,-214; 140,-194]);
  Buildings.Utilities.Controls.AssertEquality ass9(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,-300; 180,-280]);
  Modelica.Blocks.Sources.RealExpression y17(y=hea2.medium_b.T_degC) 
    annotation (extent=[40,-290; 140,-270]);
  Modelica.Blocks.Sources.RealExpression y18(y=hea5.medium_b.T_degC) 
    annotation (extent=[40,-310; 140,-290]);
  Buildings.Utilities.Controls.AssertEquality ass10(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,-260; 180,-240]);
  Modelica.Blocks.Sources.RealExpression y19(y=hea4.medium_a.T_degC) 
    annotation (extent=[40,-250; 140,-230]);
  Modelica.Blocks.Sources.RealExpression y20(y=hea7.medium_a.T_degC) 
    annotation (extent=[40,-270; 140,-250]);
  Buildings.Utilities.Controls.AssertEquality ass11(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,140; 360,160]);
  Modelica.Blocks.Sources.RealExpression y21(y=hea2.medium_b.X[1]) 
    annotation (extent=[220,150; 320,170]);
  Modelica.Blocks.Sources.RealExpression y22(y=hea1.medium_b.X[1]) 
    annotation (extent=[220,130; 320,150]);
  Buildings.Utilities.Controls.AssertEquality ass12(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,100; 360,120]);
  Modelica.Blocks.Sources.RealExpression y23(
                                            y=hea2.medium_a.X[1]) 
    annotation (extent=[220,110; 320,130]);
  Modelica.Blocks.Sources.RealExpression y24(
                                            y=hea1.medium_a.X[1]) 
    annotation (extent=[220,90; 320,110]);
  Buildings.Utilities.Controls.AssertEquality ass13(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,38; 360,58]);
  Modelica.Blocks.Sources.RealExpression y25(
                                            y=hea4.medium_b.X[1]) 
    annotation (extent=[220,48; 320,68]);
  Modelica.Blocks.Sources.RealExpression y26(
                                            y=hea3.medium_b.X[1]) 
    annotation (extent=[220,28; 320,48]);
  Buildings.Utilities.Controls.AssertEquality ass14(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,-2; 360,18]);
  Modelica.Blocks.Sources.RealExpression y27(
                                            y=hea4.medium_a.X[1]) 
    annotation (extent=[220,8; 320,28]);
  Modelica.Blocks.Sources.RealExpression y28(
                                            y=hea3.medium_a.X[1]) 
    annotation (extent=[220,-12; 320,8]);
  Buildings.Utilities.Controls.AssertEquality ass15(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,-62; 360,-42]);
  Modelica.Blocks.Sources.RealExpression y29(
                                            y=hea6.medium_b.X[1]) 
    annotation (extent=[220,-52; 320,-32]);
  Modelica.Blocks.Sources.RealExpression y30(
                                            y=hea5.medium_b.X[1]) 
    annotation (extent=[220,-72; 320,-52]);
  Buildings.Utilities.Controls.AssertEquality ass16(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,-102; 360,-82]);
  Modelica.Blocks.Sources.RealExpression y31(
                                            y=hea6.medium_a.X[1]) 
    annotation (extent=[220,-92; 320,-72]);
  Modelica.Blocks.Sources.RealExpression y32(
                                            y=hea5.medium_a.X[1]) 
    annotation (extent=[220,-112; 320,-92]);
  Buildings.Utilities.Controls.AssertEquality ass17(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,-164; 360,-144]);
  Modelica.Blocks.Sources.RealExpression y33(
                                            y=hea8.medium_b.X[1]) 
    annotation (extent=[220,-154; 320,-134]);
  Modelica.Blocks.Sources.RealExpression y34(
                                            y=hea7.medium_b.X[1]) 
    annotation (extent=[220,-174; 320,-154]);
  Buildings.Utilities.Controls.AssertEquality ass18(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,-204; 360,-184]);
  Modelica.Blocks.Sources.RealExpression y35(
                                            y=hea8.medium_a.X[1]) 
    annotation (extent=[220,-194; 320,-174]);
  Modelica.Blocks.Sources.RealExpression y36(
                                            y=hea7.medium_a.X[1]) 
    annotation (extent=[220,-214; 320,-194]);
  Buildings.Utilities.Controls.AssertEquality ass19(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,-300; 360,-280]);
  Modelica.Blocks.Sources.RealExpression y37(y=hea2.medium_b.X[1]) 
    annotation (extent=[220,-290; 320,-270]);
  Modelica.Blocks.Sources.RealExpression y38(y=hea5.medium_b.X[1]) 
    annotation (extent=[220,-310; 320,-290]);
  Buildings.Utilities.Controls.AssertEquality ass20(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[340,-260; 360,-240]);
  Modelica.Blocks.Sources.RealExpression y39(y=hea4.medium_a.X[1]) 
    annotation (extent=[220,-250; 320,-230]);
  Modelica.Blocks.Sources.RealExpression y40(y=hea7.medium_a.X[1]) 
    annotation (extent=[220,-270; 320,-250]);
equation 
  connect(POut.y,sin_1. p_in) annotation (points=[-179,150; -170,150],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sou_1.port,res_11. port_a) annotation (points=[-148,102; -100,102],
                 style(color=69, rgbcolor={0,127,255}));
  connect(TDb.y,sou_1. T_in) annotation (points=[-179,102; -170,102],
                                                                  style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_1.port, res_12.port_a) annotation (points=[-148,144; -100,144],
                                                                          style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res_11.port_b, hea1.port_a) 
                                     annotation (points=[-80,102; -54,102],
                style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(u.y, hea1.u) 
                      annotation (points=[-127,184; -64,184; -64,108; -56,108],
                                                                          style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(gain.y, hea2.u) annotation (points=[-29,184; -22,184; -22,150; -14,
        150],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(u.y, gain.u) annotation (points=[-127,184; -52,184],
                                                           style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res_12.port_b, hea2.port_a) annotation (points=[-80,144; -12,144],
                                                                          style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(POut.y,sin_2. p_in) annotation (points=[-179,150; -179.5,150; -179.5,
        70; -170,70],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sou_2.port, res_2.port_a)  annotation (points=[-148,22; -100,22],
                 style(color=69, rgbcolor={0,127,255}));
  connect(TDb.y,sou_2. T_in) annotation (points=[-179,102; -179.5,102; -179.5,
        22; -170,22],                                             style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_2.port, res_3.port_a)  annotation (points=[-148,64; -100,64],
                                                                          style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res_2.port_b, hea3.port_a) annotation (points=[-80,22; -54,22],
                style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(u.y, hea3.u) 
                      annotation (points=[-127,184; -64,184; -64,28; -56,28],
                                                                          style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(gain.y, hea4.u) annotation (points=[-29,184; -22,184; -22,70; -14,70],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(hea3.port_b, mix1.port_a) annotation (points=[-34,22; -22.2,22],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(mix1.port_b, res_4.port_a) annotation (points=[-2,22; 20,22; 20,30],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res_3.port_b, hea4.port_a) annotation (points=[-80,64; -12,64],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(hea4.port_b, res_4.port_b) annotation (points=[8,64; 20,64; 20,50],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(hea1.port_b, hea2.port_b) annotation (points=[-34,102; 20,102; 20,144; 
        8,144],
             style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(y1.y, ass1.u1) annotation (points=[145,160; 154,160; 154,156; 158,156],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y2.y, ass1.u2) annotation (points=[145,140; 152,140; 152,144; 158,144],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y3.y, ass2.u1) annotation (points=[145,120; 154,120; 154,116; 158,116],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y4.y, ass2.u2) annotation (points=[145,100; 152,100; 152,104; 158,104],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y5.y, ass3.u1) annotation (points=[145,58; 154,58; 154,54; 158,54],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y6.y, ass3.u2) annotation (points=[145,38; 152,38; 152,42; 158,42],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y7.y, ass4.u1) annotation (points=[145,18; 154,18; 154,14; 158,14],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y8.y, ass4.u2) annotation (points=[145,-2; 152,-2; 152,2; 158,2],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(POut1.y, sin_3.p_in) 
                              annotation (points=[-179,-52; -170,-52],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TDb1.y, sou_3.T_in) 
                             annotation (points=[-179,-100; -170,-100],
                                                                  style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(res_1.port_b, hea5.port_a) annotation (points=[-80,-100; -54,-100],
                style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res_5.port_b, hea6.port_a)  annotation (points=[-80,-58; -12,-58],
                                                                          style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(POut1.y, sin_4.p_in) 
                              annotation (points=[-179,-52; -179.5,-52; -179.5,
        -132; -170,-132],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TDb1.y, sou_4.T_in) 
                             annotation (points=[-179,-100; -179.5,-100; -179.5,
        -180; -170,-180],                                         style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(res_6.port_b,hea7. port_a) annotation (points=[-80,-180; -54,-180],
                style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(hea7.port_b,mix2. port_a) annotation (points=[-34,-180; -22.2,-180],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(mix2.port_b,res_8. port_a) annotation (points=[-2,-180; 20,-180; 20,
        -172],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res_7.port_b,hea8. port_a) annotation (points=[-80,-138; -12,-138],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(hea8.port_b,res_8. port_b) annotation (points=[8,-138; 20,-138; 20,
        -152],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(hea5.port_b,hea6. port_b) annotation (points=[-34,-100; 20,-100; 20,
        -58; 8,-58],
             style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(y9.y,ass5. u1) annotation (points=[145,-40; 154,-40; 154,-46; 158,-46],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y10.y, ass5.u2) 
                         annotation (points=[145,-62; 152,-62; 152,-58; 158,-58],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y11.y, ass6.u1) 
                         annotation (points=[145,-82; 154,-82; 154,-86; 158,-86],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y12.y, ass6.u2) 
                         annotation (points=[145,-102; 152,-102; 152,-98; 158,
        -98],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y13.y, ass7.u1) 
                         annotation (points=[145,-144; 154,-144; 154,-148; 158,
        -148],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y14.y, ass7.u2) 
                         annotation (points=[145,-164; 152,-164; 152,-160; 158,
        -160],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y15.y, ass8.u1) 
                         annotation (points=[145,-184; 154,-184; 154,-188; 158,
        -188],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y16.y, ass8.u2) 
                         annotation (points=[145,-204; 152,-204; 152,-200; 158,
        -200],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(sou_3.port, res_5.port_a) annotation (points=[-148,-100; -126,-100;
        -126,-58; -100,-58], style(color=69, rgbcolor={0,127,255}));
  connect(sin_3.port, res_1.port_a) annotation (points=[-148,-58; -118,-58;
        -118,-100; -100,-100], style(color=69, rgbcolor={0,127,255}));
  connect(sin_4.port, res_6.port_a) annotation (points=[-148,-138; -125,-138;
        -125,-180; -100,-180], style(color=69, rgbcolor={0,127,255}));
  connect(sou_4.port, res_7.port_a) annotation (points=[-148,-180; -116,-180;
        -116,-138; -100,-138], style(color=69, rgbcolor={0,127,255}));
  connect(y17.y,ass9. u1) 
                         annotation (points=[145,-280; 154,-280; 154,-284; 158,
        -284],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y18.y,ass9. u2) 
                         annotation (points=[145,-300; 152,-300; 152,-296; 158,
        -296],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y19.y, ass10.u1) 
                         annotation (points=[145,-240; 154,-240; 154,-244; 158,
        -244],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y20.y, ass10.u2) 
                         annotation (points=[145,-260; 152,-260; 152,-256; 158,
        -256],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(u.y, hea6.u) annotation (points=[-127,184; -70,184; -70,-52; -14,-52],
      style(color=74, rgbcolor={0,0,127}));
  connect(u.y, hea8.u) annotation (points=[-127,184; -70,184; -70,-132; -14,
        -132], style(color=74, rgbcolor={0,0,127}));
  connect(gain.y, hea5.u) annotation (points=[-29,184; -26,184; -26,-80; -60,
        -80; -60,-94; -56,-94], style(color=74, rgbcolor={0,0,127}));
  connect(gain.y, hea7.u) annotation (points=[-29,184; -26,184; -26,-160; -64,
        -160; -64,-174; -56,-174], style(color=74, rgbcolor={0,0,127}));
  connect(y21.y, ass11.u1) 
                         annotation (points=[325,160; 334,160; 334,156; 338,156],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y22.y, ass11.u2) 
                         annotation (points=[325,140; 332,140; 332,144; 338,144],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y23.y, ass12.u1) 
                         annotation (points=[325,120; 334,120; 334,116; 338,116],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y24.y, ass12.u2) 
                         annotation (points=[325,100; 332,100; 332,104; 338,104],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y25.y, ass13.u1) 
                         annotation (points=[325,58; 334,58; 334,54; 338,54],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y26.y, ass13.u2) 
                         annotation (points=[325,38; 332,38; 332,42; 338,42],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y27.y, ass14.u1) 
                         annotation (points=[325,18; 334,18; 334,14; 338,14],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y28.y, ass14.u2) 
                         annotation (points=[325,-2; 332,-2; 332,2; 338,2],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y29.y, ass15.u1) 
                         annotation (points=[325,-42; 334,-42; 334,-46; 338,-46],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y30.y, ass15.u2) 
                         annotation (points=[325,-62; 332,-62; 332,-58; 338,-58],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y31.y, ass16.u1) 
                         annotation (points=[325,-82; 334,-82; 334,-86; 338,-86],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y32.y, ass16.u2) 
                         annotation (points=[325,-102; 332,-102; 332,-98; 338,
        -98],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y33.y, ass17.u1) 
                         annotation (points=[325,-144; 334,-144; 334,-148; 338,
        -148],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y34.y, ass17.u2) 
                         annotation (points=[325,-164; 332,-164; 332,-160; 338,
        -160],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y35.y, ass18.u1) 
                         annotation (points=[325,-184; 334,-184; 334,-188; 338,
        -188],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y36.y, ass18.u2) 
                         annotation (points=[325,-204; 332,-204; 332,-200; 338,
        -200],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y37.y, ass19.u1) 
                         annotation (points=[325,-280; 334,-280; 334,-284; 338,
        -284],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y38.y, ass19.u2) 
                         annotation (points=[325,-300; 332,-300; 332,-296; 338,
        -296],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y39.y, ass20.u1) 
                         annotation (points=[325,-240; 334,-240; 334,-244; 338,
        -244],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y40.y, ass20.u2) 
                         annotation (points=[325,-260; 332,-260; 332,-256; 338,
        -256],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
end HumidifierPrescribed;
