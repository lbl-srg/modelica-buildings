<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Validation/SingleSpeedCooling.mo
within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation;
model SingleSpeedCooling
=======
within Buildings.Fluid.DXSystems.Cooling.AirSource.Validation;
model SingleSpeed
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Validation/SingleSpeed.mo
  "Validation model for single speed DX coil with PLR=1"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air
    "Medium model";

  parameter Modelica.Units.SI.Power Q_flow_nominal=datCoi.sta[1].nomVal.Q_flow_nominal
    "Nominal power";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=1141
    "Pressure drop at m_flow_nominal";

  parameter
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Validation/SingleSpeedCooling.mo
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
    datCoi(nSta=1,
      sta={
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
=======
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil
    datCoi(nSta=1, sta={
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Validation/SingleSpeed.mo
          Q_flow_nominal=-10500,
          COP_nominal=3,
          SHR_nominal=0.798655,
          m_flow_nominal=1.72),
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Validation/SingleSpeedCooling.mo
        perCur=Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXCooling_Curve_II())})
=======
        perCur=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_II())})
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Validation/SingleSpeed.mo
    "Coil data"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    final nPorts=1,
    final T=303.15)
    "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    final p(displayUnit="Pa") = 101325 + dp_nominal,
    final use_T_in=true,
    final nPorts=1,
    final use_p_in=true,
    final use_X_in=true,
    final T=299.85)
    "Source"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Validation/SingleSpeedCooling.mo
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedCooling
=======
  Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Validation/SingleSpeed.mo
    sinSpeDX(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final datCoi=datCoi,
    final T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Modelica.Blocks.Sources.TimeTable plr_onOff(final table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,1; 28800,1; 28800,1; 32400,1; 32400,1; 36000,1; 36000,
        1; 39600,1; 39600,1; 43200,1; 43200,1; 46800,1; 46800,1; 50400,1; 50400,
        1; 54000,1; 54000,1; 57600,1; 57600,1; 61200,1; 61200,0; 64800,0; 64800,
        0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0; 75600,0; 79200,0; 79200,
        0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus PLR converted into on-off signal for this model"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Modelica.Blocks.Sources.TimeTable TCIn(final table=[0,21.1; 3600,21.1; 3600,
        20.80833333; 7200,20.80833333; 7200,20.89166667; 10800,20.89166667;
        10800,21.1; 14400,21.1; 14400,20.80833333; 18000,20.80833333; 18000,
        20.6; 21600,20.6; 21600,20.89166667; 25200,20.89166667; 25200,21.45;
        28800,21.45; 28800,22.63333333; 32400,22.63333333; 32400,23.3; 36000,
        23.3; 36000,25.575; 39600,25.575; 39600,28.19166667; 43200,28.19166667;
        43200,27.90833333; 46800,27.90833333; 46800,26.90833333; 50400,
        26.90833333; 50400,26.7; 54000,26.7; 54000,26.05833333; 57600,
        26.05833333; 57600,24.60833333; 61200,24.60833333; 61200,23.55; 64800,
        23.55; 64800,23.3; 68400,23.3; 68400,23.00833333; 72000,23.00833333;
        72000,22.8; 75600,22.8; 75600,22.15833333; 79200,22.15833333; 79200,
        21.35; 82800,21.35; 82800,21.1; 86400,21.1])
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Modelica.Blocks.Sources.TimeTable TEvaIn(final table=[0,31.29534707; 3600,31.29534707;
        3600,30.89999423; 7200,30.89999423; 7200,30.58355581; 10800,30.58355581;
        10800,30.30108174; 14400,30.30108174; 14400,30.01393253; 18000,30.01393253;
        18000,29.75672215; 21600,29.75672215; 21600,29.66076742; 25200,29.66076742;
        25200,25.29138892; 28800,25.29138892; 28800,25.91180176; 32400,25.91180176;
        32400,26.79831523; 36000,26.79831523; 36000,27.40611604; 39600,27.40611604;
        39600,28.22402981; 43200,28.22402981; 43200,28.69183674; 46800,28.69183674;
        46800,29.0211012; 50400,29.0211012; 50400,29.3698004; 54000,29.3698004;
        54000,29.52289127; 57600,29.52289127; 57600,29.41955159; 61200,29.41955159;
        61200,38.68278429; 64800,38.68278429; 64800,35.75595795; 68400,35.75595795;
        68400,33.29770237; 72000,33.29770237; 72000,32.78839302; 75600,32.78839302;
        75600,32.3989099; 79200,32.3989099; 79200,32.00270417; 82800,32.00270417;
        82800,31.66453096; 86400,31.66453096])
    "Coil inlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Modelica.Blocks.Sources.TimeTable XEvaIn(final table=[0,0.010526598; 3600,0.010526598;
        3600,0.010526598; 7200,0.010526598; 7200,0.010526598; 10800,0.010526598;
        10800,0.010526598; 14400,0.010526598; 14400,0.010526598; 18000,
        0.010526598; 18000,0.010526598; 21600,0.010526598; 21600,0.010631087;
        25200,0.010631087; 25200,0.010396485; 28800,0.010396485; 28800,
        0.009496633; 32400,0.009496633; 32400,0.009521406; 36000,0.009521406;
        36000,0.009576525; 39600,0.009576525; 39600,0.009574467; 43200,
        0.009574467; 43200,0.009610872; 46800,0.009610872; 46800,0.009792709;
        50400,0.009792709; 50400,0.010022684; 54000,0.010022684; 54000,
        0.010213791; 57600,0.010213791; 57600,0.010384401; 61200,0.010384401;
        61200,0.010396282; 64800,0.010396282; 64800,0.010537993; 68400,
        0.010537993; 68400,0.010537961; 72000,0.010537961; 72000,0.010537961;
        75600,0.010537961; 75600,0.010537961; 79200,0.010537961; 79200,
        0.010537961; 82800,0.010537961; 82800,0.010537961; 86400,0.010537961])
    "Water fraction of moist air"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Modelica.Blocks.Math.RealToBoolean onOff
    "Enable the DX coil when input is greater than 0.5"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));

  Modelica.Blocks.Routing.Multiplex2 mux
    "Converts in an array"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Utilities.IO.BCVTB.From_degC TCIn_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Modelica.Blocks.Math.Mean TOutMea(
    final f=1/3600)
    "Average out value over one hour"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Buildings.Utilities.IO.BCVTB.To_degC TOutDegC
    "Convert to degree Celsius"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));

  Modelica.Blocks.Sources.RealExpression TOut(
    final y=sinSpeDX.vol.T)
    "Measured outlet air temperature from model"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

  Modelica.Blocks.Math.Mean XEvaOutMea(
    final f=1/3600)
    "Average out value over one hour"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));

  Modelica.Blocks.Sources.RealExpression XEvaOut(
    final y=sum(sinSpeDX.vol.Xi))
    "Measured outlet air humidity ratio (total air)"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));

  Modelica.Blocks.Math.Mean Q_flowMea(
    final f=1/3600)
    "Mean of cooling rate"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Modelica.Blocks.Math.Mean Q_flowSenMea(
    final f=1/3600)
    "Mean of sensible cooling rate"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));

  Modelica.Blocks.Math.Mean PMea(
    final f=1/3600)
    "Mean of power"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Modelica.Blocks.Math.Add add(
    final k1=-1)
    "Convert humidity ratio (dry air) to humidity ratio (total air)"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.Blocks.Sources.Constant XEvaInMoiAir(
    final k=1.0)
    "Moist air fraction = 1"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

  Modelica.Blocks.Sources.TimeTable TOutEPlu(final table=[0,31.29534707; 3600,31.29534707;
        3600,30.89999423; 7200,30.89999423; 7200,30.58355581; 10800,30.58355581;
        10800,30.30108174; 14400,30.30108174; 14400,30.01393253; 18000,30.01393253;
        18000,29.75672215; 21600,29.75672215; 21600,29.66076742; 25200,29.66076742;
        25200,20.31734137; 28800,20.31734137; 28800,20.48740189; 32400,20.48740189;
        32400,21.17362815; 36000,21.17362815; 36000,21.67091874; 39600,21.67091874;
        39600,22.31588652; 43200,22.31588652; 43200,22.67802681; 46800,22.67802681;
        46800,22.97615397; 50400,22.97615397; 50400,23.31283949; 54000,23.31283949;
        54000,23.48357346; 57600,23.48357346; 57600,23.44857837; 61200,23.44857837;
        61200,38.68278429; 64800,38.68278429; 64800,35.75595795; 68400,35.75595795;
        68400,33.29770237; 72000,33.29770237; 72000,32.78839302; 75600,32.78839302;
        75600,32.3989099; 79200,32.3989099; 79200,32.00270417; 82800,32.00270417;
        82800,31.66453096; 86400,31.66453096])
    "EnergyPlus result: outlet temperature"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

  Modelica.Blocks.Sources.TimeTable Q_flowEPlu(final table=[0,-1e-07; 3600,-1e-07; 3600,
        -1e-07; 7200,-1e-07; 7200,-1e-07; 10800,-1e-07; 10800,-1e-07; 14400,-1e-07;
        14400,-1e-07; 18000,-1e-07; 18000,-1e-07; 21600,-1e-07; 21600,-1e-07; 25200,
        -1e-07; 25200,-10983.1144101; 28800,-10983.1144101; 28800,-10855.9768001;
        32400,-10855.9768001; 32400,-10903.5304201; 36000,-10903.5304201; 36000,
        -10877.5678501; 39600,-10877.5678501; 39600,-10822.2172001; 43200,-10822.2172001;
        43200,-10878.2459001; 46800,-10878.2459001; 46800,-10981.5365901; 50400,
        -10981.5365901; 50400,-11055.6112701; 54000,-11055.6112701; 54000,-11121.6278701;
        57600,-11121.6278701; 57600,-11185.7466001; 61200,-11185.7466001; 61200,
        -1e-07; 64800,-1e-07; 64800,-1e-07; 68400,-1e-07; 68400,-1e-07; 72000,-1e-07;
        72000,-1e-07; 75600,-1e-07; 75600,-1e-07; 79200,-1e-07; 79200,-1e-07; 82800,
        -1e-07; 82800,-1e-07; 86400,-1e-07])
    "EnergyPlus result: heat flow"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));

  Modelica.Blocks.Sources.TimeTable Q_flowSenEPlu(final table=[0,0; 3600,0; 3600,0; 7200,
        0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,-8537.795206; 28800,-8537.795206; 28800,-9298.755552;
        32400,-9298.755552; 32400,-9643.742602; 36000,-9643.742602; 36000,-9835.115234;
        39600,-9835.115234; 39600,-10133.17939; 43200,-10133.17939; 43200,-10315.64445;
        46800,-10315.64445; 46800,-10372.27848; 50400,-10372.27848; 50400,-10397.02013;
        54000,-10397.02013; 54000,-10369.92204; 57600,-10369.92204; 57600,-10254.97156;
        61200,-10254.97156; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0;
        72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: sensible heat flow "
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Modelica.Blocks.Math.Division shrEPlu
    "EnergyPlus result: SHR"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));

  Modelica.Blocks.Sources.TimeTable XEvaOutEPlu(final table=[0,0.010526598; 3600,0.010526598;
        3600,0.010526598; 7200,0.010526598; 7200,0.010526598; 10800,0.010526598;
        10800,0.010526598; 14400,0.010526598; 14400,0.010526598; 18000,0.010526598;
        18000,0.010526598; 21600,0.010526598; 21600,0.010631087; 25200,0.010631087;
        25200,0.009824324; 28800,0.009824324; 28800,0.009132468; 32400,0.009132468;
        32400,0.009227012; 36000,0.009227012; 36000,0.009333022; 39600,0.009333022;
        39600,0.009413613; 43200,0.009413613; 43200,0.009479582; 46800,0.009479582;
        46800,0.009650565; 50400,0.009650565; 50400,0.009869069; 54000,0.009869069;
        54000,0.010038477; 57600,0.010038477; 57600,0.010167307; 61200,0.010167307;
        61200,0.010396282; 64800,0.010396282; 64800,0.010537993; 68400,0.010537993;
        68400,0.010537961; 72000,0.010537961; 72000,0.010537961; 75600,0.010537961;
        75600,0.010537961; 79200,0.010537961; 79200,0.010537961; 82800,0.010537961;
        82800,0.010537961; 86400,0.010537961])
    "EnergyPlus result: outlet water mass fraction"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Modelica.Blocks.Sources.TimeTable PEPlu(final table=[0,0; 3600,0; 3600,0; 7200,0; 7200,
        0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,2947.546668; 28800,2947.546668; 28800,2966.686535; 32400,
        2966.686535; 32400,2999.864072; 36000,2999.864072; 36000,3087.801241; 39600,
        3087.801241; 39600,3195.082124; 43200,3195.082124; 43200,3188.668029; 46800,
        3188.668029; 46800,3156.065892; 50400,3156.065892; 50400,3155.199826; 54000,
        3155.199826; 54000,3136.04256; 57600,3136.04256; 57600,3087.770321; 61200,
        3087.770321; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,
        0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: electric power"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));

  Modelica.Blocks.Sources.Pulse p(
    final nperiod=1,
    final offset=101325,
    final amplitude=1141,
    final width=100,
    final period=36000,
    final startTime=25200)
    "Pressure"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Modelica.Blocks.Sources.RealExpression XEvaInMod(
    final y=XEvaIn.y/(1 + XEvaIn.y))
    "Modified XEvaIn"
    annotation (Placement(transformation(extent={{-140,-54},{-120,-34}})));

  Modelica.Blocks.Sources.RealExpression XEvaOutEPluMod(
    final y=XEvaOutEPlu.y/(1 + XEvaOutEPlu.y))
    "Modified XEvaOut of energyPlus to comapre with the model results"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));

  Modelica.Blocks.Math.Add QCoo_flow
    "Total cooling heat flow rate"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

equation
  connect(sou.ports[1], sinSpeDX.port_a)
                                        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,10},{-10,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinSpeDX.port_b, sin.ports[1])
                                        annotation (Line(
      points={{10,10},{16,10},{16,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(plr_onOff.y, onOff.u)         annotation (Line(
      points={{-119,110},{-102,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on)         annotation (Line(
      points={{-79,110},{-60,110},{-60,18},{-11,18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mux.y, sou.X_in)          annotation (Line(
      points={{-59,-50},{-52,-50},{-52,-14},{-42,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TCIn.y, TCIn_K.Celsius)  annotation (Line(
      points={{-119,70},{-116,70},{-116,69.6},{-102,69.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TCIn_K.Kelvin, sinSpeDX.TOut) annotation (Line(
      points={{-79,69.8},{-66.5,69.8},{-66.5,13},{-11,13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, TEvaIn_K.Celsius)    annotation (Line(
      points={{-119,-10},{-112.1,-10},{-112.1,-10.4},{-102,-10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn_K.Kelvin, sou.T_in)    annotation (Line(
      points={{-79,-10.2},{-51.7,-10.2},{-51.7,-6},{-42,-6}},
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
      points={{-79,-90},{-68,-90},{-68,-68},{-96,-68},{-96,-56},{-82,-56}},
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
  connect(sinSpeDX.P, PMea.u) annotation (Line(
      points={{11,19},{14,19},{14,50},{78,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-119,30},{-74,30},{-74,-2},{-42,-2}},
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
  connect(sinSpeDX.QSen_flow, Q_flowSenMea.u) annotation (Line(
      points={{11,17},{20,17},{20,60},{-12,60},{-12,130},{-2,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QCoo_flow.y, Q_flowMea.u) annotation (Line(
      points={{-19,90},{-2,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QCoo_flow.u1, sinSpeDX.QSen_flow) annotation (Line(
      points={{-42,96},{-50,96},{-50,30},{18,30},{18,17},{11,17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.QLat_flow, QCoo_flow.u2) annotation (Line(
      points={{12.6,13},{20,13},{20,32},{-48,32},{-48,84},{-42,84}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,
            -140},{160,140}})),
             __Dymola_Commands(file=
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Validation/SingleSpeedCooling.mo
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Validation/SingleSpeedCooling.mos"
=======
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/Cooling/AirSource/Validation/SingleSpeed.mos"
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Validation/SingleSpeed.mo
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400),
    Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed\">
Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed</a>.
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
revisions="<html>
<ul>
<li>
April 5, 2023, by Karthik Devaprasad and Xing Lu:<br/>
Updated model name to differentiate from heating coil validation models.<br/>
Updated connection statements to reflect change in input instance on <code>sinSpeDX</code>
from <code>TConIn</code> to <code>TOut</code>.<br/>
Updated formatting for readability.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
September 4, 2012 by Michael Wetter:<br/>
Modified example to avoid having to access protected data.
</li>
<li>
August 20, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
<<<<<<< HEAD:Buildings/Fluid/DXSystems/Cooling/WaterSource/Validation/SingleSpeedCooling.mo
end SingleSpeedCooling;
=======
end SingleSpeed;
>>>>>>> master:Buildings/Fluid/DXSystems/Cooling/AirSource/Validation/SingleSpeed.mo
