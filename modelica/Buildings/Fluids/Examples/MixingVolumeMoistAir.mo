model MixingVolumeMoistAir 
  import Buildings;
    annotation (Diagram, Commands(file=
            "MixingVolumeMoistAir.mos" "run"),
    Coordsys(extent=[-100,-160; 180,160]));
  
// package Medium = Buildings.Media.PerfectGases.MoistAir;
   package Medium = Buildings.Media.GasesPTDecoupled.MoistAir;
//   package Medium = Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid;
  
  Buildings.Fluids.MixingVolumes.MixingVolumeMoistAir vol1(
    redeclare package Medium = Medium,
    V=1,
    nP=2) "Volume" 
          annotation (extent=[50,-10; 70,10]);
  Modelica.Thermal.HeatTransfer.TemperatureSensor TSen "Temperature sensor" 
    annotation (extent=[-68,80; -48,100]);
  Modelica.Blocks.Sources.Constant XSet(k=0.005) 
    "Set point for water mass fraction" annotation (extent=[-80,-60; -60,-40]);
  Modelica.Thermal.HeatTransfer.PrescribedHeatFlow preHeaFlo 
    annotation (extent=[36,120; 56,140]);
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 20) 
    "Set point for temperature" annotation (extent=[-80,120; -60,140]);
  Buildings.Utilities.Psychrometrics.HumidityRatioPressure humRat 
    "Conversion from humidity ratio to partial water vapor pressure" 
    annotation (extent=[-20,-118; 0,-98]);
  Buildings.Utilities.Psychrometrics.DewPointTemperature dewPoi 
    "Dew point temperature" annotation (extent=[8,-90; 28,-70]);
  Modelica.Thermal.HeatTransfer.HeatFlowSensor heatFlowSensor 
    annotation (extent=[64,120; 84,140]);
  Modelica.Blocks.Continuous.Integrator QSen "Sensible heat transfer" 
    annotation (extent=[140,100; 160,120]);
  Modelica.Blocks.Continuous.Integrator QWat "Enthalpy of extracted water" 
    annotation (extent=[140,60; 160,80]);
  Modelica.Blocks.Sources.RealExpression HWat_flow(y=vol1.HWat_flow) 
    "MoistAir heat flow rate" annotation (extent=[112,60; 132,80]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX sou(
    redeclare package Medium = Medium,
    T=293.15,
    m_flow=0.01) annotation (extent=[-38,-10; -18,10]);
  Modelica_Fluid.Sources.FixedBoundary_pTX sin(redeclare package Medium = 
        Medium, T=293.15) annotation (extent=[130,-10; 150,10], rotation=180);
  Modelica.Blocks.Continuous.LimPID PI(
    Ni=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1000,
    k=1,
    Ti=1) 
    annotation (extent=[-40,120; -20,140]);
  Modelica.Blocks.Continuous.LimPID PI1(
    Ni=0.1,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=10,
    yMax=1,
    yMin=-1) 
    annotation (extent=[-50,-60; -30,-40]);
  Modelica_Fluid.Sensors.MassFlowRate mIn_flow(redeclare package Medium = 
        Medium) annotation (extent=[6,-10; 26,10]);
  Modelica_Fluid.Sensors.MassFlowRate mOut_flow(redeclare package Medium = 
        Medium) annotation (extent=[84,-10; 104,10]);
  Modelica.Blocks.Math.Add dM_flow(k2=-1) annotation (extent=[120,-70; 140,-50]);
  Modelica.Blocks.Math.Gain gai(k=200) annotation (extent=[2,120; 22,140]);
  Modelica.Blocks.Math.Gain gai1(k=0.1) annotation (extent=[-20,-60; 0,-40]);
equation 
  connect(vol1.thermalPort, TSen.port) annotation (points=[60,9.8; 60,70; -80,
        70; -80,90; -68,90],
                    style(
      color=42,
      rgbcolor={191,0,0},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(dewPoi.p_w, humRat.p_w) annotation (points=[29,-80; 32,-80; 32,-92; 
        -28,-92; -28,-101; -19,-101],
                                    style(color=3, rgbcolor={0,0,255}));
  connect(preHeaFlo.port, heatFlowSensor.port_a) 
    annotation (points=[56,130; 64,130],
                                       style(color=42, rgbcolor={191,0,0}));
  connect(heatFlowSensor.port_b, vol1.thermalPort) 
    annotation (points=[84,130; 84,90; 60,90; 60,9.8],
                                          style(color=42, rgbcolor={191,0,0}));
  connect(heatFlowSensor.Q_flow, QSen.u) annotation (points=[74,120; 74,110;
        138,110],
             style(color=74, rgbcolor={0,0,127}));
  connect(HWat_flow.y,QWat. u) annotation (points=[133,70; 138,70],   style(
        color=74, rgbcolor={0,0,127}));
  connect(TSet.y, PI.u_s) 
    annotation (points=[-59,130; -42,130],
                                         style(color=74, rgbcolor={0,0,127}));
  connect(TSen.T, PI.u_m) annotation (points=[-48,90; -30,90; -30,118],style(
        color=74, rgbcolor={0,0,127}));
  connect(XSet.y, PI1.u_s) annotation (points=[-59,-50; -52,-50], style(color=
          74, rgbcolor={0,0,127}));
  connect(sou.port, mIn_flow.port_a) annotation (points=[-18,6.10623e-16; -6,
        6.10623e-16; -6,6.10623e-16; 6,6.10623e-16], style(color=69, rgbcolor={
          0,127,255}));
  connect(mIn_flow.port_b, vol1.port[1]) annotation (points=[26,6.10623e-16; 44,
        6.10623e-16; 44,-0.5; 60,-0.5], style(color=69, rgbcolor={0,127,255}));
  connect(mOut_flow.port_b, sin.port) annotation (points=[104,6.10623e-16; 112,
        6.10623e-16; 112,1.72421e-15; 130,1.72421e-15], style(color=69,
        rgbcolor={0,127,255}));
  connect(mOut_flow.port_a, vol1.port[2]) annotation (points=[84,6.10623e-16; 
        72,6.10623e-16; 72,0.5; 60,0.5], style(color=69, rgbcolor={0,127,255}));
  connect(mOut_flow.m_flow, dM_flow.u1) annotation (points=[94,-11; 94,-54; 118,
        -54], style(color=74, rgbcolor={0,0,127}));
  connect(mIn_flow.m_flow, dM_flow.u2) annotation (points=[16,-11; 16,-54; 60,
        -54; 60,-66; 118,-66], style(color=74, rgbcolor={0,0,127}));
  connect(PI.y, gai.u) annotation (points=[-19,130; -6.66134e-16,130],
                                                                     style(
        color=74, rgbcolor={0,0,127}));
  connect(gai.y, preHeaFlo.Q_flow) 
    annotation (points=[23,130; 36,130],
                                       style(color=74, rgbcolor={0,0,127}));
  connect(PI1.y, gai1.u) annotation (points=[-29,-50; -22,-50], style(color=74,
        rgbcolor={0,0,127}));
  connect(gai1.y, vol1.mWat_flow) annotation (points=[1,-50; 32,-50; 32,-2; 48,
        -2], style(color=74, rgbcolor={0,0,127}));
  connect(dewPoi.T, vol1.TWat) annotation (points=[7,-80; 4,-80; 4,-66; 42,-66; 
        42,-8; 48,-8],
              style(color=3, rgbcolor={0,0,255}));
  connect(vol1.XWat, PI1.u_m) annotation (points=[72,-4; 80,-4; 80,-134; -40,
        -134; -40,-62], style(color=74, rgbcolor={0,0,127}));
  connect(vol1.XWat, humRat.XWat) annotation (points=[72,-4; 80,-4; 80,-134; 
        -28,-134; -28,-115; -19,-115], style(color=74, rgbcolor={0,0,127}));
end MixingVolumeMoistAir;
