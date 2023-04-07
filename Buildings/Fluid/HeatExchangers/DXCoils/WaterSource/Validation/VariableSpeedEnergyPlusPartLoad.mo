within Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Validation;
model VariableSpeedEnergyPlusPartLoad
  "Validation model for variable speed DX coil under part load condition"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air "Medium model for air";
  package MediumWater = Buildings.Media.Water "Medium model for water";

  parameter Modelica.Units.SI.Power Q_flow_nominal=datCoi.sta[1].nomVal.Q_flow_nominal
    "Nominal power";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal=1000
    "Pressure drop at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal=40000
    "Pressure drop at mCon_flow_nominal";

  WaterSource.VariableSpeed varSpeDX(
    redeclare package MediumEva = MediumAir,
    redeclare package MediumCon = MediumWater,
    datCoi=datCoi,
    dpEva_nominal=dpEva_nominal,
    dpCon_nominal=dpCon_nominal,
    minSpeRat=0.05,
    TEva_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

 parameter Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.DXCoil datCoi(
  nSta=10,minSpeRat=0.1,
    sta={Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-1524.1,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.16648632,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=1000/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-1877.9,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.1849848,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=1500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-2226.6,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.20348328,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=2000/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-2911.3,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.24048024,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=2500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-3581.7,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.2774772,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=3000/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4239.5,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.31447416,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=3500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4885.7,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.35147112,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=4000/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-5520.7,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.38846808,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=4500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-6144.8,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.42546504,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
       perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=5000/60,
       nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-6758,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.462462,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
       perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves.Curve_I())})
          "Coil data"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
 Modelica.Blocks.Sources.TimeTable speRat(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,0.835144907; 28800,0.835144907; 28800,
        0.725963941; 32400,0.725963941; 32400,0.701309629; 36000,0.701309629;
        36000,0.726095313; 39600,0.726095313; 39600,0.756509478; 43200,
        0.756509478; 43200,0.760310507; 46800,0.760310507; 46800,0.789773752;
        50400,0.789773752; 50400,0.785538594; 54000,0.785538594; 54000,
        0.762755548; 57600,0.762755548; 57600,0.705369369; 61200,0.705369369;
        61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0;
        75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus speed ratio for this model"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Modelica.Blocks.Sources.TimeTable TCIn(table=[0,13.86251622; 3600,13.86251622;
        3600,13.86251622; 7200,13.86251622; 7200,13.86251622; 10800,13.86251622;
        10800,13.86251622; 14400,13.86251622; 14400,13.86251622; 18000,13.86251622;
        18000,13.86251622; 21600,13.86251622; 21600,13.86251622; 25200,13.86251622;
        25200,13.76067467; 28800,13.76067467; 28800,13.62587063; 32400,13.62587063;
        32400,13.56765455; 36000,13.56765455; 36000,13.51654003; 39600,13.51654003;
        39600,13.49422548; 43200,13.49422548; 43200,13.49310136; 46800,13.49310136;
        46800,13.50453648; 50400,13.50453648; 50400,13.52335024; 54000,13.52335024;
        54000,13.54653059; 57600,13.54653059; 57600,13.57254285; 61200,13.57254285;
        61200,13.60087284; 64800,13.60087284; 64800,13.60087284; 68400,13.60087284;
        68400,13.60087284; 72000,13.60087284; 72000,13.60087284; 75600,13.60087284;
        75600,13.60087284; 79200,13.60087284; 79200,13.60087284; 82800,13.60087284;
        82800,13.60087284; 86400,13.60087284])
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{160,-40},{140,-20}})));
  Modelica.Blocks.Sources.TimeTable TEvaIn(table=[0,27.30566381; 3600,27.30566381;
        3600,27.21827779; 7200,27.21827779; 7200,27.11647599; 10800,27.11647599;
        10800,27.0058024; 14400,27.0058024; 14400,26.88972232; 18000,26.88972232;
        18000,26.77810041; 21600,26.77810041; 21600,26.79816007; 25200,26.79816007;
        25200,24.38258647; 28800,24.38258647; 28800,23.60631205; 32400,23.60631205;
        32400,23.35999766; 36000,23.35999766; 36000,23.35884656; 39600,23.35884656;
        39600,23.35829243; 43200,23.35829243; 43200,23.35804345; 46800,23.35804345;
        46800,23.35801611; 50400,23.35801611; 50400,23.35827236; 54000,23.35827236;
        54000,23.3583018; 57600,23.3583018; 57600,23.35814534; 61200,23.35814534;
        61200,25.62821073; 64800,25.62821073; 64800,26.495716; 68400,26.495716;
        68400,26.7309828; 72000,26.7309828; 72000,27.15903639; 75600,27.15903639;
        75600,27.26532973; 79200,27.26532973; 79200,27.38959551; 82800,27.38959551;
        82800,27.37275176; 86400,27.37275176])
     "Coil inlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Modelica.Blocks.Sources.TimeTable XEvaIn(table=[0,0.00538; 3600,0.00538; 3600,
        0.00538; 7200,0.00538; 7200,0.00537; 10800,0.00537; 10800,0.00536;
        14400,0.00536; 14400,0.00535; 18000,0.00535; 18000,0.00534; 21600,
        0.00534; 21600,0.00534; 25200,0.00534; 25200,0.00538; 28800,0.00538;
        28800,0.00544; 32400,0.00544; 32400,0.00546; 36000,0.00546; 36000,
        0.00551; 39600,0.00551; 39600,0.00551; 43200,0.00551; 43200,0.00551;
        46800,0.00551; 46800,0.00546; 50400,0.00546; 50400,0.00546; 54000,
        0.00546; 54000,0.00548; 57600,0.00548; 57600,0.00551; 61200,0.00551;
        61200,0.00541; 64800,0.00541; 64800,0.0054; 68400,0.0054; 68400,0.0054;
        72000,0.0054; 72000,0.0054; 75600,0.0054; 75600,0.00539; 79200,0.00539;
        79200,0.00539; 82800,0.00539; 82800,0.00538; 86400,0.00538])
    "Water fraction of moist air"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Routing.Multiplex2 mux "Converts in an array"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Utilities.IO.BCVTB.From_degC TCIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{120,-40},{100,-20}})));
  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Math.Mean TOutMea(f=1/3600)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Utilities.IO.BCVTB.To_degC TOutDegC
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Sources.RealExpression TOut(y=varSpeDX.eva.vol.T)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Math.Mean XEvaOutMea(f=1/3600)
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Modelica.Blocks.Sources.RealExpression XEvaOut(y=sum(varSpeDX.eva.vol.Xi))
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Modelica.Blocks.Math.Mean Q_flowMea(f=1/3600) "Mean of cooling rate"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Math.Mean Q_flowSenMea(f=1/3600)
    "Mean of sensible cooling rate"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Modelica.Blocks.Math.Mean PMea(f=1/3600) "Mean of power"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Constant XEvaInMoiAir(k=1.0) "Moist air fraction = 1"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Modelica.Blocks.Sources.TimeTable TOutEPlu(table=[0,27.30566381; 3600,27.30566381;
        3600,27.21827779; 7200,27.21827779; 7200,27.11647599; 10800,27.11647599;
        10800,27.0058024; 14400,27.0058024; 14400,26.88972232; 18000,26.88972232;
        18000,26.77810041; 21600,26.77810041; 21600,26.79816007; 25200,26.79816007;
        25200,8.558164875; 28800,8.558164875; 28800,8.425553165; 32400,8.425553165;
        32400,8.090261936; 36000,8.090261936; 36000,8.014264329; 39600,8.014264329;
        39600,7.933216144; 43200,7.933216144; 43200,7.930680761; 46800,7.930680761;
        46800,7.787349788; 50400,7.787349788; 50400,7.794251378; 54000,7.794251378;
        54000,7.88577408; 57600,7.88577408; 57600,8.108580275; 61200,8.108580275;
        61200,25.62821073; 64800,25.62821073; 64800,26.495716; 68400,26.495716;
        68400,26.7309828; 72000,26.7309828; 72000,27.15903639; 75600,27.15903639;
        75600,27.26532973; 79200,27.26532973; 79200,27.38959551; 82800,27.38959551;
        82800,27.37275176; 86400,27.37275176])
    "EnergyPlus result: outlet temperature"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowEPlu(table=[0,-1e-07; 3600,-1e-07; 3600,
        -1e-07; 7200,-1e-07; 7200,-1e-07; 10800,-1e-07; 10800,-1e-07; 14400,-1e-07;
        14400,-1e-07; 18000,-1e-07; 18000,-1e-07; 21600,-1e-07; 21600,-1e-07; 25200,
        -1e-07; 25200,-5993.93491; 28800,-5993.93491; 28800,-5241.352381; 32400,
        -5241.352381; 32400,-5109.221236; 36000,-5109.221236; 36000,-5276.319149;
        39600,-5276.319149; 39600,-5479.659005; 43200,-5479.659005; 43200,-5505.142371;
        46800,-5505.142371; 46800,-5698.989696; 50400,-5698.989696; 50400,-5669.788807;
        54000,-5669.788807; 54000,-5517.891066; 57600,-5517.891066; 57600,-5136.545718;
        61200,-5136.545718; 61200,-1e-07; 64800,-1e-07; 64800,-1e-07; 68400,-1e-07;
        68400,-1e-07; 72000,-1e-07; 72000,-1e-07; 75600,-1e-07; 75600,-1e-07; 79200,
        -1e-07; 79200,-1e-07; 82800,-1e-07; 82800,-1e-07; 86400,-1e-07])
        "EnergyPlus result: heat flow"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowSenEPlu(table=[0,0; 3600,0; 3600,0; 7200,
        0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,-5964.489051; 28800,-5964.489051; 28800,-5206.664409;
        32400,-5206.664409; 32400,-5027.556976; 36000,-5027.556976; 36000,-5184.015367;
        39600,-5184.015367; 39600,-5373.829789; 43200,-5373.829789; 43200,-5395.020923;
        46800,-5395.020923; 46800,-5603.430852; 50400,-5603.430852; 50400,-5578.150113;
        54000,-5578.150113; 54000,-5423.518277; 57600,-5423.518277; 57600,-5042.653124;
        61200,-5042.653124; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0;
        72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: sensible heat flow "
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Math.Division shrEPlu "EnergyPlus result: SHR"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Modelica.Blocks.Sources.TimeTable XEvaOutEPlu(table=[0,0.00525; 3600,0.00525;
        3600,0.00524; 7200,0.00524; 7200,0.00523; 10800,0.00523; 10800,0.00523;
        14400,0.00523; 14400,0.00522; 18000,0.00522; 18000,0.00521; 21600,0.00521;
        21600,0.00521; 25200,0.00521; 25200,0.00521; 28800,0.00521; 28800,0.00522;
        32400,0.00522; 32400,0.00522; 36000,0.00522; 36000,0.00523; 39600,0.00523;
        39600,0.00524; 43200,0.00524; 43200,0.00525; 46800,0.00525; 46800,0.00522;
        50400,0.00522; 50400,0.00522; 54000,0.00522; 54000,0.00523; 57600,0.00523;
        57600,0.00524; 61200,0.00524; 61200,0.00527; 64800,0.00527; 64800,0.00526;
        68400,0.00526; 68400,0.00526; 72000,0.00526; 72000,0.00526; 75600,0.00526;
        75600,0.00526; 79200,0.00526; 79200,0.00525; 82800,0.00525; 82800,0.00525;
        86400,0.00525])
    "EnergyPlus result: outlet water mass fraction"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Modelica.Blocks.Sources.TimeTable PEPlu(table=[0,0; 3600,0; 3600,0; 7200,0; 7200,
        0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,1034.300037; 28800,1034.300037; 28800,900.2508689; 32400,
        900.2508689; 32400,875.7430481; 36000,875.7430481; 36000,903.2013238; 39600,
        903.2013238; 39600,937.554675; 43200,937.554675; 43200,941.9339651; 46800,
        941.9339651; 46800,975.1567966; 50400,975.1567966; 50400,970.6256299; 54000,
        970.6256299; 54000,945.3102202; 57600,945.3102202; 57600,880.6992676; 61200,
        880.6992676; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,
        0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: electric power"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Modelica.Blocks.Sources.RealExpression XEvaInMod(y=XEvaIn.y/(1 + XEvaIn.y))
    "Modified XEvaIn"
    annotation (Placement(transformation(extent={{-140,-54},{-120,-34}})));
  Modelica.Blocks.Sources.RealExpression XEvaOutEPluMod(y=XEvaOutEPlu.y/(1 + XEvaOutEPlu.y))
    "Modified XEvaOut of energyPlus to comapre with the model results"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Modelica.Blocks.Math.Add QCoo_flow "Total cooling heat flow rate"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Sources.MassFlowSource_T souAir(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    nPorts=1,
    m_flow=1.5,
    use_m_flow_in=true,
    use_X_in=true,
    T=299.85) "Source on air side"
    annotation (Placement(transformation(extent={{-52,10},{-32,30}})));
  Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumAir,
    nPorts=1,
    p(displayUnit="Pa"))
    "Sink on air side"
    annotation (Placement(transformation(extent={{58,10},{38,30}})));
  Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWater,
    nPorts=1,
    p(displayUnit="Pa"))
    "Sink on water side"
    annotation (Placement(transformation(extent={{-54,-40},{-34,-20}})));
  Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWater,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    T=298.15) "Source on water side"
    annotation (Placement(transformation(extent={{58,-40},{38,-20}})));
  Modelica.Blocks.Sources.TimeTable masEvaIn(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,0.370116476; 28800,0.370116476; 28800,0.33287751; 32400,
        0.33287751; 32400,0.324468525; 36000,0.324468525; 36000,0.332922318; 39600,
        0.332922318; 39600,0.343295848; 43200,0.343295848; 43200,0.344592286; 46800,
        0.344592286; 46800,0.354641481; 50400,0.354641481; 50400,0.353196972; 54000,
        0.353196972; 54000,0.34542623; 57600,0.34542623; 57600,0.325853203; 61200,
        0.325853203; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,
        0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
        "Mass flowrate at the evaporator"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Modelica.Blocks.Sources.TimeTable masConIn(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,0.380079667; 28800,0.380079667; 28800,0.380079667; 32400,
        0.380079667; 32400,0.380079667; 36000,0.380079667; 36000,0.380079667; 39600,
        0.380079667; 39600,0.380079667; 43200,0.380079667; 43200,0.380079667; 46800,
        0.380079667; 46800,0.380079667; 50400,0.380079667; 50400,0.380079667; 54000,
        0.380079667; 54000,0.380079667; 57600,0.380079667; 57600,0.380079667; 61200,
        0.380079667; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,
        0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
       "Mass flowrate at the condenser"
    annotation (Placement(transformation(extent={{160,0},{140,20}})));
  Sensors.TemperatureTwoPort TConOut(m_flow_nominal=0.38, redeclare package
      Medium = MediumWater) "Outlet temperature at the condenser"
    annotation (Placement(transformation(extent={{-6,-40},{-26,-20}})));
  Modelica.Blocks.Sources.TimeTable TCOutEPlu(table=[0,13.86251622; 3600,
        13.86251622; 3600,13.86251622; 7200,13.86251622; 7200,13.86251622;
        10800,13.86251622; 10800,13.86251622; 14400,13.86251622; 14400,
        13.86251622; 18000,13.86251622; 18000,13.86251622; 21600,13.86251622;
        21600,13.86251622; 25200,13.86251622; 25200,18.11262715; 28800,
        18.11262715; 28800,17.42888551; 32400,17.42888551; 32400,17.27370577;
        36000,17.27370577; 36000,17.34307309; 39600,17.34307309; 39600,
        17.46794383; 43200,17.46794383; 43200,17.48530919; 46800,17.48530919;
        46800,17.63736299; 50400,17.63736299; 50400,17.63528608; 54000,
        17.63528608; 54000,17.5487206; 57600,17.5487206; 57600,17.29857374;
        61200,17.29857374; 61200,13.60087284; 64800,13.60087284; 64800,
        13.60087284; 68400,13.60087284; 68400,13.60087284; 72000,13.60087284;
        72000,13.60087284; 75600,13.60087284; 75600,13.60087284; 79200,
        13.60087284; 79200,13.60087284; 82800,13.60087284; 82800,13.60087284;
        86400,13.60087284]) "Condenser outlet temperature"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Modelica.Blocks.Sources.TimeTable Q_flowConEPlu(table=[0,0; 3600,0; 3600,0;
        7200,0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0;
        21600,0; 21600,0; 25200,0; 25200,6924.804943; 28800,6924.804943; 28800,
        6051.578162; 32400,6051.578162; 32400,5897.389979; 36000,5897.389979;
        36000,6089.200341; 39600,6089.200341; 39600,6323.458213; 43200,
        6323.458213; 43200,6352.882939; 46800,6352.882939; 46800,6576.630813;
        50400,6576.630813; 50400,6543.351874; 54000,6543.351874; 54000,
        6368.670264; 57600,6368.670264; 57600,5929.175058; 61200,5929.175058;
        61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0;
        75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "Condenser heat flow"
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
equation
  connect(TEvaIn.y, TEvaIn_K.Celsius)    annotation (Line(
      points={{-119,-10},{-112.1,-10},{-112.1,-10.4},{-102,-10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.y, TOutMea.u)
                           annotation (Line(
      points={{61,90},{78,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOutMea.y, TOutDegC.Kelvin)
                                    annotation (Line(
      points={{101,90},{118,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaOut.y, XEvaOutMea.u)
                           annotation (Line(
      points={{61,130},{78,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaInMoiAir.y, add.u2)
                           annotation (Line(
      points={{-119,-110},{-112,-110},{-112,-96},{-102,-96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, mux.u2[1]) annotation (Line(
      points={{-79,-90},{-72,-90},{-72,-68},{-100,-68},{-100,-56},{-82,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flowSenEPlu.y, shrEPlu.u1)  annotation (Line(
      points={{61,-90},{68,-90},{68,-104},{78,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flowEPlu.y, shrEPlu.u2)  annotation (Line(
      points={{61,-130},{68,-130},{68,-116},{78,-116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varSpeDX.P, PMea.u) annotation (Line(
      points={{11,19},{14,19},{14,50},{78,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaInMod.y, mux.u1[1]) annotation (Line(
      points={{-119,-44},{-82,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaInMod.y, add.u1) annotation (Line(
      points={{-119,-44},{-110,-44},{-110,-84},{-102,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QCoo_flow.y, Q_flowMea.u) annotation (Line(
      points={{-19,90},{-2,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn_K.Kelvin, souAir.T_in) annotation (Line(points={{-79,-10.2},{-60,
          -10.2},{-60,24},{-54,24}}, color={0,0,127}));
  connect(mux.y, souAir.X_in) annotation (Line(points={{-59,-50},{-56,-50},{-56,
          16},{-54,16}}, color={0,0,127}));
  connect(souAir.ports[1], varSpeDX.port_a) annotation (Line(points={{-32,20},{
          -20,20},{-20,10},{-10,10}}, color={0,127,255}));
  connect(varSpeDX.port_b, sinAir.ports[1]) annotation (Line(points={{10,10},{
          26,10},{26,20},{38,20}}, color={0,127,255}));
  connect(souWat.ports[1], varSpeDX.portCon_a) annotation (Line(points={{38,-30},
          {6,-30},{6,0}},         color={0,127,255}));
  connect(TCIn.y, TCIn_K.Celsius) annotation (Line(points={{139,-30},{122,-30},{
          122,-30.4}}, color={0,0,127}));
  connect(TCIn_K.Kelvin, souWat.T_in) annotation (Line(points={{99,-30.2},{72,-30.2},
          {72,-26},{60,-26}}, color={0,0,127}));
  connect(speRat.y, varSpeDX.speRat) annotation (Line(points={{-119,110},{-60,110},
          {-60,40},{-16,40},{-16,18},{-11.2,18}}, color={0,0,127}));
  connect(varSpeDX.QEvaSen_flow, QCoo_flow.u1) annotation (Line(points={{11,16},
          {16,16},{16,34},{16,42},{-50,42},{-50,96},{-42,96}},   color={0,0,127}));
  connect(varSpeDX.QEvaLat_flow, QCoo_flow.u2) annotation (Line(points={{11,13},
          {18,13},{18,44},{-48,44},{-48,84},{-42,84}}, color={0,0,127}));
  connect(varSpeDX.QEvaSen_flow, Q_flowSenMea.u) annotation (Line(points={{11,16},
          {18,16},{18,60},{-12,60},{-12,130},{-2,130}},   color={0,0,127}));
  connect(masConIn.y, souWat.m_flow_in) annotation (Line(points={{139,10},{80,10},
          {80,-22},{58,-22}}, color={0,0,127}));
  connect(masEvaIn.y, souAir.m_flow_in)
    annotation (Line(points={{-119,30},{-52,30},{-52,28}}, color={0,0,127}));
  connect(sinWat.ports[1], TConOut.port_b)
    annotation (Line(points={{-34,-30},{-26,-30}}, color={0,127,255}));
  connect(TConOut.port_a, varSpeDX.portCon_b)
    annotation (Line(points={{-6,-30},{-6,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,
            -140},{160,140}})),
             __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/WaterSource/Validation/VariableSpeedEnergyPlusPartLoad.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400),
    Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.VariableSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.VariableSpeed</a>.
</p>
<p>
The difference in results of
<i>T<sub>Out</sub></i> and
<i>X<sub>Out</sub></i>
at the beginning and end of the simulation is because the mass flow rate is zero.
For zero mass flow rate, EnergyPlus assumes steady state condition,
whereas the Modelica model is a dynamic model and hence the properties at the outlet
are equal to the state variables of the model.
</p>
<p>
The EnergyPlus results were generated using the example file <code>ZoneVSWSHP_wDOAS.idf</code>
from EnergyPlus 7.1,
with a nominal cooling capacity of <i>6758</i> Watts instead of autosizing and an internal gain from
electric equipment as <i>6000</i> Watts.This allowed to have a speed ratio between 0 and 1.
</p>
<p>
Note that EnergyPlus mass fractions (<code>X</code>) are in mass of water vapor per mass of dry air,
whereas Modelica uses the total mass as a reference. Hence, the EnergyPlus values
are corrected by dividing them by
<code>1+X</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VariableSpeedEnergyPlusPartLoad;
