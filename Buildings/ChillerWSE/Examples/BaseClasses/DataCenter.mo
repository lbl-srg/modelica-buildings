within Buildings.ChillerWSE.Examples.BaseClasses;
partial model DataCenter
  "Partial model that impliments cooling system for data centers"
  extends Modelica.Icons.Example;
  replaceable package MediumA = Buildings.Media.Air "Medium model" annotation (
      Documentation(revisions="<html>
<ul>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
  replaceable package MediumW = Buildings.Media.Water "Medium model";

  // chillers parameters
  parameter Integer numChi=2 "Number of chillers";
  parameter Modelica.SIunits.MassFlowRate m1_flow_chi_nominal= 34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate m2_flow_chi_nominal= 18.3
    "Nominal mass flow rate at evaporator water in the chillers";
  parameter Modelica.SIunits.PressureDifference dp1_chi_nominal = 46.2*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dp2_chi_nominal = 44.8*1000
    "Nominal pressure";
  parameter Modelica.SIunits.Power QEva_nominal = m2_flow_chi_nominal*4200*(6.67-18.56)
    "Nominal cooling capaciaty(Negative means cooling)";
 // WSE parameters
  parameter Modelica.SIunits.MassFlowRate m1_flow_wse_nominal= 34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate m2_flow_wse_nominal= 35.3
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.PressureDifference dp1_wse_nominal = 33.1*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dp2_wse_nominal = 34.5*1000
    "Nominal pressure";

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumCW(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m1_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp1_chi_nominal+60000+6000)*{1.2,1.1,1.0,0.6}))
    "Performance data for condenser water pumps";
  parameter Modelica.SIunits.Time tWai=1200 "Waiting time";

  // AHU
  parameter Modelica.SIunits.ThermalConductance UA_nominal=numChi*QEva_nominal/
     Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        6.67,
        11.56,
        12,
        25)
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal = 161.35
    "Nominal air mass flowrate";

  replaceable Buildings.ChillerWSE.BaseClasses.PartialChillerWSE chiWSE(
    redeclare replaceable package Medium1 = MediumW,
    redeclare replaceable package Medium2 = MediumW,
    numChi=numChi,
    m1_flow_chi_nominal=m1_flow_chi_nominal,
    m2_flow_chi_nominal=m2_flow_chi_nominal,
    m1_flow_wse_nominal=m1_flow_wse_nominal,
    m2_flow_wse_nominal=m2_flow_wse_nominal,
    dp1_chi_nominal=dp1_chi_nominal,
    dp1_wse_nominal=dp1_wse_nominal,
    dp2_chi_nominal=dp2_chi_nominal,
    dp2_wse_nominal=dp2_wse_nominal,
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
      perChi,
    use_inputFilter=false)
    "Chillers and waterside economizer"
    annotation (Placement(transformation(extent={{126,22},{146,42}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCW(
    redeclare replaceable package Medium = MediumW,
    V_start=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{230,125},{250,145}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow[numChi](
    redeclare each replaceable package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each dp_nominal=60000,
    each TAirInWB_nominal(displayUnit="degC") = 283.15,
    each TApp_nominal=6,
    each PFan_nominal=6000,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Cooling tower"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      origin={141,139})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup(redeclare replaceable
      package Medium = MediumW, m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{104,-10},{84,10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3  weaData(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-220,-78},{-200,-58}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-210,-38},{-190,-18}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWSup(redeclare replaceable
      package Medium = MediumW, m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{120,130},{100,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWRet(redeclare replaceable
      package Medium = MediumW, m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{202,50},{222,70}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW[numChi](
    redeclare each replaceable package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each addPowerToMedium=false,
    per=perPumCW)
    "Condenser water pump"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={70,100})));

  Buildings.Applications.DataCenters.HVAC.AHUs.CoolingCoilHumidifyingHeating ahu(
    redeclare replaceable package Medium1 = MediumW,
    redeclare replaceable package Medium2 = MediumA,
    m1_flow_nominal=numChi*m2_flow_chi_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dpValve_nominal=6000,
    dp2_nominal=600,
    QHeaMax_flow=2000,
    mWatMax_flow=0.01,
    UA_nominal=UA_nominal,
    addPowerToMedium=false,
    dp1_nominal=6000,
    perFan(
      pressure(dp=800*{1.2,1.12,1},
         V_flow=mAir_flow_nominal/1.29*{0,0.5,1}),
         motorCooledByFluid=false))
    "Air handling unit"
    annotation (Placement(transformation(extent={{154,-130},{174,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{240,-10},{220,10}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(
    redeclare replaceable package Medium = MediumW,
    V_start=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{260,-59},{280,-39}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare replaceable package Medium =MediumW)
    "Differential pressure"
    annotation (Placement(transformation(extent={{150,-86},{170,-106}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(
    redeclare replaceable package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{114,-150},{94,-130}})));
  Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom roo(
    redeclare replaceable package Medium = MediumA,
    nPorts=2,
    rooLen=50,
    rooWid=30,
    rooHei=3,
    m_flow_nominal=mAir_flow_nominal,
    QRoo_flow=500000)
    "Room model"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={166,-168})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val[numChi](
    redeclare each package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each dpValve_nominal=6000)
    "Shutoff valves"
    annotation (Placement(transformation(extent={{190,130},{170,150}})));
equation
  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{126,26},{112,26},{112,0},{104,0}},
      color={0,127,255},
      thickness=0.5));
  connect(weaData.weaBus, weaBus.TWetBul)
    annotation (Line(
      points={{-200,-68},{-200,-28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(chiWSE.port_b1, TCWRet.port_a)
    annotation (Line(
      points={{146,38},{160,38},{160,60},{202,60}},
      color={0,127,255},
      thickness=0.5));
  connect(TCWRet.port_b, expVesCW.port_a)
    annotation (Line(
      points={{222,60},{240,60},{240,125}},
      color={0,127,255},
      thickness=0.5));
  for i in 1:numChi loop
    connect(cooTow[i].TAir, weaBus.TWetBul.TWetBul)
      annotation (Line(points={{153,143},
            {153,143},{160,143},{160,200},{-216,200},{-216,-28},{-200,-28}},
            color={0,0,127}));
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{120,140},{132,140},{132,139},{131,139}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_b, chiWSE.port_a1)
      annotation (Line(
        points={{70,90},{70,58},{110,58},{110,38},{126,38}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{70,110},{70,140},{100,140}},
        color={0,127,255},
        thickness=0.5));
    connect(val[i].port_a, expVesCW.port_a)
      annotation (Line(points={{190,140},
            {220,140},{220,120},{240,120},{240,125}}, color={0,127,255}));
   end for;
  connect(expVesChi.port_a, ahu.port_b1)
    annotation (Line(
      points={{270,-59},{270,-59},{270,-114},{174,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(senRelPre.port_a, ahu.port_a1)
    annotation (Line(points={{150,-96},{72,
          -96},{72,-114},{154,-114}}, color={0,127,255},
      thickness=0.5));
  connect(senRelPre.port_b, ahu.port_b1)
    annotation (Line(points={{170,-96},{242,
          -96},{242,-114},{174,-114}},   color={0,127,255},
      thickness=0.5));
  connect(TAirSup.port_a, ahu.port_b2)
    annotation (Line(
      points={{114,-140},{140,-140},{140,-126},{154,-126}},
      color={0,127,255},
      thickness=0.5));
  connect(ahu.port_a2, roo.airPorts[1])
    annotation (Line(points={{174,-126},{174,-126},{194,-126},{194,-140},{242,-140},
          {242,-176.7},{168.475,-176.7}},
      color={0,127,255},
      thickness=0.5));
  connect(TAirSup.port_b, roo.airPorts[2])
    annotation (Line(
      points={{94,-140},{94,-140},{74,-140},{74,-176.7},{164.425,-176.7}},
      color={0,127,255},
      thickness=0.5));
  connect(cooTow.port_a, val.port_b)
    annotation (Line(points={{151,139},{160.5,139},{160.5,140},{170,140}},
      color={0,127,255},
      thickness=0.5));
  connect(val[1].port_a, expVesCW.port_a)
    annotation (Line(
      points={{190,140},{220,140},{220,120},{240,120},{240,125}},
      color={0,127,255},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{280,
            200}})),
    Documentation(info="<html>
<p>
This is a partial model that describes the chilled water cooling system in a data center. The sizing data
are collected from the reference.
</p>
<h4>Reference </h4>
<ul>
<li>
Taylor, S. T. (2014). How to design &amp; control waterside economizers. ASHRAE Journal, 56(6), 30-36.
</li>
</ul>
</html>"));
end DataCenter;
