model HeaterCoolerIdeal 
  import Buildings;
  
  annotation(Diagram(Text(
        extent=[-202,0; -10,-34],
        style(color=3, rgbcolor={0,0,255}),
        string="Same models as above, but flow is reversed"),
      Text(
        extent=[30,234; 158,192],
        style(color=3, rgbcolor={0,0,255}),
        string="Asserts for temperture check")),
                      Commands(file="HeaterCoolerIdeal.mos" "run"),
Documentation(info="<html>
<p>
Model that tests the basic class that is used for the heater models.
It adds and removes heat for forward and reverse flow.
The top and bottom models should give similar results, although 
the sign of the temperature difference over the components differ
because of the reverse flow.
The model uses assert statements that will be triggered if
results that are expected to be close to each other differ by more
than a prescribed threshold.</p>
</html>",
revisions="<html>
<ul>
<li>
April 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Coordsys(extent=[-200,-300; 200,240]));
 package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  Buildings.HeatExchangers.HeaterCoolerIdeal hea1(redeclare package Medium = 
        Medium, Q0_flow=5000) "Heater and cooler" annotation (extent=[-54,92; -34,
        112]);
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature" 
    annotation (extent=[-200,92; -180,112]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou_1(
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
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin_1(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,134; -148,154],
                                                             rotation=0);
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[-200,140; -180,160]);
    Modelica.Blocks.Sources.Ramp u(
    height=2,
    duration=1,
    offset=-1,
    startTime=0) "Control signal" 
                 annotation (extent=[-148,174; -128,194]);
  Buildings.HeatExchangers.HeaterCoolerIdeal hea2(
                                                 redeclare package Medium = 
        Medium, Q0_flow=5000) "Heater and cooler" annotation (extent=[-12,134; 8,154]);
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (extent=[-50,174; -30,194]);
  Buildings.HeatExchangers.HeaterCoolerIdeal hea3(redeclare package Medium = 
        Medium, Q0_flow=5000) "Heater and cooler" annotation (extent=[-54,12; -34,32]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou_2(
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
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin_2(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,54; -148,74],
                                                             rotation=0);
  Buildings.HeatExchangers.HeaterCoolerIdeal hea4(
                                                 redeclare package Medium = 
        Medium, Q0_flow=5000) "Heater and cooler" annotation (extent=[-12,54; 8,74]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_4(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[10,30; 30,50],   rotation=90);
  Modelica_Fluid.Volumes.MixingVolume mix1(redeclare package Medium = Medium, V=
       0.000001) annotation (extent=[-22,12; -2,32]);
  Buildings.Utilities.Controls.AssertEquality ass1(startTime=0.2) 
    annotation (extent=[160,160; 180,180]);
  Modelica.Blocks.Sources.RealExpression y1(y=hea2.medium_b.T_degC) 
    annotation (extent=[40,170; 140,190]);
  Modelica.Blocks.Sources.RealExpression y2(y=hea1.medium_b.T_degC) 
    annotation (extent=[40,150; 140,170]);
  Buildings.Utilities.Controls.AssertEquality ass2(startTime=0.2) 
    annotation (extent=[160,120; 180,140]);
  Modelica.Blocks.Sources.RealExpression y3(y=hea2.medium_a.T_degC) 
    annotation (extent=[40,130; 140,150]);
  Modelica.Blocks.Sources.RealExpression y4(y=hea1.medium_a.T_degC) 
    annotation (extent=[40,110; 140,130]);
  Buildings.Utilities.Controls.AssertEquality ass3(startTime=0.2, threShold=2) 
    annotation (extent=[160,58; 180,78]);
  Modelica.Blocks.Sources.RealExpression y5(y=hea4.medium_b.T_degC) 
    annotation (extent=[40,68; 140,88]);
  Modelica.Blocks.Sources.RealExpression y6(y=hea3.medium_b.T_degC) 
    annotation (extent=[40,48; 140,68]);
  Buildings.Utilities.Controls.AssertEquality ass4(startTime=0.2, threShold=2) 
    annotation (extent=[160,18; 180,38]);
  Modelica.Blocks.Sources.RealExpression y7(y=hea4.medium_a.T_degC) 
    annotation (extent=[40,28; 140,48]);
  Modelica.Blocks.Sources.RealExpression y8(y=hea3.medium_a.T_degC) 
    annotation (extent=[40,8; 140,28]);
  Buildings.HeatExchangers.HeaterCoolerIdeal hea5(redeclare package Medium = 
        Medium, Q0_flow=5000) "Heater and cooler" annotation (extent=[-54,-110;
        -34,-90]);
  Modelica.Blocks.Sources.Constant TDb1(
                                       k=293.15) "Drybulb temperature" 
    annotation (extent=[-200,-110; -180,-90]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou_3(
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
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin_3(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,-68; -148,-48],
                                                             rotation=0);
    Modelica.Blocks.Sources.Constant POut1(
                                          k=101325) 
      annotation (extent=[-200,-62; -180,-42]);
  Buildings.HeatExchangers.HeaterCoolerIdeal hea6(
                                                 redeclare package Medium = 
        Medium, Q0_flow=5000) "Heater and cooler" annotation (extent=[-12,-68;
        8,-48]);
  Buildings.HeatExchangers.HeaterCoolerIdeal hea7(redeclare package Medium = 
        Medium, Q0_flow=5000) "Heater and cooler" annotation (extent=[-54,-190;
        -34,-170]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou_4(
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
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin_4(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,-148; -148,-128],
                                                             rotation=0);
  Buildings.HeatExchangers.HeaterCoolerIdeal hea8(
                                                 redeclare package Medium = 
        Medium, Q0_flow=5000) "Heater and cooler" annotation (extent=[-12,-148;
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
  Buildings.Utilities.Controls.AssertEquality ass5(startTime=0.2) 
    annotation (extent=[160,-42; 180,-22]);
  Modelica.Blocks.Sources.RealExpression y9(y=hea6.medium_b.T_degC) 
    annotation (extent=[40,-32; 140,-12]);
  Modelica.Blocks.Sources.RealExpression y10(
                                            y=hea5.medium_b.T_degC) 
    annotation (extent=[40,-52; 140,-32]);
  Buildings.Utilities.Controls.AssertEquality ass6(startTime=0.2) 
    annotation (extent=[160,-82; 180,-62]);
  Modelica.Blocks.Sources.RealExpression y11(
                                            y=hea6.medium_a.T_degC) 
    annotation (extent=[40,-72; 140,-52]);
  Modelica.Blocks.Sources.RealExpression y12(
                                            y=hea5.medium_a.T_degC) 
    annotation (extent=[40,-92; 140,-72]);
  Buildings.Utilities.Controls.AssertEquality ass7(startTime=0.2, threShold=2) 
    annotation (extent=[160,-144; 180,-124]);
  Modelica.Blocks.Sources.RealExpression y13(
                                            y=hea8.medium_b.T_degC) 
    annotation (extent=[40,-134; 140,-114]);
  Modelica.Blocks.Sources.RealExpression y14(
                                            y=hea7.medium_b.T_degC) 
    annotation (extent=[40,-154; 140,-134]);
  Buildings.Utilities.Controls.AssertEquality ass8(startTime=0.2, threShold=2) 
    annotation (extent=[160,-184; 180,-164]);
  Modelica.Blocks.Sources.RealExpression y15(
                                            y=hea8.medium_a.T_degC) 
    annotation (extent=[40,-174; 140,-154]);
  Modelica.Blocks.Sources.RealExpression y16(
                                            y=hea7.medium_a.T_degC) 
    annotation (extent=[40,-194; 140,-174]);
  Buildings.Utilities.Controls.AssertEquality ass9(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,-280; 180,-260]);
  Modelica.Blocks.Sources.RealExpression y17(y=hea2.medium_b.T_degC) 
    annotation (extent=[40,-270; 140,-250]);
  Modelica.Blocks.Sources.RealExpression y18(y=hea5.medium_b.T_degC) 
    annotation (extent=[40,-290; 140,-270]);
  Buildings.Utilities.Controls.AssertEquality ass10(threShold=1E-2, startTime=
        0.3) 
    annotation (extent=[160,-240; 180,-220]);
  Modelica.Blocks.Sources.RealExpression y19(y=hea4.medium_a.T_degC) 
    annotation (extent=[40,-230; 140,-210]);
  Modelica.Blocks.Sources.RealExpression y20(y=hea7.medium_a.T_degC) 
    annotation (extent=[40,-250; 140,-230]);
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
  connect(y1.y, ass1.u1) annotation (points=[145,180; 154,180; 154,176; 158,176],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y2.y, ass1.u2) annotation (points=[145,160; 152,160; 152,164; 158,164],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y3.y, ass2.u1) annotation (points=[145,140; 154,140; 154,136; 158,136],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y4.y, ass2.u2) annotation (points=[145,120; 152,120; 152,124; 158,124],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y5.y, ass3.u1) annotation (points=[145,78; 154,78; 154,74; 158,74],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y6.y, ass3.u2) annotation (points=[145,58; 152,58; 152,62; 158,62],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y7.y, ass4.u1) annotation (points=[145,38; 154,38; 154,34; 158,34],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y8.y, ass4.u2) annotation (points=[145,18; 152,18; 152,22; 158,22],
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
  connect(y9.y,ass5. u1) annotation (points=[145,-22; 154,-22; 154,-26; 158,-26],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y10.y, ass5.u2) 
                         annotation (points=[145,-42; 152,-42; 152,-38; 158,-38],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y11.y, ass6.u1) 
                         annotation (points=[145,-62; 154,-62; 154,-66; 158,-66],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y12.y, ass6.u2) 
                         annotation (points=[145,-82; 152,-82; 152,-78; 158,-78],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y13.y, ass7.u1) 
                         annotation (points=[145,-124; 154,-124; 154,-128; 158,
        -128],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y14.y, ass7.u2) 
                         annotation (points=[145,-144; 152,-144; 152,-140; 158,
        -140],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y15.y, ass8.u1) 
                         annotation (points=[145,-164; 154,-164; 154,-168; 158,
        -168],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y16.y, ass8.u2) 
                         annotation (points=[145,-184; 152,-184; 152,-180; 158,
        -180],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(sou_3.port, res_5.port_a) annotation (points=[-148,-100; -126,-100;
        -126,-58; -100,-58], style(color=69, rgbcolor={0,127,255}));
  connect(sin_3.port, res_1.port_a) annotation (points=[-148,-58; -126,-58;
        -126,-100; -100,-100], style(color=69, rgbcolor={0,127,255}));
  connect(sin_4.port, res_6.port_a) annotation (points=[-148,-138; -125,-138;
        -125,-180; -100,-180], style(color=69, rgbcolor={0,127,255}));
  connect(sou_4.port, res_7.port_a) annotation (points=[-148,-180; -124,-180;
        -124,-138; -100,-138], style(color=69, rgbcolor={0,127,255}));
  connect(y17.y,ass9. u1) 
                         annotation (points=[145,-260; 154,-260; 154,-264; 158,
        -264],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y18.y,ass9. u2) 
                         annotation (points=[145,-280; 152,-280; 152,-276; 158,
        -276],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y19.y,ass10. u1) 
                         annotation (points=[145,-220; 154,-220; 154,-224; 158,
        -224],
      style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=1,
      rgbfillColor={255,0,0},
      fillPattern=1));
  connect(y20.y,ass10. u2) 
                         annotation (points=[145,-240; 152,-240; 152,-236; 158,
        -236],
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
  connect(gain.y, hea5.u) annotation (points=[-29,184; -26,184; -26,-66; -60,
        -66; -60,-94; -56,-94], style(color=74, rgbcolor={0,0,127}));
  connect(gain.y, hea7.u) annotation (points=[-29,184; -26,184; -26,-146; -64,
        -146; -64,-174; -56,-174], style(color=74, rgbcolor={0,0,127}));
end HeaterCoolerIdeal;
