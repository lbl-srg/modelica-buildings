within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation;
model SingleSpeedHeatingPLREnergyPlus
  "Validation model for single speed heating DX coil with PLR=1"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.Units.SI.Power Q_flow_nominal=datCoi.sta[1].nomVal.Q_flow_nominal
    "Nominal power";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=1141
    "Pressure drop at m_flow_nominal";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=1,
    T=294.15) "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325 + dp_nominal,
    use_T_in=true,
    nPorts=1,
    use_p_in=true,
    use_X_in=true,
    T=299.85) "Source"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating
    sinSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    datCoi=datCoi,
    T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    defCur=defCur,
    defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostOperation.resistive,
    defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTriggers.onDemand,
    tDefRun=0.166667)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Modelica.Blocks.Routing.Multiplex2 mux "Converts in an array"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Utilities.IO.BCVTB.From_degC TConIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Math.Mean TOutMea(f=1/3600)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Utilities.IO.BCVTB.To_degC TOutDegC
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Sources.RealExpression TOut(y=sinSpeDX.vol.T)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Math.Mean XConOutMea(f=1/3600)
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Modelica.Blocks.Sources.RealExpression XConOut(y=sum(sinSpeDX.vol.Xi))
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Modelica.Blocks.Math.Mean Q_flowMea(f=1/3600) "Mean of cooling rate"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Math.Mean PMea(f=1/3600) "Mean of power"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Constant XConInMoiAir(k=1.0) "Moist air fraction = 1"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Modelica.Blocks.Sources.Pulse p(
    nperiod=1,
    offset=101325,
    width=100,
    period=36000,
    startTime=25200,
    amplitude=1086) "Pressure"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Modelica.Blocks.Sources.RealExpression XConInMod(y=XConIn.y/(1 + XConIn.y))
    "Modified XConIn"
    annotation (Placement(transformation(extent={{-140,-54},{-120,-34}})));
  Modelica.Blocks.Sources.RealExpression XConOutEPluMod(y=XConOutEPlu.y/(1 +
        XConOutEPlu.y))
    "Modified XConOut of energyPlus to comapre with the model results"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Modelica.Blocks.Sources.BooleanTable onOff(startValue=true, table={0,25200,28335.33835,
        28800,31430.44239,32400,34507.24081,36000,37693.52174,39600,40987.60937,
        43200,44354.28059,46800,47802.30301,50400,51328.61818,54000,54994.97321,
        57600,58729.15311,61200})
                   "EnergyPlus PLR converted into on-off signal for this model"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Modelica.Blocks.Sources.TimeTable TEvaIn(table=[0,3.55; 3600,3.55; 3600,3.008333333;
        7200,3.008333333; 7200,2.158333333; 10800,2.158333333; 10800,1.058333333;
        14400,1.058333333; 14400,0.6; 18000,0.6; 18000,0.6; 21600,0.6; 21600,1.883333333;
        25200,1.883333333; 25200,4.083333333; 28800,4.083333333; 28800,5.35; 32400,
        5.35; 32400,5.6; 36000,5.6; 36000,5.6; 39600,5.6; 39600,5.6; 43200,5.6;
        43200,5.25; 46800,5.25; 46800,4.65; 50400,4.65; 50400,4.108333333; 54000,
        4.108333333; 54000,2.616666667; 57600,2.616666667; 57600,1.7; 61200,1.7;
        61200,0.708333333; 64800,0.708333333; 64800,-0.991666667; 68400,-0.991666667;
        68400,-1.7; 72000,-1.7; 72000,-1.991666667; 75600,-1.991666667; 75600,-2.2;
        79200,-2.2; 79200,-2.55; 82800,-2.55; 82800,-3.091666667; 86400,-3.091666667])
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Modelica.Blocks.Sources.TimeTable TConIn(table=[0,17.7467728; 3600,17.7467728;
        3600,17.03647146; 7200,17.03647146; 7200,16.3042587; 10800,16.3042587; 10800,
        15.54963436; 14400,15.54963436; 14400,14.8261144; 18000,14.8261144; 18000,
        14.20392218; 21600,14.20392218; 21600,13.73212477; 25200,13.73212477; 25200,
        18.13775874; 28800,18.13775874; 28800,18.98917828; 32400,18.98917828; 32400,
        18.84362922; 36000,18.84362922; 36000,18.67781277; 39600,18.67781277; 39600,
        18.56973958; 43200,18.56973958; 43200,18.47277852; 46800,18.47277852; 46800,
        18.34707406; 50400,18.34707406; 50400,18.26949267; 54000,18.26949267; 54000,
        18.100132; 57600,18.100132; 57600,18.07707154; 61200,18.07707154; 61200,
        21.75891799; 64800,21.75891799; 64800,20.37591472; 68400,20.37591472; 68400,
        19.09735222; 72000,19.09735222; 72000,18.02416599; 75600,18.02416599; 75600,
        17.06222709; 79200,17.06222709; 79200,16.15878681; 82800,16.15878681; 82800,
        15.27429373; 86400,15.27429373])
                    "Coil inlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Modelica.Blocks.Sources.TimeTable XConIn(table=[0,0.003514733; 3600,0.003514733;
        3600,0.003282215; 7200,0.003282215; 7200,0.003125193; 10800,0.003125193;
        10800,0.002997155; 14400,0.002997155; 14400,0.002919215; 18000,0.002919215;
        18000,0.002874315; 21600,0.002874315; 21600,0.002861721; 25200,0.002861721;
        25200,0.002969884; 28800,0.002969884; 28800,0.003089307; 32400,0.003089307;
        32400,0.00314972; 36000,0.00314972; 36000,0.003137002; 39600,0.003137002;
        39600,0.003181622; 43200,0.003181622; 43200,0.003138804; 46800,0.003138804;
        46800,0.003034015; 50400,0.003034015; 50400,0.002874456; 54000,0.002874456;
        54000,0.002723247; 57600,0.002723247; 57600,0.002631946; 61200,0.002631946;
        61200,0.002600495; 64800,0.002600495; 64800,0.002587386; 68400,0.002587386;
        68400,0.002591803; 72000,0.002591803; 72000,0.002631426; 75600,0.002631426;
        75600,0.002660396; 79200,0.002660396; 79200,0.002675337; 82800,0.002675337;
        82800,0.002679452; 86400,0.002679452])
                "Water fraction of moist air"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Sources.TimeTable TOutEPlu_ori(table=[0,17.7467728; 3600,17.7467728;
        3600,17.03647146; 7200,17.03647146; 7200,16.3042587; 10800,16.3042587; 10800,
        15.54963436; 14400,15.54963436; 14400,14.8261144; 18000,14.8261144; 18000,
        14.20392218; 21600,14.20392218; 21600,13.73212477; 25200,13.73212477; 25200,
        34.6586062; 28800,34.6586062; 28800,33.06256802; 32400,33.06256802; 32400,
        30.14383413; 36000,30.14383413; 36000,27.75367476; 39600,27.75367476; 39600,
        26.00233862; 43200,26.00233862; 43200,24.62931456; 46800,24.62931456; 46800,
        23.65413217; 50400,23.65413217; 50400,23.15522467; 54000,23.15522467; 54000,
        23.24062711; 57600,23.24062711; 57600,23.85075817; 61200,23.85075817; 61200,
        21.75891799; 64800,21.75891799; 64800,20.37591472; 68400,20.37591472; 68400,
        19.09735222; 72000,19.09735222; 72000,18.02416599; 75600,18.02416599; 75600,
        17.06222709; 79200,17.06222709; 79200,16.15878681; 82800,16.15878681; 82800,
        15.27429373; 86400,15.27429373])
    "EnergyPlus result: outlet temperature"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.TimeTable PEPlu_ori(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,4521.561247; 28800,4521.561247; 28800,3807.557756; 32400,
        3807.557756; 32400,3036.661804; 36000,3036.661804; 36000,2429.169114; 39600,
        2429.169114; 39600,1984.291082; 43200,1984.291082; 43200,1647.032691; 46800,
        1647.032691; 46800,1426.801036; 50400,1426.801036; 50400,1320.925757; 54000,
        1320.925757; 54000,1417.287327; 57600,1417.287327; 57600,1615.165913; 61200,
        1615.165913; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,
        0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: electric power"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Modelica.Blocks.Sources.TimeTable XConOutEPlu_ori(table=[0,0.003514733; 3600,0.003514733;
        3600,0.003282215; 7200,0.003282215; 7200,0.003125193; 10800,0.003125193;
        10800,0.002997155; 14400,0.002997155; 14400,0.002919215; 18000,0.002919215;
        18000,0.002874315; 21600,0.002874315; 21600,0.002861721; 25200,0.002861721;
        25200,0.002969884; 28800,0.002969884; 28800,0.003089307; 32400,0.003089307;
        32400,0.00314972; 36000,0.00314972; 36000,0.003137002; 39600,0.003137002;
        39600,0.003181622; 43200,0.003181622; 43200,0.003138804; 46800,0.003138804;
        46800,0.003034015; 50400,0.003034015; 50400,0.002874456; 54000,0.002874456;
        54000,0.002723247; 57600,0.002723247; 57600,0.002631946; 61200,0.002631946;
        61200,0.002600495; 64800,0.002600495; 64800,0.002587386; 68400,0.002587386;
        68400,0.002591803; 72000,0.002591803; 72000,0.002631426; 75600,0.002631426;
        75600,0.002660396; 79200,0.002660396; 79200,0.002675337; 82800,0.002675337;
        82800,0.002679452; 86400,0.002679452])
    "EnergyPlus result: outlet water mass fraction"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowEPlu_ori(table=[0,0; 3600,0; 3600,0; 7200,
        0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,13056.85272; 28800,13056.85272; 28800,11124.95877;
        32400,11124.95877; 32400,8933.803237; 36000,8933.803237; 36000,7175.078965;
        39600,7175.078965; 39600,5876.46084; 43200,5876.46084; 43200,4867.188478;
        46800,4867.188478; 46800,4194.807999; 50400,4194.807999; 50400,3860.64525;
        54000,3860.64525; 54000,4060.810991; 57600,4060.810991; 57600,4560.249442;
        61200,4560.249442; 61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0;
        72000,0; 75600,0; 75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
                           "EnergyPlus result: heat flow"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
    datCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          activate_CooCoi=false,
          Q_flow_nominal=15000,
          COP_nominal=2.75,
          SHR_nominal=1,
          m_flow_nominal=0.782220983308365,
          TEvaIn_nominal=273.15 + 6,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_Curve_II())},
      nSta=1) "Coil data"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  UnitDelay PEPlu(samplePeriod=3600)
    annotation (Placement(transformation(extent={{-68,-140},{-48,-120}})));
  UnitDelay Q_flowEPlu(samplePeriod=3600)
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  UnitDelay TOutEPlu(samplePeriod=3600, y_start=29.34948133)
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  UnitDelay XConOutEPlu(samplePeriod=1)
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  // The UnitDelay is reimplemented to avoid in Dymola 2016 the translation warning
  //   The initial conditions for variables of type Boolean are not fully specified.
  //   Dymola has selected default initial conditions.
  //   Assuming fixed default start value for the discrete non-states:
  //     PEPlu.firstTrigger(start = false)
  //     ...
  Data.Generic.BaseClasses.Defrost defCur(
    defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostOperation.resistive,
    QDefResCap=10500,
    QCraCap=200,
    PLFraFunPLR={1})
    annotation (Placement(transformation(extent={{80,-6},{100,14}})));

  Modelica.Blocks.Sources.TimeTable XOut(table=[0, 0.002977455;
3600, 0.002977455;
3600, 0.00291943;
7200, 0.00291943;
7200, 0.002837845;
10800, 0.002837845;
10800, 0.002801369;
14400, 0.002801369;
14400, 0.002809981;
18000, 0.002809981;
18000, 0.002808798;
21600, 0.002808798;
21600, 0.002948981;
25200, 0.002948981;
25200, 0.003124722;
28800, 0.003124722;
28800, 0.003250046;
32400, 0.003250046;
32400, 0.003136823;
36000, 0.003136823;
36000, 0.003181272;
39600, 0.003181272;
39600, 0.00319715;
43200, 0.00319715;
43200, 0.003049156;
46800, 0.003049156;
46800, 0.002861627;
50400, 0.002861627;
50400, 0.002651674;
54000, 0.002651674;
54000, 0.002559639;
57600, 0.002559639;
57600, 0.002541949;
61200, 0.002541949;
61200, 0.002551284;
64800, 0.002551284;
64800, 0.002574109;
68400, 0.002574109;
68400, 0.002658437;
72000, 0.002658437;
72000, 0.002704881;
75600, 0.002704881;
75600, 0.002697955;
79200, 0.002697955;
79200, 0.002691605;
82800, 0.002691605;
82800, 0.002672408;
86400, 0.002672408])
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
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
  connect(TEvaIn_K.Kelvin, sinSpeDX.TOut) annotation (Line(
      points={{-79,79.8},{-66.5,79.8},{-66.5,13},{-11,13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TConIn_K.Kelvin, sou.T_in)    annotation (Line(
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
  connect(XConOut.y,XConOutMea. u)
                           annotation (Line(
      points={{61,130},{78,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XConInMoiAir.y, add.u2)
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
      points={{-119,20},{-74,20},{-74,-2},{-42,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XConInMod.y, mux.u1[1]) annotation (Line(
      points={{-119,-44},{-82,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XConInMod.y, add.u1) annotation (Line(
      points={{-119,-44},{-110,-44},{-110,-84},{-102,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on) annotation (Line(
      points={{-99,110},{-54,110},{-54,18},{-11,18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TEvaIn.y, TEvaIn_K.Celsius) annotation (Line(
      points={{-119,80},{-110.5,80},{-110.5,79.6},{-102,79.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TConIn.y,TConIn_K. Celsius) annotation (Line(
      points={{-119,-10},{-110.5,-10},{-110.5,-10.4},{-102,-10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PEPlu_ori.y, PEPlu.u) annotation (Line(
      points={{-79,-130},{-70,-130}},
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
  connect(XConOutEPlu_ori.y,XConOutEPlu. u) annotation (Line(
      points={{-19,-130},{-2,-130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.QSen_flow, Q_flowMea.u) annotation (Line(points={{11,17},{20,
          17},{20,54},{-10,54},{-10,90},{-2,90}}, color={0,0,127}));
  connect(XOut.y, sinSpeDX.XOut) annotation (Line(points={{-119,50},{-20,50},{
          -20,1},{-11,1}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-140},
            {160,140}})),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Validation/SingleSpeedHeatingPLREnergyPlus.mos"
        "Simulate and Plot"),
    experiment(Tolerance=1e-6, StopTime=86400),
            Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed</a>.
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
end SingleSpeedHeatingPLREnergyPlus;
