within Buildings.Examples.BoilerPlant.PlantModel;
model BoilerPlant
    "Boiler plant model for closed loop testing"

  replaceable package MediumA =
      Buildings.Media.Air;

  replaceable package MediumW =
      Buildings.Media.Water
    "Medium model";

  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal = V*1.2*6/3600
    "Nominal mass flow rate"
    annotation(dialog(group="Zone parameters"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = boiEff1[1]*boiCap1 + boiEff2[1]*boiCap2
    "Nominal heat flow rate of radiator"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.HeatFlowRate boiCap1= 15000
    "Boiler capacity for boiler-1"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.HeatFlowRate boiCap2= 15000
    "Boiler capacity for boiler-2"
    annotation(dialog(group="Boiler parameters"));

  parameter Real boiEff1[6](
    final unit="1",
    displayUnit="1") = {0.6246, 0.7711, -1.2077*10e-15, 0.008576, -0.005933, 0.003156}
    "Efficiency for boiler-1"
    annotation(dialog(group="Boiler parameters"));

  parameter Real boiEff2[6](
    final unit="1",
    displayUnit="1") = {0.6246, 0.7711, -1.2077*10e-15, 0.008576, -0.005933, 0.003156}
    "Efficiency for boiler-2"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.Temperature TRadSup_nominal = 273.15+70
    "Radiator nominal supply water temperature"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.Temperature TRadRet_nominal = 273.15+50
    "Radiator nominal return water temperature"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=0.000604*1000
    "Radiator nominal mass flow rate"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.Temperature TBoiSup_nominal = 273.15+70
    "Boiler nominal supply water temperature"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.Temperature TBoiRet_min = 273.15+60
    "Boiler minimum return water temperature"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal1=mRad_flow_nominal
    "Boiler-1 nominal mass flow rate"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal2=mRad_flow_nominal
    "Boiler-2 nominal mass flow rate"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.Volume V=1200
    "Room volume"
    annotation(dialog(group="Zone parameters"));

  parameter Modelica.Units.SI.Temperature TAir_nominal=273.15 + 23.9
    "Air temperature at nominal condition"
    annotation(dialog(group="Zone parameters"));

  parameter Real zonTheCap(
    final unit="J/K",
    displayUnit="J/K",
    final quantity="HeatCapacity") = 2*V*1.2*1500
    "Zone thermal capacitance"
    annotation(dialog(group="Zone parameters"));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal_value=6000
    "Nominal pressure drop of fully open valve, used if CvData=Buildings.Fluid.Types.CvTypes.OpPoint";

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal_value=1000
    "Pressure drop of pipe and other resistances that are in series";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSta[2]
    "Boiler status signal"
    annotation (Placement(transformation(extent={{-360,100},{-320,140}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[1]
    "Pump status signal"
    annotation (Placement(transformation(extent={{-360,20},{-320,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotIsoVal[2](
    final unit="1",
    displayUnit="1")
    "Hot water isolation valve signal"
    annotation (Placement(transformation(extent={{-360,50},{-320,90}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1")
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-360,-20},{-320,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValSig(
    final unit="1",
    displayUnit="1")
    "Bypass valve signal"
    annotation (Placement(transformation(extent={{-360,-60},{-320,-20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput QRooInt_flowrate(
    final unit="W",
    displayUnit="W",
    final quantity="EnergyFlowRate")
    "Room internal load flowrate"
    annotation (Placement(transformation(extent={{-360,190},{-320,230}}),
      iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRadConVal(
    final unit="1",
    displayUnit="1") "Radiator control valve signal"
    annotation (Placement(transformation(extent={{-360,150},{-320,190}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutAir(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-360,-100},{-320,-60}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBoiHotWatSupSet[2](
    final unit=fill("K", 2),
    displayUnit=fill("degC", 2),
    final quantity=fill("ThermodynamicTemperature", 2))
    "Boiler hot water supply temperature setpoint vector"
    annotation (Placement(transformation(extent={{-360,-150},{-320,-110}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoiSta[2]
    "Boiler status signal"
    annotation (Placement(transformation(extent={{320,-90},{360,-50}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSta[1]
    "Pump status signal"
    annotation (Placement(transformation(extent={{320,-130},{360,-90}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yZonTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{320,120},{360,160}}),
      iconTransformation(extent={{100,70},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply temperature"
    annotation (Placement(transformation(extent={{320,80},{360,120}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured return temperature"
    annotation (Placement(transformation(extent={{320,40},{360,80}}),
      iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatDp[1](
    final unit="Pa",
    displayUnit="Pa")
    "Hot water differential pressure between supply and return"
    annotation (Placement(transformation(extent={{320,-10},{360,30}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured flowrate in primary circuit"
    annotation (Placement(transformation(extent={{320,-50},{360,-10}}),
      iconTransformation(extent={{100,-50},{140,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[2](
    final unit=fill("1",2),
    displayUnit=fill("1",2))
    "Measured boiler hot water isolation valve position"
    annotation (Placement(transformation(extent={{320,-170},{360,-130}}),
      iconTransformation(extent={{100,-140},{140,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBypValSig(
    final unit="1",
    displayUnit="1")
    "Measured bypass valve position signal"
    annotation (Placement(transformation(extent={{320,160},{360,200}}),
      iconTransformation(extent={{100,100},{140,140}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mA_flow_nominal,
    final V=1.2*V,
    final nPorts=1)
    "Mixing volume to represent zone air"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(
    final G=20000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{100,200},{120,220}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(
    final C=zonTheCap)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));

  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mRad_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a_nominal=TRadSup_nominal,
    final T_b_nominal=TRadRet_nominal,
    final TAir_nominal=TAir_nominal,
    final dp_nominal=0)
    "Radiator"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mBoi_flow_nominal1,
    final dp_nominal=dpFixed_nominal_value,
    final Q_flow_nominal=boiCap1,
    final T_nominal=TBoiSup_nominal,
    final effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    final a=boiEff1,
    final fue=Fluid.Data.Fuels.NaturalGasHigherHeatingValue(),
    final UA=boiCap1/39.81)
    "Boiler-2"
    annotation (Placement(transformation(extent={{110,-160},{90,-140}})));

  Buildings.Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumW,
    p=100000,
    nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{0,-100},{-20,-80}})));

  Buildings.Fluid.Boilers.BoilerPolynomial boi1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mBoi_flow_nominal2,
    final dp_nominal=dpFixed_nominal_value,
    final Q_flow_nominal=boiCap2,
    final T_nominal=TBoiSup_nominal,
    final effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    final a=boiEff2,
    final fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue(),
    final UA=boiCap2/39.81)
    "Boiler-1"
    annotation (Placement(transformation(extent={{110,-220},{90,-200}})));

  Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium = Media.Water,
    final allowFlowReversal=true,
    redeclare Fluid.Movers.Data.Pumps.BoilerPlant per,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    riseTime=15) "Hot water primary pump-1" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-70})));

  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi_flow_nominal2,-mRad_flow_nominal,mBoi_flow_nominal1},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-150})));

  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mRad_flow_nominal,-mRad_flow_nominal,-mRad_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,40})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal,
    final dpValve_nominal=dpValve_nominal_value,
    riseTime=30,
    dpFixed_nominal=dpFixed_nominal_value)
    "Minimum flow bypass valve"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

  Buildings.Fluid.FixedResistances.Junction spl5(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mRad_flow_nominal,-mRad_flow_nominal,
        mRad_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=270,
      origin={210,40})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal,
    final dpValve_nominal=dpValve_nominal_value,
    y_start=0,
    dpFixed_nominal=dpFixed_nominal_value)
    "Isolation valve for boiler-2"
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal,
    final dpValve_nominal=dpValve_nominal_value,
    y_start=0,
    dpFixed_nominal=dpFixed_nominal_value)
    "Isolation valve for boiler-1"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[1]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro[1]
    "Element-wise product"
    annotation (Placement(transformation(extent={{-210,-20},{-190,0}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));

  Buildings.Fluid.Sensors.Temperature zonTem(
    redeclare package Medium = Media.Air)
    "Measured zone air temperature"
    annotation (Placement(transformation(extent={{180,150},{200,170}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal,
    final dpValve_nominal=6000,
    y_start=0,
    dpFixed_nominal=1000)
    "Isolation valve for radiator"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare package Medium = Media.Water)
    "Differential pressure sensor between hot water supply and return"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal/1000)
    "Volume flow-rate through primary circuit"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-280,-90},{-260,-70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium =Media.Water,
    final m_flow_nominal=mRad_flow_nominal)
    "Measured radiator supply temperature"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal)
    "Measured radiator return temperature"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=1)
    "Real replicator"
    annotation (Placement(transformation(extent={{260,0},{280,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2[1](
    final uLow=fill(0.09,1),
    final uHigh=fill(0.1, 1))
    "Check if pumps are on"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat[1]
    "Hold pump enable status until change process is completed"
    annotation (Placement(transformation(extent={{-300,30},{-280,50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[1]
    "Switch to signal from controller once enabling process has been completed"
    annotation (Placement(transformation(extent={{-260,30},{-240,50}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[1]
    "Logical pre block"
    annotation (Placement(transformation(extent={{240,-140},{260,-120}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo1(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal)
    "Volume flow-rate through boiler"
    annotation (Placement(transformation(extent={{34,-160},{54,-140}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo2(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal)
    "Volume flow-rate through boiler"
    annotation (Placement(transformation(extent={{34,-220},{54,-200}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mBoi_flow_nominal1)
    "Measured boiler supply hot water temperature"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mBoi_flow_nominal2)
    "Measured boiler supply hot water temperature"
    annotation (Placement(transformation(extent={{60,-220},{80,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[2]
    "Switch to signal from controller once enabling process has been completed"
    annotation (Placement(transformation(extent={{-210,110},{-190,130}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1[2]
    "Hold pump enable status until change process is completed"
    annotation (Placement(transformation(extent={{-260,110},{-240,130}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{-300,142},{-280,162}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID[2](
    final controllerType=fill(Buildings.Controls.OBC.CDL.Types.SimpleController.PI,2),
    final k=fill(10e-3, 2),
    final Ti=fill(90, 2),
    final xi_start=fill(1, 2))
    "PI controller for regulating hot water supply temperature from boiler"
    annotation (Placement(transformation(extent={{-230,-120},{-210,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1[2]
    "Product of required boiler part load ratio and current status"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi[2]
    "Switch"
    annotation (Placement(transformation(extent={{-90,-170},{-70,-150}})));

  Buildings.Fluid.FixedResistances.Junction spl6(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={-mBoi_flow_nominal1,mRad_flow_nominal,-mBoi_flow_nominal2},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={150,-150})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2[2](
    final t=fill(273.15 + 95, 2))
    "Check if supply temperature has exceeded safe operation limit"
    annotation (Placement(transformation(extent={{-210,-218},{-190,-198}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=2)
    "Multi Or"
    annotation (Placement(transformation(extent={{-180,-218},{-160,-198}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "End boiler part load hold when supply temperature setpoint is achieved or if supply temperature exceeds safe operation limit"
    annotation (Placement(transformation(extent={{-140,-218},{-120,-198}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1[2]
    "Find difference between setpoint and measured temperature"
    annotation (Placement(transformation(extent={{-290,-170},{-270,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[2](
    final h=fill(0.3, 2))
    "Check if supply temperature setpoint is met"
    annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=2)
    "Multi And"
    annotation (Placement(transformation(extent={{-230,-170},{-210,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Hold boiler part load signal at 1 until supply temperature setpoint is achieved"
    annotation (Placement(transformation(extent={{-190,-170},{-170,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg[2]
    "Trigger boiler enable process to meet required supply temperature setpoint"
    annotation (Placement(transformation(extent={{-290,74},{-270,94}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr2(
    final nin=2)
    "Multi-Or"
    annotation (Placement(transformation(extent={{-250,74},{-230,94}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro2[2]
    "Product of required boiler part load ratio and current status"
    annotation (Placement(transformation(extent={{-270,-120},{-250,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat2[2]
    "Latch"
    annotation (Placement(transformation(extent={{260,-80},{280,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3[2](
    final t=fill(0.02,2))
    "Check if boilers are enabled"
    annotation (Placement(transformation(extent={{160,-210},{180,-190}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{200,-210},{220,-190}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1[2]
    "Logical not"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[1](
    final t=fill(120, 1))
    "Timer for pump proven ON signal"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));

  Modelica.Fluid.Pipes.DynamicPipe pipe(
    redeclare package Medium = MediumW,
    final nParallel=1,
    final length=2000,
    final isCircular=true,
    final diameter=0.0762,
    final height_ab=0.0102,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow,
    final nNodes=2,
    final use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer,
    flowModel(
      final dp_nominal(displayUnit="Pa") = 50000,
      final m_flow_nominal=mRad_flow_nominal),
    heatTransfer(
      final alpha0=15*1/0.3))
    "Dynamic pipe element to represent duct loss"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=-90,
        origin={210,-16})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut1
    "Pipe external surface temperature"
    annotation (Placement(transformation(extent={{230,-20},{250,0}})));

equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{120,180},{130,180},{130,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{120,210},{130,210},{130,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{150,180},{130,180},{130,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(rad.heatPortCon, vol.heatPort) annotation (Line(
      points={{88,127.2},{88,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(rad.heatPortRad, vol.heatPort) annotation (Line(
      points={{92,127.2},{92,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(spl4.port_3, val.port_a)
    annotation (Line(points={{-20,40},{80,40}},     color={0,127,255}));

  connect(val.port_b, spl5.port_3)
    annotation (Line(points={{100,40},{200,40}},  color={0,127,255}));

  connect(val2.port_a, spl1.port_3)
    annotation (Line(points={{0,-150},{-20,-150}},    color={0,127,255}));

  connect(val1.port_a, spl1.port_1) annotation (Line(points={{0,-210},{-30,-210},
          {-30,-160}},        color={0,127,255}));

  connect(uBypValSig, val.y) annotation (Line(points={{-340,-40},{-120,-40},{
          -120,64},{90,64},{90,52}},  color={0,0,127}));

  connect(uHotIsoVal[1], val1.y) annotation (Line(points={{-340,60},{-340,70},{-170,
          70},{-170,-130},{-10,-130},{-10,-180},{10,-180},{10,-198}},
                                                         color={0,0,127}));

  connect(uHotIsoVal[2], val2.y) annotation (Line(points={{-340,80},{-340,70},{-170,
          70},{-170,-130},{10,-130},{10,-138}},          color={0,0,127}));

  connect(QRooInt_flowrate, preHea.Q_flow)
    annotation (Line(points={{-340,210},{100,210}},
                                                 color={0,0,127}));

  connect(zonTem.port, vol.ports[1]) annotation (Line(points={{190,150},{190,
          144},{150,144},{150,150}},
                            color={0,127,255}));

  connect(zonTem.T, yZonTem) annotation (Line(points={{197,160},{280,160},{280,
          140},{340,140}},
                     color={0,0,127}));

  connect(val3.port_b, rad.port_a)
    annotation (Line(points={{40,120},{80,120}},   color={0,127,255}));

  connect(uRadConVal, val3.y)
    annotation (Line(points={{-340,170},{30,170},{30,132}},
                                                          color={0,0,127}));

  connect(spl4.port_2, senRelPre.port_a) annotation (Line(points={{-30,50},{-30,
          80},{80,80}},    color={0,127,255}));

  connect(senRelPre.port_b, spl5.port_1) annotation (Line(points={{100,80},{210,
          80},{210,50}},   color={0,127,255}));

  connect(senVolFlo.port_b, spl4.port_1) annotation (Line(points={{20,0},{40,0},
          {40,20},{-30,20},{-30,30}},                color={0,127,255}));

  connect(senVolFlo.V_flow, VHotWat_flow) annotation (Line(points={{10,11},{10,16},
          {80,16},{80,-30},{340,-30}},             color={0,0,127}));

  connect(TOutAir, TOut.T)
    annotation (Line(points={{-340,-80},{-282,-80}},   color={0,0,127}));

  connect(TOut.port, theCon.port_a) annotation (Line(points={{-260,-80},{-180,-80},
          {-180,180},{100,180}},
                              color={191,0,0}));

  connect(senTem.port_b, val3.port_a)
    annotation (Line(points={{0,120},{20,120}},    color={0,127,255}));

  connect(spl4.port_2, senTem.port_a) annotation (Line(points={{-30,50},{-30,120},
          {-20,120}},       color={0,127,255}));

  connect(senTem.T, ySupTem) annotation (Line(points={{-10,131},{-10,140},{270,
          140},{270,100},{340,100}},                color={0,0,127}));

  connect(rad.port_b, senTem1.port_a)
    annotation (Line(points={{100,120},{180,120}},
                                                 color={0,127,255}));

  connect(senTem1.port_b, spl5.port_1) annotation (Line(points={{200,120},{210,
          120},{210,50}},  color={0,127,255}));

  connect(senTem1.T, yRetTem) annotation (Line(points={{190,131},{190,134},{260,
          134},{260,60},{340,60}},
                                color={0,0,127}));

  connect(reaRep.y, yHotWatDp)
    annotation (Line(points={{282,10},{340,10}},     color={0,0,127}));

  connect(senRelPre.p_rel, reaRep.u) annotation (Line(points={{90,71},{90,66},{240,
          66},{240,10},{258,10}},           color={0,0,127}));

  connect(pro[1].y, pum.y) annotation (Line(points={{-188,-10},{-110,-10},{-110,
          -70},{-42,-70}}, color={0,0,127}));

  connect(yHotWatIsoVal[1], val1.y_actual) annotation (Line(points={{340,-160},
          {280,-160},{280,-174},{30,-174},{30,-203},{15,-203}},color={0,0,127}));

  connect(yHotWatIsoVal[2], val2.y_actual) annotation (Line(points={{340,-140},
          {280,-140},{280,-174},{30,-174},{30,-143},{15,-143}},color={0,0,127}));

  connect(uPumSpe, pro[1].u2) annotation (Line(points={{-340,0},{-290,0},{-290,-16},
          {-212,-16}},      color={0,0,127}));

  connect(uPumSta, lat.u)
    annotation (Line(points={{-340,40},{-302,40}}, color={255,0,255}));

  connect(lat.y, logSwi.u2)
    annotation (Line(points={{-278,40},{-262,40}}, color={255,0,255}));

  connect(lat.y, logSwi.u1) annotation (Line(points={{-278,40},{-270,40},{-270,
          48},{-262,48}}, color={255,0,255}));

  connect(logSwi.y, booToRea.u)
    annotation (Line(points={{-238,40},{-222,40}}, color={255,0,255}));

  connect(uPumSta, logSwi.u3) annotation (Line(points={{-340,40},{-310,40},{
          -310,28},{-270,28},{-270,32},{-262,32}}, color={255,0,255}));

  connect(pre.y, lat.clr) annotation (Line(points={{262,-130},{272,-130},{272,
          -220},{-314,-220},{-314,34},{-302,34}}, color={255,0,255}));

  connect(pum.y_actual, hys2[1].u) annotation (Line(points={{-37,-59},{-37,-24},
          {90,-24},{90,-10},{98,-10}}, color={0,0,127}));

  connect(val2.port_b, senVolFlo1.port_a)
    annotation (Line(points={{20,-150},{34,-150}}, color={0,127,255}));

  connect(val1.port_b, senVolFlo2.port_a)
    annotation (Line(points={{20,-210},{34,-210}}, color={0,127,255}));

  connect(senVolFlo1.port_b, senTem2.port_a)
    annotation (Line(points={{54,-150},{60,-150}}, color={0,127,255}));

  connect(senTem2.port_b, boi.port_b)
    annotation (Line(points={{80,-150},{90,-150}}, color={0,127,255}));

  connect(senVolFlo2.port_b, senTem3.port_a)
    annotation (Line(points={{54,-210},{60,-210}}, color={0,127,255}));

  connect(senTem3.port_b, boi1.port_b)
    annotation (Line(points={{80,-210},{90,-210}}, color={0,127,255}));

  connect(uBoiSta, lat1.u)
    annotation (Line(points={{-340,120},{-262,120}}, color={255,0,255}));

  connect(lat1.y, logSwi1.u2)
    annotation (Line(points={{-238,120},{-212,120}}, color={255,0,255}));

  connect(logSwi1.y, booToRea1.u)
    annotation (Line(points={{-188,120},{-162,120}}, color={255,0,255}));

  connect(uBoiSta, logSwi1.u3) annotation (Line(points={{-340,120},{-310,120},{
          -310,100},{-220,100},{-220,112},{-212,112}}, color={255,0,255}));

  connect(lat1.y, logSwi1.u1) annotation (Line(points={{-238,120},{-220,120},{
          -220,128},{-212,128}}, color={255,0,255}));

  connect(pre1.y, lat1.clr) annotation (Line(points={{-278,152},{-270,152},{
          -270,114},{-262,114}}, color={255,0,255}));

  connect(senTem3.T, conPID[1].u_m) annotation (Line(points={{70,-199},{70,-188},
          {-300,-188},{-300,-126},{-220,-126},{-220,-122}},
                                              color={0,0,127}));

  connect(senTem2.T, conPID[2].u_m) annotation (Line(points={{70,-139},{70,-126},
          {-220,-126},{-220,-122}}, color={0,0,127}));

  connect(conPID.y, pro1.u2) annotation (Line(points={{-208,-110},{-180,-110},{-180,
          -116},{-122,-116}}, color={0,0,127}));

  connect(booToRea1.y, pro1.u1) annotation (Line(points={{-138,120},{-130,120},{
          -130,-104},{-122,-104}}, color={0,0,127}));

  connect(boi.port_a, spl6.port_1)
    annotation (Line(points={{110,-150},{140,-150}}, color={0,127,255}));

  connect(boi1.port_a, spl6.port_3) annotation (Line(points={{110,-210},{150,
          -210},{150,-160}}, color={0,127,255}));

  connect(pro1.y, swi.u3) annotation (Line(points={{-98,-110},{-96,-110},{-96,
          -168},{-92,-168}}, color={0,0,127}));

  connect(booToRea1.y, swi.u1) annotation (Line(points={{-138,120},{-130,120},{
          -130,-152},{-92,-152}}, color={0,0,127}));

  connect(booRep.y, swi.u2)
    annotation (Line(points={{-138,-160},{-92,-160}}, color={255,0,255}));

  connect(swi[1].y, boi1.y) annotation (Line(points={{-68,-160},{-60,-160},{-60,
          -116},{120,-116},{120,-202},{112,-202}}, color={0,0,127}));

  connect(swi[2].y, boi.y) annotation (Line(points={{-68,-160},{-60,-160},{-60,
          -116},{120,-116},{120,-142},{112,-142}}, color={0,0,127}));

  connect(senTem3.T, greThr2[1].u) annotation (Line(points={{70,-199},{70,-188},
          {-300,-188},{-300,-208},{-212,-208}}, color={0,0,127}));

  connect(senTem2.T, greThr2[2].u) annotation (Line(points={{70,-139},{70,-126},
          {-300,-126},{-300,-208},{-212,-208}}, color={0,0,127}));

  connect(greThr2.y, mulOr1.u[1:2]) annotation (Line(points={{-188,-208},{-186,-208},
          {-186,-211.5},{-182,-211.5}}, color={255,0,255}));

  connect(mulOr1.y, or2.u1)
    annotation (Line(points={{-158,-208},{-142,-208}}, color={255,0,255}));

  connect(greThr.y, mulAnd.u[1:2]) annotation (Line(points={{-238,-160},{-236,-160},
          {-236,-163.5},{-232,-163.5}}, color={255,0,255}));

  connect(sub1.y, greThr.u)
    annotation (Line(points={{-268,-160},{-262,-160}}, color={0,0,127}));

  connect(senTem3.T,sub1 [1].u1) annotation (Line(points={{70,-199},{70,-188},{
          -300,-188},{-300,-154},{-292,-154}},
                                          color={0,0,127}));

  connect(senTem2.T,sub1 [2].u1) annotation (Line(points={{70,-139},{70,-126},{
          -300,-126},{-300,-154},{-292,-154}},
                                          color={0,0,127}));

  connect(mulAnd.y, or2.u2) annotation (Line(points={{-208,-160},{-200,-160},{-200,
          -180},{-150,-180},{-150,-216},{-142,-216}}, color={255,0,255}));

  connect(or2.y, lat3.clr) annotation (Line(points={{-118,-208},{-110,-208},{-110,
          -176},{-196,-176},{-196,-166},{-192,-166}}, color={255,0,255}));

  connect(edg.y,mulOr2. u[1:2]) annotation (Line(points={{-268,84},{-260,84},{-260,
          80.5},{-252,80.5}},         color={255,0,255}));

  connect(uBoiSta, edg.u) annotation (Line(points={{-340,120},{-310,120},{-310,84},
          {-292,84}}, color={255,0,255}));

  connect(mulOr2.y, lat3.u) annotation (Line(points={{-228,84},{-160,84},{-160,-140},
          {-196,-140},{-196,-160},{-192,-160}}, color={255,0,255}));

  connect(lat3.y, booRep.u)
    annotation (Line(points={{-168,-160},{-162,-160}}, color={255,0,255}));

  connect(pro2.y, conPID.u_s)
    annotation (Line(points={{-248,-110},{-232,-110}}, color={0,0,127}));

  connect(TBoiHotWatSupSet, pro2.u2) annotation (Line(points={{-340,-130},{-308,
          -130},{-308,-116},{-272,-116}}, color={0,0,127}));

  connect(booToRea1.y, pro2.u1) annotation (Line(points={{-138,120},{-130,120},{
          -130,-94},{-280,-94},{-280,-104},{-272,-104}}, color={0,0,127}));

  connect(pro2.y,sub1. u2) annotation (Line(points={{-248,-110},{-240,-110},{
          -240,-134},{-296,-134},{-296,-166},{-292,-166}},
                                                      color={0,0,127}));

  connect(lat2.y, yBoiSta)
    annotation (Line(points={{282,-70},{340,-70}}, color={255,0,255}));

  connect(pre2.y, lat2.clr) annotation (Line(points={{182,-70},{196,-70},{196,-76},
          {258,-76}}, color={255,0,255}));

  connect(swi.y, greThr3.u) annotation (Line(points={{-68,-160},{-60,-160},{-60,
          -116},{120,-116},{120,-200},{158,-200}}, color={0,0,127}));

  connect(greThr3.y, pre3.u)
    annotation (Line(points={{182,-200},{198,-200}}, color={255,0,255}));

  connect(pre3.y, lat2.u) annotation (Line(points={{222,-200},{230,-200},{230,-70},
          {258,-70}}, color={255,0,255}));

  connect(lat2.y, pre1.u) annotation (Line(points={{282,-70},{292,-70},{292,220},
          {-308,220},{-308,152},{-302,152}}, color={255,0,255}));

  connect(not1.y, pre2.u) annotation (Line(points={{122,-60},{140,-60},{140,-70},
          {158,-70}}, color={255,0,255}));

  connect(logSwi1.y, not1.u) annotation (Line(points={{-188,120},{-172,120},{-172,
          92},{74,92},{74,-60},{98,-60}}, color={255,0,255}));

  connect(spl1.port_2, pum.port_a)
    annotation (Line(points={{-30,-140},{-30,-80}}, color={0,127,255}));

  connect(preSou.ports[1], pum.port_a) annotation (Line(points={{-20,-90},{-30,-90},
          {-30,-80}}, color={0,127,255}));

  connect(pum.port_b, senVolFlo.port_a)
    annotation (Line(points={{-30,-60},{-30,0},{0,0}}, color={0,127,255}));

  connect(booToRea.y, pro.u1) annotation (Line(points={{-198,40},{-192,40},{-192,
          20},{-220,20},{-220,-4},{-212,-4}}, color={0,0,127}));

  connect(hys2.y, tim.u)
    annotation (Line(points={{122,-10},{138,-10}}, color={255,0,255}));

  connect(tim.passed, yPumSta) annotation (Line(points={{162,-18},{200,-18},{200,
          -110},{340,-110}}, color={255,0,255}));

  connect(tim.passed, pre.u) annotation (Line(points={{162,-18},{200,-18},{200,-130},
          {238,-130}}, color={255,0,255}));

  connect(val.y_actual, yBypValSig) annotation (Line(points={{95,47},{160,47},{160,
          90},{240,90},{240,180},{340,180}}, color={0,0,127}));

  connect(spl5.port_2, pipe.port_a)
    annotation (Line(points={{210,30},{210,-6}}, color={0,127,255}));

  connect(pipe.port_b, spl6.port_2) annotation (Line(points={{210,-26},{210,-150},
          {160,-150}}, color={0,127,255}));

  connect(zonTem.T, TOut1.T) annotation (Line(points={{197,160},{220,160},{220,
          -10},{228,-10}}, color={0,0,127}));

  connect(TOut1.port, pipe.heatPorts[1]) annotation (Line(points={{250,-10},{
          260,-10},{260,-26},{220,-26},{220,-14.55},{214.4,-14.55}}, color={191,
          0,0}));

  connect(TOut1.port, pipe.heatPorts[2]) annotation (Line(points={{250,-10},{
          260,-10},{260,-26},{220,-26},{220,-17.65},{214.4,-17.65}}, color={191,
          0,0}));

  annotation (defaultComponentName="boiPla",
    Documentation(info="<html>
      <p>
      This model implements a primary-only, condensing boiler plant with a headered, 
      variable-speed primary pump, as defined in ASHRAE RP-1711, March 2020 draft.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      October 28, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-320,-240},{320,240}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{-100,160},{100,120}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-18},{40,-98}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-54},{60,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-60},{60,-54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-80},{-12,-98},{14,-98},{0,-80}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(extent={{-80,58},{-50,26}}, lineColor={28,108,200}),
        Polygon(
          points={{-80,40},{-50,40},{-66,58},{-80,40}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-66,-40},{-66,-12}}, color={28,108,200}),
        Line(points={{-66,58},{-66,88}}, color={28,108,200}),
        Line(points={{70,88},{70,-44},{70,-50}}, color={28,108,200}),
        Polygon(points={{-80,26},{-80,26}}, lineColor={28,108,200}),
        Polygon(
          points={{-76,-12},{-54,-12},{-66,0},{-76,-12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,12},{-54,12},{-66,0},{-76,12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-66,12},{-66,26}}, color={28,108,200}),
        Ellipse(
          extent={{-82,-40},{-52,-72}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Ellipse(
          extent={{56,-38},{86,-70}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}));
end BoilerPlant;
