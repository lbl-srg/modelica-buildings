model Stratified "Test model for stratified tank" 
  
  annotation(Diagram, Commands(file="Stratified.mos" "run"),
    Documentation(info="<html>
This test model compares two tank models. The only difference between
the two tank models is that one uses the model from Stefan Wischhusen
that reduces the numerical diffusion that is induced by the upwind
discretization scheme.
</html>"));
 package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
  
  Buildings.Fluids.Storage.Stratified tanSim(
    redeclare package Medium = Medium,
    nSeg=10,
    hTan=3,
    dIns=0.3,
    VTan=5) "Tank"      annotation (extent=[-20,0; 0,20]);
    Modelica.Blocks.Sources.TimeTable TWat(table=[0,273.15 + 40; 3600,273.15 +
        40; 3600,273.15 + 20; 7200,273.15 + 20]) "Water temperature" 
                 annotation (extent=[-100,0; -80,20]);
  Sources.PrescribedBoundary_pTX sou_1(
    p=300000 + 5000,
    T=273.15 + 50,
    redeclare package Medium = Medium) 
                          annotation (extent=[-60,0; -40,20]);
  Sources.PrescribedBoundary_pTX sin_1(
    p=300000,
    redeclare package Medium = Medium,
    T=273.15 + 20)        annotation (extent=[86,0; 66,20],  rotation=0);
    FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5000,
    m0_flow=10) 
             annotation (extent=[36,0; 56,20]);
  Buildings.Fluids.Storage.StratifiedEnhanced tanEnh(
    redeclare package Medium = Medium,
    nSeg=10,
    a=1E-4,
    hTan=3,
    dIns=0.3,
    VTan=5) "Tank"      annotation (extent=[-18,-38; 2,-18]);
  Sources.PrescribedBoundary_pTX sou_2(
    p=300000 + 5000,
    T=273.15 + 50,
    redeclare package Medium = Medium) 
                          annotation (extent=[-58,-38; -38,-18]);
  Sources.PrescribedBoundary_pTX sin_2(
    p=300000,
    redeclare package Medium = Medium,
    T=273.15 + 20)        annotation (extent=[88,-38; 68,-18],
                                                             rotation=0);
    FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5000,
    m0_flow=10) 
             annotation (extent=[38,-38; 58,-18]);
  Buildings.Fluids.Sensors.EnthalpyFlowRate HOut_flow(redeclare package Medium 
      = Medium) "Enthalpy flow rate" annotation (extent=[12,2; 28,18]);
  Buildings.Fluids.Sensors.EnthalpyFlowRate HOut_flow1(redeclare package Medium
      = Medium) "Enthalpy flow rate" annotation (extent=[6,-36; 22,-20]);
  Modelica.Blocks.Continuous.Integrator dH 
    "Differenz in enthalpy (should be zero at steady-state)" 
    annotation (extent=[70,-80; 90,-60]);
  Modelica.Blocks.Math.Add add(k2=-1) annotation (extent=[34,-80; 54,-60]);
    Modelica.Blocks.Sources.TimeTable P(table=[0,300000; 4200,300000; 4200,
        305000; 7200,305000; 7200,310000; 10800,310000; 10800,305000]) 
    "Pressure boundary condition" 
                 annotation (extent=[20,60; 40,80]);
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/86400,
    amplitude=10,
    offset=273.15 + 20) annotation (extent=[-90,62; -70,82]);
  Modelica.Thermal.HeatTransfer.PrescribedTemperature TBCSid2 
    "Boundary condition for tank" annotation (extent=[-40,50; -28,62]);
  Modelica.Thermal.HeatTransfer.PrescribedTemperature TBCSid1 
    "Boundary condition for tank" annotation (extent=[-40,84; -28,96]);
  Modelica.Thermal.HeatTransfer.PrescribedTemperature TBCTop1 
    "Boundary condition for tank" annotation (extent=[-40,66; -28,78]);
  Modelica.Thermal.HeatTransfer.PrescribedTemperature TBCTop2 
    "Boundary condition for tank" annotation (extent=[-40,32; -28,44]);
equation 
  connect(TWat.y, sou_1.T_in) annotation (points=[-79,10; -62,10], style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res_1.port_b, sin_1.port) annotation (points=[56,10; 66,10], style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(sou_1.port, tanSim.port_a) annotation (points=[-40,10; -20,10], style(
        color=69, rgbcolor={0,127,255}));
  connect(res_2.port_b,sin_2. port) annotation (points=[58,-28; 68,-28],
                                                                       style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(sou_2.port, tanEnh.port_a) annotation (points=[-38,-28; -18,-28],
      style(color=69, rgbcolor={0,127,255}));
  connect(TWat.y, sou_2.T_in) annotation (points=[-79,10; -70,10; -70,-28; -60,
        -28], style(color=74, rgbcolor={0,0,127}));
  connect(tanSim.port_b, HOut_flow.port_a) annotation (points=[5.55112e-16,10; 
        12,10], style(color=69, rgbcolor={0,127,255}));
  connect(HOut_flow.port_b, res_1.port_a) 
    annotation (points=[28,10; 36,10], style(color=69, rgbcolor={0,127,255}));
  connect(tanEnh.port_b, HOut_flow1.port_a) 
    annotation (points=[2,-28; 6,-28], style(color=69, rgbcolor={0,127,255}));
  connect(HOut_flow1.port_b, res_2.port_a) annotation (points=[22,-28; 38,-28],
      style(color=69, rgbcolor={0,127,255}));
  connect(add.y, dH.u) 
    annotation (points=[55,-70; 68,-70], style(color=74, rgbcolor={0,0,127}));
  connect(HOut_flow.H_flow, add.u1) annotation (points=[20,1.2; 20,-64; 32,-64],
      style(color=74, rgbcolor={0,0,127}));
  connect(HOut_flow1.H_flow, add.u2) annotation (points=[14,-36.8; 14,-76; 32,
        -76], style(color=74, rgbcolor={0,0,127}));
  connect(P.y, sin_1.p_in) annotation (points=[41,70; 100,70; 100,16; 88,16],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(P.y, sin_2.p_in) annotation (points=[41,70; 100,70; 100,-22; 90,-22],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(sine.y, TBCSid1.T) annotation (points=[-69,72; -55.5,72; -55.5,90;
        -41.2,90], style(color=74, rgbcolor={0,0,127}));
  connect(sine.y, TBCTop1.T) annotation (points=[-69,72; -41.2,72], style(color=
         74, rgbcolor={0,0,127}));
  connect(sine.y, TBCSid2.T) annotation (points=[-69,72; -56,72; -56,56; -41.2,
        56], style(color=74, rgbcolor={0,0,127}));
  connect(sine.y, TBCTop2.T) annotation (points=[-69,72; -56,72; -56,38; -41.2,
        38], style(color=74, rgbcolor={0,0,127}));
  connect(TBCSid2.port, tanEnh.heaPorSid) annotation (points=[-28,56; -24,56; 
        -24,-12; -2,-12; -2,-28; -2.4,-28], style(color=42, rgbcolor={191,0,0}));
  connect(TBCTop2.port, tanEnh.heaPorTop) annotation (points=[-28,38; -26,38; 
        -26,-14; -6,-14; -6,-20.6], style(color=42, rgbcolor={191,0,0}));
end Stratified;
