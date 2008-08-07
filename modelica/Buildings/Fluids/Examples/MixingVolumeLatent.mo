model MixingVolumeLatent 
  import Buildings;
    annotation (Diagram, Commands(file=
            "MixingVolumeLatent.mos" "run"),
    Coordsys(extent=[-100,-100; 180,100]));
  
// package Medium = Buildings.Media.SimpleAirPTDecoupled;
 package Medium = Buildings.Media.PerfectGases.MoistAir;
  Buildings.Fluids.Components.MixingVolumeLatent vol1(
    redeclare package Medium = Medium,
    V=1,
    nP=1,
    initType=Modelica_Fluid.Types.Init.InitialValues) "Volume" 
          annotation (extent=[50,-46; 70,-26]);
  Modelica.Thermal.HeatTransfer.TemperatureSensor TSen "Temperature sensor" 
    annotation (extent=[-68,10; -48,30]);
  Modelica_Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium) 
    annotation (extent=[90,0; 110,20]);
  Modelica.Blocks.Math.Gain gain(k=10000) 
                                       annotation (extent=[-20,-50; 0,-30]);
  Modelica.Blocks.Math.Feedback feeBac annotation (extent=[-50,-50; -30,-30]);
  Modelica.Blocks.Sources.Constant XSet(k=0.005) 
    "Set point for water mass fraction" annotation (extent=[-80,-50; -60,-30]);
  Modelica.Thermal.HeatTransfer.PrescribedHeatFlow preHeaFlo 
    annotation (extent=[12,50; 32,70]);
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 5) 
    "Set point for temperature" annotation (extent=[-80,50; -60,70]);
  Modelica.Blocks.Math.Gain gain1(k=100)  annotation (extent=[-16,50; 4,70]);
  Modelica.Blocks.Math.Feedback feeBac1 annotation (extent=[-50,50; -30,70]);
  Buildings.Utilities.Psychrometrics.HumidityRatioPressure humRat(redeclare package 
      Medium = Medium) 
    "Conversion from humidity ratio to partial water vapor pressure"
    annotation (extent=[-20,-90; 0,-70]);
  Buildings.Utilities.Psychrometrics.DewPointTemperature dewPoi 
    "Dew point temperature" annotation (extent=[10,-74; 30,-54]);
  Modelica.Thermal.HeatTransfer.HeatFlowSensor heatFlowSensor
    annotation (extent=[40,50; 60,70]);
  Modelica.Blocks.Continuous.Integrator QSen "Sensible heat transfer"
    annotation (extent=[140,20; 160,40]);
  Modelica.Blocks.Continuous.Integrator QLat "Latent heat transfer"
    annotation (extent=[140,-20; 160,0]);
equation 
  connect(vol1.thermalPort, TSen.port) annotation (points=[60,-26.2; 60,0; -80,
        0; -80,20; -68,20],
                    style(
      color=42,
      rgbcolor={191,0,0},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(pressure.port, vol1.port[1]) annotation (points=[100,-5.55112e-16; 
        100,-36; 60,-36],       style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(XSet.y, feeBac.u1) annotation (points=[-59,-40; -48,-40],
                                                                  style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(feeBac.y, gain.u) annotation (points=[-31,-40; -22,-40],
                                                                 style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(vol1.X_out[1], feeBac.u2) annotation (points=[72,-42; 80,-42; 80,-100; 
        -40,-100; -40,-48],
                          style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(gain1.y, preHeaFlo.Q_flow) annotation (points=[5,60; 12,60],   style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TSet.y, feeBac1.u1) annotation (points=[-59,60; -48,60], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(feeBac1.y, gain1.u) annotation (points=[-31,60; -18,60], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TSen.T, feeBac1.u2) annotation (points=[-48,20; -40,20; -40,52],
                 style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(gain.y, vol1.QLat_flow) annotation (points=[1,-40; 48,-40],
              style(color=74, rgbcolor={0,0,127}));
  connect(dewPoi.T, vol1.TLiq) annotation (points=[31,-64; 44,-64; 44,-46; 48,
        -46], style(color=3, rgbcolor={0,0,255}));
  connect(dewPoi.p_w, humRat.p_w) annotation (points=[9,-64.2; 10,-64.2; 10,-64; 
        -28,-64; -28,-73; -19,-73], style(color=3, rgbcolor={0,0,255}));
  connect(vol1.X_out, humRat.X) annotation (points=[72,-42; 80,-42; 80,-100; 
        -32,-100; -32,-87; -19,-87], style(color=74, rgbcolor={0,0,127}));
  connect(preHeaFlo.port, heatFlowSensor.port_a)
    annotation (points=[32,60; 40,60], style(color=42, rgbcolor={191,0,0}));
  connect(heatFlowSensor.port_b, vol1.thermalPort)
    annotation (points=[60,60; 60,-26.2], style(color=42, rgbcolor={191,0,0}));
  connect(heatFlowSensor.Q_flow, QSen.u) annotation (points=[50,50; 50,30; 138,
        30], style(color=74, rgbcolor={0,0,127}));
  connect(gain.y, QLat.u) annotation (points=[1,-40; 40,-40; 40,-10; 138,-10], 
      style(color=74, rgbcolor={0,0,127}));
end MixingVolumeLatent;
