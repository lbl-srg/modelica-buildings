model ExtraProperty 
  import Buildings;
    annotation (Diagram, Commands(file=
            "ExtraProperty.mos" "run"));
 package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir(extraPropertiesNames={"CO2"});
 // package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir;
  
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    initType=Modelica_Fluid.Types.Init.InitialValues,
    nP=4,
    V=2*3*3) "Mixing volume" 
                          annotation (extent=[70,30; 90,50]);
  annotation (Diagram, Coordsys(extent=[-100,-100; 180,180]));
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-100,-100; -80,-80]);
  Sources.PrescribedExtraPropertyFlowRate sou(redeclare package Medium = Medium) 
    annotation (extent=[-2,30; 18,50]);
  Modelica.Blocks.Sources.Constant step(k=8.18E-6) 
    annotation (extent=[-80,30; -60,50]);
  Buildings.Fluids.Sensors.ExtraPropertyOnePort senVol(
                    redeclare package Medium = Medium) "Sensor at volume" 
    annotation (extent=[100,50; 120,70]);
  Buildings.Fluids.Sensors.ExtraPropertyOnePort senSou(
                    redeclare package Medium = Medium, substanceName="CO2") 
    "Sensor at source" 
    annotation (extent=[100,90; 120,110]);
  Modelica.Blocks.Sources.Constant m_flow(k=15*1.2/3600) "Fresh air flow rate" 
    annotation (extent=[-80,-14; -60,6]);
  Sources.PrescribedMassFlowRate_phX mSou(redeclare package Medium = Medium, h=
        293.15) annotation (extent=[2,-20; 22,0]);
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (extent=[-40,-54; -20,-34]);
  Sources.PrescribedMassFlowRate_phX mSin(redeclare package Medium = Medium, h=
        293.15) annotation (extent=[0,-60; 20,-40]);
  Conversions.MassFractionVolumeFraction masFraSou(MMMea=Modelica.Media.
        IdealGases.Common.SingleGasesData.CO2.MM) 
    annotation (extent=[140,120; 160,140]);
  Conversions.MassFractionVolumeFraction masFraVol(MMMea=Modelica.Media.
        IdealGases.Common.SingleGasesData.CO2.MM) 
    annotation (extent=[140,50; 160,70]);
  RelativePressure dp(redeclare package Medium = Medium) 
    annotation (extent=[102,-38; 122,-18]);
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(startTime=0,
      threShold=1E-8) 
    annotation (extent=[136,-88; 156,-68]);
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero signal" 
    annotation (extent=[78,-94; 98,-74]);
  Buildings.Fluids.Sensors.Pressure preSen(redeclare package Medium = Medium) 
    "Pressure sensor" annotation (extent=[34,118; 54,138]);
equation 
  connect(sou.port, vol.port[1]) 
    annotation (points=[18,40; 49,40; 49,39.25; 80,39.25],
                                        style(color=69, rgbcolor={0,127,255}));
  connect(step.y, sou.mC_flow_in[1]) annotation (points=[-59,40; -4.1,40],  style(
        color=74, rgbcolor={0,0,127}));
  connect(sou.port, senSou.port) annotation (points=[18,40; 26,40; 26,90; 110,
        90], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=58,
      rgbfillColor={0,127,0},
      fillPattern=1));
  connect(vol.port[2], senVol.port) annotation (points=[80,39.75; 110,39.75;
        110,50], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=58,
      rgbfillColor={0,127,0},
      fillPattern=1));
  connect(m_flow.y, mSou.m_flow_in) annotation (points=[-59,-4; -43.575,-4; 
        -43.575,-4; -28.15,-4; -28.15,-4; 2.7,-4], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=58,
      rgbfillColor={0,127,0},
      fillPattern=1));
  connect(mSou.port, vol.port[3]) annotation (points=[22,-10; 80,-10; 80,40.25],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=58,
      rgbfillColor={0,127,0},
      fillPattern=1));
  connect(m_flow.y, gain.u) annotation (points=[-59,-4; -50,-4; -50,-44; -42,
        -44], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=58,
      rgbfillColor={0,127,0},
      fillPattern=1));
  connect(gain.y, mSin.m_flow_in) annotation (points=[-19,-44; 0.7,-44], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=58,
      rgbfillColor={0,127,0},
      fillPattern=1));
  connect(mSin.port, vol.port[4]) annotation (points=[20,-50; 80,-50; 80,40.75],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=58,
      rgbfillColor={0,127,0},
      fillPattern=1));
  connect(senSou.C, masFraSou.m) annotation (points=[121,100; 130,100; 130,130;
        139.8,130], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
  connect(senVol.C, masFraVol.m) annotation (points=[121,60; 139.8,60], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
  connect(mSou.port, dp.port_a) annotation (points=[22,-10; 62,-10; 62,-28; 101,
        -28], style(color=69, rgbcolor={0,127,255}));
  connect(mSin.port, dp.port_b) annotation (points=[20,-50; 136,-50; 136,-28;
        123,-28], style(color=69, rgbcolor={0,127,255}));
  connect(dp.p_rel, assertEquality.u1) annotation (points=[112,-37; 114,-37;
        114,-72; 134,-72], style(color=74, rgbcolor={0,0,127}));
  connect(zer.y, assertEquality.u2) 
    annotation (points=[99,-84; 134,-84], style(color=74, rgbcolor={0,0,127}));
  connect(preSen.port, sou.port) annotation (points=[44,118; 26,118; 26,40; 18,
        40],
      style(color=69, rgbcolor={0,127,255}));
end ExtraProperty;
