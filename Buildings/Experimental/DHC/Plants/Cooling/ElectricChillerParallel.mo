within Buildings.Experimental.DHC.Plants.Cooling;
model ElectricChillerParallel
  "District cooling plant model"
  extends Buildings.Experimental.DHC.Plants.BaseClasses.PartialPlant(
    have_eleCoo=true,
    have_pum=true,
    have_fan=true,
    have_weaBus=true,
    typ=Buildings.Experimental.DHC.Types.DistrictSystemType.Cooling);
  // chiller parameters
  final parameter Integer numChi=2
    "Number of chillers"
    annotation (Dialog(group="Chiller"));
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi
    "Performance data of chiller"
    annotation (Dialog(group="Chiller"),choicesAllMatching=true,
   Placement(transformation(extent={{124,264},{138,278}})));
  parameter Modelica.Units.SI.MassFlowRate mCHW_flow_nominal
    "Nominal chilled water mass flow rate" annotation (Dialog(group="Chiller"));
  parameter Modelica.Units.SI.Pressure dpCHW_nominal
    "Pressure difference at the chilled water side"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.Units.SI.HeatFlowRate QChi_nominal(max=0)
    "Nominal cooling capacity of single chiller (negative means cooling)"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.Units.SI.MassFlowRate mMin_flow
    "Minimum mass flow rate of single chiller"
    annotation (Dialog(group="Chiller"));
  // cooling tower parameters
  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal
    "Nominal condenser water mass flow rate"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.Units.SI.Pressure dpCW_nominal
    "Pressure difference at the condenser water side"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.Units.SI.Temperature TAirInWB_nominal
    "Nominal air wetbulb temperature" annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.Units.SI.Temperature TCW_nominal
    "Nominal condenser water temperature at tower inlet"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.Units.SI.TemperatureDifference dTApp
    "Approach temperature" annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.Units.SI.Temperature TMin
    "Minimum allowed water temperature entering chiller"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.Units.SI.Power PFan_nominal "Fan power"
    annotation (Dialog(group="Cooling Tower"));
  // pump parameters
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perCHWPum
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data of chilled water pump"
    annotation (Dialog(group="Pump"),choicesAllMatching=true,
   Placement(transformation(extent={{164,264},{178,278}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perCWPum
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data of condenser water pump"
    annotation (Dialog(group="Pump"),choicesAllMatching=true,
   Placement(transformation(extent={{204,264},{218,278}})));
  parameter Modelica.Units.SI.Pressure dpCHWPumVal_nominal
    "Nominal pressure drop of chilled water pump valve"
    annotation (Dialog(group="Pump"));
  parameter Modelica.Units.SI.Pressure dpCWPumVal_nominal
    "Nominal pressure drop of condenser water pump valve"
    annotation (Dialog(group="Pump"));
  parameter Modelica.Units.SI.Time tau=1
    "Pump time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Boolean use_inputFilter=false
    "= true, if pump speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Pump"));
  parameter Modelica.Units.SI.Time riseTimePump=30
    "Pump rise time of the filter (time to reach 99.6 % of the speed)" annotation (
      Dialog(
      tab="Dynamics",
      group="Pump",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization for pumps (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Pump",enable=use_inputFilter));
  parameter Real[numChi] yCHWP_start=fill(0,numChi)
    "Initial value of CHW pump signals"
    annotation(Dialog(tab="Dynamics", group="Pump",enable=use_inputFilter));
  parameter Real[numChi] yCWP_start=fill(0,numChi)
    "Initial value of CW pump signals"
    annotation(Dialog(tab="Dynamics", group="Pump",enable=use_inputFilter));
  parameter Modelica.Units.SI.PressureDifference dpCooTowVal_nominal
    "Nominal pressure difference of the cooling tower valve";
  // control settings
  parameter Modelica.Units.SI.Time tWai "Waiting time"
    annotation (Dialog(group="Control Settings"));
  // dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state, must be steady state if energyDynamics is steady state"
    annotation(Evaluate=true, Dialog(tab = "Advanced", group="Dynamics"));
  Modelica.Blocks.Interfaces.BooleanInput on
    "On signal of the plant"
    annotation (Placement(transformation(extent={{-420,200},{-380,240}}),
   iconTransformation(extent={{-340,200},{-300,240}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final unit="K",
    displayUnit="degC")
    "Set point for chilled water supply temperature"
    annotation (Placement(transformation(extent={{-420,100},{-380,140}}),
   iconTransformation(extent={{-340,140},{-300,180}})));
  Buildings.Applications.BaseClasses.Equipment.ElectricChillerParallel mulChiSys(
    final use_inputFilter=use_inputFilter,
    final per=fill(
      perChi,
      numChi),
    final m1_flow_nominal=mCW_flow_nominal,
    final m2_flow_nominal=mCHW_flow_nominal,
    final dp1_nominal=dpCW_nominal/2,
    final dp2_nominal=dpCHW_nominal,
    final num=numChi,
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium)
    "Chillers connected in parallel"
    annotation (Placement(transformation(extent={{60,40},{40,60}})));
  Buildings.Experimental.DHC.Plants.Cooling.Subsystems.CoolingTowersWithBypass cooTowWitByp(
    redeclare final package Medium=Medium,
    final num=numChi,
    final m_flow_nominal=mCW_flow_nominal,
    final use_inputFilter=use_inputFilter,
    final dp_nominal=dpCW_nominal/2,
    final dpValve_nominal = dpCooTowVal_nominal,
    final TAirInWB_nominal=TAirInWB_nominal,
    final TWatIn_nominal=TCW_nominal,
    final dT_nominal=dT_nominal,
    final dTApp=dTApp,
    final PFan_nominal=PFan_nominal,
    final TMin=TMin)
    "Cooling towers with bypass valve"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Applications.BaseClasses.Equipment.FlowMachine_y pumCHW(
    redeclare final package Medium=Medium,
    final per=fill(
      perCHWPum,
      numChi),
    yValve_start=fill(
      1,
      numChi),
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTimePump=riseTimePump,
    final init=init,
    final yPump_start=yCHWP_start,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mCHW_flow_nominal,
    final dpValve_nominal=dpCHWPumVal_nominal,
    final num=numChi)
    "Chilled water pumps"
    annotation (Placement(transformation(extent={{-52,34},{-32,54}})));
  Buildings.Applications.BaseClasses.Equipment.FlowMachine_m pumCW(
    redeclare final package Medium=Medium,
    final per=fill(
      perCWPum,
      numChi),
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTimePump=riseTimePump,
    final init=init,
    final yPump_start=yCWP_start,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mCW_flow_nominal,
    final dpValve_nominal=dpCWPumVal_nominal,
    final num=numChi)
    "Condenser water pumps"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare final package Medium=Medium,
    final allowFlowReversal=false,
    final m_flow_nominal=mCHW_flow_nominal,
    final dpValve_nominal=dpCHWPumVal_nominal,
    final use_inputFilter=true,
    riseTime=60)
    "Chilled water bypass valve"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=0,origin={-30,-70})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{140,-30},{160,-50}})));
  Buildings.Experimental.DHC.Plants.Cooling.Controls.ChillerStage chiStaCon(
    final tWai=tWai,
    final QChi_nominal=QChi_nominal)
    "Chiller staging controller"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-270,-50},{-250,-30}})));
  Buildings.Fluid.Sources.Boundary_pT expTanCW(
    redeclare final package Medium=Medium,
    p=300000,
    nPorts=1)
    "Condenser water expansion tank"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,142})));
  Buildings.Fluid.Sources.Boundary_pT expTanCHW(
    redeclare final package Medium=Medium,
    p=300000,
    nPorts=1)
    "Chilled water expansion tank"
    annotation (Placement(transformation(extent={{-108,-26},{-88,-6}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=Medium)
    "Chilled water return mass flow"
    annotation (Placement(transformation(extent={{-230,-50},{-210,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal chiOn[numChi]
    "Convert chiller on signal from boolean to real"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(
    nin=4)
    "Total pump power"
    annotation (Placement(transformation(extent={{340,150},{360,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPFan(
    nin=2)
    "Total fan power"
    annotation (Placement(transformation(extent={{340,190},{360,210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPCoo(
    nin=2)
    "Total cooling power"
    annotation (Placement(transformation(extent={{340,230},{360,250}})));
  Buildings.Fluid.FixedResistances.Junction joiCHWRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal .* {1,-1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal={0,0,0})
    "Flow joint for the chilled water return side"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=90, origin={-80,-40})));
  Buildings.Fluid.FixedResistances.Junction splCHWSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal .* {1,-1,-1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal={0,0,0})
    "Flow splitter for the chilled water supply side"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,origin={120,-42})));
  Buildings.Experimental.DHC.Plants.Cooling.Controls.ChilledWaterBypass chiBypCon(
    final numChi=numChi,
    final mMin_flow=mMin_flow,
    k=1,
    Ti=120)
    "Chilled water bypass control"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Fluid.Sensors.MassFlowRate senMasFloCHW(
    redeclare final package Medium = Medium)
    "Total chilled water pump mass flow rate"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,20})));
protected
  final parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default)
    "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

initial equation
  assert(energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState or
         massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState,
         "In " + getInstanceName() +
         ": energyDynamics is selected as steady state, and therefore massDynamics must also be steady-state.");

equation
  connect(cooTowWitByp.port_b,pumCW.port_a)
    annotation (Line(points={{-20,170},{60,170}},color={0,127,255}));
  connect(on,chiStaCon.on)
    annotation (Line(points={{-400,220},{-220,220},{-220,213.75},{-201.25,
          213.75}},
      color={255,0,255}));
  connect(pumCHW.port_b,mulChiSys.port_a2)
    annotation (Line(points={{-32,44},{40,44}}, color={0,127,255}));
  connect(pumCW.port_b,mulChiSys.port_a1)
    annotation (Line(points={{80,170},{120,170},{120,56},{60,56}},
      color={0,127,255}));
  connect(mulChiSys.port_b1,cooTowWitByp.port_a)
    annotation (Line(points={{40,56},{-80,56},{-80,170},{-40,170}},
      color={0,127,255}));
  connect(expTanCW.ports[1],pumCW.port_a)
    annotation (Line(points={{1.9984e-15,152},{1.9984e-15,170},{60,170}},
      color={0,127,255}));
  connect(senTCHWRet.port_b,senMasFlo.port_a)
    annotation (Line(points={{-250,-40},{-230,-40}},color={0,127,255}));
  connect(chiStaCon.y,mulChiSys.on)
    annotation (Line(points={{-179.375,210},{-160,210},{-160,100},{80,100},{80,54},{62,54}},
      color={255,0,255}));
  connect(chiStaCon.y,chiOn.u)
    annotation (Line(points={{-179.375,210},{-122,210}},
      color={255,0,255}));
  connect(chiOn.y,pumCW.u)
    annotation (Line(points={{-98,210},{0,210},{0,174},{58,174}},
      color={0,0,127}));
  connect(chiStaCon.y,cooTowWitByp.on)
    annotation (Line(points={{-179.375,210},{-160,210},{-160,174},{-42,174}},
      color={255,0,255}));
  connect(weaBus.TWetBul,cooTowWitByp.TWetBul)
    annotation (Line(points={{0,380},{0,380},{0,238},{-50,238},{-50,168},{-42,168}},
    color={255,204,51},thickness=0.5),Text(string="%first",index=-1,
    extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(port_aSerCoo,senTCHWRet.port_a)
    annotation (Line(points={{-380,-40},{-270,-40}},color={0,127,255}));
  connect(senTCHWSup.port_b,port_bSerCoo)
    annotation (Line(points={{160,-40},{380,-40}}, color={0,127,255}));
  connect(TCHWSupSet,mulChiSys.TSet)
    annotation (Line(points={{-400,120},{100,120},{100,50},{62,50}},color={0,0,127}));
  connect(totPPum.y,PPum)
    annotation (Line(points={{362,160},{400,160}},color={0,0,127}));
  connect(pumCW.P,totPPum.u[1:2])
    annotation (Line(points={{81,174},{240,174},{240,159.75},{338,159.75}},
                                                                         color={0,0,127}));
  connect(pumCHW.P,totPPum.u[3:4])
    annotation (Line(points={{-31,48},{0,48},{0,0},{240,0},{240,160.75},{338,
          160.75}},
      color={0,0,127}));
  connect(totPFan.y,PFan)
    annotation (Line(points={{362,200},{400,200}},color={0,0,127}));
  connect(cooTowWitByp.PFan,totPFan.u[1:2])
    annotation (Line(points={{-19,176},{-20,176},{-20,200},{338,200},{338,200.5}},
      color={0,0,127}));
  connect(totPCoo.y,PCoo)
    annotation (Line(points={{362,240},{400,240}},color={0,0,127}));
  connect(mulChiSys.P,totPCoo.u[1:2])
    annotation (Line(points={{39,52},{20,52},{20,240.5},{338,240.5}},
      color={0,0,127}));
  connect(splCHWSup.port_3,senTCHWSup.port_a)
    annotation (Line(points={{130,-42},{130,-40},{140,-40}},color={0,127,255}));
  connect(senTCHWRet.T,chiStaCon.TChiWatRet)
    annotation (Line(points={{-260,-29},{-260,209.75},{-201.25,209.75}},
      color={0,0,127}));
  connect(senTCHWSup.T,chiStaCon.TChiWatSup)
    annotation (Line(points={{150,-51},{150,-200},{-240,-200},{-240,207.5},{-201.25,207.5}},
      color={0,0,127}));
  connect(senMasFlo.m_flow,chiStaCon.mFloChiWat)
    annotation (Line(points={{-220,-29},{-220,205.25},{-201.25,205.25}},
      color={0,0,127}));
  connect(chiStaCon.y,chiBypCon.chiOn)
    annotation (Line(points={{-179.375,210},{-160,210},{-160,-145},{-122,-145}},
      color={255,0,255}));
  connect(senMasFlo.port_b, joiCHWRet.port_3)
    annotation (Line(points={{-210,-40},{-90,-40}}, color={0,127,255}));
  connect(valByp.port_b, joiCHWRet.port_1)
    annotation (Line(points={{-40,-70},{-80,-70},{-80,-50}}, color={0,127,255}));
  connect(senMasFloCHW.m_flow, chiBypCon.mFloChi) annotation (Line(points={{109,
          20},{-140,20},{-140,-155},{-122,-155}}, color={0,0,127}));
  connect(valByp.port_a, splCHWSup.port_2) annotation (Line(points={{-20,-70},{
          120,-70},{120,-52}}, color={0,127,255}));
  connect(joiCHWRet.port_2, pumCHW.port_a)
    annotation (Line(points={{-80,-30},{-80,44},{-52,44}}, color={0,127,255}));
  connect(expTanCHW.ports[1], pumCHW.port_a) annotation (Line(points={{-88,-16},
          {-80,-16},{-80,44},{-52,44}}, color={0,127,255}));
  connect(mulChiSys.port_b2, senMasFloCHW.port_a)
    annotation (Line(points={{60,44},{120,44},{120,30}}, color={0,127,255}));
  connect(senMasFloCHW.port_b, splCHWSup.port_1)
    annotation (Line(points={{120,10},{120,-32}}, color={0,127,255}));
  connect(chiBypCon.y, valByp.y) annotation (Line(points={{-99,-150},{-30,-150},
          {-30,-82}}, color={0,0,127}));
  connect(chiOn.y, pumCHW.u) annotation (Line(points={{-98,210},{-90,210},{-90,48},
          {-54,48}}, color={0,0,127}));
  annotation (
    defaultComponentName="pla",
    Documentation(
      info="<html>
<p>This model implements a generic district central cooling plant as illustrated
in the schematics below. </p>
<ul>
<li>The cooling is provided by two parallel chillers instantiated from
<a href=\"modelica://Buildings.Applications.BaseClasses.Equipment.ElectricChillerParallel\">
Buildings.Applications.BaseClasses.Equipment.ElectricChillerParallel</a>. </li>
<li>The chilled water bypass loop is controlled to ensure a minimum flow of
chilled water running through the chillers all the time. </li>
<li>The condenser water is cooled by two parallel cooling towers with a bypass
loop. See <a href=\"modelica://Buildings.Experimental.DHC.Plants.Cooling.Subsystems.CoolingTowersWithBypass\">
Buildings.Experimental.DHC.Plants.Cooling.Subsystems.CoolingTowersWithBypass</a>
for the details of the modeling of the cooling towers. </li>
<li>The chilled water loop is equipped with two parallel constant speed pumps,
which run one-and-one with each chiller. The condenser water pumps are constant speed with prescribed
mass flow rates. </li>
<li>The plant operates when it receives an <code>on</code> signal from the
external control. </li>
</ul>
<p>The staging of the chillers is based on the calculated cooling load. </p>
<p>See <a href=\"modelica://Buildings.Experimental.DHC.Plants.Cooling.Controls.ChillerStage\">
Buildings.Experimental.DHC.Plants.Cooling.Controls.ChillerStage</a> for
the detailed control logic. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Plants/Cooling/ElectricChillerParallel.png\" alt=\"System schematics\"/>. </p>
</html>",
      revisions="<html>
<ul>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
Revised chilled water pump control to be constant speed and running 1-and-1 with chillers.
</li>
<li>
December 14, 2022, by Kathryn Hinkelman:<br/>
Corrected <code>chiBypCon</code> to control mass flow rate through the chillers.<br>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912#issuecomment-1324375700\">issue 2912</a>.
</li>
<li>
November 16, 2022, by Michael Wetter:<br/>
Corrected wrong assignments for chiller system <code>mulChiSys</code> which assigned chilled water
to condenser water parameters and vice versa.<br/>
Changed rise time of valve to 30 seconds so that it is the same as the one for the pumps.
</li>
<li>
September 15, 2022, by Kathryn Hinkelman:<br/>
Propagated dynamics and initialization parameters for pumps.
</li>
<li>
March 3, 2022, by Michael Wetter:<br/>
Moved <code>massDynamics</code> to <code>Advanced</code> tab and
added assertion for correct combination of energy and mass dynamics.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>.
</li>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        extent={{-300,-300},{300,300}}),
      graphics={
        Polygon(
          points={{-62,-14},{-62,-14}},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end ElectricChillerParallel;
