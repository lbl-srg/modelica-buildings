within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model HeatPumpGroupAirToWater
  "Validation model for heat pump group"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW/HW medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Data.Controller datCtlPlaAwNrv(
    cfg(
      have_chiWat=false,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      have_pumChiWatPriDed=false,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=hpAwNrv.is_rev,
      typ=hpAwNrv.typ,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=hpAwNrv.cpChiWat_default,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      have_valHpInlIso=false,
      have_valHpOutIso=false,
      typMod=hpAwNrv.typMod,
      have_senVHeaWatSec=false,
      cpHeaWat_default=hpAwNrv.cpHeaWat_default,
      cpSou_default=hpAwNrv.cpSou_default,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=hpAwNrv.nHp,
      nPumHeaWatPri=hpAwNrv.nHp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=hpAwNrv.nHp,
      have_senVChiWatSec=false,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSupHp_nominal=datHpAwNrv.THeaWatSupHp_nominal)
    "Controller parameters"
    annotation (Placement(transformation(extent={{-170,40},{-150,60}})));
  parameter Data.Controller datCtlPlaAw(
    cfg(
      have_chiWat=true,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      have_pumChiWatPriDed=false,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=hpAw.is_rev,
      typ=hpAw.typ,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=hpAw.cpChiWat_default,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      have_valHpInlIso=true,
      have_valHpOutIso=true,
      typMod=hpAw.typMod,
      have_senVHeaWatSec=false,
      cpHeaWat_default=hpAw.cpHeaWat_default,
      cpSou_default=hpAw.cpSou_default,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=hpAw.nHp,
      nPumHeaWatPri=hpAw.nHp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=hpAw.nHp,
      have_senVChiWatSec=false,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSupHp_nominal=datHpAw.THeaWatSupHp_nominal,
    TChiWatSup_nominal=datHpAw.TChiWatSupHp_nominal) "Controller parameters"
    annotation (Placement(transformation(extent={{-170,-140},{-150,-120}})));

  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.HeatPumpGroup datHpAwNrv(
    final cpHeaWat_default=hpAwNrv.cpHeaWat_default,
    final cpSou_default=hpAwNrv.cpSou_default,
    final nHp=hpAwNrv.nHp,
    final typ=hpAwNrv.typ,
    final is_rev=hpAwNrv.is_rev,
    final typMod=hpAwNrv.typMod,
    mHeaWatHp_flow_nominal=datHpAwNrv.capHeaHp_nominal / abs(datHpAwNrv.THeaWatSupHp_nominal -
      Buildings.Templates.Data.Defaults.THeaWatRetMed) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaHp_nominal=500E3,
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    perFitHp(
      hea(
        P=datHpAwNrv.capHeaHp_nominal / Buildings.Templates.Data.Defaults.COPHpAwHea,
        coeQ={- 4.2670305442, - 0.7381077035, 6.0049480456, 0, 0},
        coeP={- 4.9107455513, 5.3665308366, 0.5447612754, 0, 0},
        TRefLoa=Buildings.Templates.Data.Defaults.THeaWatRetMed,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHpHeaLow)))
    "Non-reversible AWHP parameters"
    annotation (Placement(transformation(extent={{-130,40},{-110,60}})));
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.HeatPumpGroup datHpAw(
    final cpHeaWat_default=hpAw.cpHeaWat_default,
    final cpSou_default=hpAw.cpSou_default,
    final nHp=hpAw.nHp,
    final typ=hpAw.typ,
    final is_rev=hpAw.is_rev,
    final typMod=hpAw.typMod,
    mHeaWatHp_flow_nominal=datHpAw.capHeaHp_nominal / abs(datHpAw.THeaWatSupHp_nominal -
      Buildings.Templates.Data.Defaults.THeaWatRetMed) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaHp_nominal=500E3,
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    mChiWatHp_flow_nominal=datHpAw.capCooHp_nominal / abs(datHpAw.TChiWatSupHp_nominal -
      Buildings.Templates.Data.Defaults.TChiWatRet) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCooHp_nominal=500E3,
    TChiWatSupHp_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCooHp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    perFitHp(
      hea(
        P=datHpAw.capHeaHp_nominal / Buildings.Templates.Data.Defaults.COPHpAwHea,
        coeQ={- 4.2670305442, - 0.7381077035, 6.0049480456, 0, 0},
        coeP={- 4.9107455513, 5.3665308366, 0.5447612754, 0, 0},
        TRefLoa=Buildings.Templates.Data.Defaults.THeaWatRetMed,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHpHeaLow),
      coo(
        P=datHpAw.capCooHp_nominal / Buildings.Templates.Data.Defaults.COPHpAwCoo,
        coeQ={- 2.2545246871, 6.9089257665, - 3.6548225094, 0, 0},
        coeP={- 5.8086010402, 1.6894933858, 5.1167787436, 0, 0},
        TRefLoa=Buildings.Templates.Data.Defaults.TChiWatRet,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHpCoo)))
    "Reversible AWHP parameters"
    annotation (Placement(transformation(extent={{-130,-140},{-110,-120}})));
  Fluid.Sources.Boundary_pT sup(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=hpAwNrv.nHp)
    "Boundary condition at distribution system supply"
    annotation (Placement(transformation(extent={{120,130},{100,150}})));
  Fluid.Sources.Boundary_pT inlHp1(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=hpAwNrv.nHp)
    "Boundary conditions at HP inlet"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={180,160})));
  Fluid.Sensors.TemperatureTwoPort TRet1[hpAwNrv.nHp](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=datHpAwNrv.mHeaWatHp_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Fluid.Sensors.TemperatureTwoPort TSup1[hpAwNrv.nHp](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=datHpAwNrv.mHeaWatHp_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  Controls.OpenLoop ctlPlaAwNrv(
    final cfg=datCtlPlaAwNrv.cfg,
    final dat=datCtlPlaAwNrv)
    "Plant controller"
    annotation (Placement(transformation(extent={{-20,130},{-40,150}})));
  HeatPumpGroups.AirToWater hpAwNrv(
    redeclare final package MediumHeaWat=Medium,
    nHp=3,
    is_rev=false,
    final dat=datHpAwNrv,
    final energyDynamics=energyDynamics)
    "Non reversible AWHP"
    annotation (Placement(transformation(extent={{100,40},{-100,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet(
    amplitude=datHpAwNrv.THeaWatSupHp_nominal - datHpAwNrv.THeaWatRetHp_nominal,
    freqHz=3 / 3000,
    y(final unit="K",
      displayUnit="degC"),
    offset=datHpAwNrv.THeaWatRetHp_nominal,
    startTime=0)
    "HW return temperature value"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWatInl(
    k=sup.p + datHpAwNrv.dpHeaWatHp_nominal)
    "HW inlet pressure"
    annotation (Placement(transformation(extent={{-170,150},{-150,170}})));
  HeatPumpGroups.AirToWater hpAw(
    redeclare final package MediumHeaWat=Medium,
    nHp=3,
    is_rev=true,
    final dat=datHpAw,
    final energyDynamics=energyDynamics)
    "Reversible AWHP"
    annotation (Placement(transformation(extent={{100,-140},{-100,-60}})));
  Controls.OpenLoop ctlPlaAw(
    final cfg=datCtlPlaAw.cfg,
    final dat=datCtlPlaAw)
    "Plant controller"
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  Fluid.Sources.Boundary_pT inlHp(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=hpAwNrv.nHp)
    "Boundary conditions at HP inlet"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Fluid.Sensors.TemperatureTwoPort TRet[hpAw.nHp](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=datHpAw.mHeaWatHp_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Fluid.Sources.Boundary_pT sup1(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=hpAwNrv.nHp)
    "Boundary condition at distribution system supply"
    annotation (Placement(transformation(extent={{120,-50},{100,-30}})));
  Fluid.Sensors.TemperatureTwoPort TSup[hpAw.nHp](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=datHpAw.mHeaWatHp_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet1(
    amplitude=datHpAw.THeaWatSupHp_nominal - datHpAw.THeaWatRetHp_nominal,
    freqHz=3 / 3000,
    y(final unit="K",
      displayUnit="degC"),
    offset=datHpAw.THeaWatRetHp_nominal,
    startTime=0)
    "HW return temperature value"
    annotation (Placement(transformation(extent={{-210,-70},{-190,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=datHpAw.TChiWatRetHp_nominal - datHpAw.TChiWatSupHp_nominal,
    freqHz=3 / 3000,
    y(final unit="K",
      displayUnit="degC"),
    offset=datHpAw.TChiWatRetHp_nominal,
    startTime=0)
    "CHW return temperature value"
    annotation (Placement(transformation(extent={{-210,-110},{-190,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWatInl1(
    k=sup.p + hpAw.dpHeaWatHp_nominal)
    "HW inlet pressure"
    annotation (Placement(transformation(extent={{-210,10},{-190,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pChiWatInl(
    k=sup.p + hpAw.dpChiWatHp_nominal)
    "CHW inlet pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-200,-20})));
  Buildings.Controls.OBC.CDL.Reals.Switch TRetAct
    "Active return temperature"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel
    "Active inlet gaupe pressure"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla
    "Plant controller"
    annotation (Placement(iconVisible=false,transformation(extent={{-20,-20},{20,20}}),
      iconTransformation(extent={{-548,-190},{-508,-150}})));
  Buildings.Templates.Components.Interfaces.Bus busHp[hpAw.nHp]
    "HP control bus"
    annotation (Placement(iconVisible=false,transformation(extent={{-120,-20},{-80,20}}),
      iconTransformation(extent={{-536,100},{-496,140}})));
equation
  connect(ctlPlaAwNrv.bus, hpAwNrv.bus)
    annotation (Line(points={{-20,140},{0,140},{0,120}},color={255,204,51},thickness=0.5));
  connect(inlHp1.ports, TRet1.port_a)
    annotation (Line(points={{-100,140},{-80,140}},color={0,127,255}));
  connect(TRet1.port_b, hpAwNrv.ports_aChiHeaWat)
    annotation (Line(points={{-60,140},{-50,140},{-50,120}},color={0,127,255}));
  connect(hpAwNrv.ports_bChiHeaWat, TSup1.port_a)
    annotation (Line(points={{50,120},{50,140},{60,140}},color={0,127,255}));
  connect(TSup1.port_b, sup.ports)
    annotation (Line(points={{80,140},{100,140}},color={0,127,255}));
  connect(weaDat.weaBus, hpAwNrv.busWea)
    annotation (Line(points={{170,160},{20,160},{20,120}},color={255,204,51},thickness=0.5));
  connect(THeaWatRet.y, inlHp1.T_in)
    annotation (Line(points={{-148,120},{-140,120},{-140,144},{-122,144}},color={0,0,127}));
  connect(pHeaWatInl.y, inlHp1.p_in)
    annotation (Line(points={{-148,160},{-140,160},{-140,148},{-122,148}},color={0,0,127}));
  connect(weaDat.weaBus, hpAw.busWea)
    annotation (Line(points={{170,160},{160,160},{160,0},{20,0},{20,-60}},color={255,204,51},thickness=0.5));
  connect(ctlPlaAw.bus, hpAw.bus)
    annotation (Line(points={{-20,-40},{0,-40},{0,-60}},color={255,204,51},thickness=0.5));
  connect(inlHp.ports, TRet.port_a)
    annotation (Line(points={{-100,-40},{-80,-40}},color={0,127,255}));
  connect(TRet.port_b, hpAw.ports_aChiHeaWat)
    annotation (Line(points={{-60,-40},{-50,-40},{-50,-60}},color={0,127,255}));
  connect(TSup.port_b, sup1.ports)
    annotation (Line(points={{80,-40},{100,-40}},color={0,127,255}));
  connect(hpAw.ports_bChiHeaWat, TSup.port_a)
    annotation (Line(points={{50,-60},{50,-40},{60,-40}},color={0,127,255}));
  connect(THeaWatRet1.y, TRetAct.u1)
    annotation (Line(points={{-188,-60},{-180,-60},{-180,-72},{-162,-72}},color={0,0,127}));
  connect(TChiWatRet.y, TRetAct.u3)
    annotation (Line(points={{-188,-100},{-170,-100},{-170,-88},{-162,-88}},
      color={0,0,127}));
  connect(pHeaWatInl1.y, pInl_rel.u1)
    annotation (Line(points={{-188,20},{-180,20},{-180,8},{-162,8}},color={0,0,127}));
  connect(pChiWatInl.y, pInl_rel.u3)
    annotation (Line(points={{-188,-20},{-180,-20},{-180,-8},{-162,-8}},color={0,0,127}));
  connect(pInl_rel.y, inlHp.p_in)
    annotation (Line(points={{-138,0},{-132,0},{-132,-32},{-122,-32}},color={0,0,127}));
  connect(TRetAct.y, inlHp.T_in)
    annotation (Line(points={{-138,-80},{-132,-80},{-132,-36},{-122,-36}},color={0,0,127}));
  connect(busPla, ctlPlaAw.bus)
    annotation (Line(points={{0,0},{0,-40},{-20,-40}},color={255,204,51},thickness=0.5));
  connect(busPla.hp, busHp)
    annotation (Line(points={{0,0},{-100,0}},color={255,204,51},thickness=0.5));
  connect(busHp[1].y1Hea, pInl_rel.u2)
    annotation (Line(points={{-100,0},{-100,20},{-170,20},{-170,0},{-162,0}},
      color={255,204,51},thickness=0.5));
  connect(pInl_rel.u2, TRetAct.u2)
    annotation (Line(points={{-162,0},{-170,0},{-170,-80},{-162,-80}},color={255,0,255}));
  annotation (
    Diagram(
      coordinateSystem(
        extent={{-220,-220},{220,220}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Components/Validation/HeatPumpGroupAirToWater.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StartTime=10497600.0,
      StopTime=10505600.0),
    Documentation(
      info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups.AirToWater\">
Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups.AirToWater</a>
in a configuration in which the heat pump components are exposed
to a constant differential pressure and a varying
return temperature.
</p>
<p>
The model is configured to represent either a non-reversible heat pump
(component <code>heaPumNonRev</code>) or a reversible heat pump
(component <code>heaPumRev</code>) that switches between cooling and heating
mode.
</p>
<p>
It can be seen that the HW supply temperature setpoint is not met
at minimum HW return temperature because the outdoor air temperature
is below the heat pump selection conditions.
</p>
</html>"));
end HeatPumpGroupAirToWater;
