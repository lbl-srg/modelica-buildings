within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Validation;
model VariableSpeedEnergyPlus "Validation model for variable speed DX coil "
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;

 parameter Modelica.SIunits.Power Q_flow_nominal = datCoi.sta[1].nomVal.Q_flow_nominal
    "Nominal power";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = datCoi.sta[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";
 parameter Modelica.SIunits.PressureDifference dp_nominal = 1000
    "Pressure drop at m_flow_nominal";
 parameter Modelica.SIunits.PressureDifference dpCon_nominal = 40000
    "Pressure drop at mCon_flow_nominal";

  VariableSpeed  varSpeDX(
    dp_nominal=dp_nominal,
    datCoi=datCoi,
    minSpeRat=0.2,
    dpCon_nominal=dpCon_nominal)
                   "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  WaterCooled.Data.Generic.DXCoil datCoi(nSta=10, sta={
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-1524.1,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.16648632,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2000/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-1877.9,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.1849848,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2200/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-2226.6,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.20348328,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2400/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-2911.3,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.24048024,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2600/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-3581.7,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.2774772,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=2800/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4239.5,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.31447416,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3000/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4885.7,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.35147112,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3200/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-5520.7,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.38846808,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3400/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-6144.8,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.42546504,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I()),
        Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage(
        spe=3600/60,
        nomVal=WaterCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-6758,
          COP_nominal=4,
          SHR_nominal=0.75,
          m_flow_nominal=0.462462,
          mCon_flow_nominal=0.381695),
        perCur=WaterCooled.Examples.PerformanceCurves.Curve_I())})
          "Coil data"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));

  Modelica.Blocks.Sources.TimeTable speRat(table=[0,0; 3600,0; 3600,0; 7200,0; 7200,
        0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,0.9899866164; 28800,0.9899866164; 28800,0.6858820534;
        32400,0.6858820534; 32400,0.7061013723; 36000,0.7061013723; 36000,0.7386825182;
        39600,0.7386825182; 39600,0.7675487504; 43200,0.7675487504; 43200,0.7600118437;
        46800,0.7600118437; 46800,0.7995458639; 50400,0.7995458639; 50400,0.8037543296;
        54000,0.8037543296; 54000,0.7955772166; 57600,0.7955772166; 57600,0.7491336793;
        61200,0.7491336793; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0;
        72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus speed ratio for this model"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Modelica.Blocks.Sources.TimeTable TCIn(table=[0,15.2762751076125; 3600,15.2762751076125;
        3600,15.2762751076125; 7200,15.2762751076125; 7200,15.2762751076125; 10800,
        15.2762751076125; 10800,15.2762751076125; 14400,15.2762751076125; 14400,
        15.2762751076125; 18000,15.2762751076125; 18000,15.2762751076125; 21600,
        15.2762751076125; 21600,15.2762751076125; 25200,15.2762751076125; 25200,
        14.6469891292113; 28800,14.6469891292113; 28800,14.254995634525; 32400,14.254995634525;
        32400,14.2780478258515; 36000,14.2780478258515; 36000,14.3571459441434;
        39600,14.3571459441434; 39600,14.4343493725683; 43200,14.4343493725683;
        43200,14.5088230530333; 46800,14.5088230530333; 46800,14.5811666487; 50400,
        14.5811666487; 50400,14.6507823403123; 54000,14.6507823403123; 54000,14.7217210528734;
        57600,14.7217210528734; 57600,14.7920425614899; 61200,14.7920425614899;
        61200,14.8256970815556; 64800,14.8256970815556; 64800,14.8256970815556;
        68400,14.8256970815556; 68400,14.8256970815556; 72000,14.8256970815556;
        72000,14.8256970815556; 75600,14.8256970815556; 75600,14.8256970815556;
        79200,14.8256970815556; 79200,14.8256970815556; 82800,14.8256970815556;
        82800,14.8256970815556; 86400,14.8256970815556])
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{160,-40},{140,-20}})));
  Modelica.Blocks.Sources.TimeTable TEvaIn(table=[0,29.5204920720037; 3600,29.5204920720037;
        3600,29.4060460410378; 7200,29.4060460410378; 7200,29.285912065901; 10800,
        29.285912065901; 10800,29.1642207424414; 14400,29.1642207424414; 14400,29.0421021857414;
        18000,29.0421021857414; 18000,28.955415764513; 21600,28.955415764513; 21600,
        29.0347908816146; 25200,29.0347908816146; 25200,25.062470658696; 28800,25.062470658696;
        28800,23.3624004874375; 32400,23.3624004874375; 32400,23.3581691226756;
        36000,23.3581691226756; 36000,23.3579092531025; 39600,23.3579092531025;
        39600,23.3582695437336; 43200,23.3582695437336; 43200,23.3581784747651;
        46800,23.3581784747651; 46800,23.3580945182643; 50400,23.3580945182643;
        50400,23.3580756311268; 54000,23.3580756311268; 54000,23.358044963971; 57600,
        23.358044963971; 57600,23.3579675155636; 61200,23.3579675155636; 61200,26.0582429102179;
        64800,26.0582429102179; 64800,28.4954014121538; 68400,28.4954014121538;
        68400,29.2262853967086; 72000,29.2262853967086; 72000,29.5503894347851;
        75600,29.5503894347851; 75600,29.6651659335165; 79200,29.6651659335165;
        79200,29.671173939674; 82800,29.671173939674; 82800,29.6150304535369; 86400,
        29.6150304535369]) "Coil inlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Modelica.Blocks.Sources.TimeTable XEvaIn(table=[0,0.00662703171662698; 3600,0.00662703171662698;
        3600,0.00660504215376483; 7200,0.00660504215376483; 7200,0.00658329104118168;
        10800,0.00658329104118168; 10800,0.00656177589177944; 14400,0.00656177589177944;
        14400,0.00654049410182535; 18000,0.00654049410182535; 18000,0.00651944240508857;
        21600,0.00651944240508857; 21600,0.00652616247658349; 25200,0.00652616247658349;
        25200,0.00666053993126324; 28800,0.00666053993126324; 28800,0.00673479097243179;
        32400,0.00673479097243179; 32400,0.00682692111389599; 36000,0.00682692111389599;
        36000,0.00690858401503027; 39600,0.00690858401503027; 39600,0.00697952455696202;
        43200,0.00697952455696202; 43200,0.00698518869159839; 46800,0.00698518869159839;
        46800,0.00693025718672722; 50400,0.00693025718672722; 50400,0.00699544381353734;
        54000,0.00699544381353734; 54000,0.00705476184798462; 57600,0.00705476184798462;
        57600,0.00705121555656397; 61200,0.00705121555656397; 61200,0.0068652622648989;
        64800,0.0068652622648989; 64800,0.00673914893305207; 68400,0.00673914893305207;
        68400,0.00674139555486991; 72000,0.00674139555486991; 72000,0.00671792125842839;
        75600,0.00671792125842839; 75600,0.00669496853221997; 79200,0.00669496853221997;
        79200,0.00667225226518614; 82800,0.00667225226518614; 82800,0.00664977595587345;
        86400,0.00664977595587345])
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
  Modelica.Blocks.Sources.TimeTable TOutEPlu(table=[0,29.5204920720037; 3600,29.5204920720037;
        3600,29.4060460410378; 7200,29.4060460410378; 7200,29.285912065901; 10800,
        29.285912065901; 10800,29.1642207424414; 14400,29.1642207424414; 14400,29.0421021857414;
        18000,29.0421021857414; 18000,28.955415764513; 21600,28.955415764513; 21600,
        29.0347908816146; 25200,29.0347908816146; 25200,17.3039335180202; 28800,
        17.3039335180202; 28800,16.1085419348605; 32400,16.1085419348605; 32400,
        16.0486814252428; 36000,16.0486814252428; 36000,15.9715377141509; 39600,
        15.9715377141509; 39600,15.9109890410551; 43200,15.9109890410551; 43200,
        15.9318080947262; 46800,15.9318080947262; 46800,15.8522886488701; 50400,
        15.8522886488701; 50400,15.8473079022527; 54000,15.8473079022527; 54000,
        15.8677169202761; 57600,15.8677169202761; 57600,15.9733033333832; 61200,
        15.9733033333832; 61200,26.0582429102179; 64800,26.0582429102179; 64800,
        28.4954014121538; 68400,28.4954014121538; 68400,29.2262853967086; 72000,
        29.2262853967086; 72000,29.5503894347851; 75600,29.5503894347851; 75600,
        29.6651659335165; 79200,29.6651659335165; 79200,29.671173939674; 82800,29.671173939674;
        82800,29.6150304535369; 86400,29.6150304535369])
    "EnergyPlus result: outlet temperature"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowEPlu(table=[0,1e-07; 3600,1e-07; 3600,
        1e-07; 7200,1e-07; 7200,1e-07; 10800,1e-07; 10800,1e-07; 14400,1e-07;
        14400,1e-07; 18000,1e-07; 18000,1e-07; 21600,1e-07; 21600,1e-07; 25200,
        1e-07; 25200,-9965.63669309236; 28800,-9965.63669309236; 28800,-6752.18146593818;
        32400,-6752.18146593818; 32400,-6969.90771169547; 36000,-6969.90771169547;
        36000,-7312.34503683062; 39600,-7312.34503683062; 39600,-7613.00494338516;
        43200,-7613.00494338516; 43200,-7529.2729465192; 46800,-7529.2729465192;
        46800,-7939.58166679653; 50400,-7939.58166679653; 50400,-7980.9763546484;
        54000,-7980.9763546484; 54000,-7891.910078039; 57600,-7891.910078039;
        57600,-7398.46168158635; 61200,-7398.46168158635; 61200,1e-07; 64800,
        1e-07; 64800,1e-07; 68400,1e-07; 68400,1e-07; 72000,1e-07; 72000,1e-07;
        75600,1e-07; 75600,1e-07; 79200,1e-07; 79200,1e-07; 82800,1e-07; 82800,
        1e-07; 86400,1e-07])                 "EnergyPlus result: heat flow"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowSenEPlu(table=[0,0; 3600,0; 3600,0;
        7200,0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0;
        21600,0; 21600,0; 25200,0; 25200,-9965.63669309236; 28800,-9965.63669309236;
        28800,-6752.18146593818; 32400,-6752.18146593818; 32400,-6969.90771169547;
        36000,-6969.90771169547; 36000,-7312.34503683062; 39600,-7312.34503683062;
        39600,-7613.00494338516; 43200,-7613.00494338516; 43200,-7529.2729465192;
        46800,-7529.2729465192; 46800,-7939.58166679653; 50400,-7939.58166679653;
        50400,-7980.9763546484; 54000,-7980.9763546484; 54000,-7891.910078039;
        57600,-7891.910078039; 57600,-7398.46168158635; 61200,-7398.46168158635;
        61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0;
        75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: sensible heat flow "
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Math.Division shrEPlu "EnergyPlus result: SHR"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Modelica.Blocks.Sources.TimeTable XEvaOutEPlu(table=[0,0.00662703171662698; 3600,
        0.00662703171662698; 3600,0.00660504215376483; 7200,0.00660504215376483;
        7200,0.00658329104118168; 10800,0.00658329104118168; 10800,0.00656177589177944;
        14400,0.00656177589177944; 14400,0.00654049410182535; 18000,0.00654049410182535;
        18000,0.00651944240508857; 21600,0.00651944240508857; 21600,0.00652616247658349;
        25200,0.00652616247658349; 25200,0.00666053993126319; 28800,0.00666053993126319;
        28800,0.00673479097243175; 32400,0.00673479097243175; 32400,0.00682692111389588;
        36000,0.00682692111389588; 36000,0.00690858401503034; 39600,0.00690858401503034;
        39600,0.00697952455696202; 43200,0.00697952455696202; 43200,0.00698518869159843;
        46800,0.00698518869159843; 46800,0.00693025718672708; 50400,0.00693025718672708;
        50400,0.0069954438135373; 54000,0.0069954438135373; 54000,0.0070547618479847;
        57600,0.0070547618479847; 57600,0.00705121555656393; 61200,0.00705121555656393;
        61200,0.0068652622648989; 64800,0.0068652622648989; 64800,0.00673914893305207;
        68400,0.00673914893305207; 68400,0.00674139555486991; 72000,0.00674139555486991;
        72000,0.00671792125842839; 75600,0.00671792125842839; 75600,0.00669496853221997;
        79200,0.00669496853221997; 79200,0.00667225226518614; 82800,0.00667225226518614;
        82800,0.00664977595587345; 86400,0.00664977595587345])
    "EnergyPlus result: outlet water mass fraction"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Modelica.Blocks.Sources.TimeTable PEPlu(table=[0,0; 3600,0; 3600,0; 7200,0; 7200,
        0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,1763.47498707807; 28800,1763.47498707807; 28800,1183.36369923951;
        32400,1183.36369923951; 32400,1222.24061595185; 36000,1222.24061595185;
        36000,1284.94443778468; 39600,1284.94443778468; 39600,1340.45543498917;
        43200,1340.45543498917; 43200,1328.35677565975; 46800,1328.35677565975;
        46800,1403.56121122807; 50400,1403.56121122807; 50400,1413.41392138206;
        54000,1413.41392138206; 54000,1400.19120963128; 57600,1400.19120963128;
        57600,1315.1351214868; 61200,1315.1351214868; 61200,0; 64800,0; 64800,0;
        68400,0; 68400,0; 72000,0; 72000,0; 75600,0; 75600,0; 79200,0; 79200,0;
        82800,0; 82800,0; 86400,0])
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
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,1.24782466102257; 28800,1.24782466102257; 28800,0.914953057215137;
        32400,0.914953057215137; 32400,0.937085040581806; 36000,0.937085040581806;
        36000,0.972748228832585; 39600,0.972748228832585; 39600,1.00434508780792;
        43200,1.00434508780792; 43200,0.996095220779564; 46800,0.996095220779564;
        46800,1.03936899663537; 50400,1.03936899663537; 50400,1.04397556594066;
        54000,1.04397556594066; 54000,1.03502493169209; 57600,1.03502493169209;
        57600,0.984188026796858; 61200,0.984188026796858; 61200,0; 64800,0; 64800,
        0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0; 75600,0; 79200,0; 79200,
        0; 82800,0; 82800,0; 86400,0]) "Mass flowrate at the evaporator"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Modelica.Blocks.Sources.TimeTable masConIn(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,0.448577471123572; 28800,0.448577471123572; 28800,0.448577471123573;
        32400,0.448577471123573; 32400,0.448577471123572; 36000,0.448577471123572;
        36000,0.448577471123572; 39600,0.448577471123572; 39600,0.448577471123572;
        43200,0.448577471123572; 43200,0.448577471123572; 46800,0.448577471123572;
        46800,0.448577471123572; 50400,0.448577471123572; 50400,0.448577471123572;
        54000,0.448577471123572; 54000,0.448577471123572; 57600,0.448577471123572;
        57600,0.448577471123572; 61200,0.448577471123572; 61200,0; 64800,0; 64800,
        0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0; 75600,0; 79200,0; 79200,
        0; 82800,0; 82800,0; 86400,0]) "Mass flowrate at the condenser"
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
