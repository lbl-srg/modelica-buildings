within Buildings.Experimental.DHC.CentralPlants.Cooling;
model Plant
  "District cooling plant model"
  extends Buildings.Experimental.DHC.CentralPlants.BaseClasses.PartialPlant(
    have_eleCoo=true,
    have_pum=true,
    have_fan=true,
    have_weaBus=true,
    typ=Buildings.Experimental.DHC.Types.DistrictSystemType.Cooling);
  // chiller parameters
  parameter Integer numChi(
    min=1,
    max=2)=2
    "Number of chillers, maximum is 2"
    annotation (Dialog(group="Chiller"));
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi
    "Performance data of chiller"
    annotation (Dialog(group="Chiller"),choicesAllMatching=true,
   Placement(transformation(extent={{124,264},{138,278}})));
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal
    "Nominal chilled water mass flow rate"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.Pressure dpCHW_nominal
    "Pressure difference at the chilled water side"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.HeatFlowRate QChi_nominal
    "Nominal cooling capacity of single chiller (negative means cooling)"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.MassFlowRate mMin_flow
    "Minimum mass flow rate of single chiller"
    annotation (Dialog(group="Chiller"));
  // cooling tower parameters
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal
    "Nominal condenser water mass flow rate"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Pressure dpCW_nominal
    "Pressure difference at the condenser water side"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Temperature TAirInWB_nominal
    "Nominal air wetbulb temperature"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Temperature TCW_nominal
    "Nominal condenser water temperature at tower inlet"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.TemperatureDifference dTApp
    "Approach temperature"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Temperature TMin
    "Minimum allowed water temperature entering chiller"
    annotation (Dialog(group="Cooling Tower"));
  parameter Modelica.SIunits.Power PFan_nominal
    "Fan power"
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
  parameter Modelica.SIunits.Pressure dpCHWPumVal_nominal
    "Nominal pressure drop of chilled water pump valve"
    annotation (Dialog(group="Pump"));
  parameter Modelica.SIunits.Pressure dpCWPumVal_nominal
    "Nominal pressure drop of condenser water pump valve"
    annotation (Dialog(group="Pump"));
  parameter Modelica.SIunits.PressureDifference dpCooTowVal_nominal
   "Nominal pressure difference of the cooling tower valve";
  // control settings
  parameter Modelica.SIunits.Time tWai
    "Waiting time"
    annotation (Dialog(group="Control Settings"));
  parameter Modelica.SIunits.PressureDifference dpSetPoi(
    displayUnit="Pa")
    "Demand side pressure difference setpoint"
    annotation (Dialog(group="Control Settings"));
  // dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  Modelica.Blocks.Interfaces.BooleanInput on
    "On signal of the plant"
    annotation (Placement(transformation(extent={{-340,180},{-300,220}}),
   iconTransformation(extent={{-342,202},{-302,242}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSupSet(
    final unit="K",
    displayUnit="degC")
    "Set point for chilled water supply temperature"
    annotation (Placement(transformation(extent={{-340,120},{-300,160}}),
   iconTransformation(extent={{-340,138},{-300,178}})));
  Modelica.Blocks.Interfaces.RealInput dpMea(
    final unit="Pa")
    "Measured pressure difference"
    annotation (Placement(transformation(extent={{-340,60},{-300,100}}),
   iconTransformation(extent={{-340,78},{-300,118}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.ElectricChillerParallel mulChiSys(
    use_inputFilter=false,
    final per=fill(
      perChi,
      numChi),
    final m1_flow_nominal=mCHW_flow_nominal,
    final m2_flow_nominal=mCW_flow_nominal,
    final dp1_nominal=dpCHW_nominal,
    final dp2_nominal=dpCW_nominal,
    final num=numChi,
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium)
    "Chillers connected in parallel"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Buildings.Experimental.DHC.CentralPlants.Cooling.Subsystems.CoolingTowersWithBypass cooTowWitByp(
    redeclare final package Medium=Medium,
    final num=numChi,
    final m_flow_nominal=mCW_flow_nominal,
    final dp_nominal=dpCW_nominal,
    final dpValve_nominal = dpCooTowVal_nominal,
    final TAirInWB_nominal=TAirInWB_nominal,
    final TWatIn_nominal=TCW_nominal,
    final dT_nominal=dT_nominal,
    final dTApp=dTApp,
    final PFan_nominal=PFan_nominal,
    final TMin=TMin)
    "Cooling towers with bypass valve"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_y pumCHW(
    redeclare final package Medium=Medium,
    final per=fill(
      perCHWPum,
      numChi),
    use_inputFilter=false,
    yValve_start=fill(
      1,
      numChi),
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mCHW_flow_nominal,
    final dpValve_nominal=dpCHWPumVal_nominal,
    final num=numChi)
    "Chilled water pumps"
    annotation (Placement(transformation(extent={{-50,-16},{-30,4}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_m pumCW(
    redeclare final package Medium=Medium,
    final per=fill(
      perCWPum,
      numChi),
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mCW_flow_nominal,
    final dpValve_nominal=dpCWPumVal_nominal,
    final num=numChi)
    "Condenser water pumps"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare final package Medium=Medium,
    final allowFlowReversal=false,
    final m_flow_nominal=mCHW_flow_nominal*0.05,
    final dpValve_nominal=dpCHW_nominal)
    "Chilled water bypass valve"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=0,origin={-30,-90})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloByp(
    redeclare final package Medium=Medium)
    "Chilled water bypass valve mass flow meter"
    annotation (Placement(transformation(extent={{40,-80},{20,-100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{140,-30},{160,-50}})));
  Buildings.Experimental.DHC.CentralPlants.Cooling.Controls.ChilledWaterPumpSpeed chiWatPumCon(
    tWai=0,
    final m_flow_nominal=mCHW_flow_nominal,
    final dpSetPoi=dpSetPoi)
    "Chilled water pump controller"
    annotation (Placement(transformation(extent={{-140,-12},{-120,8}})));
  Buildings.Experimental.DHC.CentralPlants.Cooling.Controls.ChillerStage chiStaCon(
    final tWai=tWai,
    final QChi_nominal=QChi_nominal)
    "Chiller staging controller"
    annotation (Placement(transformation(extent={{-240,184},{-220,204}})));
  Modelica.Blocks.Sources.RealExpression mPum_flow(
    final y=pumCHW.port_a.m_flow)
    "Total chilled water pump mass flow rate"
    annotation (Placement(transformation(extent={{-210,-8},{-190,12}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-270,-100},{-250,-80}})));
  Buildings.Fluid.Sources.Boundary_pT expTanCW(
    redeclare final package Medium=Medium,
    nPorts=1)
    "Condenser water expansion tank"
    annotation (Placement(transformation(extent={{40,110},{20,130}})));
  Buildings.Fluid.Sources.Boundary_pT expTanCHW(
    redeclare final package Medium=Medium,
    nPorts=1)
    "Chilled water expansion tank"
    annotation (Placement(transformation(extent={{-110,-40},{-90,-20}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=Medium)
    "Chilled water return mass flow"
    annotation (Placement(transformation(extent={{-190,-100},{-170,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal chiOn[numChi]
    "Convert chiller on signal from boolean to real"
    annotation (Placement(transformation(extent={{-40,184},{-20,204}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(
    nin=4)
    "Total pump power"
    annotation (Placement(transformation(extent={{260,150},{280,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPFan(
    nin=2)
    "Total fan power"
    annotation (Placement(transformation(extent={{260,190},{280,210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPCoo(
    nin=2)
    "Total cooling power"
    annotation (Placement(transformation(extent={{260,230},{280,250}})));
  Buildings.Fluid.FixedResistances.Junction joiCHWRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal .* {1,-1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal={0,0,0})
    "Flow joint for the chilled water return side"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=-90,origin={-80,-90})));
  Buildings.Fluid.FixedResistances.Junction splCHWSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCHW_flow_nominal .* {1,-1,-1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal={0,0,0})
    "Flow splitter for the chilled water supply side"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,origin={80,-90})));
  Buildings.Experimental.DHC.CentralPlants.Cooling.Controls.ChilledWaterBypass chiBypCon(
    final numChi=numChi,
    final mMin_flow=mMin_flow)
    "Chilled water bypass control"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
protected
  final parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default)
    "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=Medium.specificHeatCapacityCp(
    sta_default)
    "Specific heat capacity of the fluid";
equation
  connect(senMasFloByp.port_b,valByp.port_a)
    annotation (Line(points={{20,-90},{-20,-90}},color={0,127,255}));
  connect(cooTowWitByp.port_b,pumCW.port_a)
    annotation (Line(points={{-20,90},{20,90}},color={0,127,255}));
  connect(on,chiStaCon.on)
    annotation (Line(points={{-320,200},{-242,200}},color={255,0,255}));
  connect(chiWatPumCon.dpMea,dpMea)
    annotation (Line(points={{-142,-6},{-280,-6},{-280,80},{-320,80}},color={0,0,127}));
  connect(mPum_flow.y,chiWatPumCon.masFloPum)
    annotation (Line(points={{-189,2},{-142,2}},color={0,0,127}));
  connect(chiWatPumCon.y,pumCHW.u)
    annotation (Line(points={{-119,-2},{-52,-2}},color={0,0,127}));
  connect(pumCHW.port_b,mulChiSys.port_a2)
    annotation (Line(points={{-30,-6},{-10,-6}},color={0,127,255}));
  connect(pumCW.port_b,mulChiSys.port_a1)
    annotation (Line(points={{40,90},{80,90},{80,6},{10,6}},color={0,127,255}));
  connect(mulChiSys.port_b1,cooTowWitByp.port_a)
    annotation (Line(points={{-10,6},{-80,6},{-80,90},{-40,90}},color={0,127,255}));
  connect(expTanCW.ports[1],pumCW.port_a)
    annotation (Line(points={{20,120},{0,120},{0,90},{20,90}},color={0,127,255}));
  connect(senTCHWRet.port_b,senMasFlo.port_a)
    annotation (Line(points={{-250,-90},{-190,-90}},color={0,127,255}));
  connect(chiStaCon.y,mulChiSys.on)
    annotation (Line(points={{-219,194},{-160,194},{-160,160},{100,160},{100,4},{12,4}},color={255,0,255}));
  connect(chiStaCon.y,chiOn.u)
    annotation (Line(points={{-219,194},{-42,194}},color={255,0,255}));
  connect(chiOn.y,pumCW.u)
    annotation (Line(points={{-18,194},{8,194},{8,94},{18,94}},color={0,0,127}));
  connect(chiStaCon.y,cooTowWitByp.on)
    annotation (Line(points={{-219,194},{-160,194},{-160,94},{-42,94}},color={255,0,255}));
  connect(weaBus.TWetBul,cooTowWitByp.TWetBul)
    annotation (Line(points={{1,266},{0,266},{0,238},{-50,238},{-50,88},{-42,88}},
    color={255,204,51},thickness=0.5),Text(string="%first",index=-1,
    extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(port_aSerCoo,senTCHWRet.port_a)
    annotation (Line(points={{-300,-40},{-280,-40},{-280,-90},{-270,-90}},color={0,127,255}));
  connect(senTCHWSup.port_b,port_bSerCoo)
    annotation (Line(points={{160,-40},{300,-40}}, color={0,127,255}));
  connect(TCHWSupSet,mulChiSys.TSet)
    annotation (Line(points={{-320,140},{-280,140},{-280,180},{120,180},{120,0},{12,0}},color={0,0,127}));
  connect(totPPum.y,PPum)
    annotation (Line(points={{282,160},{320,160}},color={0,0,127}));
  connect(pumCW.P,totPPum.u[1:2])
    annotation (Line(points={{41,94},{80,94},{80,140},{240,140},{240,160.5},{258,160.5}},color={0,0,127}));
  connect(pumCHW.P,totPPum.u[3:4])
    annotation (Line(points={{-29,-2},{-20,-2},{-20,44},{84,44},{84,136},{242,136},
          {242,158.5},{258,158.5}}, color={0,0,127}));
  connect(totPFan.y,PFan)
    annotation (Line(points={{282,200},{320,200}},color={0,0,127}));
  connect(cooTowWitByp.PFan,totPFan.u[1:2])
    annotation (Line(points={{-19,96},{-6,96},{-6,200},{258,200},{258,199}},color={0,0,127}));
  connect(totPCoo.y,PCoo)
    annotation (Line(points={{282,240},{320,240}},color={0,0,127}));
  connect(mulChiSys.P,totPCoo.u[1:2])
    annotation (Line(points={{-11,2},{-14,2},{-14,40},{234,40},{234,239},{258,239}},color={0,0,127}));
  connect(mulChiSys.port_b2,splCHWSup.port_1)
    annotation (Line(points={{10,-6},{80,-6},{80,-80}},color={0,127,255}));
  connect(splCHWSup.port_3,senTCHWSup.port_a)
    annotation (Line(points={{90,-90},{90,-40},{140,-40}},
                                                 color={0,127,255}));
  connect(splCHWSup.port_2,senMasFloByp.port_a)
    annotation (Line(points={{80,-100},{80,-110},{60,-110},{60,-90},{40,-90}},color={0,127,255}));
  connect(joiCHWRet.port_2,pumCHW.port_a)
    annotation (Line(points={{-80,-80},{-80,-6},{-50,-6}},color={0,127,255}));
  connect(joiCHWRet.port_1,senMasFlo.port_b)
    annotation (Line(points={{-80,-100},{-80,-110},{-100,-110},{-100,-90},{-170,-90}},color={0,127,255}));
  connect(joiCHWRet.port_3,valByp.port_b)
    annotation (Line(points={{-70,-90},{-40,-90}},color={0,127,255}));
  connect(expTanCHW.ports[1],pumCHW.port_a)
    annotation (Line(points={{-90,-30},{-80,-30},{-80,-6},{-50,-6}},color={0,127,255}));
  connect(senTCHWRet.T,chiStaCon.TChiWatRet)
    annotation (Line(points={{-260,-79},{-260,196},{-242,196}},color={0,0,127}));
  connect(senTCHWSup.T,chiStaCon.TChiWatSup)
    annotation (Line(points={{150,-51},{150,-120},{-220,-120},{-220,166},{-252,166},
          {-252,192},{-242,192}},color={0,0,127}));
  connect(senMasFlo.m_flow,chiStaCon.mFloChiWat)
    annotation (Line(points={{-180,-79},{-180,172},{-246,172},{-246,188},{-242,188}},color={0,0,127}));
  connect(chiBypCon.y,valByp.y)
    annotation (Line(points={{-59,-150},{-30,-150},{-30,-102}},color={0,0,127}));
  connect(senMasFloByp.m_flow,chiBypCon.mFloByp)
    annotation (Line(points={{30,-101},{30,-166},{-90,-166},{-90,-154},{-82,-154}},color={0,0,127}));
  connect(chiStaCon.y,chiBypCon.chiOn)
    annotation (Line(points={{-219,194},{-160,194},{-160,-147},{-82,-147}},color={255,0,255}));
  annotation (
    defaultComponentName="pla",
    Documentation(
      info="<html>
<p>This model showcases a generic district central cooling plant as illustrated in the schematics below. </p>
<ul>
<li>The cooling is provided by two parallel chillers instantiated from </li>
<p><a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment.ElectricChillerParallel\">Buildings.Applications.DataCenters.ChillerCooled.Equipment.ElectricChillerParallel</a>. </p>
<li>The chilled water bypass loop is controlled to ensure a minimum flow </li>
<p>of chilled water running through the chillers all the time. </p>
<li>The condenser water is cooled by two parallel cooling towers with a bypass loop. </li>
<p>See <a href=\"modelica://Buildings.Experimental.DHC.CentralPlants.Cooling.Subsystems.CoolingTowerWithBypass\">Buildings.Experimental.DHC.CentralPlants.Cooling.Subsystems.CoolingTowerWithBypass</a> </p>
<p>for the details of the modeling of the cooling towers. </p>
<li>The chilled water loop is equipped with two parallel variable speed pumps, </li>
<p>which are controlled to maitain a use-determined pressure difference setpoint at the demand side. </p>
<p>The condenser water pumps are constant speed with prescribed mass flow rates. </p>
<li>The plant operates when it receives an <code>on</code> signal from the external control. </li>
</ul>
<p>The staging of the chillers is based on the calculated cooling load. </p>
<p>See <a href=\"modelica://Buildings.Experimental.DHC.CentralPlants.Cooling.Controls.ChillerStage\">Buildings.Experimental.DHC.CentralPlants.Cooling.Controls.ChillerStage</a> for the detailed control logic. </p>
<p><img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/CentralPlants/Cooling/Plant.png\" alt=\"System schematics\"/>. </p>
</html>",
      revisions="<html>
<ul>
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
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}})));
end Plant;
