within Buildings.Templates.HeatingPlants.HotWater.Components.Controls;
block Guideline36 "Guideline 36 controller"
  extends
    Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36);

  // FIXME: Are primary-only non-condensing boiler systems supported?
  final parameter Boolean have_priOnl =
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    "Is the boiler plant a primary-only, condensing boiler plant?";

  // FIXME: How are the following configurations supported?
  // - Hybrid plant with dedicated non-condensing boiler pumps and headered condensing boiler pumps (see for instance Figure A-27 in G36)
  // - Dedicated pump provided with boiler with factory controls
  final parameter Boolean have_heaPriPum =
    typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered or
    typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Headered
    "True: Headered primary hot water pumps;
     False: Dedicated primary hot water pumps";

  final parameter Boolean have_varPriPum = have_varPumHeaWatPriCon or have_varPumHeaWatPriNon
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

  final parameter Integer nBoi = nBoiCon + nBoiNon
    "Number of boilers";

  // Concatenation with array-comprehension to be CDL-compliant.
  final parameter Integer boiTyp[nBoi] = {
    if i<=nBoiCon then Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.BoilerTypes.condensingBoiler
    else Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.BoilerTypes.nonCondensingBoiler
    for i in 1:nBoi}
    "Boiler type";

  final parameter Integer nSta = size(staMat, 1)
    "Number of boiler plant stages";

  final parameter Integer staMat[:, nBoi] = dat.sta
    "Staging matrix with stage as row index and boiler as column index";

  /* FIXME: For hybrid plants, how to specify the number of pumps for condensing and non-condensing boilers?
  To support integrated pumps with factory controls in the template, I suggest
  to use the same control logic as implemented here but maybe with separate
  dedicated output connectors.
  This would make it clear that those are not AO/DO points of the controller
  but only used for simulation purposes.
  */
  final parameter Integer nPumPri =
    nPumHeaWatPriCon + nPumHeaWatPriNon
    "Number of primary pumps in the boiler plant loop";

  final parameter Integer nSenPri = nSenDpHeaWatRem
    "Total number of remote differential pressure sensors in primary loop"
    annotation(Dialog(tab="General",
      group="Boiler plant configuration parameters",
      enable = have_remDPRegPri or have_locDPRegPri));

  parameter Integer nPumPri_nominal(
    final max=nPumPri,
    final min=1) = nPumPri
    "Number of primary HW pumps that operate at design conditions";

  final parameter Integer nPumSec = nPumHeaWatSec
    "Total number of secondary hot water pumps";

  final parameter Integer nSenSec = nSenDpHeaWatRem
    "Total number of remote differential pressure sensors in secondary loop";

  parameter Integer nPumSec_nominal(
    final max=nPumSec) = nPumSec
    "Number of secondary HW pumps that operate at design conditions";

  // FIXME: This should rather be an input point.
  parameter Real schTab[:,2] = [0,1;6,1;18,1;24,1]
    "Boiler plant enable schedule";

  // FIXME: this should not be exposed in the controller but rather computed with size() as below.
  final parameter Integer nSchRow = size(schTab, 1)
    "Number of rows to be created for plant schedule table"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  final parameter Real TOutLoc = dat.TOutLck
    "Boiler lock-out temperature for outdoor air"
    annotation(Dialog(tab="Plant enable/disable parameters"));

  // Concatenation with array-comprehension to be CDL-compliant.
  final parameter Real boiDesCap[nBoi] = {
    if i<=nBoiCon then dat.capBoiCon_nominal[i]
    else dat.capBoiNon_nominal[i-nBoiCon] for i in 1:nBoi}
    "Design boiler capacities vector";

  final parameter Real boiFirMin[nBoi] = {
    if i<=nBoiCon then dat.ratFirBoiCon_min[i]
    else dat.ratFirBoiNon_min[i-nBoiCon] for i in 1:nBoi}
    "Boiler minimum firing ratio";

  final parameter Real minFloSet[nBoi] = {
    if i<=nBoiCon then dat.ratFirBoiCon_min[i]
    else dat.ratFirBoiNon_min[i-nBoiCon] for i in 1:nBoi}
    "Design minimum hot water flow through each boiler";

  final parameter Real maxFloSet[nBoi] = {
    if i<=nBoiCon then dat.VHeaWatBoiCon_flow_nominal[i]
    else dat.VHeaWatBoiNon_flow_nominal[i-nBoiCon] for i in 1:nBoi}
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
    if i<=nBoiCon then dat.VHeaWatBoiCon_flow_nominal[i]
    else dat.VHeaWatBoiNon_flow_nominal[i-nBoiCon] for i in 1:nBoi}
    "Vector of design flowrates for all boilers in plant";

  final parameter Real maxLocDpPri = dat.dpHeaWatLocSet_nominal
    "Maximum primary loop local differential pressure setpoint";

  // FIXME: Duplicate parameter + Missing enable condition.
  final parameter Real minSecPumSpe = dat.yPumHeaWatSec_min
    "Minimum secondary pump speed";

  // FIXME: Duplicate parameter + Missing enable condition.
  final parameter Real minPumSpeSec = dat.yPumHeaWatSec_min
    "Minimum pump speed";

  // FIXME: Missing enable condition.
  final parameter Real minPriPumSpeSta[nSta] = dat.yPumHeaWatPriSta_min
    "Vector of minimum primary pump speed for each stage";

  // FIXME: Missing enable condition: only required for primary-secondary plants with a flow meter in the secondary loop, see G36 3.1.8.4.
  final parameter Real VHotWatSec_flow_nominal = dat.VHeaWatSec_flow_nominal
    "Secondary loop design hot water flow rate";

  final parameter Real maxLocDpSec = dat.dpHeaWatLocSet_nominal
    "Maximum hot water loop local differential pressure setpoint in secondary loop";

  final parameter Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes
    speConTypPri =
    if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None then (
      if have_senDpHeaWatLoc then
      Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.localDP
      else Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.remoteDP)
    else (
      if typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDecoupler or
         typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference
         then Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.flowrate
      else Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.PrimaryPumpSpeedControlTypes.temperature)
    "Primary pump speed regulation method";

  final parameter Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.SecondaryPumpSpeedControlTypes
    speConTypSec = if have_senDpHeaWatLoc then
      Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.SecondaryPumpSpeedControlTypes.localDP
      else Buildings.Templates.HeatingPlants.HotWater.Components.Controls.TypesTmp.SecondaryPumpSpeedControlTypes.remoteDP
    "Secondary pump speed regulation method";

  Guideline36Plugin ctl(
    final have_priOnl=have_priOnl,
    final have_heaPriPum=have_heaPriPum,
    final have_varPriPum=have_varPriPum,
    final have_secFloSen=have_secFloSen,
    final have_priSecTemSen=have_priSecTemSen,
    final have_varSecPum=have_varSecPum,
    final nBoi=nBoi,
    final boiTyp=boiTyp,
    final nSta=nSta,
    final staMat=staMat,
    final nPumPri=nPumPri,
    final nSenPri=nSenPri,
    final nPumPri_nominal=nPumPri_nominal,
    final nPumSec=nPumSec,
    final nSenSec=nSenSec,
    final nPumSec_nominal=nPumSec_nominal,
    final schTab=schTab,
    final nSchRow=nSchRow,
    final TOutLoc=TOutLoc,
    final boiDesCap=boiDesCap,
    final boiFirMin=boiFirMin,
    final minFloSet=minFloSet,
    final maxFloSet=maxFloSet,
    final TPlaHotWatSetMax=TPlaHotWatSetMax,
    final TConBoiHotWatSetMax=TConBoiHotWatSetMax,
    final minPumSpePri=minPumSpePri,
    final VHotWatPri_flow_nominal=VHotWatPri_flow_nominal,
    final boiDesFlo=boiDesFlo,
    final maxLocDpPri=maxLocDpPri,
    final minSecPumSpe=minSecPumSpe,
    final minPumSpeSec=minPumSpeSec,
    final minPriPumSpeSta=minPriPumSpeSta,
    final VHotWatSec_flow_nominal=VHotWatSec_flow_nominal,
    final maxLocDpSec=maxLocDpSec)
    "Plant controller"
    annotation (Placement(transformation(extent={{60,-34},{80,34}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum reqHeaWatPlaAirHan(
    final nin=nAirHan)
    "Sum of HW plant requests from AHU"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqHeaWatPlaEquZon(
    final nin=nEquZon)
    "Sum of HW plant requests from zone equipment"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqHeaWatPla
    "Sum of HW plant requests from all served units"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqHeaWatResAirHan(
    final nin=nAirHan)
    "Sum of HW reset requests from AHU"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqHeaWatResEquZon(
    final nin=nEquZon)
    "Sum of HW reset requests from zone equipment"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Add reqHeaWatRes
    "Sum of HW reset requests from all served units"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uBoi[nBoi](each k=true)
    "Not an input point per G36 4.11.1: this should be removed."
    annotation (Placement(transformation(extent={{-100,350},{-80,370}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uBoiAva[nBoi](each
      k=true) "Not an input point per G36 4.11.1: this should be removed."
    annotation (Placement(transformation(extent={{-100,310},{-80,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_TSupPri(k=
        Buildings.Templates.Data.Defaults.THeaWatSup)
    "Which sensor is that: primary loop or secondary loop? Missing Boolean condition & support for hybrid plants"
    annotation (Placement(transformation(extent={{-100,270},{-80,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_TRetPri(k=
        Buildings.Templates.Data.Defaults.THeaWatRet)
    "Missing Boolean condition & support for hybrid plants"
    annotation (Placement(transformation(extent={{-100,230},{-80,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_VHotWatPri_flow(k=1E-2)
    "Missing Boolean condition & support for hybrid plants"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uHotWatIsoVal[nBoi](each k=1)
    "This point should be optional. If present, there should rather be 2 Boolean input points (DI)."
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uBypValPos(k=0) "Not an input point per G36 4.11.1: this should be removed.
" annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uPriPumSpe[nPumPri](
      each k=0.5) "Not an input point per G36 4.11.1: this should be removed.
" annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold FIXME_yHotWatIsoValCon[nBoiCon](
    each t=1E-2, each h=5E-3)
    if have_boiCon and
    typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Should be a DO point (Boolean)"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold FIXME_yHotWatIsoValNon[nBoiNon](
    each t=1E-2, each h=5E-3)
    if have_boiNon and
    typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Should be a DO point (Boolean)"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));

initial equation
  assert(nAirHan + nEquZon > 0,
   "In "+ getInstanceName() + ": "+
   "The plant model requires at least one air handler or one zone equipment " +
   "generating HW plant requests and HW reset requests.");

equation
  /* Control point connection - start */

  // Inputs from plant control bus
  connect(FIXME_uBoiAva.y, ctl.uBoiAva);
  connect(FIXME_uBoi.y, ctl.uBoi);
  connect(busPumHeaWatPriCon.y1_actual, ctl.uPriPum[1:nBoiCon]);
  connect(busPumHeaWatPriNon.y1_actual, ctl.uPriPum[(nBoiCon+1):(nBoiCon+nBoiNon)]);
  connect(busPumHeaWatSec.y1_actual, ctl.uSecPum);

  connect(busAirHan.reqHeaWatRes, reqHeaWatResAirHan.u);
  connect(busEquZon.reqHeaWatRes, reqHeaWatResEquZon.u);
  connect(busAirHan.reqHeaWatPla, reqHeaWatPlaAirHan.u);
  connect(busEquZon.reqHeaWatPla, reqHeaWatPlaEquZon.u);

  connect(bus.TOut, ctl.TOut);
  connect(FIXME_TSupPri.y, ctl.TSupPri);
  connect(FIXME_TRetPri.y, ctl.TRetPri);
  connect(FIXME_VHotWatPri_flow.y, ctl.VHotWatPri_flow);
  connect(bus.dpHeaWatRem, ctl.dpHotWatPri_rem);
  connect(bus.THeaWatSecRet, ctl.TRetSec);
  connect(bus.VHeaWatSec_flow, ctl.VHotWatSec_flow);
  connect(bus.VHeaWatByp_flow, ctl.VHotWatDec_flow);
  connect(bus.THeaWatSecSup, ctl.TSupSec);
  connect(busBoiCon.T, ctl.TSupBoi[1:nBoiCon]);
  connect(busBoiNon.T, ctl.TSupBoi[(nBoiCon+1):(nBoiCon+nBoiNon)]);
  connect(bus.dpHeaWatRem, ctl.dpHotWatSec_rem);
  connect(bus.dpHeaWatLoc, ctl.dpHotWatPri_loc);
  connect(bus.dpHeaWatLoc, ctl.dpHotWatSec_loc);
  connect(FIXME_uHotWatIsoVal.y, ctl.uHotWatIsoVal);
  connect(FIXME_uBypValPos.y, ctl.uBypValPos);
  connect(FIXME_uPriPumSpe.y, ctl.uPriPumSpe);

  // Outputs to plant control bus
  connect(ctl.yBoi[1:nBoiCon], busBoiCon.y1);
  connect(ctl.yBoi[(nBoiCon+1):(nBoiCon+nBoiNon)], busBoiNon.y1);
  connect(ctl.yPriPum[1:nBoiCon], busPumHeaWatPriCon.y1);
  connect(ctl.yPriPum[(nBoiCon+1):(nBoiCon+nBoiNon)], busPumHeaWatPriNon.y1);
  connect(ctl.yPriPumSpe, busPumHeaWatPriCon.y);
  connect(ctl.yPriPumSpe, busPumHeaWatPriNon.y);
  connect(ctl.ySecPum, busPumHeaWatSec.y1);
  connect(ctl.ySecPumSpe, busPumHeaWatSec.y);
  connect(ctl.yBypValPos, busValHeaWatMinByp.y);
  connect(ctl.yBypValPos, busValHeaWatMinByp.y);
  connect(ctl.TBoiHotWatSupSet[1:nBoiCon], busBoiCon.THeaWatSupSet);
  connect(ctl.TBoiHotWatSupSet[(nBoiCon+1):(nBoiCon+nBoiNon)], busBoiNon.THeaWatSupSet);

  connect(FIXME_yHotWatIsoValCon.y, busValBoiConIso.y1);
  connect(FIXME_yHotWatIsoValNon.y, busValBoiNonIso.y1);
  /* Control point connection - stop */

  connect(reqHeaWatResAirHan.y, reqHeaWatRes.u1) annotation (Line(points={{-58,0},
          {-50,0},{-50,-24},{-42,-24}}, color={255,127,0}));
  connect(reqHeaWatResEquZon.y, reqHeaWatRes.u2) annotation (Line(points={{-58,-30},
          {-50,-30},{-50,-36},{-42,-36}}, color={255,127,0}));
  connect(reqHeaWatPlaAirHan.y, reqHeaWatPla.u1) annotation (Line(points={{-58,-60},
          {-50,-60},{-50,-64},{-42,-64}}, color={255,127,0}));
  connect(reqHeaWatPlaEquZon.y, reqHeaWatPla.u2) annotation (Line(points={{-58,-90},
          {-50,-90},{-50,-76},{-42,-76}}, color={255,127,0}));
  connect(reqHeaWatPla.y, ctl.plaReq) annotation (Line(points={{-18,-70},{0,-70},
          {0,29},{58,29}}, color={255,127,0}));
  connect(reqHeaWatRes.y, ctl.TSupResReq) annotation (Line(points={{-18,-30},{-4,
          -30},{-4,32},{58,32}}, color={255,127,0}));
  connect(ctl.yHotWatIsoVal[1:nBoiCon], FIXME_yHotWatIsoValCon.u) annotation (
      Line(points={{82,2},{100,2},{100,20},{118,20}}, color={0,0,127}));
  connect(ctl.yHotWatIsoVal[(nBoiCon + 1):(nBoiCon + nBoiNon)],
    FIXME_yHotWatIsoValNon.u) annotation (Line(points={{82,2},{100,2},{100,-20},
          {118,-20}}, color={0,0,127}));
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
end Guideline36;
