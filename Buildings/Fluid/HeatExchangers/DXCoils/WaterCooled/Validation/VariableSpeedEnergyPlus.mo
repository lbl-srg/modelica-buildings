within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Validation;
model VariableSpeedEnergyPlus
  "Validation model for variable speed DX coil "
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;

  parameter Modelica.Units.SI.Power Q_flow_nominal=datCoi.sta[1].nomVal.Q_flow_nominal
    "Nominal power";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal=1000
    "Pressure drop at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal=40000
    "Pressure drop at mCon_flow_nominal";

  VariableSpeed varSpeDX(
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

 parameter Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi(
  nSta=10,minSpeRat=0.1,
    sta={Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-1524.1,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.16648632,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=1000/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-1877.9,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.1849848,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=1500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-2226.6,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.20348328,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2000/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-2911.3,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.24048024,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-3581.7,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.2774772,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3000/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4239.5,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.31447416,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4885.7,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.35147112,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=4000/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-5520.7,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.38846808,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=4500/60,
      nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-6144.8,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.42546504,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
       perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=5000/60,
       nomVal=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-6758,COP_nominal=4,SHR_nominal=0.75,
          m_flow_nominal=0.462462,mCon_flow_nominal=0.380079667,
          TEvaIn_nominal=273.15+19.44,TConIn_nominal=273.15+29.4,phiIn_nominal=0.5148),
       perCur=Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Examples.PerformanceCurves.Curve_I())})
          "Coil data"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,1; 28800,1; 28800,1; 32400,1; 32400,1; 36000,1;
        36000,1; 39600,1; 39600,1; 43200,1; 43200,1; 46800,1; 46800,1; 50400,1;
        50400,1; 54000,1; 54000,1; 57600,1; 57600,1; 61200,1; 61200,0; 64800,0;
        64800,0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0; 75600,0; 79200,0;
        79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus speed ratio for this model"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Modelica.Blocks.Sources.TimeTable TCIn(table=[0,14.00192912; 3600,14.00192912;
        3600,14.00192912; 7200,14.00192912; 7200,14.00192912; 10800,14.00192912;
        10800,14.00192912; 14400,14.00192912; 14400,14.00192912; 18000,14.00192912;
        18000,14.00192912; 21600,14.00192912; 21600,14.00192912; 25200,14.00192912;
        25200,13.87116782; 28800,13.87116782; 28800,13.68940516; 32400,13.68940516;
        32400,13.61181349; 36000,13.61181349; 36000,13.56830163; 39600,13.56830163;
        39600,13.53753354; 43200,13.53753354; 43200,13.53223224; 46800,13.53223224;
        46800,13.544731; 50400,13.544731; 50400,13.56823102; 54000,13.56823102;
        54000,13.59838157; 57600,13.59838157; 57600,13.63238101; 61200,13.63238101;
        61200,13.66852976; 64800,13.66852976; 64800,13.66852976; 68400,13.66852976;
        68400,13.66852976; 72000,13.66852976; 72000,13.66852976; 75600,13.66852976;
        75600,13.66852976; 79200,13.66852976; 79200,13.66852976; 82800,13.66852976;
        82800,13.66852976; 86400,13.66852976])
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{160,-40},{140,-20}})));
  Modelica.Blocks.Sources.TimeTable TEvaIn(table=[0,29.12922216; 3600,29.12922216;
        3600,29.05566774; 7200,29.05566774; 7200,28.96128616; 10800,28.96128616;
        10800,28.85494074; 14400,28.85494074; 14400,28.74236486; 18000,28.74236486;
        18000,28.63355658; 21600,28.63355658; 21600,28.65392227; 25200,28.65392227;
        25200,25.92690623; 28800,25.92690623; 28800,24.32658509; 32400,24.32658509;
        32400,24.00495885; 36000,24.00495885; 36000,23.4817184; 39600,23.4817184;
        39600,23.50449436; 43200,23.50449436; 43200,23.48876996; 46800,23.48876996;
        46800,23.52144673; 50400,23.52144673; 50400,23.61388018; 54000,23.61388018;
        54000,23.64607195; 57600,23.64607195; 57600,23.58143828; 61200,23.58143828;
        61200,26.68408826; 64800,26.68408826; 64800,27.85802964; 68400,27.85802964;
        68400,28.17092771; 72000,28.17092771; 72000,28.78657683; 75600,28.78657683;
        75600,29.10487544; 79200,29.10487544; 79200,29.21730921; 82800,29.21730921;
        82800,29.18512017; 86400,29.18512017])
     "Coil inlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Modelica.Blocks.Sources.TimeTable XEvaIn(table=[0,0.00531; 3600,0.00531; 3600,
        0.0053; 7200,0.0053; 7200,0.00529; 10800,0.00529; 10800,0.00529; 14400,0.00529;
        14400,0.00528; 18000,0.00528; 18000,0.00527; 21600,0.00527; 21600,0.00527;
        25200,0.00527; 25200,0.00531; 28800,0.00531; 28800,0.00537; 32400,0.00537;
        32400,0.00539; 36000,0.00539; 36000,0.00542; 39600,0.00542; 39600,0.00541;
        43200,0.00541; 43200,0.0054; 46800,0.0054; 46800,0.00534; 50400,0.00534;
        50400,0.00534; 54000,0.00534; 54000,0.00536; 57600,0.00536; 57600,0.00538;
        61200,0.00538; 61200,0.00533; 64800,0.00533; 64800,0.00532; 68400,0.00532;
        68400,0.00532; 72000,0.00532; 72000,0.00532; 75600,0.00532; 75600,0.00531;
        79200,0.00531; 79200,0.00531; 82800,0.00531; 82800,0.0053; 86400,0.0053])
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
  Modelica.Blocks.Sources.TimeTable TOutEPlu(table=[0,29.12922216; 3600,29.12922216;
        3600,29.05566774; 7200,29.05566774; 7200,28.96128616; 10800,28.96128616;
        10800,28.85494074; 14400,28.85494074; 14400,28.74236486; 18000,28.74236486;
        18000,28.63355658; 21600,28.63355658; 21600,28.65392227; 25200,28.65392227;
        25200,9.511780529; 28800,9.511780529; 28800,8.096740784; 32400,8.096740784;
        32400,7.757702268; 36000,7.757702268; 36000,7.493011832; 39600,7.493011832;
        39600,7.487562491; 43200,7.487562491; 43200,7.469723021; 46800,7.469723021;
        46800,7.42876332; 50400,7.42876332; 50400,7.475557577; 54000,7.475557577;
        54000,7.520585945; 57600,7.520585945; 57600,7.513057428; 61200,7.513057428;
        61200,26.68408826; 64800,26.68408826; 64800,27.85802964; 68400,27.85802964;
        68400,28.17092771; 72000,28.17092771; 72000,28.78657683; 75600,28.78657683;
        75600,29.10487544; 79200,29.10487544; 79200,29.21730921; 82800,29.21730921;
        82800,29.18512017; 86400,29.18512017])
    "EnergyPlus result: outlet temperature"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowEPlu(table=[0,-1e-07; 3600,-1e-07; 3600,
        -1e-07; 7200,-1e-07; 7200,-1e-07; 10800,-1e-07; 10800,-1e-07; 14400,-1e-07;
        14400,-1e-07; 18000,-1e-07; 18000,-1e-07; 21600,-1e-07; 21600,-1e-07; 25200,
        -1e-07; 25200,-7101.486157; 28800,-7101.486157; 28800,-7065.001284; 32400,
        -7065.001284; 32400,-7062.147282; 36000,-7062.147282; 36000,-7059.359628;
        39600,-7059.359628; 39600,-7061.127967; 43200,-7061.127967; 43200,-7061.045112;
        46800,-7061.045112; 46800,-7058.99449; 50400,-7058.99449; 50400,-7058.349457;
        54000,-7058.349457; 54000,-7057.487529; 57600,-7057.487529; 57600,-7055.318157;
        61200,-7055.318157; 61200,-1e-07; 64800,-1e-07; 64800,-1e-07; 68400,-1e-07;
        68400,-1e-07; 72000,-1e-07; 72000,-1e-07; 75600,-1e-07; 75600,-1e-07; 79200,
        -1e-07; 79200,-1e-07; 82800,-1e-07; 82800,-1e-07; 86400,-1e-07])
        "EnergyPlus result: heat flow"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowSenEPlu(table=[0,0; 3600,0; 3600,0; 7200,
        0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,-7101.486157; 28800,-7101.486157; 28800,-7022.028225;
        32400,-7022.028225; 32400,-7029.813507; 36000,-7029.813507; 36000,-6918.432248;
        39600,-6918.432248; 39600,-6930.451185; 43200,-6930.451185; 43200,-6931.267635;
        46800,-6931.267635; 46800,-6962.40406; 50400,-6962.40406; 50400,-6982.045473;
        54000,-6982.045473; 54000,-6976.779585; 57600,-6976.779585; 57600,-6952.399564;
        61200,-6952.399564; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0;
        72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: sensible heat flow "
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Math.Division shrEPlu "EnergyPlus result: SHR"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Modelica.Blocks.Sources.TimeTable XEvaOutEPlu(table=[0,0.00531; 3600,0.00531;
        3600,0.0053; 7200,0.0053; 7200,0.00529; 10800,0.00529; 10800,0.00529; 14400,
        0.00529; 14400,0.00528; 18000,0.00528; 18000,0.00527; 21600,0.00527; 21600,
        0.00527; 25200,0.00527; 25200,0.00531; 28800,0.00531; 28800,0.00533; 32400,
        0.00533; 32400,0.00536; 36000,0.00536; 36000,0.00529; 39600,0.00529; 39600,
        0.00529; 43200,0.00529; 43200,0.00528; 46800,0.00528; 46800,0.00525; 50400,
        0.00525; 50400,0.00527; 54000,0.00527; 54000,0.00528; 57600,0.00528; 57600,
        0.00529; 61200,0.00529; 61200,0.00533; 64800,0.00533; 64800,0.00532; 68400,
        0.00532; 68400,0.00532; 72000,0.00532; 72000,0.00532; 75600,0.00532; 75600,
        0.00531; 79200,0.00531; 79200,0.00531; 82800,0.00531; 82800,0.0053; 86400,
        0.0053])
    "EnergyPlus result: outlet water mass fraction"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Modelica.Blocks.Sources.TimeTable PEPlu(table=[0,0; 3600,0; 3600,0; 7200,0; 7200,
        0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,1230.619384; 28800,1230.619384; 28800,1217.250881; 32400,
        1217.250881; 32400,1213.815124; 36000,1213.815124; 36000,1210.9557; 39600,
        1210.9557; 39600,1210.19962; 43200,1210.19962; 43200,1209.925786; 46800,
        1209.925786; 46800,1209.728055; 50400,1209.728055; 50400,1210.57757; 54000,
        1210.57757; 54000,1211.642811; 57600,1211.642811; 57600,1212.400701; 61200,
        1212.400701; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,
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
        0; 25200,0; 25200,0.42634453; 28800,0.42634453; 28800,0.42634453; 32400,
        0.42634453; 32400,0.42634453; 36000,0.42634453; 36000,0.42634453; 39600,
        0.42634453; 39600,0.42634453; 43200,0.42634453; 43200,0.42634453; 46800,
        0.42634453; 46800,0.42634453; 50400,0.42634453; 50400,0.42634453; 54000,
        0.42634453; 54000,0.42634453; 57600,0.42634453; 57600,0.42634453; 61200,
        0.42634453; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,
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
  Modelica.Blocks.Sources.TimeTable TCOutEPlu(table=[0,14.00192912; 3600,14.00192912;
        3600,14.00192912; 7200,14.00192912; 7200,14.00192912; 10800,14.00192912;
        10800,14.00192912; 14400,14.00192912; 14400,14.00192912; 18000,14.00192912;
        18000,14.00192912; 21600,14.00192912; 21600,14.00192912; 25200,14.00192912;
        25200,19.03036339; 28800,19.03036339; 28800,18.81784119; 32400,18.81784119;
        32400,18.73639861; 36000,18.73639861; 36000,18.68945378; 39600,18.68945378;
        39600,18.65932416; 43200,18.65932416; 43200,18.65380814; 46800,18.65380814;
        46800,18.66492477; 50400,18.66492477; 50400,18.6885344; 54000,18.6885344;
        54000,18.71879002; 57600,18.71879002; 57600,18.75190471; 61200,18.75190471;
        61200,13.66852976; 64800,13.66852976; 64800,13.66852976; 68400,13.66852976;
        68400,13.66852976; 72000,13.66852976; 72000,13.66852976; 75600,13.66852976;
        75600,13.66852976; 79200,13.66852976; 79200,13.66852976; 82800,13.66852976;
        82800,13.66852976; 86400,13.66852976])
                            "Condenser outlet temperature"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Modelica.Blocks.Sources.TimeTable Q_flowConEPlu(table=[0,0; 3600,0; 3600,0; 7200,
        0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,8209.043603; 28800,8209.043603; 28800,8160.527077;
        32400,8160.527077; 32400,8154.580894; 36000,8154.580894; 36000,8149.219757;
        39600,8149.219757; 39600,8150.307625; 43200,8150.307625; 43200,8149.978319;
        46800,8149.978319; 46800,8147.749739; 50400,8147.749739; 50400,8147.86927;
        54000,8147.86927; 54000,8147.96606; 57600,8147.96606; 57600,8146.478788;
        61200,8146.478788; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0;
        72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
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
  connect(sinWat.ports[1], TConOut.port_b) annotation (Line(points={{-34,-30},{
          -30,-30},{-26,-30}}, color={0,127,255}));
  connect(TConOut.port_a, varSpeDX.portCon_b)
    annotation (Line(points={{-6,-30},{-6,-30},{-6,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,
            -140},{160,140}})),
             __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/WaterCooled/Validation/VariableSpeedEnergyPlus.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400),
    Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.VariableSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.VariableSpeed</a>.
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
electric equipment as <i>9400</i> Watts. This allowed to have a speed ratio of one.
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
end VariableSpeedEnergyPlus;
