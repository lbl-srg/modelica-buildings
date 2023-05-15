within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation;
model SingleSpeedCoolingPLR
  "Validation model for single speed DX coil with PLR=1"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.Units.SI.Power Q_flow_nominal=datCoi.sta[1].nomVal.Q_flow_nominal
    "Nominal power";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=1141
    "Pressure drop at m_flow_nominal";

  parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
    datCoi(nSta=1,
    sta={
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
      spe=1800/60,
      nomVal=
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-25237.66,
        COP_nominal=3,
        SHR_nominal=0.775047,
        m_flow_nominal=1.72,
        tWet=1000,
        gamma=1.5),
      perCur=Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXCooling_Curve_II())})
    "Coil data"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

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

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedCooling
    sinSpeDX(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal,
    final datCoi=datCoi,
    final T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    final from_dp=true,
    final computeReevaporation=true,
    final eva(m(start=0)),
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

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
    "Measured outlet air temperature"
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
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Modelica.Blocks.Math.Add add(
    final k1=-1)
    "Convert humidity ratio (dry air) to humidity ratio (total air)"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.Blocks.Sources.Constant XEvaInMoiAir(
    final k=1.0)
    "Moist air fraction = 1"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

  Modelica.Blocks.Math.Division shrEPlu
    "EnergyPlus result: SHR"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));

  Modelica.Blocks.Sources.Pulse p(
    final nperiod=1,
    final offset=101325,
    final width=100,
    final period=36000,
    final startTime=25200,
    final amplitude=1086)
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

  Modelica.Blocks.Sources.BooleanTable onOff(startValue=true,
    table={
      0,
      25200,
      26223.8694421458,
      28800,
      30457.5364262964,
      32400,
      34157.5093643325,
      36000,
      37915.2504828207,
      39600,
      41687.2390146012,
      43200,
      45363.3505825759,
      46800,
      49129.0477925565,
      50400,
      52764.5288886473,
      54000,
      56361.5689116996,
      57600,
      59868.3223307805})
    "EnergyPlus PLR converted into on-off signal for this model"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

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

  Modelica.Blocks.Sources.TimeTable TEvaIn(
    final table=[
      0,29.34948133;
      3600,29.34948133;
      3600,29.01814876;
      7200,29.01814876;
      7200,28.76345897;
      10800,28.76345897;
      10800,28.53396626;
      14400,28.53396626;
      14400,28.29506697;
      18000,28.29506697;
      18000,28.08827214;
      21600,28.08827214;
      21600,28.04639166;
      25200,28.04639166;
      25200,24.08651629;
      28800,24.08651629;
      28800,24.09243025;
      32400,24.09243025;
      32400,24.20516777;
      36000,24.20516777;
      36000,24.37566383;
      39600,24.37566383;
      39600,24.56160617;
      43200,24.56160617;
      43200,24.52393669;
      46800,24.52393669;
      46800,24.39077471;
      50400,24.39077471;
      50400,24.33155125;
      54000,24.33155125;
      54000,24.27362306;
      57600,24.27362306;
      57600,24.16566121;
      61200,24.16566121;
      61200,35.62393274;
      64800,35.62393274;
      64800,32.89683519;
      68400,32.89683519;
      68400,31.14979083;
      72000,31.14979083;
      72000,30.65928154;
      75600,30.65928154;
      75600,30.28912721;
      79200,30.28912721;
      79200,29.91867206;
      82800,29.91867206;
      82800,29.61490681;
      86400,29.61490681])
    "Coil inlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Modelica.Blocks.Sources.TimeTable XEvaIn(
    final table=[
      0,0.00946;
      3600,0.00946;
      3600,0.00946;
      7200,0.00946;
      7200,0.00946;
      10800,0.00946;
      10800,0.00946;
      14400,0.00946;
      14400,0.00946;
      18000,0.00946;
      18000,0.00946;
      21600,0.00946;
      21600,0.00955;
      25200,0.00955;
      25200,0.0103;
      28800,0.0103;
      28800,0.0109;
      32400,0.0109;
      32400,0.0108;
      36000,0.0108;
      36000,0.0105;
      39600,0.0105;
      39600,0.01;
      43200,0.01;
      43200,0.00969;
      46800,0.00969;
      46800,0.00947;
      50400,0.00947;
      50400,0.00926;
      54000,0.00926;
      54000,0.00923;
      57600,0.00923;
      57600,0.00937;
      61200,0.00937;
      61200,0.00936;
      64800,0.00936;
      64800,0.00946;
      68400,0.00946;
      68400,0.00946;
      72000,0.00946;
      72000,0.00946;
      75600,0.00946;
      75600,0.00946;
      79200,0.00946;
      79200,0.00946;
      82800,0.00946;
      82800,0.00946;
      86400,0.00946])
    "Water fraction of moist air"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Modelica.Blocks.Sources.TimeTable TOutEPlu_ori(
    final table=[0,29.34948133; 3600,29.34948133;
        3600,29.01814876; 7200,29.01814876; 7200,28.76345897; 10800,28.76345897;
        10800,28.53396626; 14400,28.53396626; 14400,28.29506697; 18000,28.29506697;
        18000,28.08827214; 21600,28.08827214; 21600,28.04639166; 25200,28.04639166;
        25200,19.79102221; 28800,19.79102221; 28800,17.58304653; 32400,17.58304653;
        32400,17.35471965; 36000,17.35471965; 36000,16.95320861; 39600,16.95320861;
        39600,16.4388043; 43200,16.4388043; 43200,16.03301122; 46800,16.03301122;
        46800,15.41071946; 50400,15.41071946; 50400,15.15437515; 54000,15.15437515;
        54000,15.09543443; 57600,15.09543443; 57600,15.3159498; 61200,15.3159498;
        61200,35.62393274; 64800,35.62393274; 64800,32.89683519; 68400,32.89683519;
        68400,31.14979083; 72000,31.14979083; 72000,30.65928154; 75600,30.65928154;
        75600,30.28912721; 79200,30.28912721; 79200,29.91867206; 82800,29.91867206;
        82800,29.61490681; 86400,29.61490681])
    "EnergyPlus result: outlet temperature"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Modelica.Blocks.Sources.TimeTable PEPlu_ori(
    final table=[0,0; 3600,0; 3600,0; 7200,
        0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,
        0; 21600,0; 25200,0; 25200,2221.47212; 28800,2221.47212; 28800,
        3595.947729; 32400,3595.947729; 32400,3819.11052; 36000,3819.11052;
        36000,4235.566014; 39600,4235.566014; 39600,4714.070326; 43200,
        4714.070326; 43200,4835.805362; 46800,4835.805362; 46800,5089.357992;
        50400,5089.357992; 50400,5132.912713; 54000,5132.912713; 54000,
        5082.720823; 57600,5082.720823; 57600,4820.015593; 61200,4820.015593;
        61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0;
        75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: electric power"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));

  Modelica.Blocks.Sources.TimeTable XEvaOutEPlu_ori(
    final table=[0,0.009460927; 3600,0.009460927;
        3600,0.009460927; 7200,0.009460927; 7200,0.009460927; 10800,0.009460927;
        10800,0.009460927; 14400,0.009460927; 14400,0.009460927; 18000,0.009460927;
        18000,0.009460927; 21600,0.009460927; 21600,0.009553929; 25200,0.009553929;
        25200,0.010316263; 28800,0.010316263; 28800,0.010677981; 32400,0.010677981;
        32400,0.010521771; 36000,0.010521771; 36000,0.010225222; 39600,0.010225222;
        39600,0.009821415; 43200,0.009821415; 43200,0.009523837; 46800,0.009523837;
        46800,0.009220467; 50400,0.009220467; 50400,0.009042737; 54000,0.009042737;
        54000,0.009012184; 57600,0.009012184; 57600,0.009145645; 61200,0.009145645;
        61200,0.009361285; 64800,0.009361285; 64800,0.009459829; 68400,0.009459829;
        68400,0.009459801; 72000,0.009459801; 72000,0.009459801; 75600,0.009459801;
        75600,0.009459801; 79200,0.009459801; 79200,0.009459801; 82800,0.009459801;
        82800,0.009459801; 86400,0.009459801])
    "EnergyPlus result: outlet water mass fraction"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

  Modelica.Blocks.Sources.TimeTable Q_flowSenEPlu_ori(
    final table=[0,0; 3600,0; 3600,0;
        7200,0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,
        0; 21600,0; 25200,0; 25200,7378.442557; 28800,7378.442557; 28800,11190.03413;
        32400,11190.03413; 32400,11772.99874; 36000,11772.99874; 36000,12749.11676;
        39600,12749.11676; 39600,13941.844; 43200,13941.844; 43200,14565.84942;
        46800,14565.84942; 46800,15396.44898; 50400,15396.44898; 50400,15729.34223;
        54000,15729.34223; 54000,15730.20543; 57600,15730.20543; 57600,15170.91533;
        61200,15170.91533; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0;
        72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: sensible heat flow "
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Modelica.Blocks.Sources.TimeTable Q_flowEPlu_ori(
    final table=[0,0; 3600,0; 3600,
        0; 7200,0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,
        0; 18000,0; 18000,0; 21600,0; 21600,0; 25200,-1e-9;
        25200,-7464.76568; 28800,-7464.76568; 28800,-12134.51902; 32400,-12134.51902;
        32400,-12829.73888; 36000,-12829.73888; 36000,-13827.82263; 39600,-13827.82263;
        39600,-14802.70071; 43200,-14802.70071; 43200,-15271.18519; 46800,-15271.18519;
        46800,-16441.6341; 50400,-16441.6341; 50400,-16638.80981; 54000,-16638.80981;
        54000,-16649.7802; 57600,-16649.7802; 57600,-16109.92984; 61200,-16109.92984;
        61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0;
        72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0;
        82800,0; 86400,0])
    "EnergyPlus result: heat flow"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));

  Modelica.Blocks.Math.Add QCoo_flow
    "Total cooling heat flow rate"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  UnitDelay PEPlu(
    final samplePeriod=3600)
    "Delay input signal by one hour to match timestep with Modelica simulation"
    annotation (Placement(transformation(extent={{-68,-140},{-48,-120}})));

  UnitDelay Q_flowSenEPlu(
    final samplePeriod=3600)
    "Delay input signal by one hour to match timestep with Modelica simulation"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

  UnitDelay Q_flowEPlu(
    final samplePeriod=3600)
    "Delay input signal by one hour to match timestep with Modelica simulation"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));

  UnitDelay TOutEPlu(
    final samplePeriod=3600,
    final y_start=29.34948133)
    "Delay input signal by one hour to match timestep with Modelica simulation"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  UnitDelay XEvaOutEPlu(
    final samplePeriod=3600)
    "Delay input signal by one hour to match timestep with Modelica simulation"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Modelica.Blocks.Math.MultiSum multiSum(
    final nu=2)
    "Add small value to measured value to avoid division by zero"
    annotation (Placement(transformation(extent={{118,-120},{130,-108}})));

  Modelica.Blocks.Sources.Constant small(
    final k=-1e-9)
    "Small value to avoid division by zero"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  // The UnitDelay is reimplemented to avoid in Dymola 2016 the translation warning
  //   The initial conditions for variables of type Boolean are not fully specified.
  //   Dymola has selected default initial conditions.
  //   Assuming fixed default start value for the discrete non-states:
  //     PEPlu.firstTrigger(start = false)
  //     ...
protected
  block UnitDelay
    extends Modelica.Blocks.Discrete.UnitDelay(
      firstTrigger(start=false, fixed=true));
  end UnitDelay;

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
  connect(mux.y, sou.X_in)          annotation (Line(
      points={{-59,-50},{-52,-50},{-52,-14},{-42,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TCIn_K.Kelvin, sinSpeDX.TOut) annotation (Line(
      points={{-79,69.8},{-66.5,69.8},{-66.5,13},{-11,13}},
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
  connect(sinSpeDX.P, PMea.u) annotation (Line(
      points={{11,19},{30,19},{30,50},{38,50}},
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
  connect(onOff.y, sinSpeDX.on) annotation (Line(
      points={{-99,110},{-54,110},{-54,18},{-11,18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TCIn.y, TCIn_K.Celsius) annotation (Line(
      points={{-119,70},{-110.5,70},{-110.5,69.6},{-102,69.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, TEvaIn_K.Celsius) annotation (Line(
      points={{-119,-10},{-110.5,-10},{-110.5,-10.4},{-102,-10.4}},
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
      points={{11,15},{20,15},{20,32},{-48,32},{-48,84},{-42,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PEPlu_ori.y, PEPlu.u) annotation (Line(
      points={{-79,-130},{-70,-130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flowSenEPlu_ori.y, Q_flowSenEPlu.u) annotation (Line(
      points={{61,-50},{78,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flowSenEPlu.y, shrEPlu.u1) annotation (Line(
      points={{101,-50},{108,-50},{108,-84},{138,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flowEPlu_ori.y, Q_flowEPlu.u) annotation (Line(
      points={{61,-130},{78,-130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOutEPlu_ori.y, TOutEPlu.u) annotation (Line(
      points={{-19,-70},{-2,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaOutEPlu_ori.y, XEvaOutEPlu.u) annotation (Line(
      points={{-19,-130},{-2,-130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.y, shrEPlu.u2) annotation (Line(
      points={{131.02,-114},{134,-114},{134,-96},{138,-96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(small.y, multiSum.u[1]) annotation (Line(
      points={{101,-90},{110,-90},{110,-111.9},{118,-111.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flowEPlu.y, multiSum.u[2]) annotation (Line(
      points={{101,-130},{108,-130},{108,-116.1},{118,-116.1}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-140},
            {160,140}})),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Validation/SingleSpeedCoolingPLR.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400),
            Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedCooling\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedCooling</a>.
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
from EnergyPlus 7.1.
<p>
The EnergyPlus results were generated using the example file
<code>DXCoilSystemAuto.idf</code> from EnergyPlus 7.1.
On the summer design day, the PLR is below 1.
A similar effect has been achieved in this example by turning on the coil only for the period
during which it run in EnergyPlus.
This results in on-off cycle and fluctuating results.
To compare the results, the Modelica outputs are averaged over <i>3600</i> seconds,
and the EnergyPlus outputs are used with a zero order delay to avoid the time shift in results.
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
Updated class name to differentiate from validation models for heating coils.<br/>
Updated connect statements to reflect change in input instance on <code>sinSpeDX</code>
from <code>TConIn</code> to <code>TOut</code>.<br/>
Updated comments and formatting for readability.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Implemented <code>UnitDelay</code> to avoid a translation warning
because <code>UnitDelay.firstTrigger</code> does not set the <code>fixed</code>
attribute in MSL 3.2.1.
</li>
<li>
June 9, 2015, by Michael Wetter:<br/>
Corrected wrong link to run script.
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
end SingleSpeedCoolingPLR;
