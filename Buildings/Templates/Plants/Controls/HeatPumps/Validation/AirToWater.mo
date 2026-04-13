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
  parameter Real VHeaWat_flow_nominal(
    unit="m3/s")=capHea_nominal / abs(THeaWatSup_nominal - THeaWatRet_nominal) /
    ctl.cp_default / ctl.rho_default
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
  parameter Real VChiWat_flow_nominal(
    unit="m3/s")=capCoo_nominal / abs(TChiWatSup_nominal - TChiWatRet_nominal) /
    ctl.cp_default / ctl.rho_default
    "Design CHW volume flow rate"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Templates.Plants.Controls.HeatPumps.AirToWater ctl(
    have_heaWat=true,
    have_chiWat=true,
    have_hrc_select=true,
    have_valHpInlIso=true,
    have_valHpOutIso=true,
    have_pumChiWatPriDed_select=true,
    have_pumPriHdr=false,
    is_priOnl=false,
    have_pumHeaWatPriVar_select=false,
    have_pumChiWatPriVar_select=false,
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
    VHeaWatHp_flow_nominal=1.1*fill(VHeaWat_flow_nominal/ctl.nHp, ctl.nHp),
    VHeaWatHp_flow_min=0.6*ctl.VHeaWatHp_flow_nominal,
    final VHeaWatSec_flow_nominal=VHeaWat_flow_nominal,
    capHeaHp_nominal=fill(350E3, ctl.nHp),
    dpHeaWatRemSet_max={5E4},
    final TChiWatSup_nominal=TChiWatSup_nominal,
    TChiWatSupSet_max=288.15,
    VChiWatHp_flow_nominal=1.1*fill(VChiWat_flow_nominal/ctl.nHp, ctl.nHp),
    VChiWatHp_flow_min=0.6*ctl.VChiWatHp_flow_nominal,
    final VChiWatSec_flow_nominal=VChiWat_flow_nominal,
    capCooHp_nominal=fill(350E3, ctl.nHp),
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.7,
    dpChiWatRemSet_max={5E4},
    staEqu=[1/3,1/3,1/3; 2/3,2/3,2/3; 1,1,1],
    idxEquAlt={1, 2, 3},
    TChiWatSupHrc_min=277.15,
    THeaWatSupHrc_max=333.15,
    COPHeaHrc_nominal=2.8,
    capCooHrc_min=ctl.capHeaHrc_min *(1 - 1 / ctl.COPHeaHrc_nominal),
    capHeaHrc_min=0.3 * 0.5 * sum(ctl.capHeaHp_nominal))
    "Plant controller-1"
    annotation (Placement(transformation(extent={{-70,-22},{-30,50}})));

  Buildings.Templates.Plants.Controls.HeatPumps.AirToWater ctl1(
    have_heaWat=true,
    have_chiWat=true,
    have_hrc_select=false,
    have_valHpInlIso=false,
    have_valHpOutIso=false,
    have_pumChiWatPriDed_select=false,
    have_pumPriHdr=false,
    is_priOnl=false,
    have_pumHeaWatPriVar_select=false,
    have_pumChiWatPriVar_select=false,
    have_senVHeaWatPri_select=false,
    have_senVChiWatPri_select=false,
    have_senTHeaWatPriRet_select=false,
    have_senTChiWatPriRet_select=false,
    nHp=2,
    have_HpShc=true,
    nPumChiWatPri=ctl1.nHp,
    have_senDpHeaWatRemWir=false,
    nSenDpHeaWatRem=1,
    have_senDpChiWatRemWir=false,
    nSenDpChiWatRem=1,
    final THeaWatSup_nominal=THeaWatSup_nominal,
    THeaWatSupSet_min=298.15,
    VHeaWatHp_flow_nominal=1.1*fill(VHeaWat_flow_nominal/ctl.nHp, ctl.nHp),
    VHeaWatHp_flow_min=0.6*ctl.VHeaWatHp_flow_nominal,
    final VHeaWatSec_flow_nominal=VHeaWat_flow_nominal,
    capHeaHp_nominal=fill(350E3, ctl.nHp),
    dpHeaWatRemSet_max={5E4},
    final TChiWatSup_nominal=TChiWatSup_nominal,
    TChiWatSupSet_max=288.15,
    VChiWatHp_flow_nominal=1.1*fill(VChiWat_flow_nominal/ctl.nHp, ctl.nHp),
    VChiWatHp_flow_min=0.6*ctl.VChiWatHp_flow_nominal,
    final VChiWatSec_flow_nominal=VChiWat_flow_nominal,
    capCooHp_nominal=fill(350E3, ctl.nHp),
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.7,
    dpChiWatRemSet_max={5E4},
    idxEquAlt={1,2},
    TChiWatSupHrc_min=277.15,
    THeaWatSupHrc_max=333.15,
    COPHeaHrc_nominal=2.8,
    capCooHrc_min=ctl.capHeaHrc_min *(1 - 1 / ctl.COPHeaHrc_nominal),
    capHeaHrc_min=0.3 * 0.5 * sum(ctl.capHeaHp_nominal),
    staEqu=ctl1.staEquSinMod,
    staEquDouMod=[0,0,1; 1/2,1/2,1; 1,1,1],
    staEquSinMod=[1/2,1/2,0; 1,1,0; 1,1,1])
    "Plant controller-2"
    annotation (Placement(transformation(extent={{148,-22},{188,50}})));

protected
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
    annotation (Placement(transformation(extent={{-230,-50},{-210,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTHeaWat(
    final k=(THeaWatRet_nominal - THeaWatSup_nominal) *(if ctl.have_hrc then 0.5
      else 1))
    "HW Delta-T"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTChiWat(
    final k=(TChiWatRet_nominal - TChiWatSup_nominal) *(if ctl.have_hrc then 0.5
      else 1))
    "CHW Delta-T"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VHeaWat_flow(
    final k=VHeaWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VChiWat_flow(
    final k=VChiWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Components.Controls.StatusEmulator y1Hp_actual[ctl.nHp]
    "HP status"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Components.Controls.StatusEmulator y1PumHeaWatPri_actual1[ctl.nPumHeaWatPri]
    if ctl.have_heaWat and ctl.have_pumHeaWatPri
    "Primary HW pump status"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Components.Controls.StatusEmulator y1PumChiWatPri_actual[ctl.nPumChiWatPri]
    if ctl.have_chiWat and ctl.have_pumChiWatPri
    "Primary CHW pump status"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Components.Controls.StatusEmulator y1PumHeaWatSec_actual[ctl.nPumHeaWatSec]
    if ctl.have_heaWat and ctl.have_pumHeaWatSec
    "Secondary HW pump status"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Components.Controls.StatusEmulator y1PumChiWatSec_actual[ctl.nPumChiWatSec]
    if ctl.have_chiWat and ctl.have_pumChiWatSec
    "Secondary CHW pump status"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    amplitude=10,
    freqHz=0.5 / 24 / 3600,
    phase=- 0.43633231299858,
    offset=10 + 273.15)
    "OAT"
    annotation (Placement(transformation(extent={{-260,82},{-240,102}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemHea(
    t=1E-2,
    h=0.5E-2)
    "Return true if heating demand"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemCoo(
    t=1E-2,
    h=0.5E-2)
    "Return true if cooling demand"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaHeaWat
    "Generate HW plant request"
    annotation (Placement(transformation(extent={{-150,100},{-130,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaChiWat
    "Generate CHW plant request"
    annotation (Placement(transformation(extent={{-150,60},{-130,80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[2](
    each k=5)
    "Use fraction of flow rate as a proxy for plant reset request"
    annotation (Placement(transformation(extent={{-178,30},{-158,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reqResHeaWat
    "Generate HW reset request"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reqResChiWat
    "Generate CHW reset request"
    annotation (Placement(transformation(extent={{-150,0},{-130,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin[1](
    amplitude=0.1 * ctl.dpHeaWatRemSet_max,
    freqHz={4 / 8000},
    each phase=3.1415926535898)
    if ctl.have_heaWat
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-230,-96},{-210,-76}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpHeaWatRem[1]
    if ctl.have_heaWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpChiWatRem[1]
    if ctl.have_chiWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpHeaWatLoc[1](
    each dpLocSet_max=20E4)
    if ctl.have_heaWat
    "Local HW DP reset"
    annotation (Placement(transformation(extent={{-110,-150},{-90,-130}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpChiWatLoc[1](
    each dpLocSet_max=15E4)
    if ctl.have_chiWat
    "Local CHW DP reset"
    annotation (Placement(transformation(extent={{-110,-190},{-90,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1[1](
    amplitude=0.1 * ctl.dpChiWatRemSet_max,
    freqHz={3 / 8000},
    each phase=3.1415926535898)
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-230,-136},{-210,-116}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpHeaWatLoc(
    final k=4)
    if ctl.have_heaWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-150,-170},{-130,-150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpChiWatLoc(
    final k=3)
    if ctl.have_chiWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Components.Controls.StatusEmulator y1Hrc_actual
    if ctl.have_hrc
    "Sidestream HRC status"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTHeaWatUpsHrc(
    final k=THeaWatRet_nominal - THeaWatSup_nominal)
    "HW Delta-T as measured upstream of HRC"
    annotation (Placement(transformation(extent={{-260,190},{-240,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTChiWatUpsHrc(
    final k=TChiWatRet_nominal - TChiWatSup_nominal)
    "CHW Delta-T as measured upstream of HRC"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));
  Buildings.Controls.OBC.CDL.Reals.Add THeaWatRet
    if ctl.have_heaWat
    "HWRT"
    annotation (Placement(transformation(extent={{-150,150},{-130,170}})));
  Buildings.Controls.OBC.CDL.Reals.Add THeaWatRetUpsHrc
    if ctl.have_heaWat
    "HWRT upstream of HRC"
    annotation (Placement(transformation(extent={{-150,190},{-130,210}})));
  Buildings.Controls.OBC.CDL.Reals.Add TChiWatRet
    if ctl.have_chiWat
    "CHWRT"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Reals.Add TChiWatRetUpsHrc
    if ctl.have_chiWat
    "CHWRT upstream of HRC"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));

  Buildings.Controls.OBC.CDL.Reals.Add THeaWatRet1
    if ctl.have_heaWat
    "HWRT"
    annotation (Placement(transformation(extent={{80,200},{100,220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTHeaWat1(final k=(
        THeaWatRet_nominal - THeaWatSup_nominal)*(if ctl.have_hrc then 0.5
         else 1))
    "HW Delta-T"
    annotation (Placement(transformation(extent={{10,200},{30,220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTChiWat1(final k=(
        TChiWatRet_nominal - TChiWatSup_nominal)*(if ctl.have_hrc then 0.5
         else 1))
    "CHW Delta-T"
    annotation (Placement(transformation(extent={{10,160},{30,180}})));
  Buildings.Controls.OBC.CDL.Reals.Add TChiWatRet1
    if ctl.have_chiWat
    "CHWRT"
    annotation (Placement(transformation(extent={{50,160},{70,180}})));
  Components.Controls.StatusEmulator y1Hp_actual1[ctl1.nHpTot] "HP status"
    annotation (Placement(transformation(extent={{210,50},{230,70}})));
  Components.Controls.StatusEmulator y1PumHeaWatPri_actual2[ctl1.nPumHeaWatPri]
    if ctl.have_heaWat and ctl.have_pumHeaWatPri "Primary HW pump status"
    annotation (Placement(transformation(extent={{240,30},{260,50}})));
  Components.Controls.StatusEmulator y1PumChiWatPri_actual1[ctl1.nPumChiWatPri]
    if ctl.have_chiWat and ctl.have_pumChiWatPri "Primary CHW pump status"
    annotation (Placement(transformation(extent={{210,10},{230,30}})));
  Components.Controls.StatusEmulator y1PumHeaWatSec_actual1[ctl1.nPumHeaWatSec]
    if ctl.have_heaWat and ctl.have_pumHeaWatSec "Secondary HW pump status"
    annotation (Placement(transformation(extent={{240,-10},{260,10}})));
  Components.Controls.StatusEmulator y1PumChiWatSec_actual1[ctl1.nPumChiWatSec]
    if ctl.have_chiWat and ctl.have_pumChiWatSec "Secondary CHW pump status"
    annotation (Placement(transformation(extent={{210,-30},{230,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin2
                                                  [1](
    amplitude=0.1*ctl.dpHeaWatRemSet_max,
    freqHz={4/8000},
    each phase=3.1415926535898)
    if ctl.have_heaWat
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{10,-106},{30,-86}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpHeaWatRem1
                                                  [1]
    if ctl.have_heaWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{90,-100},{110,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpChiWatRem1
                                                  [1]
    if ctl.have_chiWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{90,-140},{110,-120}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpHeaWatLoc1
                                                             [1](each
      dpLocSet_max=20E4)
    if ctl.have_heaWat
    "Local HW DP reset"
    annotation (Placement(transformation(extent={{130,-160},{150,-140}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpChiWatLoc1
                                                             [1](each
      dpLocSet_max=15E4)
    if ctl.have_chiWat
    "Local CHW DP reset"
    annotation (Placement(transformation(extent={{130,-200},{150,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin3[1](
    amplitude=0.1*ctl.dpChiWatRemSet_max,
    freqHz={3/8000},
    each phase=3.1415926535898)
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{10,-146},{30,-126}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpHeaWatLoc1(final k=4)
    if ctl.have_heaWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{90,-180},{110,-160}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpChiWatLoc1(final k=3)
    if ctl.have_chiWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{90,-222},{110,-202}})));
  Components.Controls.StatusEmulator y1PumChiWatPriFouPip_actual1
    if ctl.have_chiWat and ctl.have_pumChiWatPri "Primary CHW pump status"
    annotation (Placement(transformation(extent={{220,-90},{240,-70}})));
  Components.Controls.StatusEmulator y1PumHeaWatPriFouPip_actual1
    if ctl.have_chiWat and ctl.have_pumChiWatPri "Primary HW pump status"
    annotation (Placement(transformation(extent={{220,-60},{240,-40}})));
equation
  connect(ratV_flow.y[1], VHeaWat_flow.u)
    annotation (Line(points={{-208,-40},{-190,-40},{-190,-20},{-182,-20}},color={0,0,127}));
  connect(ratV_flow.y[2], VChiWat_flow.u)
    annotation (Line(points={{-208,-40},{-152,-40}},
                                                   color={0,0,127}));
  connect(ctl.y1Hp, y1Hp_actual.y1)
    annotation (Line(points={{-28,53},{-12,53},{-12,60},{-2,60}},
                                                              color={255,0,255}));
  connect(y1Hp_actual.y1_actual, ctl.u1Hp_actual)
    annotation (Line(points={{22,60},{30,60},{30,80},{-74,80},{-74,46},{-72,46}},
      color={255,0,255}));
  connect(ctl.y1PumHeaWatPri, y1PumHeaWatPri_actual1.y1)
    annotation (Line(points={{-28,37},{-10,37},{-10,40},{28,40}},
                                                              color={255,0,255}));
  connect(ctl.y1PumChiWatPri, y1PumChiWatPri_actual.y1)
    annotation (Line(points={{-28,35},{-10,35},{-10,20},{-2,20}},
                                                              color={255,0,255}));
  connect(ctl.y1PumHeaWatSec, y1PumHeaWatSec_actual.y1)
    annotation (Line(points={{-28,31},{-10,31},{-10,0},{28,0}},
                                                            color={255,0,255}));
  connect(ctl.y1PumChiWatSec, y1PumChiWatSec_actual.y1)
    annotation (Line(points={{-28,29},{-12,29},{-12,-20},{-2,-20}},
                                                                color={255,0,255}));
  connect(y1PumHeaWatPri_actual1.y1_actual, ctl.u1PumHeaWatPri_actual)
    annotation (Line(points={{52,40},{64,40},{64,82},{-76,82},{-76,42},{-72,42}},
      color={255,0,255}));
  connect(y1PumHeaWatSec_actual.y1_actual, ctl.u1PumHeaWatSec_actual)
    annotation (Line(points={{52,0},{68,0},{68,86},{-80,86},{-80,34},{-72,34}},
      color={255,0,255}));
  connect(y1PumChiWatPri_actual.y1_actual, ctl.u1PumChiWatPri_actual)
    annotation (Line(points={{22,20},{66,20},{66,84},{-78,84},{-78,40},{-72,40}},
      color={255,0,255}));
  connect(y1PumChiWatSec_actual.y1_actual, ctl.u1PumChiWatSec_actual)
    annotation (Line(points={{22,-20},{70,-20},{70,88},{-82,88},{-82,32},{-72,32}},
      color={255,0,255}));
  connect(TOut.y, ctl.TOut)
    annotation (Line(points={{-238,92},{-90,92},{-90,15.8},{-72,15.8}},
                                                                  color={0,0,127}));
  connect(ratV_flow.y[1], isDemHea.u)
    annotation (Line(points={{-208,-40},{-190,-40},{-190,110},{-182,110}},color={0,0,127}));
  connect(ratV_flow.y[2], isDemCoo.u)
    annotation (Line(points={{-208,-40},{-190,-40},{-190,70},{-182,70}},color={0,0,127}));
  connect(isDemCoo.y, reqPlaChiWat.u)
    annotation (Line(points={{-158,70},{-152,70}},
                                                color={255,0,255}));
  connect(isDemHea.y, reqPlaHeaWat.u)
    annotation (Line(points={{-158,110},{-152,110}},
                                                  color={255,0,255}));
  connect(reqPlaHeaWat.y, ctl.nReqPlaHeaWat)
    annotation (Line(points={{-128,110},{-106,110},{-106,23.8},{-72,23.8}},
                                                                   color={255,127,0}));
  connect(reqPlaChiWat.y, ctl.nReqPlaChiWat)
    annotation (Line(points={{-128,70},{-110,70},{-110,21.8},{-72,21.8}},
                                                                 color={255,127,0}));
  connect(VHeaWat_flow.y, ctl.VHeaWatPri_flow)
    annotation (Line(points={{-158,-20},{-96,-20},{-96,9.8},{-72,9.8}},
                                                                   color={0,0,127}));
  connect(VHeaWat_flow.y, ctl.VHeaWatSec_flow)
    annotation (Line(points={{-158,-20},{-96,-20},{-96,-4.2},{-72,-4.2}},
                                                                 color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatPri_flow)
    annotation (Line(points={{-128,-40},{-94,-40},{-94,3.8},{-72,3.8}},
                                                                 color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatSec_flow)
    annotation (Line(points={{-128,-40},{-94,-40},{-94,-12.2},{-72,-12.2}},
                                                                   color={0,0,127}));
  connect(ratV_flow.y, gai.u)
    annotation (Line(points={{-208,-40},{-190,-40},{-190,40},{-180,40}},color={0,0,127}));
  connect(gai[1].y, reqResHeaWat.u)
    annotation (Line(points={{-156,40},{-152,40}},
                                                color={0,0,127}));
  connect(gai[2].y, reqResChiWat.u)
    annotation (Line(points={{-156,40},{-154,40},{-154,10},{-152,10}},
                                                                  color={0,0,127}));
  connect(reqResHeaWat.y, ctl.nReqResHeaWat)
    annotation (Line(points={{-128,40},{-88,40},{-88,19.8},{-72,19.8}},
                                                                 color={255,127,0}));
  connect(reqResChiWat.y, ctl.nReqResChiWat)
    annotation (Line(points={{-128,10},{-110,10},{-110,17.8},{-72,17.8}},
                                                                 color={255,127,0}));
  connect(sin.y, dpHeaWatRem.u2)
    annotation (Line(points={{-208,-86},{-152,-86}},
                                                   color={0,0,127}));
  connect(dpChiWatRem.y, ctl.dpChiWatRem)
    annotation (Line(points={{-128,-120},{-88,-120},{-88,-20.2},{-72,-20.2}},
                                                                       color={0,0,127}));
  connect(dpHeaWatRem.y, ctl.dpHeaWatRem)
    annotation (Line(points={{-128,-80},{-90,-80},{-90,-14.2},{-72,-14.2}},
                                                                     color={0,0,127}));
  connect(ctl.dpHeaWatRemSet, dpHeaWatRem.u1)
    annotation (Line(points={{-28,5},{-20,5},{-20,-60},{-170,-60},{-170,-74},{-152,
          -74}},
      color={0,0,127}));
  connect(ctl.dpChiWatRemSet, dpChiWatRem.u1)
    annotation (Line(points={{-28,3},{-22,3},{-22,-100},{-160,-100},{-160,-114},
          {-152,-114}},
      color={0,0,127}));
  connect(sin1.y, dpChiWatRem.u2)
    annotation (Line(points={{-208,-126},{-152,-126}},
                                                     color={0,0,127}));
  connect(dpHeaWatRem[1].y, dpHeaWatLoc.u)
    annotation (Line(points={{-128,-80},{-122,-80},{-122,-140},{-156,-140},{-156,
          -160},{-152,-160}},
      color={0,0,127}));
  connect(ctl.dpHeaWatRemSet, resDpHeaWatLoc.dpRemSet)
    annotation (Line(points={{-28,5},{-20,5},{-20,-60},{-170,-60},{-170,-134},{-112,
          -134}},
      color={0,0,127}));
  connect(dpChiWatRem[1].y, dpChiWatLoc.u)
    annotation (Line(points={{-128,-120},{-124,-120},{-124,-180},{-160,-180},{-160,
          -200},{-152,-200}},
      color={0,0,127}));
  connect(ctl.dpChiWatRemSet, resDpChiWatLoc.dpRemSet)
    annotation (Line(points={{-28,3},{-22.0833,3},{-22.0833,-100},{-160,-100},{-160,
          -174},{-112,-174}},
      color={0,0,127}));
  connect(dpHeaWatRem.y, resDpHeaWatLoc.dpRem)
    annotation (Line(points={{-128,-80},{-122,-80},{-122,-146},{-112,-146}},
                                                                        color={0,0,127}));
  connect(dpChiWatRem.y, resDpChiWatLoc.dpRem)
    annotation (Line(points={{-128,-120},{-124,-120},{-124,-186},{-112,-186}},
                                                                          color={0,0,127}));
  connect(resDpChiWatLoc.dpLocSet, ctl.dpChiWatLocSet)
    annotation (Line(points={{-88.2,-180},{-84,-180},{-84,-22.2},{-72,-22.2}},
                                                                         color={0,0,127}));
  connect(dpChiWatLoc.y, ctl.dpChiWatLoc)
    annotation (Line(points={{-128,-200},{-82,-200},{-82,-24.2},{-72,-24.2}},
                                                                       color={0,0,127}));
  connect(dpHeaWatLoc.y, ctl.dpHeaWatLoc)
    annotation (Line(points={{-128,-160},{-86,-160},{-86,-18.2},{-72,-18.2}},
                                                                       color={0,0,127}));
  connect(resDpHeaWatLoc.dpLocSet, ctl.dpHeaWatLocSet)
    annotation (Line(points={{-88.2,-140},{-80,-140},{-80,-16.2},{-72,-16.2}},
                                                                         color={0,0,127}));
  connect(ctl.y1Hrc, y1Hrc_actual.y1)
    annotation (Line(points={{-28,-7},{-14,-7},{-14,-40},{28,-40}},
                                                                  color={255,0,255}));
  connect(y1Hrc_actual.y1_actual, ctl.u1Hrc_actual)
    annotation (Line(points={{52,-40},{72,-40},{72,90},{-84,90},{-84,30},{-72,30}},
      color={255,0,255}));
  connect(ctl.TChiWatSupSet, ctl.TChiWatSecSup)
    annotation (Line(points={{-28,-3},{-26,-3},{-26,-30},{-102,-30},{-102,-6.2},
          {-72,-6.2}},
      color={0,0,127}));
  connect(ctl.TChiWatSupSet, ctl.TChiWatPriSup)
    annotation (Line(points={{-28,-3},{-26,-3},{-26,-30},{-102,-30},{-102,7.8},{
          -72,7.8}},
      color={0,0,127}));
  connect(ctl.THeaWatSupSet, ctl.THeaWatPriSup)
    annotation (Line(points={{-28,-1},{-24,-1},{-24,-32},{-104,-32},{-104,13.8},
          {-72,13.8}},
      color={0,0,127}));
  connect(ctl.THeaWatSupSet, ctl.THeaWatSecSup)
    annotation (Line(points={{-28,-1},{-24,-1},{-24,-32},{-104,-32},{-104,1.8},{
          -72,1.8}},
      color={0,0,127}));
  connect(ctl.THeaWatSupSet, THeaWatRet.u1)
    annotation (Line(points={{-28,-1},{-24,-1},{-24,176},{-156,176},{-156,166},{
          -152,166}},
      color={0,0,127}));
  connect(dTHeaWat.y, THeaWatRet.u2)
    annotation (Line(points={{-238,160},{-156,160},{-156,154},{-152,154}},
                                                                       color={0,0,127}));
  connect(ctl.TChiWatSupSet, TChiWatRet.u2)
    annotation (Line(points={{-28,-3},{-26,-3},{-26,126},{-190,126},{-190,134},{
          -182,134}},
      color={0,0,127}));
  connect(dTChiWat.y, TChiWatRet.u1)
    annotation (Line(points={{-198,140},{-194,140},{-194,146},{-182,146}},color={0,0,127}));
  connect(dTChiWatUpsHrc.y, TChiWatRetUpsHrc.u1)
    annotation (Line(points={{-198,180},{-194,180},{-194,186},{-182,186}},color={0,0,127}));
  connect(TChiWatRetUpsHrc.u2, ctl.TChiWatSupSet)
    annotation (Line(points={{-182,174},{-190,174},{-190,126},{-26,126},{-26,-3},
          {-28,-3}},
      color={0,0,127}));
  connect(THeaWatRetUpsHrc.u2, ctl.THeaWatSupSet)
    annotation (Line(points={{-152,194},{-156,194},{-156,176},{-24,176},{-24,-1},
          {-28,-1}},
      color={0,0,127}));
  connect(dTHeaWatUpsHrc.y, THeaWatRetUpsHrc.u1)
    annotation (Line(points={{-238,200},{-170,200},{-170,206},{-152,206}},
                                                                         color={0,0,127}));
  connect(THeaWatRet.y, ctl.THeaWatPriRet)
    annotation (Line(points={{-128,160},{-96,160},{-96,11.8},{-72,11.8}},
                                                                   color={0,0,127}));
  connect(THeaWatRet.y, ctl.THeaWatSecRet)
    annotation (Line(points={{-128,160},{-96,160},{-96,-0.2},{-72,-0.2}},
                                                                 color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatSecRet)
    annotation (Line(points={{-158,140},{-98,140},{-98,-8.2},{-72,-8.2}},
                                                                   color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatPriRet)
    annotation (Line(points={{-158,140},{-98,140},{-98,5.8},{-72,5.8}},
                                                                   color={0,0,127}));
  connect(TChiWatRetUpsHrc.y, ctl.TChiWatRetUpsHrc)
    annotation (Line(points={{-158,180},{-100,180},{-100,-10.2},{-72,-10.2}},
                                                                   color={0,0,127}));
  connect(THeaWatRetUpsHrc.y, ctl.THeaWatRetUpsHrc)
    annotation (Line(points={{-128,200},{-92,200},{-92,-2.2},{-72,-2.2}},
                                                                 color={0,0,127}));
  connect(dTHeaWat1.y, THeaWatRet1.u2)
    annotation (Line(points={{32,210},{68,210},{68,204},{78,204}},
                                                             color={0,0,127}));
  connect(dTChiWat1.y, TChiWatRet1.u1) annotation (Line(points={{32,170},{32,176},
          {48,176}},            color={0,0,127}));
  connect(ctl1.y1PumHeaWatPri, y1PumHeaWatPri_actual2.y1) annotation (Line(
        points={{190,37},{204,37},{204,40},{238,40}},         color={255,0,255}));
  connect(ctl1.y1PumChiWatPri, y1PumChiWatPri_actual1.y1) annotation (Line(
        points={{190,35},{206,35},{206,20},{208,20}},         color={255,0,255}));
  connect(ctl1.y1PumHeaWatSec, y1PumHeaWatSec_actual1.y1) annotation (Line(
        points={{190,31},{204,31},{204,0},{238,0}},         color={255,0,255}));
  connect(ctl1.y1PumChiWatSec, y1PumChiWatSec_actual1.y1) annotation (Line(
        points={{190,29},{192,29},{192,-20},{208,-20}},     color={255,0,255}));
  connect(y1PumHeaWatPri_actual2.y1_actual, ctl1.u1PumHeaWatPri_actual)
    annotation (Line(points={{262,40},{270,40},{270,80},{136,80},{136,42},{146,42}},
                   color={255,0,255}));
  connect(y1PumChiWatPri_actual1.y1_actual, ctl1.u1PumChiWatPri_actual)
    annotation (Line(points={{232,20},{272,20},{272,82},{134,82},{134,40},{146,40}},
                   color={255,0,255}));
  connect(y1PumHeaWatSec_actual1.y1_actual, ctl1.u1PumHeaWatSec_actual)
    annotation (Line(points={{262,0},{274,0},{274,86},{132,86},{132,34},{146,34}},
                   color={255,0,255}));
  connect(y1PumChiWatSec_actual1.y1_actual, ctl1.u1PumChiWatSec_actual)
    annotation (Line(points={{232,-20},{276,-20},{276,90},{130,90},{130,32},{146,
          32}},            color={255,0,255}));
  connect(reqPlaHeaWat.y, ctl1.nReqPlaHeaWat) annotation (Line(points={{-128,110},
          {-106,110},{-106,142},{120,142},{120,23.8},{146,23.8}},
        color={255,127,0}));
  connect(reqPlaChiWat.y, ctl1.nReqPlaChiWat) annotation (Line(points={{-128,70},
          {-94,70},{-94,128},{74,128},{74,21.8},{146,21.8}},       color={255,127,
          0}));
  connect(reqResHeaWat.y, ctl1.nReqResHeaWat) annotation (Line(points={{-128,40},
          {-88,40},{-88,96},{88,96},{88,20},{146,20},{146,19.8}},
                                                              color={255,127,0}));
  connect(reqResChiWat.y, ctl1.nReqResChiWat) annotation (Line(points={{-128,10},
          {-110,10},{-110,-52},{110,-52},{110,17.8},{146,17.8}},   color={255,127,
          0}));
  connect(ctl1.THeaWatSupSet, ctl1.THeaWatPriSup) annotation (Line(points={{190,-1},
          {194,-1},{194,-28},{140,-28},{140,13.8},{146,13.8}},         color={0,
          0,127}));
  connect(ctl1.TChiWatSupSet, ctl1.TChiWatPriSup) annotation (Line(points={{190,-3},
          {196,-3},{196,-30},{138,-30},{138,7.8},{146,7.8}},
        color={0,0,127}));
  connect(ctl1.THeaWatSupSet, ctl1.THeaWatSecSup) annotation (Line(points={{190,-1},
          {194,-1},{194,-28},{140,-28},{140,1.8},{146,1.8}},         color={0,0,
          127}));
  connect(TOut.y, ctl1.TOut) annotation (Line(points={{-238,92},{98,92},{98,15.8},
          {146,15.8}},     color={0,0,127}));
  connect(ctl1.THeaWatSupSet, THeaWatRet1.u1) annotation (Line(points={{190,-1},
          {196,-1},{196,8},{200,8},{200,64},{124,64},{124,232},{72,232},{72,216},
          {78,216}},            color={0,0,127}));
  connect(ctl1.TChiWatSupSet, TChiWatRet1.u2) annotation (Line(points={{190,-3},
          {196,-3},{196,-32},{94,-32},{94,132},{40,132},{40,164},{48,164}},
                                     color={0,0,127}));
  connect(THeaWatRet1.y, ctl1.THeaWatPriRet) annotation (Line(points={{102,210},
          {112,210},{112,12},{146,12},{146,11.8}},
                                                color={0,0,127}));
  connect(TChiWatRet1.y, ctl1.TChiWatPriRet) annotation (Line(points={{72,170},{
          100,170},{100,5.8},{146,5.8}},                   color={0,0,127}));
  connect(VHeaWat_flow.y, ctl1.VHeaWatSec_flow) annotation (Line(points={{-158,-20},
          {-4,-20},{-4,-4.2},{146,-4.2}},   color={0,0,127}));
  connect(ctl1.TChiWatSupSet, ctl1.TChiWatSecSup) annotation (Line(points={{190,-3},
          {196,-3},{196,-30},{138,-30},{138,-6.2},{146,-6.2}},
        color={0,0,127}));
  connect(VChiWat_flow.y, ctl1.VChiWatSec_flow) annotation (Line(points={{-128,-40},
          {-94,-40},{-94,-58},{114,-58},{114,-12.2},{146,-12.2}},
                                              color={0,0,127}));
  connect(sin2.y, dpHeaWatRem1.u2)
    annotation (Line(points={{32,-96},{88,-96}},     color={0,0,127}));
  connect(sin3.y, dpChiWatRem1.u2)
    annotation (Line(points={{32,-136},{88,-136}},   color={0,0,127}));
  connect(dpHeaWatRem1[1].y, dpHeaWatLoc1.u) annotation (Line(points={{112,-90},
          {126,-90},{126,-132},{122,-132},{122,-152},{82,-152},{82,-170},{88,-170}},
                                                                   color={0,0,127}));
  connect(ctl1.dpHeaWatRemSet, resDpHeaWatLoc1.dpRemSet) annotation (Line(points={{190,5},
          {202,5},{202,-168},{128,-168},{128,-144}},
                       color={0,0,127}));
  connect(dpChiWatRem1[1].y, dpChiWatLoc1.u) annotation (Line(points={{112,-130},
          {118,-130},{118,-164},{122,-164},{122,-196},{82,-196},{82,-212},{88,-212}},
                                                                   color={0,0,127}));
  connect(ctl1.dpChiWatRemSet, resDpChiWatLoc1.dpRemSet) annotation (Line(points={{190,3},
          {190,-36},{182,-36},{182,-208},{122,-208},{122,-200},{118,-200},{118,-184},
          {128,-184}},                                                 color={0,
          0,127}));
  connect(dpHeaWatRem1.y, resDpHeaWatLoc1.dpRem) annotation (Line(points={{112,-90},
          {126,-90},{126,-132},{122,-132},{122,-156},{128,-156}},
                                             color={0,0,127}));
  connect(dpChiWatRem1.y, resDpChiWatLoc1.dpRem) annotation (Line(points={{112,-130},
          {118,-130},{118,-164},{122,-164},{122,-196},{128,-196}},
                                             color={0,0,127}));
  connect(resDpChiWatLoc1.dpLocSet, ctl1.dpChiWatLocSet) annotation (Line(points={{151.8,
          -190},{151.8,-192},{166,-192},{166,-132},{130,-132},{130,-44},{126,-44},
          {126,-22.2},{146,-22.2}},                    color={0,0,127}));
  connect(dpChiWatLoc1.y, ctl1.dpChiWatLoc) annotation (Line(points={{112,-212},
          {172,-212},{172,-56},{118,-56},{118,-24.2},{146,-24.2}},
                   color={0,0,127}));
  connect(dpHeaWatLoc1.y, ctl1.dpHeaWatLoc) annotation (Line(points={{112,-170},
          {158,-170},{158,-156},{162,-156},{162,-40},{130,-40},{130,-18},{146,
          -18},{146,-18.2}},
                   color={0,0,127}));
  connect(resDpHeaWatLoc1.dpLocSet, ctl1.dpHeaWatLocSet) annotation (Line(points={{151.8,
          -150},{151.8,-152},{158,-152},{158,-36},{134,-36},{134,-16.2},{146,-16.2}},
                                                       color={0,0,127}));
  connect(ctl1.dpHeaWatRemSet, dpHeaWatRem1.u1) annotation (Line(points={{190,5},
          {194,5},{194,0},{200,0},{200,-74},{80,-74},{80,-84},{88,-84}},
                      color={0,0,127}));
  connect(ctl1.dpChiWatRemSet, dpChiWatRem1.u1) annotation (Line(points={{190,3},
          {190,-36},{182,-36},{182,-124},{120,-124},{120,-114},{80,-114},{80,-124},
          {88,-124}},                              color={0,0,127}));
  connect(ctl1.y1Hp, y1Hp_actual1[1:ctl1.nHp].y1) annotation (Line(points={{190,53},
          {198,53},{198,60},{208,60}},     color={255,0,255}));
  connect(y1Hp_actual1[1:ctl1.nHp].y1_actual, ctl1.u1Hp_actual) annotation (
      Line(points={{232,60},{240,60},{240,76},{140,76},{140,46},{146,46}},
        color={255,0,255}));
  connect(y1Hp_actual1[ctl1.nHp + 1].y1_actual, ctl1.u1HpShc_actual)
    annotation (Line(points={{232,60},{240,60},{240,76},{140,76},{140,44},{146,44}},
        color={255,0,255}));
  connect(ctl1.y1HpShc, y1Hp_actual1[ctl1.nHpTot].y1) annotation (Line(points={{
          190,55},{200,55},{200,60},{210,60}}, color={255,0,255}));
  connect(ctl1.y1PumHeaWatPriShc, y1PumHeaWatPriFouPip_actual1.y1) annotation (
      Line(points={{190,-25},{208,-25},{208,-50},{218,-50}}, color={255,0,255}));
  connect(ctl1.y1PumChiWatPriShc, y1PumChiWatPriFouPip_actual1.y1) annotation (
      Line(points={{190,-27},{206,-27},{206,-80},{218,-80}}, color={255,0,255}));
  connect(y1PumHeaWatPriFouPip_actual1.y1_actual, ctl1.u1PumHeaWatPriShc_actual)
    annotation (Line(points={{242,-50},{280,-50},{280,96},{128,96},{128,38},{146,
          38}}, color={255,0,255}));
  connect(y1PumChiWatPriFouPip_actual1.y1_actual, ctl1.u1PumChiWatPriShc_actual)
    annotation (Line(points={{242,-80},{284,-80},{284,100},{116,100},{116,36},{146,
          36}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Validation/AirToWater.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400.0,
      Tolerance=1e-06),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        extent={{-300,-240},{300,240}})),
    Documentation(
      revisions="<html>
<ul>
<li>
July 30, 2025, by Karthik Devaprasad:<br/>
Added instance of controller for hybrid heat pump plant with two 2-pipe ASHPs and
one 4-pipe ASHP.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.AirToWater\">
Buildings.Templates.Plants.Controls.HeatPumps.AirToWater</a>
in two configurations:
<ol><li><code>ctl</code> with three equally sized lead/lag alternate
heat pumps and a sidestream heat recovery chiller.</li>
<li>
<code>ctl1</code>, which controls a hybrid heat pump plant with two equally-sized
2-pipe air-source heat pumps (ASHPs) in a lead-lag relationship, and an additional
4-pipe ASHP that is prioritized when servicing simultaneous heating and cooling
loads.
</li>
</ol>
</p>
<p>
Simulating this model shows how the controller responds to a varying load by 
</p>
<ul>
<li>
enabling the sidestream HRC in cooling mode,
</li>
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
