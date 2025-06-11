within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model TableData2DLoadDepSHC
  extends Modelica.Icons.Example;
  replaceable package MediumLiq=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW or CHW medium";
  replaceable package MediumAmb=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Ambient-side medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Modelica.Units.SI.Temperature THwSup_nominal=323.15
    "HW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THwRet_nominal=315.15
    "HW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChwSup_nominal=280.15
    "CHW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChwRet_nominal=285.15
    "CHW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAmbHea_nominal=268.15
    "OA temperature"
    annotation (Dialog(group="Nominal condition - Heating mode"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal = 58E3
    "Heating heat flow rate - Heating mode"
    annotation (Dialog(group="Nominal condition - Heating mode"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaShc_flow_nominal = 85E3
    "Heating heat flow rate - SHC mode"
    annotation (Dialog(group="Nominal condition - Heating mode"));
  parameter Modelica.Units.SI.Temperature TAmbCoo_nominal=308.15
    "Ambient side fluid temperature — Entering or leaving depending on use_TAmbOutForTab"
    annotation (Dialog(group="Nominal condition - Cooling mode"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal = -73E3
    "Cooling heat flow rate - Cooling mode"
    annotation (Dialog(group="Nominal condition - Cooling mode"));
  parameter Modelica.Units.SI.HeatFlowRate QCooShc_flow_nominal = -65E3
    "Cooling heat flow rate - SHC mode"
    annotation (Dialog(group="Nominal condition - Cooling mode"));
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal=
    QHea_flow_nominal / (THwSup_nominal - THwRet_nominal) /
    Buildings.Media.Water.cp_const
    "HW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChw_flow_nominal=
    QCoo_flow_nominal / (TChwSup_nominal - TChwRet_nominal) /
    Buildings.Media.Water.cp_const
    "CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHw_nominal=30000
    "Total HW pressure drop across HP and isolation valve"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChw_nominal=40000
    "Total CHW pressure drop across HP and isolation valve"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TChiWatSet(
    table=[0,0; 10,0; 80,TChwEnt.k - TChwSup_nominal; 95,TChwEnt.k -
        TChwSup_nominal],
    offset={TChwSup_nominal},
    timeScale=20,
    y(each final unit="K", each displayUnit="degC"))
    "CHW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatSet(
    amplitude=THwEnt.k - THwSup_nominal,
    freqHz=1.5/3600,
    offset=THwSup_nominal + (THwEnt.k - THwSup_nominal)/2,
    startTime=100,
    y(final unit="K", displayUnit="degC"))
    "HW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-150,62},{-130,82}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THwEnt(k=THwSup_nominal +
    (THwRet_nominal - THwSup_nominal)*QHeaShc_flow_nominal/QHea_flow_nominal,
    y(final unit="K", displayUnit="degC")) "Condenser entering HW temperature"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChwEnt(k=TChwSup_nominal +
    (TChwRet_nominal - TChwSup_nominal)* QCooShc_flow_nominal /QCoo_flow_nominal,
    y(final unit="K", displayUnit="degC"))
    "Evaporator entering CHW temperature"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(k=15 + 273.15, y(
        final unit="K", displayUnit="degC")) "OA temperature"
    annotation (Placement(transformation(extent={{-130,130},{-110,150}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupNom(k=
        THwSup_nominal, y(final unit="K", displayUnit="degC"))
    "Design HW supply temperature"
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(
    table=[0,3; 1,2; 2,1],
    timeScale=1500,
    period=4500)
                "Operating mode command"
    annotation (Placement(transformation(extent={{-130,90},{-110,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable on(
    table=[0,1; 5000,0],
    timeScale=1,
    period=5400)  "On/off command"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC hp(
    redeclare final package MediumCon=MediumLiq,
    redeclare final package MediumEva=MediumLiq,
    redeclare final package MediumAmb=MediumAmb,
    final energyDynamics=energyDynamics,
    nUni=3,
    use_preDro=false,
    dpHw_nominal=30E3,
    dpChw_nominal=40E3,
    final dat=dat,
    mCon_flow_nominal=mHw_flow_nominal,
    mEva_flow_nominal=mChw_flow_nominal,
    typ=Buildings.Fluid.HeatPumps.Types.HeatPump.AirToWater,
    final QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    final QHeaShc_flow_nominal=QHeaShc_flow_nominal,
    final QCooShc_flow_nominal=QCooShc_flow_nominal,
    final TConHea_nominal=THwSup_nominal,
    final TEvaHea_nominal=TAmbHea_nominal,
    TConCoo_nominal=TChwSup_nominal,
    TEvaCoo_nominal=TAmbCoo_nominal)
    "Multipipe heat pump"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-110,120},{-70,160}}), iconTransformation(
          extent={{-28,-54},{-8,-34}})));
  parameter Data.TableData2DLoadDepSHC.Generic dat(
    PLRHeaSup={1},
    PLRCooSup={1},
    PLRShcSup={1},
    fileNameHea=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
    fileNameCoo=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
    fileNameShc=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt"),
    mCon_flow_nominal=1.7,
    mEva_flow_nominal=3.5,
    dpCon_nominal=30E3,
    dpEva_nominal=40E3,
    devIde="",
    use_TEvaOutForTab=true,
    use_TConOutForTab=true) "Performance data"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Sources.Boundary_pT hwIn(
    redeclare final package Medium = MediumLiq,
    p=hwOut.p + hp.dpHw_nominal + hp.dpValIso_nominal,
    use_T_in=true,
    nPorts=1) "Boundary conditions of HW at HP inlet"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Sources.Boundary_pT hwOut(
    redeclare final package Medium = MediumLiq,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) "Boundary conditions of HW at HP outlet"
    annotation (Placement(transformation(extent={{140,30},{120,50}})));
  Sources.Boundary_pT chwOut(
    redeclare final package Medium = MediumLiq,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1) "Boundary conditions of CHW at HP outlet"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Sources.Boundary_pT chwIn(
    redeclare final package Medium = MediumLiq,
    p=chwOut.p + hp.dpChw_nominal + hp.dpValIso_nominal,
    use_T_in=true,
    nPorts=1) "Boundary conditions of CHW at HP inlet"
    annotation (Placement(transformation(extent={{142,-50},{122,-30}})));
  Sensors.TemperatureTwoPort THwSup(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwRet_nominal) "HW supply temperature"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Sensors.TemperatureTwoPort THwRet(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwSup_nominal) "HW return temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Sensors.TemperatureTwoPort TChwRet(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwRet_nominal) "CHW return temperature"
    annotation (Placement(transformation(extent={{120,-50},{100,-30}})));
  Sensors.TemperatureTwoPort TChwSup(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwSup_nominal) "CHW supply temperature"
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  Actuators.Valves.TwoWayTable  valHwIso(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=hp.mCon_flow_nominal,
    flowCharacteristics=hp.chaValHwIso,
    dpValve_nominal=hp.dpValIso_nominal,
    strokeTime=10,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpHw_nominal)
    "HW isolation valve"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Actuators.Valves.TwoWayTable  valChwIso(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=hp.mEva_flow_nominal,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpChw_nominal,
    flowCharacteristics=hp.chaValChwIso)
    "CHW isolation valve"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
equation
  connect(THeaWatSet.y, min1.u1) annotation (Line(points={{-128,72},{-120,72},{-120,
          46},{-112,46}},    color={0,0,127}));
  connect(THeaWatSupNom.y, min1.u2) annotation (Line(points={{-128,20},{-120,20},
          {-120,34},{-112,34}},
                              color={0,0,127}));
  connect(min1.y, hp.THwSet) annotation (Line(points={{-88,40},{12,40},{12,4},{28,
          4}},     color={0,0,127}));
  connect(TChiWatSet.y[1], hp.TChwSet) annotation (Line(points={{-78,80},{14,80},
          {14,0},{28,0}},  color={0,0,127}));
  connect(on.y[1], hp.on) annotation (Line(points={{-78,120},{18,120},{18,-2},{28,
          -2}},     color={255,0,255}));
  connect(mode.y[1], hp.mode) annotation (Line(points={{-108,100},{16,100},{16,-4},
          {28,-4}}, color={255,127,0}));
  connect(TOut.y, weaBus.TDryBul) annotation (Line(points={{-108,140},{-98,140},
          {-98,140.1},{-89.9,140.1}},color={0,0,127}));
  connect(weaBus, hp.weaBus) annotation (Line(
      points={{-90,140},{20,140},{20,40},{40,40},{40,10}},
      color={255,204,51},
      thickness=0.5));
  connect(THwEnt.y, hwIn.T_in) annotation (Line(points={{-128,-20},{-80,-20},{-80,
          24},{-72,24}},
                     color={0,0,127}));
  connect(TChwEnt.y, chwIn.T_in) annotation (Line(points={{-128,-80},{150,-80},{
          150,-36},{144,-36}}, color={0,0,127}));
  connect(THwSup.port_b, hwOut.ports[1])
    annotation (Line(points={{120,40},{120,40}}, color={0,127,255}));
  connect(hwIn.ports[1], THwRet.port_a)
    annotation (Line(points={{-50,20},{-40,20}}, color={0,127,255}));
  connect(THwRet.port_b, hp.port_a1)
    annotation (Line(points={{-20,20},{20,20},{20,6},{30,6}},
                                                   color={0,127,255}));
  connect(chwIn.ports[1], TChwRet.port_a)
    annotation (Line(points={{122,-40},{122,-40},{120,-40}},
                                                 color={0,127,255}));
  connect(TChwRet.port_b, hp.port_a2) annotation (Line(points={{100,-40},{60,-40},
          {60,-6},{50,-6}}, color={0,127,255}));
  connect(chwOut.ports[1], TChwSup.port_b)
    annotation (Line(points={{-50,-40},{-40,-40}}, color={0,127,255}));
  connect(hp.port_b1, valHwIso.port_a) annotation (Line(points={{50,6},{60,6},{60,
          40},{70,40}},    color={0,127,255}));
  connect(valHwIso.port_b, THwSup.port_a)
    annotation (Line(points={{90,40},{100,40}},color={0,127,255}));
  connect(TChwSup.port_a, valChwIso.port_b)
    annotation (Line(points={{-20,-40},{-10,-40}},
                                               color={0,127,255}));
  connect(hp.port_b2, valChwIso.port_a) annotation (Line(points={{30,-6},{20,-6},
          {20,-40},{10,-40}}, color={0,127,255}));
  connect(hp.yValHwIso, valHwIso.y) annotation (Line(points={{48,11},{48,60},{80,
          60},{80,52}}, color={0,0,127}));
  connect(hp.yValChwIso, valChwIso.y) annotation (Line(points={{32,-11},{32,-20},
          {0,-20},{0,-28}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-160,-160},{160,160}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDepSHC.mos"
        "Simulate and plot"),
    experiment(
      StopTime=5400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>
This model validates the load calculation and staging logic of the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC</a>.
</p>
<p>
The model represents a three-module system.
The operating mode switches between simultaneous heating and cooling, 
heating only, and cooling only.
The on/off command starts as <code>true</code> and is switched to 
<code>false</code> at the end.
</p>
<p>
The validation is carried out by computing the tracked temperature
using the heat flow rate calculated by the block, and feeding back 
this variable as input.
It is then expected that the tracked temperature matches the setpoint.
Note that a filtered value of the tracked temperature is used to avoid
creating an algebraic loop.
</p>
</html>", revisions="<html>
<ul>
<li>
FIXME, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TableData2DLoadDepSHC;
