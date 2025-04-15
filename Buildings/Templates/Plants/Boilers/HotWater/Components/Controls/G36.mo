within Buildings.Templates.Plants.Boilers.HotWater.Components.Controls;
block G36 "Guideline 36 controller"
  extends
    Buildings.Templates.Plants.Boilers.HotWater.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36);

  final parameter Boolean have_priOnl =
    cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None
    "Is the boiler plant a primary-only, condensing boiler plant?";

  // FIXME: How are the following configurations supported?
  // - Hybrid plant with dedicated non-condensing boiler pumps and headered condensing boiler pumps (see for instance Figure A-27 in G36)
  // - Dedicated pump provided with boiler with factory controls
  final parameter Boolean have_heaPriPum =
    cfg.typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered or
    cfg.typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Headered
    "True: Headered primary hot water pumps;
     False: Dedicated primary hot water pumps";

  final parameter Boolean have_varPriPum = cfg.have_pumHeaWatPriVarCon or cfg.have_pumHeaWatPriVarNon
    "True: Variable-speed primary pumps;
     False: Fixed-speed primary pumps";

  final parameter Boolean have_secFloSen = have_senVHeaWatSec
    "True: Flowrate sensor in secondary loop;
    False: Flowrate sensor in decoupler";

  final parameter Boolean have_priSecTemSen = have_senTHeaWatPriSupCon or have_senTHeaWatPriSupNon
    "True: Temperature sensors in primary and secondary loops;
    False: Temperature sensors in boiler supply and secondary loop";

  // Only variable speed secondary pumps are supported in the template.
  final parameter Boolean have_varSecPum = true
    "True: Variable-speed secondary pumps;
    False: Fixed-speed secondary pumps";

  final parameter Integer nBoi = cfg.nBoiCon + cfg.nBoiNon
    "Number of boilers";

  // Concatenation with array-comprehension to be CDL-compliant.
  final parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.BoilerTypes boiTyp[nBoi] = {
    if i<=cfg.nBoiCon then Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.BoilerTypes.condensingBoiler
    else Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.BoilerTypes.nonCondensingBoiler
    for i in 1:nBoi}
    "Boiler type";

  final parameter Integer staMat[:, nBoi] = dat.sta
    "Staging matrix with stage as row index and boiler as column index";

  final parameter Integer nPumPri =
    cfg.nPumHeaWatPriCon + cfg.nPumHeaWatPriNon
    "Number of primary pumps in the boiler plant loop";

  final parameter Integer nSenPri = nSenDpHeaWatRem
    "Total number of remote differential pressure sensors in primary loop";

  parameter Integer nPumPri_nominal(
    final max=nPumPri,
    final min=1) = nPumPri
    "Number of primary HW pumps that operate at design conditions";

  final parameter Real TOutLoc = dat.TOutLck
    "Boiler lock-out temperature for outdoor air"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  // Concatenation with array-comprehension to be CDL-compliant.
  final parameter Real boiDesCap[nBoi] = {
    if i<=cfg.nBoiCon then dat.capBoiCon_nominal[i]
    else dat.capBoiNon_nominal[i-cfg.nBoiCon] for i in 1:nBoi}
    "Design boiler capacities vector";

  final parameter Real boiFirMin[nBoi] = {
    if i<=cfg.nBoiCon then dat.ratFirBoiCon_min[i]
    else dat.ratFirBoiNon_min[i-cfg.nBoiCon] for i in 1:nBoi}
    "Boiler minimum firing ratio";

  final parameter Real minFloSet[nBoi] = {
    if i<=cfg.nBoiCon then dat.ratFirBoiCon_min[i]
    else dat.ratFirBoiNon_min[i-cfg.nBoiCon] for i in 1:nBoi}
    "Design minimum hot water flow through each boiler";

  final parameter Real maxFloSet[nBoi] = {
    if i<=cfg.nBoiCon then dat.VHeaWatBoiCon_flow_nominal[i]
    else dat.VHeaWatBoiNon_flow_nominal[i-cfg.nBoiCon] for i in 1:nBoi}
    "Design HW volume flow rate - Each boiler";

  final parameter Real TPlaHotWatSetMax=dat.THeaWatSup_nominal
    "Design (highest) HW supply temperature setpoint";

  final parameter Real TConBoiHotWatSetMax=dat.THeaWatConSup_nominal
    "Design (highest) HW supply temperature setpoint for condensing boilers";

  // FIXME: Missing enable condition.
  final parameter Real minPumSpePri=dat.yPumHeaWatPri_min
    "Minimum pump speed";

  // FIXME: Missing enable condition: only required for primary-only plants with headered variable speed pumps using differential pressure pump speed control, see G36 3.1.8.4.
  final parameter Real VHotWatPri_flow_nominal =
    max(dat.VHeaWatPriCon_flow_nominal, dat.VHeaWatPriNon_flow_nominal)
    "Plant design hot water flow rate through  primary loop";

  // FIXME: Missing enable condition: only required for primary-only hot water plants with a minimum flow bypass valve, see G36 3.1.8.2.
  final parameter Real boiDesFlo[nBoi] = {
    if i<=cfg.nBoiCon then dat.VHeaWatBoiCon_flow_nominal[i]
    else dat.VHeaWatBoiNon_flow_nominal[i-cfg.nBoiCon] for i in 1:nBoi}
    "Vector of design flowrates for all boilers in plant";

  final parameter Real maxLocDpPri = dat.dpHeaWatLocSet_max
    "Maximum primary loop local differential pressure setpoint";
  final parameter Real minSecPumSpe = dat.yPumHeaWatSec_min
    "Minimum secondary pump speed";
  final parameter Real minPriPumSpeSta[dat.nSta] = dat.yPumHeaWatPriSta_min
    "Vector of minimum primary pump speed for each stage";
  final parameter Real VHotWatSec_flow_nominal = dat.VHeaWatSec_flow_nominal
    "Secondary loop design hot water flow rate";
  final parameter Real maxLocDpSec = dat.dpHeaWatLocSet_max
    "Maximum hot water loop local differential pressure setpoint in secondary loop";
  final parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes
    speConTypPri =
    if cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None then (
      if cfg.have_senDpHeaWatRemWir then
      Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.remoteDP else
      Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.localDP)
    else (
      if typMeaCtlHeaWatPri==Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.FlowDecoupler or
         typMeaCtlHeaWatPri==Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference
         then Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.flowrate
      else Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.PrimaryPumpSpeedControlTypes.temperature)
    "Primary pump speed regulation method";

  final parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.SecondaryPumpSpeedControlTypes
    speConTypSec = if cfg.have_senDpHeaWatRemWir then
      Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.SecondaryPumpSpeedControlTypes.remoteDP
      else Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.SecondaryPumpSpeedControlTypes.localDP
    "Secondary pump speed regulation method";

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.PrimaryController ctlLooPri(
    final boiDesCap=boiDesCap,
    final boiDesFlo=boiDesFlo,
    final boiFirMin=boiFirMin,
    final boiTyp=boiTyp,
    final have_heaPriPum=have_heaPriPum,
    final have_priOnl=have_priOnl,
    final have_priSecTemSen=have_priSecTemSen,
    final have_secFloSen=have_secFloSen,
    final have_varPriPum=have_varPriPum,
    final maxFloSet=maxFloSet,
    final maxLocDpPri=maxLocDpPri,
    final minFloSet=minFloSet,
    minLocDpPri=3E4,
    final minPriPumSpeSta=minPriPumSpeSta,
    final minPumSpePri=minPumSpePri,
    final minSecPumSpe=minSecPumSpe,
    final nBoi=nBoi,
    final nPumPri=nPumPri,
    final nPumPri_nominal=nPumPri_nominal,
    final nSenPri=nSenPri,
    final speConTypPri=speConTypPri,
    final staMat=staMat,
    final TConBoiHotWatSetMax=TConBoiHotWatSetMax,
    final TOutLoc=TOutLoc,
    final TPlaHotWatSetMax=TPlaHotWatSetMax,
    final VHotWatPri_flow_nominal=VHotWatPri_flow_nominal)
    "Primary loop controller"
    annotation (Placement(transformation(extent={{-10,-36},{10,32}})));
  ControllerSecondaryPump_patch ctlPumHeaWatSec(
    final have_secFloSen=have_secFloSen,
    final have_varSecPum=have_varSecPum,
    final maxLocDp=maxLocDp,
    final maxPumSpe=maxPumSpe,
    final minLocDp=minLocDp,
    final minPumSpe=minPumSpe,
    final nPum=cfg.nPumHeaWatSec,
    final nPum_nominal=cfg.nPumHeaWatSec,
    final nPumPri=nPumPri,
    final nSen=nSen,
    final speConTyp=speConTyp,
    final VHotWat_flow_nominal=VHotWat_flow_nominal) if cfg.typPumHeaWatSec ==
    Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.Centralized
    "Secondary HW pump controller - For centralized pumps only"
    annotation (Placement(transformation(extent={{50,60},{70,100}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqPlaHeaWatAirHan(
    final nin=nAirHan)
    "Sum of HW plant requests from AHU"
    annotation (Placement(transformation(extent={{230,152},{210,172}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqPlaHeaWatEquZon(
    final nin=nEquZon)
    "Sum of HW plant requests from zone equipment"
    annotation (Placement(transformation(extent={{230,-130},{210,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqPlaHeaWat
    "Sum of HW plant requests from all served units"
    annotation (Placement(transformation(extent={{190,150},{170,170}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqResHeaWatAirHan(
    final nin=nAirHan)
    "Sum of HW reset requests from AHU"
    annotation (Placement(transformation(extent={{230,110},{210,130}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqResHeaWatEquZon(
    final nin=nEquZon)
    "Sum of HW reset requests from zone equipment"
    annotation (Placement(transformation(extent={{230,-170},{210,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqResHeaWat
    "Sum of HW reset requests from all served units"
    annotation (Placement(transformation(extent={{192,110},{172,130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxPumHeaWatSec[cfg.nPumHeaWatSec](
     k={i for i in 1:cfg.nPumHeaWatSec}) if cfg.typPumHeaWatSec == Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.Centralized
    "Secondary HW pump index - No rotation logic currently implemented"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaBoi[nBoi](each k=true)
    "Boiler available signal – Implementation does not handle fault detection yet"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}}),
        iconTransformation(extent={{-240,220},{-200,260}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHeaWatSet[nSenDpHeaWatRem](
    final k=dat.dpHeaWatRemSet_max)
    "HW differential pressure setpoint - Remote sensor(s)"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax FIXME_max(nin=nSenDpHeaWatRem)
    "There should be one setpoint value for each remote sensor"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
initial equation
  assert(nAirHan + nEquZon > 0,
   "In "+ getInstanceName() + ": "+
   "The plant model requires at least one air handler or one zone equipment " +
   "generating HW plant requests and HW reset requests.");

equation
  /* Control point connection - start */

  // Primary loop controller inputs from plant control bus
  connect(bus.dpHeaWatLoc, ctlLooPri.dpHotWatPri_loc);
  connect(bus.dpHeaWatRem, ctlLooPri.dpHotWatPri_rem);
  connect(bus.TOut, ctlLooPri.TOut);
  // FIXME: There should be distinct connectors in the controller for condensing and non-condensing groups.
  connect(busLooCon.THeaWatPlaRet, ctlLooPri.TRetPri);
  connect(busLooNon.THeaWatPlaRet, ctlLooPri.TRetPri);
  connect(bus.THeaWatSecRet, ctlLooPri.TRetSec);
  connect(busBoiCon.THeaWatSup, ctlLooPri.TSupBoi[1:cfg.nBoiCon]);
  connect(busBoiNon.THeaWatSup, ctlLooPri.TSupBoi[(cfg.nBoiCon+1):nBoi]);
  // FIXME: There should be distinct connectors in the controller for condensing and non-condensing groups.
  connect(busLooCon.THeaWatPriSup, ctlLooPri.TSupPri);
  connect(busLooNon.THeaWatPriSup, ctlLooPri.TSupPri);
  connect(bus.THeaWatSecSup, ctlLooPri.TSupSec);
  connect(busValBoiConIso.y1_actual, ctlLooPri.uHotWatIsoVal[1:cfg.nBoiCon]);
  connect(busValBoiNonIso.y1_actual, ctlLooPri.uHotWatIsoVal[(cfg.nBoiCon+1):nBoi]);
  connect(busPumHeaWatPriCon.y1_actual, ctlLooPri.uPriPum[1:cfg.nBoiCon]);
  connect(busPumHeaWatPriNon.y1_actual, ctlLooPri.uPriPum[(cfg.nBoiCon+1):nBoi]);
  connect(bus.u1Sch, ctlLooPri.uSchEna);
  // FIXME: There should be distinct connectors in the controller for condensing and non-condensing groups.
  connect(busLooCon.VHeaWatByp_flow, ctlLooPri.VHotWatDec_flow);
  connect(busLooNon.VHeaWatByp_flow, ctlLooPri.VHotWatDec_flow);
  // FIXME: There should be distinct connectors in the controller for condensing and non-condensing groups.
  connect(busLooCon.VHeaWatPri_flow, ctlLooPri.VHotWatPri_flow);
  connect(busLooNon.VHeaWatPri_flow, ctlLooPri.VHotWatPri_flow);
  connect(bus.VHotWatSec_flow, ctlLooPri.VHotWatSec_flow);

  // Secondary HW pump controller inputs from plant control bus
  connect(bus.dpHeaWatLoc, ctlPumHeaWatSec.dpHotWat_local);
  connect(bus.dpHeaWatRem, ctlPumHeaWatSec.dpHotWat_remote);
  connect(busPumHeaWatSec.y1_actual, ctlPumHeaWatSec.uHotWatPum);
  connect(busPumHeaWatPriCon.y1_actual, ctlPumHeaWatSec.uPriPumSta[1:cfg.nBoiCon]);
  connect(busPumHeaWatPriNon.y1_actual, ctlPumHeaWatSec.uPriPumSta[(cfg.nBoiCon+1):nBoi]);
  connect(bus.VHeaWatSec_flow, ctlPumHeaWatSec.VHotWat_flow);

  // Primary loop controller outputs to plant control bus
  connect(ctlLooPri.TBoiHotWatSupSet[1:cfg.nBoiCon], busBoiCon.THeaWatSupSet);
  connect(ctlLooPri.TBoiHotWatSupSet[(cfg.nBoiCon+1):nBoi], busBoiNon.THeaWatSupSet);
  connect(ctlLooPri.yBoi[1:cfg.nBoiCon], busBoiCon.y1);
  connect(ctlLooPri.yBoi[(cfg.nBoiCon+1):nBoi], busBoiNon.y1);
  connect(ctlLooPri.yBypValPos, busValHeaWatMinByp.y);
  connect(ctlLooPri.yHotWatIsoVal[1:cfg.nBoiCon], busValBoiConIso.y1);
  connect(ctlLooPri.yHotWatIsoVal[(cfg.nBoiCon+1):nBoi], busValBoiNonIso.y1);
  connect(ctlLooPri.yPriPum[1:cfg.nBoiCon], busPumHeaWatPriCon.y1);
  connect(ctlLooPri.yPriPum[(cfg.nBoiCon+1):nBoi], busPumHeaWatPriNon.y1);
  // FIXME: There should be distinct connectors in the controller for condensing and non-condensing groups.
  connect(ctlLooPri.yPriPumSpe, busPumHeaWatPriCon.y);
  connect(ctlLooPri.yPriPumSpe, busPumHeaWatPriNon.y);

  // Secondary HW pump controller outputs to plant control bus
  connect(ctlPumHeaWatSec.yHotWatPum, busPumHeaWatSec.y1);
  connect(ctlPumHeaWatSec.yPumSpe, busPumHeaWatSec.y);

  /* Control point connection - stop */

  connect(reqResHeaWatAirHan.y,reqResHeaWat. u1) annotation (Line(points={{208,120},
          {198,120},{198,126},{194,126}}, color={255,127,0}));
  connect(reqResHeaWatEquZon.y,reqResHeaWat. u2) annotation (Line(points={{208,-160},
          {198,-160},{198,114},{194,114}},color={255,127,0}));
  connect(reqPlaHeaWatAirHan.y,reqPlaHeaWat. u1) annotation (Line(points={{208,162},
          {200,162},{200,166},{192,166}}, color={255,127,0}));
  connect(reqPlaHeaWatEquZon.y,reqPlaHeaWat. u2) annotation (Line(points={{208,-120},
          {200,-120},{200,154},{192,154}},color={255,127,0}));
  connect(reqPlaHeaWat.y, ctlLooPri.plaReq) annotation (Line(points={{168,160},{
          -20,160},{-20,23.5},{-12,23.5}}, color={255,127,0}));
  connect(reqResHeaWat.y, ctlLooPri.TSupResReq) annotation (Line(points={{170,120},
          {-18,120},{-18,26.9},{-12,26.9}}, color={255,127,0}));
  connect(idxPumHeaWatSec.y, ctlPumHeaWatSec.uPumLeaLag) annotation (Line(
        points={{12,100},{40,100},{40,98.2},{48,98.2}}, color={255,127,0}));
  connect(ctlLooPri.yPla, ctlPumHeaWatSec.uPlaEna) annotation (Line(points={{12,
          9.9},{30,9.9},{30,90},{48,90}}, color={255,0,255}));
  connect(busEquZon.reqResHeaWat, reqResHeaWatEquZon.u) annotation (Line(
      points={{260,-140},{240,-140},{240,-160},{232,-160}},
      color={255,204,51},
      thickness=0.5));
  connect(busEquZon.reqPlaHeaWat, reqPlaHeaWatEquZon.u) annotation (Line(
      points={{260,-140},{240,-140},{240,-120},{232,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(busAirHan.reqPlaHeaWat, reqPlaHeaWatAirHan.u) annotation (Line(
      points={{260,140},{240,140},{240,162},{232,162}},
      color={255,204,51},
      thickness=0.5));
  connect(busAirHan.reqResHeaWat, reqResHeaWatAirHan.u) annotation (Line(
      points={{260,140},{240,140},{240,120},{232,120}},
      color={255,204,51},
      thickness=0.5));
  connect(reqResHeaWat.y, ctlPumHeaWatSec.supResReq) annotation (Line(points={{170,
          120},{44,120},{44,86},{48,86}}, color={255,127,0}));
  connect(ctlPumHeaWatSec.yPumSpe, ctlPumHeaWatSec.uPumSpe) annotation (Line(
        points={{72,70},{76,70},{76,50},{44,50},{44,82},{48,82}}, color={0,0,127}));
  connect(ctlLooPri.yPriPum, ctlPumHeaWatSec.uPriPumSta) annotation (Line(
        points={{12,-10.5},{32,-10.5},{32,78},{48,78}}, color={255,0,255}));
  connect(ctlLooPri.yMaxSecPumSpe, ctlPumHeaWatSec.uMaxSecPumSpeCon)
    annotation (Line(points={{12,-7.1},{34,-7.1},{34,62},{48,62}}, color={0,0,127}));
  connect(u1AvaBoi.y, ctlLooPri.uBoiAva) annotation (Line(points={{-78,20},{-20,
          20},{-20,-0.3},{-12,-0.3}}, color={255,0,255}));
  connect(dpHeaWatSet.y, FIXME_max.u)
    annotation (Line(points={{-78,60},{-62,60}}, color={0,0,127}));
  connect(FIXME_max.y, ctlPumHeaWatSec.dpHotWatSet) annotation (Line(points={{-38,
          60},{28,60},{28,66},{48,66}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4>Description</h4>
<p>
This is an implementation of the control sequence specified in ASHRAE (2021)
for hot water plants.
It is based on
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller</a>.
</p>
<h4>Details</h4>
<p>
For hybrid plants, units shall be indexed so that condensing boilers have the
lowest indices and non-condensing boilers have the highest indices.
</p>
<p>
Distributed secondary pumps are currently not supported.
This limitation stems from the Guideline 36 controller implementation in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Controller</a>.
</p>
<h4>Control points</h4>
<p>
The Guideline 36 control sequence requires the following input points in
addition to the ones from the HW plant model.
</p>
<ul>
<li>Outdoor air temperature <code>TOut</code>:
AI signal with a dimensionality of zero</li>
<li>HW differential pressure from remote sensor(s) <code>dpHeaWatRem</code>:
AI signal with a dimensionality of one, the number of remote
sensors is specified by the parameter <code>nSenDpHeaWatRem</code>.</li>
<li>
Inside the sub-bus <code>busAirHan[:]</code> (resp. <code>busEquZon[:]</code>),
with a dimensionality of one
<ul>
<li>HW plant requests yielded by the air handler or zone
equipment controller <code>bus(AirHan|EquZon)[:].reqHeaWatPla</code>:
AI signal (Integer), with a dimensionality of one
</li>
<li>HW reset requests yielded by the air handler or zone
equipment controller <code>bus(AirHan|EquZon)[:].reqHeaWatRes</code>:
AI signal (Integer), with a dimensionality of one</li>
</ul>
</li>
</ul>
<h4>References</h4>
<ul>
<li>
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end G36;
