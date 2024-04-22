within Buildings.Templates.Plants.Controls.HeatPumps.Validation;
model AirToWater
  final parameter Real capHea_nominal(
    final unit="W")=sum(ctl.capHeaHp_nominal)
    "Installed heating capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Real THeaWatSup_nominal(
    unit="K",
    displayUnit="degC")=323.15
    "Design HW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real THeaWatRet_nominal(
    unit="K",
    displayUnit="degC")=315.15
    "Design HW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real VHeaWat_flow_nominal(unit="m3/s")=capHea_nominal/abs(
    THeaWatSup_nominal - THeaWatRet_nominal)/ctl.cp_default/ctl.rho_default
    "Design HW volume flow rate"
    annotation (Dialog(group="Nominal condition"));
  final parameter Real capCoo_nominal(
    final unit="W")=sum(ctl.capCooHp_nominal)
    "Installed cooling capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Real TChiWatSup_nominal(
    unit="K",
    displayUnit="degC")=280.15
    "Design CHW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real TChiWatRet_nominal(
    unit="K",
    displayUnit="degC")=285.15
    "Design CHW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real VChiWat_flow_nominal(unit="m3/s")=capCoo_nominal/abs(
    TChiWatSup_nominal - TChiWatRet_nominal)/ctl.cp_default/ctl.rho_default
    "Design CHW volume flow rate"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Templates.Plants.Controls.HeatPumps.AirToWater ctl(
    have_heaWat=true,
    have_chiWat=true,
    final have_hrc_select=true,
    have_valHpInlIso=true,
    have_valHpOutIso=true,
    have_pumChiWatPriDed_select=true,
    have_pumHeaWatSec_select=true,
    have_pumPriHdr=false,
    have_pumChiWatSec_select=true,
    have_senVHeaWatPri_select=false,
    have_senVChiWatPri_select=false,
    have_senTHeaWatPriRet_select=false,
    have_senTChiWatPriRet_select=false,
    nHp=3,
    have_senDpHeaWatRemWir=false,
    nSenDpHeaWatRem=1,
    have_senDpChiWatRemWir=false,
    nSenDpChiWatRem=1,
    final THeaWatSup_nominal=THeaWatSup_nominal,
    THeaWatSupSet_min=298.15,
    final VHeaWatSec_flow_nominal=VHeaWat_flow_nominal,
    capHeaHp_nominal=fill(350E3, ctl.nHp),
    dpHeaWatRemSet_max={5E4},
    final TChiWatSup_nominal=TChiWatSup_nominal,
    TChiWatSupSet_max=288.15,
    final VChiWatSec_flow_nominal=VChiWat_flow_nominal,
    capCooHp_nominal=fill(350E3, ctl.nHp),
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.7,
    dpChiWatRemSet_max={5E4},
    staEqu=[1/3,1/3,1/3; 2/3,2/3,2/3; 1,1,1],
    idxEquAlt={1,2,3},
    TChiWatSupHrc_min=277.15,
    THeaWatSupHrc_max=333.15,
    COPHeaHrc_nominal=2.8,
    capCooHrc_min=ctl.capHeaHrc_min*(1 - 1/ctl.COPHeaHrc_nominal),
    capHeaHrc_min=0.3*0.5*sum(ctl.capHeaHp_nominal))
                       "Plant controller"
    annotation (Placement(transformation(extent={{0,-20},{40,52}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratV_flow(
    table=[
      0, 0, 0;
      5, 0, 0;
      6, 1, 0;
      12, 0.2, 0.2;
      15, 0, 1;
      22, 0.1, 0.1;
      24, 0, 0],
    timeScale=3600)
    "Source signal for volume flow rate ratio – Index 1 for HW, 2 for CHW"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTHeaWat(final k=(
        THeaWatRet_nominal - THeaWatSup_nominal)*(if ctl.have_hrc then 0.5
         else 1)) "HW Delta-T"
    annotation (Placement(transformation(extent={{-190,150},{-170,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTChiWat(final k=(
        TChiWatRet_nominal - TChiWatSup_nominal)*(if ctl.have_hrc then 0.5
         else 1)) "CHW Delta-T"
    annotation (Placement(transformation(extent={{-150,130},{-130,150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VHeaWat_flow(
    final k=VHeaWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VChiWat_flow(
    final k=VChiWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Components.Controls.StatusEmulator y1Hp_actual[ctl.nHp]
    "HP status"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Components.Controls.StatusEmulator y1PumHeaWatPri_actual1[ctl.nPumHeaWatPri]
    if ctl.have_heaWat and ctl.have_pumHeaWatPri "Primary HW pump status"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Components.Controls.StatusEmulator y1PumChiWatPri_actual[ctl.nPumChiWatPri]
    if ctl.have_chiWat and ctl.have_pumChiWatPri
    "Primary CHW pump status"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Components.Controls.StatusEmulator y1PumHeaWatSec_actual[ctl.nPumHeaWatSec]
    if ctl.have_heaWat and ctl.have_pumHeaWatSec
    "Secondary HW pump status"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Components.Controls.StatusEmulator y1PumChiWatSec_actual[ctl.nPumChiWatSec]
    if ctl.have_chiWat and ctl.have_pumChiWatSec
    "Secondary CHW pump status"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    amplitude=10,
    freqHz=0.5 / 24 / 3600,
    phase=- 0.43633231299858,
    offset=10 + 273.15)
    "OAT"
    annotation (Placement(transformation(extent={{-190,82},{-170,102}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemHea(
    t=1E-2,
    h=0.5E-2)
    "Return true if heating demand"
    annotation (Placement(transformation(extent={{-110,100},{-90,120}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemCoo(
    t=1E-2,
    h=0.5E-2)
    "Return true if cooling demand"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaHeaWat
    "Generate HW plant request"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaChiWat
    "Generate CHW plant request"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[2](
    each k=5)
    "Use fraction of flow rate as a proxy for plant reset request"
    annotation (Placement(transformation(extent={{-108,30},{-88,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reqResHeaWat
    "Generate HW reset request"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reqResChiWat
    "Generate CHW reset request"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin[1](
    amplitude=0.1 * ctl.dpHeaWatRemSet_max,
    freqHz={4 / 8000},
    each phase=3.1415926535898)
    if ctl.have_heaWat
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-160,-96},{-140,-76}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpHeaWatRem[1] if ctl.have_heaWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpChiWatRem[1]
    if ctl.have_chiWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpHeaWatLoc[1](each
      dpLocSet_max=20E4)
    if ctl.have_heaWat
    "Local HW DP reset"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpChiWatLoc[1](each
      dpLocSet_max=15E4)
    if ctl.have_chiWat
    "Local CHW DP reset"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1[1](
    amplitude=0.1 * ctl.dpChiWatRemSet_max,
    freqHz={3 / 8000},
    each phase=3.1415926535898)
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-160,-136},{-140,-116}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpHeaWatLoc(final k=4)
    if ctl.have_heaWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpChiWatLoc(final k=3)
    if ctl.have_chiWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Components.Controls.StatusEmulator y1Hrc_actual if ctl.have_hrc
    "Sidestream HRC status"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTHeaWatUpsHrc(final k=
        THeaWatRet_nominal - THeaWatSup_nominal)
    "HW Delta-T as measured upstream of HRC"
    annotation (Placement(transformation(extent={{-190,190},{-170,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTChiWatUpsHrc(final k=
        TChiWatRet_nominal - TChiWatSup_nominal)
    "CHW Delta-T as measured upstream of HRC"
    annotation (Placement(transformation(extent={{-150,170},{-130,190}})));
  Buildings.Controls.OBC.CDL.Reals.Add THeaWatRet if ctl.have_heaWat "HWRT"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Reals.Add THeaWatRetUpsHrc if ctl.have_heaWat
    "HWRT upstream of HRC"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Reals.Add TChiWatRet if ctl.have_heaWat "CHWRT"
    annotation (Placement(transformation(extent={{-110,130},{-90,150}})));
  Buildings.Controls.OBC.CDL.Reals.Add TChiWatRetUpsHrc if ctl.have_heaWat
    "CHWRT upstream of HRC"
    annotation (Placement(transformation(extent={{-110,170},{-90,190}})));
equation
  connect(ratV_flow.y[1], VHeaWat_flow.u)
    annotation (Line(points={{-138,-40},{-120,-40},{-120,-20},{-112,-20}},
                                                                      color={0,0,127}));
  connect(ratV_flow.y[2], VChiWat_flow.u)
    annotation (Line(points={{-138,-40},{-82,-40}},color={0,0,127}));
  connect(ctl.y1Hp, y1Hp_actual.y1)
    annotation (Line(points={{42,48},{58,48},{58,60},{68,60}},color={255,0,255}));
  connect(y1Hp_actual.y1_actual, ctl.u1Hp_actual)
    annotation (Line(points={{92,60},{100,60},{100,80},{-4,80},{-4,46.2},{-2,
          46.2}},
      color={255,0,255}));
  connect(ctl.y1PumHeaWatPri, y1PumHeaWatPri_actual1.y1)
    annotation (Line(points={{42,32},{60,32},{60,40},{98,40}},color={255,0,255}));
  connect(ctl.y1PumChiWatPri, y1PumChiWatPri_actual.y1)
    annotation (Line(points={{42,30},{60,30},{60,20},{68,20}},color={255,0,255}));
  connect(ctl.y1PumHeaWatSec, y1PumHeaWatSec_actual.y1)
    annotation (Line(points={{42,26},{60,26},{60,0},{98,0}},  color={255,0,255}));
  connect(ctl.y1PumChiWatSec, y1PumChiWatSec_actual.y1)
    annotation (Line(points={{42,24},{58,24},{58,-20},{68,-20}},
                                                            color={255,0,255}));
  connect(y1PumHeaWatPri_actual1.y1_actual, ctl.u1PumHeaWatPri_actual)
    annotation (Line(points={{122,40},{134,40},{134,82},{-6,82},{-6,44.2},{-2,
          44.2}},
      color={255,0,255}));
  connect(y1PumHeaWatSec_actual.y1_actual, ctl.u1PumHeaWatSec_actual)
    annotation (Line(points={{122,0},{138,0},{138,86},{-10,86},{-10,40.2},{-2,
          40.2}},
      color={255,0,255}));
  connect(y1PumChiWatPri_actual.y1_actual, ctl.u1PumChiWatPri_actual)
    annotation (Line(points={{92,20},{136,20},{136,84},{-8,84},{-8,42.2},{-2,
          42.2}},
      color={255,0,255}));
  connect(y1PumChiWatSec_actual.y1_actual, ctl.u1PumChiWatSec_actual)
    annotation (Line(points={{92,-20},{140,-20},{140,88},{-12,88},{-12,38.2},{
          -2,38.2}},
      color={255,0,255}));
  connect(TOut.y, ctl.TOut)
    annotation (Line(points={{-168,92},{-20,92},{-20,22},{-2,22}},      color={0,0,127}));
  connect(ratV_flow.y[1], isDemHea.u)
    annotation (Line(points={{-138,-40},{-120,-40},{-120,110},{-112,110}},color={0,0,127}));
  connect(ratV_flow.y[2], isDemCoo.u)
    annotation (Line(points={{-138,-40},{-120,-40},{-120,70},{-112,70}},  color={0,0,127}));
  connect(isDemCoo.y, reqPlaChiWat.u)
    annotation (Line(points={{-88,70},{-82,70}},  color={255,0,255}));
  connect(isDemHea.y, reqPlaHeaWat.u)
    annotation (Line(points={{-88,110},{-82,110}},color={255,0,255}));
  connect(reqPlaHeaWat.y, ctl.nReqPlaHeaWat) annotation (Line(points={{-58,110},
          {-40,110},{-40,30},{-2,30}}, color={255,127,0}));
  connect(reqPlaChiWat.y, ctl.nReqPlaChiWat) annotation (Line(points={{-58,70},
          {-40,70},{-40,28},{-2,28}},  color={255,127,0}));
  connect(VHeaWat_flow.y, ctl.VHeaWatPri_flow)
    annotation (Line(points={{-88,-20},{-26,-20},{-26,16},{-2,16}},color={0,0,127}));
  connect(VHeaWat_flow.y, ctl.VHeaWatSec_flow)
    annotation (Line(points={{-88,-20},{-26,-20},{-26,2},{-2,2}},
                                                               color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatPri_flow)
    annotation (Line(points={{-58,-40},{-24,-40},{-24,10},{-2,10}},    color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatSec_flow)
    annotation (Line(points={{-58,-40},{-22,-40},{-22,-6},{-2,-6}},color={0,0,127}));
  connect(ratV_flow.y, gai.u)
    annotation (Line(points={{-138,-40},{-120,-40},{-120,40},{-110,40}},color={0,0,127}));
  connect(gai[1].y, reqResHeaWat.u)
    annotation (Line(points={{-86,40},{-82,40}},color={0,0,127}));
  connect(gai[2].y, reqResChiWat.u)
    annotation (Line(points={{-86,40},{-84,40},{-84,10},{-82,10}},color={0,0,127}));
  connect(reqResHeaWat.y,ctl.nReqResHeaWat)
    annotation (Line(points={{-58,40},{-42,40},{-42,26},{-2,26}},color={255,127,0}));
  connect(reqResChiWat.y,ctl.nReqResChiWat)
    annotation (Line(points={{-58,10},{-40,10},{-40,24},{-2,24}},color={255,127,0}));
  connect(sin.y, dpHeaWatRem.u2)
    annotation (Line(points={{-138,-86},{-82,-86}},color={0,0,127}));
  connect(dpChiWatRem.y, ctl.dpChiWatRem)
    annotation (Line(points={{-58,-120},{-18,-120},{-18,-14},{-2,-14}},
                                                                   color={0,0,127}));
  connect(dpHeaWatRem.y, ctl.dpHeaWatRem)
    annotation (Line(points={{-58,-80},{-20,-80},{-20,-8},{-2,-8}},color={0,0,127}));
  connect(ctl.dpHeaWatRemSet, dpHeaWatRem.u1)
    annotation (Line(points={{42,6},{50,6},{50,-60},{-100,-60},{-100,-74},{-82,
          -74}},
      color={0,0,127}));
  connect(ctl.dpChiWatRemSet, dpChiWatRem.u1)
    annotation (Line(points={{42,4},{48,4},{48,-100},{-90,-100},{-90,-114},{-82,
          -114}},
      color={0,0,127}));
  connect(sin1.y, dpChiWatRem.u2)
    annotation (Line(points={{-138,-126},{-82,-126}},color={0,0,127}));
  connect(dpHeaWatRem[1].y, dpHeaWatLoc.u)
    annotation (Line(points={{-58,-80},{-52,-80},{-52,-140},{-86,-140},{-86,
          -160},{-82,-160}},
      color={0,0,127}));
  connect(ctl.dpHeaWatRemSet, resDpHeaWatLoc.dpRemSet)
    annotation (Line(points={{42,6},{50,6},{50,-60},{-100,-60},{-100,-134},{-42,
          -134}},
      color={0,0,127}));
  connect(dpChiWatRem[1].y, dpChiWatLoc.u)
    annotation (Line(points={{-58,-120},{-54,-120},{-54,-180},{-90,-180},{-90,
          -200},{-82,-200}},
      color={0,0,127}));
  connect(ctl.dpChiWatRemSet, resDpChiWatLoc.dpRemSet)
    annotation (Line(points={{42,4},{47.9167,4},{47.9167,-100},{-90,-100},{-90,
          -174},{-42,-174}},
      color={0,0,127}));
  connect(dpHeaWatRem.y, resDpHeaWatLoc.dpRem)
    annotation (Line(points={{-58,-80},{-52,-80},{-52,-146},{-42,-146}},color={0,0,127}));
  connect(dpChiWatRem.y, resDpChiWatLoc.dpRem)
    annotation (Line(points={{-58,-120},{-54,-120},{-54,-186},{-42,-186}},color={0,0,127}));
  connect(resDpChiWatLoc.dpLocSet, ctl.dpChiWatLocSet)
    annotation (Line(points={{-18.2,-180},{-14,-180},{-14,-16},{-2,-16}},
                                                                     color={0,0,127}));
  connect(dpChiWatLoc.y, ctl.dpChiWatLoc)
    annotation (Line(points={{-58,-200},{-12,-200},{-12,-18},{-2,-18}},
                                                                   color={0,0,127}));
  connect(dpHeaWatLoc.y, ctl.dpHeaWatLoc)
    annotation (Line(points={{-58,-160},{-16,-160},{-16,-12},{-2,-12}},
                                                                   color={0,0,127}));
  connect(resDpHeaWatLoc.dpLocSet, ctl.dpHeaWatLocSet)
    annotation (Line(points={{-18.2,-140},{-10,-140},{-10,-10},{-2,-10}},
                                                                       color={0,0,127}));
  connect(ctl.y1Hrc, y1Hrc_actual.y1) annotation (Line(points={{42,-8},{56,-8},
          {56,-40},{98,-40}},          color={255,0,255}));
  connect(y1Hrc_actual.y1_actual, ctl.u1Hrc_actual) annotation (Line(points={{122,-40},
          {142,-40},{142,90},{-14,90},{-14,36.2},{-2,36.2}},              color
        ={255,0,255}));
  connect(ctl.TChiWatSupSet, ctl.TChiWatSecSup) annotation (Line(points={{42,-4},
          {44,-4},{44,-30},{-32,-30},{-32,0},{-2,0}},   color={0,0,127}));
  connect(ctl.TChiWatSupSet, ctl.TChiWatPriSup) annotation (Line(points={{42,-4},
          {44,-4},{44,-30},{-32,-30},{-32,14},{-2,14}}, color={0,0,127}));
  connect(ctl.THeaWatSupSet, ctl.THeaWatPriSup) annotation (Line(points={{42,-2},
          {46,-2},{46,-32},{-34,-32},{-34,20},{-2,20}}, color={0,0,127}));
  connect(ctl.THeaWatSupSet, ctl.THeaWatSecSup) annotation (Line(points={{42,-2},
          {46,-2},{46,-32},{-34,-32},{-34,8},{-2,8}},   color={0,0,127}));
  connect(ctl.THeaWatSupSet, THeaWatRet.u1) annotation (Line(points={{42,-2},{
          46,-2},{46,176},{-86,176},{-86,166},{-82,166}},
                                                       color={0,0,127}));
  connect(dTHeaWat.y, THeaWatRet.u2) annotation (Line(points={{-168,160},{-86,
          160},{-86,154},{-82,154}},
                                color={0,0,127}));
  connect(ctl.TChiWatSupSet, TChiWatRet.u2) annotation (Line(points={{42,-4},{
          44,-4},{44,126},{-120,126},{-120,134},{-112,134}},
                                                          color={0,0,127}));
  connect(dTChiWat.y, TChiWatRet.u1) annotation (Line(points={{-128,140},{-124,
          140},{-124,146},{-112,146}},
                                  color={0,0,127}));
  connect(dTChiWatUpsHrc.y, TChiWatRetUpsHrc.u1) annotation (Line(points={{-128,
          180},{-124,180},{-124,186},{-112,186}}, color={0,0,127}));
  connect(TChiWatRetUpsHrc.u2, ctl.TChiWatSupSet) annotation (Line(points={{-112,
          174},{-120,174},{-120,126},{44,126},{44,-4},{42,-4}}, color={0,0,127}));
  connect(THeaWatRetUpsHrc.u2, ctl.THeaWatSupSet) annotation (Line(points={{-82,194},
          {-86,194},{-86,176},{46,176},{46,-2},{42,-2}},      color={0,0,127}));
  connect(dTHeaWatUpsHrc.y, THeaWatRetUpsHrc.u1) annotation (Line(points={{-168,
          200},{-100,200},{-100,206},{-82,206}}, color={0,0,127}));
  connect(THeaWatRet.y, ctl.THeaWatPriRet) annotation (Line(points={{-58,160},{
          -26,160},{-26,18},{-2,18}},
                                  color={0,0,127}));
  connect(THeaWatRet.y, ctl.THeaWatSecRet) annotation (Line(points={{-58,160},{
          -26,160},{-26,6},{-2,6}},
                                  color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatSecRet) annotation (Line(points={{-88,140},{
          -28,140},{-28,-2},{-2,-2}},
                                  color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatPriRet) annotation (Line(points={{-88,140},{
          -28,140},{-28,20},{-2,20},{-2,12}},
                                          color={0,0,127}));
  connect(TChiWatRetUpsHrc.y, ctl.TChiWatRetUpsHrc) annotation (Line(points={{-88,180},
          {-30,180},{-30,-4},{-2,-4}},      color={0,0,127}));
  connect(THeaWatRetUpsHrc.y, ctl.THeaWatRetUpsHrc) annotation (Line(points={{-58,200},
          {-22,200},{-22,4},{-2,4}},        color={0,0,127}));
  annotation (
    __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Validation/AirToWater.mos"
    "Simulate and plot"),
    experiment(StopTime=86400.0, Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-200,-240},{200,240}})),
    Documentation(revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.AirToWater\">
Buildings.Templates.Plants.Controls.HeatPumps.AirToWater</a>
in a configuration with three equally sized lead/lag alternate
heat pumps.
</p>
<p>
Simulating this model shows how the controller responds to a varying load by 
</p>
<ul>
<li>
staging or unstaging the AWHPs and associated primary pumps,
</li>
<li>
rotating lead/lag alternate equipment to ensure even wear,
</li>
<li>
resetting the supply temperature and remote differential pressure 
in both the CHW and HW loops based on the valve position,
</li>
<li>
staging the secondary pumps.
</li>
</ul>
</html>"));
end AirToWater;
