within Buildings.Fluid.HeatPumps.ModularReversible.Validation;
model TableData2DLoadDepSHC
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW or CHW medium";
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
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TChiWatSet(
    table=[0,0; 10,0; 80,0.2*(TChwEnt.k - TChwSup_nominal); 95,0.2*(TChwEnt.k
         - TChwSup_nominal)],
    offset={TChwSup_nominal},
    timeScale=20,
    y(each final unit="K", each displayUnit="degC"))
    "CHW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatSet(
    amplitude=THwEnt.k - THwSup_nominal,
    freqHz=1/3600,
    offset=THwSup_nominal,
    startTime=1000,
    y(final unit="K", displayUnit="degC"))
    "HW supply or return temperature setpoint"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THwEnt(k=THwSup_nominal +
    (THwRet_nominal - THwSup_nominal)*QHeaShc_flow_nominal/QHea_flow_nominal,
    y(final unit="K", displayUnit="degC")) "Condenser entering HW temperature"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChwEnt(k=TChwSup_nominal +
    (TChwRet_nominal - TChwSup_nominal)* QCooShc_flow_nominal /QCoo_flow_nominal,
    y(final unit="K", displayUnit="degC"))
    "Evaporator entering CHW temperature"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(k=15 + 273.15, y(
        final unit="K", displayUnit="degC")) "OA temperature"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupNom(k=
        THwSup_nominal, y(final unit="K", displayUnit="degC"))
    "Design HW supply temperature"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(
    table=[0,3; 1,2; 2,1],
    timeScale=1200,
    period=3600)
    "Operating mode command"
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable on(
    table=[0,0; 500,1; 5000,0],
    timeScale=1,
    period=5400)  "On/off command"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC hp(
    redeclare final package MediumCon=Medium,
    redeclare final package MediumEva=Medium,
    final energyDynamics=energyDynamics,
    nUni=3,
    use_preDro=false,
    dpHw_nominal=30000,
    dpChw_nominal=40000,
    final dat=dat,
    mCon_flow_nominal=mHw_flow_nominal,
    mEva_flow_nominal=mChw_flow_nominal,
    final QHea_flow_nominal=QHea_flow_nominal,
    QCoo_flow_nominal=QCoo_flow_nominal,
    final QHeaShc_flow_nominal=QHeaShc_flow_nominal,
    final QCooShc_flow_nominal=QCooShc_flow_nominal,
    final TConHea_nominal=THwSup_nominal,
    final TEvaHea_nominal=TAmbHea_nominal,
    TConCoo_nominal=TChwSup_nominal,
    TEvaCoo_nominal=TAmbCoo_nominal)
    "Multipipe heat pump"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{0,100},{40,140}}),     iconTransformation(
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
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Sources.Boundary_pT hwIn(
    redeclare final package Medium = Medium,
    p=hwOut.p + hp.dpHw_nominal + hp.dpValIso_nominal,
    use_T_in=true,
    nPorts=1) "Boundary conditions of HW at HP inlet"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Sources.Boundary_pT hwOut(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) "Boundary conditions of HW at HP outlet"
    annotation (Placement(transformation(extent={{140,10},{120,30}})));
  Sources.Boundary_pT chwOut(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1) "Boundary conditions of CHW at HP outlet"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Sources.Boundary_pT chwIn(
    redeclare final package Medium = Medium,
    p=chwOut.p + hp.dpChw_nominal + hp.dpValIso_nominal,
    use_T_in=true,
    nPorts=1) "Boundary conditions of CHW at HP inlet"
    annotation (Placement(transformation(extent={{142,-70},{122,-50}})));
  Sensors.TemperatureTwoPort THwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwSup_nominal) "HW supply temperature"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Sensors.TemperatureTwoPort THwRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwRet_nominal) "HW return temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Sensors.TemperatureTwoPort TChwRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwRet_nominal) "CHW return temperature"
    annotation (Placement(transformation(extent={{120,-70},{100,-50}})));
  Sensors.TemperatureTwoPort TChwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwSup_nominal) "CHW supply temperature"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
  Actuators.Valves.TwoWayTable  valHwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    flowCharacteristics=hp.chaValHwIso,
    dpValve_nominal=hp.dpValIso_nominal,
    strokeTime=10,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpHw_nominal)
    "Equivalent actuator for modules' condenser barrels and HW isolation valves"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Actuators.Valves.TwoWayTable  valChwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpChw_nominal,
    flowCharacteristics=hp.chaValChwIso)
    "Equivalent actuator for modules' evaporator barrels and CHW isolation valves"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message=
        "Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
             annotation (Placement(transformation(extent={{130,-30},{150,-10}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=hp.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
equation
  connect(THeaWatSet.y, min1.u1) annotation (Line(points={{-128,40},{-120,40},{-120,
          26},{-112,26}},    color={0,0,127}));
  connect(THeaWatSupNom.y, min1.u2) annotation (Line(points={{-128,0},{-120,0},{
          -120,14},{-112,14}},color={0,0,127}));
  connect(min1.y, hp.THwSet) annotation (Line(points={{-88,20},{12,20},{12,-16},
          {28,-16}},
                   color={0,0,127}));
  connect(TChiWatSet.y[1], hp.TChwSet) annotation (Line(points={{-88,60},{14,60},
          {14,-20},{28,-20}},
                           color={0,0,127}));
  connect(on.y[1], hp.on) annotation (Line(points={{-88,100},{10,100},{10,-22},{
          28,-22}}, color={255,0,255}));
  connect(mode.y[1], hp.mode) annotation (Line(points={{-128,80},{16,80},{16,-24},
          {28,-24}},color={255,127,0}));
  connect(TOut.y, weaBus.TDryBul) annotation (Line(points={{-128,120},{-98,120},
          {-98,120.1},{20.1,120.1}}, color={0,0,127}));
  connect(weaBus, hp.weaBus) annotation (Line(
      points={{20,120},{20,20},{40,20},{40,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(THwEnt.y, hwIn.T_in) annotation (Line(points={{-128,-40},{-80,-40},{-80,
          4},{-72,4}},
                     color={0,0,127}));
  connect(TChwEnt.y, chwIn.T_in) annotation (Line(points={{-128,-100},{150,-100},
          {150,-56},{144,-56}},color={0,0,127}));
  connect(THwSup.port_b, hwOut.ports[1])
    annotation (Line(points={{120,20},{120,20}}, color={0,127,255}));
  connect(hwIn.ports[1], THwRet.port_a)
    annotation (Line(points={{-50,0},{-40,0}},   color={0,127,255}));
  connect(THwRet.port_b, hp.port_a1)
    annotation (Line(points={{-20,0},{20,0},{20,-14},{30,-14}},
                                                   color={0,127,255}));
  connect(chwIn.ports[1], TChwRet.port_a)
    annotation (Line(points={{122,-60},{120,-60}},
                                                 color={0,127,255}));
  connect(TChwRet.port_b, hp.port_a2) annotation (Line(points={{100,-60},{60,-60},
          {60,-26},{50,-26}},
                            color={0,127,255}));
  connect(chwOut.ports[1], TChwSup.port_b)
    annotation (Line(points={{-50,-60},{-40,-60}}, color={0,127,255}));
  connect(hp.port_b1, valHwIso.port_a) annotation (Line(points={{50,-14},{60,-14},
          {60,20},{70,20}},color={0,127,255}));
  connect(valHwIso.port_b, THwSup.port_a)
    annotation (Line(points={{90,20},{100,20}},color={0,127,255}));
  connect(TChwSup.port_a, valChwIso.port_b)
    annotation (Line(points={{-20,-60},{-10,-60}},
                                               color={0,127,255}));
  connect(hp.port_b2, valChwIso.port_a) annotation (Line(points={{30,-26},{20,-26},
          {20,-60},{10,-60}}, color={0,127,255}));
  connect(hp.yValHwIso, valHwIso.y) annotation (Line(points={{48,-9},{48,40},{80,
          40},{80,32}}, color={0,0,127}));
  connect(hp.yValChwIso, valChwIso.y) annotation (Line(points={{32,-31},{32,-40},
          {0,-40},{0,-48}}, color={0,0,127}));
  connect(hp.nUniHea, sumNumUni.u[1]) annotation (Line(points={{43,-32},{43,-40},
          {62,-40},{62,-22.3333},{68,-22.3333}}, color={255,127,0}));
  connect(hp.nUniCoo, sumNumUni.u[2]) annotation (Line(points={{40,-32},{40,-38},
          {64,-38},{64,-20},{68,-20}},
                                   color={255,127,0}));
  connect(hp.nUniShc, sumNumUni.u[3]) annotation (Line(points={{37,-32},{37,-36},
          {66,-36},{66,-17.6667},{68,-17.6667}},
                                               color={255,127,0}));
  connect(sumNumUni.y, intLesEquThr.u)
    annotation (Line(points={{92,-20},{98,-20}},
                                             color={255,127,0}));
  connect(intLesEquThr.y, assMes.u)
    annotation (Line(points={{122,-20},{128,-20}},
                                               color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-160},{160,160}}, grid={2,2})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Validation/TableData2DLoadDepSHC.mos"
        "Simulate and plot"),
    experiment(
      StopTime=5400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>
This model validates the hydronics and built-in control logic of
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC</a>.
</p>
<p>
The model represents a three-module system where the HW and CHW isolation
valves are modeled using an equivalent actuator.
The actuator model represents the parallel network of the modules'
condenser or evaporator barrels in series with the HW or CHW isolation valves.
It is parameterized with the flow characteristics calculated 
by the heat pump model, and controlled by the output variables provided 
by this model.
The heat pump operating mode switches between simultaneous heating and cooling,
heating only, and cooling only.
The on/off command starts as <code>true</code> and is switched to
<code>false</code> at the end.
</p>
<p>
While the heat pump component is subjected to the design HW and CHW 
differential pressures and return temperatures, the supply temperature 
setpoints vary, creating a varying load.
The validation then consists in verifying that the modules are effectively 
staged in various modes to adapt to the load. Additionally, it confirms that the 
isolation valve parameterization and controls result in HW and CHW flow rates
that vary linearly with the number of enabled modules on each side.
</p>
</html>", revisions="<html>
<ul>
<li>
July 1, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TableData2DLoadDepSHC;
