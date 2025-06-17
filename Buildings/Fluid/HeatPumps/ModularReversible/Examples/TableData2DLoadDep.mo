within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model TableData2DLoadDep
  "Validation model for heat pump component with ideal controls"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW or CHW medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal=hp.TConHea_nominal -
    hp.dTCon_nominal;
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=hp.TConCoo_nominal +
    hp.dTEva_nominal;
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    k=hp.TConCoo_nominal,
    y(final unit="K",
      displayUnit="degC"))
    "CHWST setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-80,120})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(
    k=hp.TConHea_nominal,
    y(final unit="K",
      displayUnit="degC"))
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet(
    amplitude=hp.TConHea_nominal - THeaWatRet_nominal,
    freqHz=3 / 3000,
    y(final unit="K",
      displayUnit="degC"),
    offset=THeaWatRet_nominal,
    startTime=0)
    "HW return temperature value"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[
      0, 1, 1;
      30, 0, 1;
      45, 1, 0;
      75, 0, 0],
    timeScale=60,
    period=5400)
    "Heat pump enable and heating mode command"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSetAct(
    y(final unit="K",
      displayUnit="degC"))
    "Active supply temperature setpoint"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=TChiWatRet_nominal - hp.TConCoo_nominal,
    freqHz=3 / 3000,
    y(final unit="K",
      displayUnit="degC"),
    offset=TChiWatRet_nominal,
    startTime=0)
    "CHW return temperature value"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Fluid.Sources.Boundary_pT inlHp(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1)
    "Boundary conditions of CHW/HW at HP inlet"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TRetAct
    "Active return temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel
    "Active inlet gauge pressure"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWatInl(
    k=sup.p + hp.dpCon_nominal)
    "HW inlet pressure"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pChiWatInl(
    k=sup.p + hp.dpCon_nominal *(hp.mEva_flow_nominal / hp.mCon_flow_nominal) ^ 2)
    "CHW inlet pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-80,-40})));
  Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TAmbHea(
    y(final unit="K",
      displayUnit="degC"),
    height=4,
    duration=500,
    offset=hp.TEvaHea_nominal,
    startTime=2400) "Ambient fluid supply temperature value"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TAmbCoo(
    y(final unit="K",
      displayUnit="degC"),
    height=- 4,
    duration=500,
    offset=hp.TEvaCoo_nominal,
    startTime=1400) "Ambient-side fluid supply temperature value"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TAmbAct
    "Active ambient-side fluid supply temperature"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel1
    "Active inlet gauge pressure"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pAmbInlHea(
    k=retAmb.p + hp.dpEva_nominal) "Ambient fluid inlet pressure"
    annotation (Placement(transformation(extent={{-130,-130},{-110,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pAmbInlCoo(
    k=retAmb.p + hp.dpCon_nominal) "Ambient-side fluid inlet pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-120,-160})));
  Fluid.Sources.Boundary_pT inlHpAmb(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) "Boundary conditions of ambient-side fluid at HP inlet"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Fluid.Sources.Boundary_pT retAmb(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=2) "Boundary conditions of ambient-side fluid at HP outlet"
    annotation (Placement(transformation(extent={{190,-70},{170,-50}})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep hp(
    show_T=true,
    redeclare final package MediumCon=Medium,
    redeclare final package MediumEva=Medium,
    use_rev=true,
    use_intSafCtr=false,
    mCon_flow_nominal=datHea.mCon_flow_nominal,
    QHea_flow_nominal=890E3,
    QCoo_flow_nominal=- 630E3,
    datCoo=datCoo,
    TConHea_nominal=336.15,
    CCon=0,
    GConOut=0,
    GConIns=0,
    TEvaHea_nominal=279.15,
    mEva_flow_nominal=datHea.mEva_flow_nominal,
    use_conCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    TEva_start=290.15,
    use_evaCap=false,
    final energyDynamics=energyDynamics,
    final datHea=datHea,
    TConCoo_nominal=279.15,
    TEvaCoo_nominal=336.15)
    "Heat pump"
    annotation (Placement(transformation(extent={{-10.5,-10.5},{10.5,10.5}},
      rotation=0,origin={110.5,-6.5})));
  parameter Data.TableData2DLoadDep.GenericHeatPump datHea(
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_HP.txt"),
    PLRSup={0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.9,1.0},
    PLRCyc_min=0.2,
    P_min=50,
    mCon_flow_nominal=45,
    mEva_flow_nominal=30,
    dpCon_nominal=40E3,
    dpEva_nominal=37E3,
    devIde="30XW852",
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    tabUppBou=[
      276.45, 336.15;
      303.15, 336.15],
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=true)
    "Heat pump performance data"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Sources.Boundary_pT sup(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=2)
    "Boundary condition at distribution system supply"
    annotation (Placement(transformation(extent={{190,-10},{170,10}})));
  parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic datCoo(
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_Chiller.txt"),
    PLRSup={0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.9,1.0},
    PLRCyc_min=0.2,
    P_min=50,
    mCon_flow_nominal=45,
    mEva_flow_nominal=30,
    dpCon_nominal=40E3,
    dpEva_nominal=37E3,
    devIde="30XW852",
    use_TEvaOutForTab=true,
    use_TConOutForTab=true,
    tabLowBou=[
      292.15, 276.45;
      336.15, 276.45],
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=true)
    "Chiller performance data"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Sources.Boundary_pT inlHp1(
    redeclare final package Medium=Medium,
    p=pHeaWatInl.k,
    use_T_in=true,
    nPorts=1)
    "Boundary conditions of CHW/HW at HP inlet"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Sensors.TemperatureTwoPort TRet1(
    redeclare final package Medium=Medium,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Sensors.TemperatureTwoPort TSup1(
    redeclare final package Medium=Medium,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{130,-110},{150,-90}})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep hpNrv(
    show_T=true,
    redeclare final package MediumCon=Medium,
    redeclare final package MediumEva=Medium,
    use_rev=false,
    use_intSafCtr=false,
    mCon_flow_nominal=datHea.mCon_flow_nominal,
    QHea_flow_nominal=890E3,
    TConHea_nominal=336.15,
    CCon=0,
    GConOut=0,
    GConIns=0,
    TEvaHea_nominal=279.15,
    mEva_flow_nominal=datHea.mEva_flow_nominal,
    use_conCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    TEva_start=290.15,
    use_evaCap=false,
    final energyDynamics=energyDynamics,
    final datHea=datHea)
    "Non reversible heat pump"
    annotation (Placement(transformation(extent={{-10.5,-10.5},{10.5,10.5}},
      rotation=0,origin={110.5,-106.5})));
  Sources.Boundary_pT inlHpAmb1(
    redeclare final package Medium=Medium,
    p=pAmbInlHea.k,
    use_T_in=true,
    nPorts=1) "Boundary conditions of ambient-side fluid at HP inlet"
    annotation (Placement(transformation(extent={{10,-150},{30,-130}})));
equation
  connect(TChiWatSupSet.y, TSetAct.u3)
    annotation (Line(points={{-68,120},{-64,120},{-64,112},{-42,112}},color={0,0,127}));
  connect(THeaWatSupSet.y, TSetAct.u1)
    annotation (Line(points={{-68,160},{-60,160},{-60,128},{-42,128}},color={0,0,127}));
  connect(THeaWatRet.y, TRetAct.u1)
    annotation (Line(points={{-68,80},{-60,80},{-60,68},{-42,68}},color={0,0,127}));
  connect(TChiWatRet.y, TRetAct.u3)
    annotation (Line(points={{-68,40},{-60,40},{-60,52},{-42,52}},color={0,0,127}));
  connect(TRetAct.y, inlHp.T_in)
    annotation (Line(points={{-18,60},{-10,60},{-10,4},{8,4}},color={0,0,127}));
  connect(pInl_rel.y, inlHp.p_in)
    annotation (Line(points={{-18,-20},{0,-20},{0,8},{8,8}},color={0,0,127}));
  connect(pHeaWatInl.y, pInl_rel.u1)
    annotation (Line(points={{-68,0},{-60,0},{-60,-12},{-42,-12}},color={0,0,127}));
  connect(pChiWatInl.y, pInl_rel.u3)
    annotation (Line(points={{-68,-40},{-46,-40},{-46,-28},{-42,-28}},color={0,0,127}));
  connect(TAmbHea.y,TAmbAct. u1)
    annotation (Line(points={{-108,-80},{-60,-80},{-60,-72},{-42,-72}},color={0,0,127}));
  connect(TAmbCoo.y,TAmbAct. u3)
    annotation (Line(points={{-68,-100},{-46,-100},{-46,-88},{-42,-88}},color={0,0,127}));
  connect(pAmbInlHea.y, pInl_rel1.u1)
    annotation (Line(points={{-108,-120},{-64,-120},{-64,-152},{-42,-152}},color={0,0,127}));
  connect(pAmbInlCoo.y, pInl_rel1.u3)
    annotation (Line(points={{-108,-160},{-60,-160},{-60,-168},{-42,-168}},color={0,0,127}));
  connect(TAmbAct.y,inlHpAmb. T_in)
    annotation (Line(points={{-18,-80},{0,-80},{0,-36},{8,-36}},color={0,0,127}));
  connect(pInl_rel1.y,inlHpAmb. p_in)
    annotation (Line(points={{-18,-160},{-10,-160},{-10,-32},{8,-32}},color={0,0,127}));
  connect(TSetAct.y, hp.TSet)
    annotation (Line(points={{-18,120},{80,120},{80,-2.3},{97.9,-2.3}}, color={0,0,127}));
  connect(TRet.port_b, hp.port_a1)
    annotation (Line(points={{70,0},{86,0},{86,-0.2},{100,-0.2}},color={0,127,255}));
  connect(TSup.port_a, hp.port_b1)
    annotation (Line(points={{130,0},{126,0},{126,-0.2},{121,-0.2}},color={0,127,255}));
  connect(TSup.port_b, sup.ports[1])
    annotation (Line(points={{150,0},{160,0},{160,-1},{170,-1}},color={0,127,255}));
  connect(inlHpAmb.ports[1], hp.port_a2)
    annotation (Line(points={{30,-40},{140,-40},{140,-12.8},{121,-12.8}},color={0,127,255}));
  connect(retAmb.ports[1], hp.port_b2)
    annotation (Line(points={{170,-61},{90,-61},{90,-12.8},{100,-12.8}},color={0,127,255}));
  connect(y1.y[1], hp.on)
    annotation (Line(points={{-158,140},{82,140},{82,-6.5},{97.9,-6.5}}, color={255,0,255}));
  connect(inlHp.ports[1], TRet.port_a)
    annotation (Line(points={{30,0},{50,0}},color={0,127,255}));
  connect(TRet1.port_b, hpNrv.port_a1)
    annotation (Line(points={{70,-100},{86,-100},{86,-100.2},{100,-100.2}},color={0,127,255}));
  connect(TSup1.port_a, hpNrv.port_b1)
    annotation (Line(points={{130,-100},{126,-100},{126,-100.2},{121,-100.2}},
      color={0,127,255}));
  connect(y1.y[1], hpNrv.on)
    annotation (Line(points={{-158,140},{82,140},{82,-106.5},{97.9,-106.5}},
      color={255,0,255}));
  connect(inlHp1.ports[1], TRet1.port_a)
    annotation (Line(points={{30,-100},{50,-100}},color={0,127,255}));
  connect(TSup1.port_b, sup.ports[2])
    annotation (Line(points={{150,-100},{160,-100},{160,1},{170,1}},color={0,127,255}));
  connect(inlHpAmb1.ports[1], hpNrv.port_a2)
    annotation (Line(points={{30,-140},{160,-140},{160,-112.8},{121,-112.8}},
      color={0,127,255}));
  connect(hpNrv.port_b2,retAmb. ports[2])
    annotation (Line(points={{100,-112.8},{90,-112.8},{90,-59},{170,-59}},color={0,127,255}));
  connect(TAmbHea.y,inlHpAmb1. T_in)
    annotation (Line(points={{-108,-80},{-60,-80},{-60,-136},{8,-136}},color={0,0,127}));
  connect(THeaWatRet.y, inlHp1.T_in)
    annotation (Line(points={{-68,80},{-4,80},{-4,-96},{8,-96}},color={0,0,127}));
  connect(THeaWatSupSet.y, hpNrv.TSet)
    annotation (Line(points={{-68,160},{84,160},{84,-102.3},{97.9,-102.3}},
      color={0,0,127}));
  connect(y1.y[2], TSetAct.u2)
    annotation (Line(points={{-158,140},{-50,140},{-50,120},{-42,120}},color={255,0,255}));
  connect(y1.y[2], TRetAct.u2)
    annotation (Line(points={{-158,140},{-50,140},{-50,60},{-42,60}},color={255,0,255}));
  connect(y1.y[2], pInl_rel.u2)
    annotation (Line(points={{-158,140},{-50,140},{-50,-20},{-42,-20}},color={255,0,255}));
  connect(y1.y[2], pInl_rel1.u2)
    annotation (Line(points={{-158,140},{-50,140},{-50,-160},{-42,-160}},color={255,0,255}));
  connect(y1.y[2], hp.hea)
    annotation (Line(points={{-158,140},{82,140},{82,-8.6},{97.9,-8.6}}, color={255,0,255}));
  connect(y1.y[2],TAmbAct. u2)
    annotation (Line(points={{-158,140},{-86,140},{-86,146},{-50,146},{-50,-80},{-42,-80}},
      color={255,0,255}));
  annotation (
    Diagram(
      coordinateSystem(
        extent={{-200,-180},{200,180}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StartTime=10497600.0,
      StopTime=10503000.0),
    Documentation(
      info="<html>
<p>
This model illustrates the use of 
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep</a>
in a configuration in which water-to-water heat pump components are
exposed to a constant differential pressure and a varying return temperature
on the load side.
</p>
<p>
The heat pump components are configured to represent either a non-reversible
heat pump (component <code>hpNrv</code>) or a reversible heat pump
(component <code>hp</code>) that switches between cooling and heating mode.
</p>
</html>",
      revisions="<html>
<ul>
<li>
xxxx, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TableData2DLoadDep;
