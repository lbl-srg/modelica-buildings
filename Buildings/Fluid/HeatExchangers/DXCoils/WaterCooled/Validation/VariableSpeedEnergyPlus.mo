within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Validation;
model VariableSpeedEnergyPlus "Validation model for variable speed DX coil "
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;

 parameter Modelica.SIunits.Power Q_flow_nominal = datCoi.sta[1].nomVal.Q_flow_nominal
    "Nominal power";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = datCoi.sta[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";
 parameter Modelica.SIunits.PressureDifference dpEva_nominal = 1000
    "Pressure drop at m_flow_nominal";
 parameter Modelica.SIunits.PressureDifference dpCon_nominal = 40000
    "Pressure drop at mCon_flow_nominal";

  VariableSpeed  varSpeDX(
    dpEva_nominal=dpEva_nominal,
    datCoi=datCoi,
    dpCon_nominal=dpCon_nominal,
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    varSpeDX(T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
             energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    watCooCon(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    minSpeRat=0.05)
                   "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  WaterCooled.Data.Generic.DXCoil datCoi(nSta=10,
    minSpeRat=0.1,
    sta={
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-1524.1,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.16648632,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2000/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-1877.9,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.1849848,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2200/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-2226.6,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.20348328,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-2911.3,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.24048024,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2600/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-3581.7,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.2774772,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2800/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4239.5,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.31447416,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3000/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4885.7,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.35147112,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3200/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-5520.7,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.38846808,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3400/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-6144.8,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.42546504,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3600/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-6758,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.462462,
          mCon_flow_nominal=0.380079667),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I())})
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

  Modelica.Blocks.Sources.TimeTable TCIn(table=[0,14.00683739; 3600,14.00683739;
        3600,14.00683739; 7200,14.00683739; 7200,14.00683739; 10800,14.00683739;
        10800,14.00683739; 14400,14.00683739; 14400,14.00683739; 18000,
        14.00683739; 18000,14.00683739; 21600,14.00683739; 21600,14.00683739;
        25200,14.00683739; 25200,13.87552675; 28800,13.87552675; 28800,
        13.69286773; 32400,13.69286773; 32400,13.61476734; 36000,13.61476734;
        36000,13.57089739; 39600,13.57089739; 39600,13.53976992; 43200,
        13.53976992; 43200,13.53421144; 46800,13.53421144; 46800,13.546532;
        50400,13.546532; 50400,13.56990874; 54000,13.56990874; 54000,
        13.59997465; 57600,13.59997465; 57600,13.63391675; 61200,13.63391675;
        61200,13.67002808; 64800,13.67002808; 64800,13.67002808; 68400,
        13.67002808; 68400,13.67002808; 72000,13.67002808; 72000,13.67002808;
        75600,13.67002808; 75600,13.67002808; 79200,13.67002808; 79200,
        13.67002808; 82800,13.67002808; 82800,13.67002808; 86400,13.67002808])
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{160,-40},{140,-20}})));
  Modelica.Blocks.Sources.TimeTable TEvaIn(table=[0,29.5825369; 3600,29.5825369;
        3600,29.50952996; 7200,29.50952996; 7200,29.41551164; 10800,29.41551164;
        10800,29.30959085; 14400,29.30959085; 14400,29.19741682; 18000,
        29.19741682; 18000,29.0889453; 21600,29.0889453; 21600,29.10927102;
        25200,29.10927102; 25200,26.38634072; 28800,26.38634072; 28800,
        24.78692326; 32400,24.78692326; 32400,24.46170212; 36000,24.46170212;
        36000,23.92913368; 39600,23.92913368; 39600,23.94699649; 43200,
        23.94699649; 43200,23.92812452; 46800,23.92812452; 46800,23.96439884;
        50400,23.96439884; 50400,24.05812526; 54000,24.05812526; 54000,
        24.09064513; 57600,24.09064513; 57600,24.02689295; 61200,24.02689295;
        61200,27.13649774; 64800,27.13649774; 64800,28.31177225; 68400,
        28.31177225; 68400,28.62465231; 72000,28.62465231; 72000,29.24169626;
        75600,29.24169626; 75600,29.55515204; 79200,29.55515204; 79200,
        29.66771875; 82800,29.66771875; 82800,29.63701136; 86400,29.63701136])
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
  Modelica.Blocks.Sources.RealExpression TOut(y=varSpeDX.varSpeDX.vol.T)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Math.Mean XEvaOutMea(f=1/3600)
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Modelica.Blocks.Sources.RealExpression XEvaOut(y=sum(varSpeDX.varSpeDX.vol.Xi))
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
  Modelica.Blocks.Sources.TimeTable TOutEPlu(table=[0,29.5825369; 3600,
        29.5825369; 3600,29.50952996; 7200,29.50952996; 7200,29.41551164; 10800,
        29.41551164; 10800,29.30959085; 14400,29.30959085; 14400,29.19741682;
        18000,29.19741682; 18000,29.0889453; 21600,29.0889453; 21600,
        29.10927102; 25200,29.10927102; 25200,9.933220801; 28800,9.933220801;
        28800,8.489103487; 32400,8.489103487; 32400,8.121648803; 36000,
        8.121648803; 36000,7.844340011; 39600,7.844340011; 39600,7.846585486;
        43200,7.846585486; 43200,7.839593444; 46800,7.839593444; 46800,
        7.80685344; 50400,7.80685344; 50400,7.857974059; 54000,7.857974059;
        54000,7.906090799; 57600,7.906090799; 57600,7.901812295; 61200,
        7.901812295; 61200,27.13649774; 64800,27.13649774; 64800,28.31177225;
        68400,28.31177225; 68400,28.62465231; 72000,28.62465231; 72000,
        29.24169626; 75600,29.24169626; 75600,29.55515204; 79200,29.55515204;
        79200,29.66771875; 82800,29.66771875; 82800,29.63701136; 86400,
        29.63701136])
    "EnergyPlus result: outlet temperature"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowEPlu(table=[0,-1e-07; 3600,-1e-07;
        3600,-1e-07; 7200,-1e-07; 7200,-1e-07; 10800,-1e-07; 10800,-1e-07;
        14400,-1e-07; 14400,-1e-07; 18000,-1e-07; 18000,-1e-07; 21600,-1e-07;
        21600,-1e-07; 25200,-1e-07; 25200,-7118.82657; 28800,-7118.82657; 28800,
        -7076.338977; 32400,-7076.338977; 32400,-7071.584588; 36000,-7071.584588;
        36000,-7068.106502; 39600,-7068.106502; 39600,-7070.155998; 43200,-7070.155998;
        43200,-7070.378274; 46800,-7070.378274; 46800,-7068.266947; 50400,-7068.266947;
        50400,-7067.990411; 54000,-7067.990411; 54000,-7067.508378; 57600,-7067.508378;
        57600,-7065.43655; 61200,-7065.43655; 61200,-1e-07; 64800,-1e-07; 64800,
        -1e-07; 68400,-1e-07; 68400,-1e-07; 72000,-1e-07; 72000,-1e-07; 75600,-1e-07;
        75600,-1e-07; 79200,-1e-07; 79200,-1e-07; 82800,-1e-07; 82800,-1e-07;
        86400,-1e-07])                       "EnergyPlus result: heat flow"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowSenEPlu(table=[0,0; 3600,0; 3600,0;
        7200,0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0;
        21600,0; 21600,0; 25200,0; 25200,-7118.82657; 28800,-7118.82657; 28800,
        -7052.352692; 32400,-7052.352692; 32400,-7070.935252; 36000,-7070.935252;
        36000,-6961.132165; 39600,-6961.132165; 39600,-6967.822214; 43200,-6967.822214;
        43200,-6962.73232; 46800,-6962.73232; 46800,-6991.936697; 50400,-6991.936697;
        50400,-7010.320474; 54000,-7010.320474; 54000,-7003.90451; 57600,-7003.90451;
        57600,-6978.528713; 61200,-6978.528713; 61200,0; 64800,0; 64800,0;
        68400,0; 68400,0; 72000,0; 72000,0; 75600,0; 75600,0; 79200,0; 79200,0;
        82800,0; 82800,0; 86400,0])
    "EnergyPlus result: sensible heat flow "
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Math.Division shrEPlu "EnergyPlus result: SHR"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Modelica.Blocks.Sources.TimeTable XEvaOutEPlu(table=[0,0.00538; 3600,0.00538;
        3600,0.00538; 7200,0.00538; 7200,0.00537; 10800,0.00537; 10800,0.00536;
        14400,0.00536; 14400,0.00535; 18000,0.00535; 18000,0.00534; 21600,
        0.00534; 21600,0.00534; 25200,0.00534; 25200,0.00538; 28800,0.00538;
        28800,0.00542; 32400,0.00542; 32400,0.00546; 36000,0.00546; 36000,
        0.00541; 39600,0.00541; 39600,0.00541; 43200,0.00541; 43200,0.00541;
        46800,0.00541; 46800,0.00539; 50400,0.00539; 50400,0.0054; 54000,0.0054;
        54000,0.00542; 57600,0.00542; 57600,0.00543; 61200,0.00543; 61200,
        0.00541; 64800,0.00541; 64800,0.0054; 68400,0.0054; 68400,0.0054; 72000,
        0.0054; 72000,0.0054; 75600,0.0054; 75600,0.00539; 79200,0.00539; 79200,
        0.00539; 82800,0.00539; 82800,0.00538; 86400,0.00538])
    "EnergyPlus result: outlet water mass fraction"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Modelica.Blocks.Sources.TimeTable PEPlu(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,1234.058747; 28800,1234.058747; 28800,
        1220.300991; 32400,1220.300991; 32400,1216.667266; 36000,1216.667266;
        36000,1213.93492; 39600,1213.93492; 39600,1213.264228; 43200,
        1213.264228; 43200,1213.101804; 46800,1213.101804; 46800,1212.975045;
        50400,1212.975045; 50400,1213.859714; 54000,1213.859714; 54000,
        1214.948084; 57600,1214.948084; 57600,1215.728051; 61200,1215.728051;
        61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0;
        75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
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
  Sources.MassFlowSource_T                 souAir(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    nPorts=1,
    m_flow=1.5,
    use_m_flow_in=true,
    use_X_in=true,
    T=299.85) "Source on air side"
    annotation (Placement(transformation(extent={{-52,10},{-32,30}})));
  Sources.Boundary_pT                 sinAir(
    redeclare package Medium = MediumAir,
    nPorts=1,
    p(displayUnit="Pa"))
              "Sink on air side"
    annotation (Placement(transformation(extent={{58,10},{38,30}})));
  Sources.Boundary_pT                 sinWat(
    redeclare package Medium = MediumWater,
    nPorts=1,
    p(displayUnit="Pa"))
              "Sink on water side"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Sources.MassFlowSource_T            souWat(
    redeclare package Medium = MediumWater,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true,
    T=298.15) "Source on water side"
    annotation (Placement(transformation(extent={{58,-40},{38,-20}})));
  Modelica.Blocks.Sources.TimeTable masEvaIn(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,0.42634453; 28800,0.42634453; 28800,0.42634453;
        32400,0.42634453; 32400,0.42634453; 36000,0.42634453; 36000,0.42634453;
        39600,0.42634453; 39600,0.42634453; 43200,0.42634453; 43200,0.42634453;
        46800,0.42634453; 46800,0.42634453; 50400,0.42634453; 50400,0.42634453;
        54000,0.42634453; 54000,0.42634453; 57600,0.42634453; 57600,0.42634453;
        61200,0.42634453; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0;
        72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
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
      points={{11,18},{14,18},{14,50},{78,50}},
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
  connect(souAir.ports[1], varSpeDX.port_a1) annotation (Line(points={{-32,20},{
          -20,20},{-20,16},{-10,16}}, color={0,127,255}));
  connect(varSpeDX.port_b1, sinAir.ports[1]) annotation (Line(points={{10,16},{26,
          16},{26,20},{38,20}}, color={0,127,255}));
  connect(souWat.ports[1], varSpeDX.port_a2) annotation (Line(points={{38,-30},{
          26,-30},{26,4},{10,4}}, color={0,127,255}));
  connect(sinWat.ports[1], varSpeDX.port_b2) annotation (Line(points={{-30,-30},
          {-20,-30},{-20,4},{-10,4}}, color={0,127,255}));
  connect(TCIn.y, TCIn_K.Celsius) annotation (Line(points={{139,-30},{122,-30},{
          122,-30.4}}, color={0,0,127}));
  connect(TCIn_K.Kelvin, souWat.T_in) annotation (Line(points={{99,-30.2},{72,-30.2},
          {72,-26},{60,-26}}, color={0,0,127}));
  connect(speRat.y, varSpeDX.speRat) annotation (Line(points={{-119,110},{-60,110},
          {-60,40},{-16,40},{-16,18},{-11.2,18}}, color={0,0,127}));
  connect(varSpeDX.QEvaSen_flow, QCoo_flow.u1) annotation (Line(points={{11,13.4},
          {16,13.4},{16,34},{16,42},{-50,42},{-50,96},{-42,96}}, color={0,0,127}));
  connect(varSpeDX.QEvaLat_flow, QCoo_flow.u2) annotation (Line(points={{11,10},
          {18,10},{18,44},{-48,44},{-48,84},{-42,84}}, color={0,0,127}));
  connect(varSpeDX.QEvaSen_flow, Q_flowSenMea.u) annotation (Line(points={{11,13.4},
          {18,13.4},{18,60},{-12,60},{-12,130},{-2,130}}, color={0,0,127}));
  connect(masConIn.y, souWat.m_flow_in) annotation (Line(points={{139,10},{80,10},
          {80,-22},{58,-22}}, color={0,0,127}));
  connect(masEvaIn.y, souAir.m_flow_in)
    annotation (Line(points={{-119,30},{-52,30},{-52,28}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,
            -140},{160,140}})),
             __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/WaterCooled/Validation/VariableSpeedEnergyPlus.mos"
        "Simulate and plot"),
    experiment(StopTime=86400),
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
The EnergyPlus results were generated using the example file <code>DXCoilSystemAuto.idf</code>
from EnergyPlus 7.1,
with a nominal cooling capacity of <i>10500</i> Watts instead of using
autosizing. This allowed to have a part load ratio of one.
</p>
<p>
Note that EnergyPlus mass fractions (<code>X</code>) are in mass of water vapor per mass of dry air,
whereas Modelica uses the total mass as a reference. Hence, the EnergyPlus values
are corrected by dividing them by
<code>1+X</code>.
</p>
</html>",
revisions=""));
end VariableSpeedEnergyPlus;
