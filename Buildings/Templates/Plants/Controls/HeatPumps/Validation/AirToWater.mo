within Buildings.Templates.Plants.Controls.HeatPumps.Validation;
model AirToWater
  "Validation model for air-source heat pump plant controller"
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
    nHpShc=0,
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
    idxEquAlt={1, 2, 3},
    TChiWatSupHrc_min=277.15,
    THeaWatSupHrc_max=333.15,
    COPHeaHrc_nominal=2.8,
    capCooHrc_min=ctl.capHeaHrc_min *(1 - 1 / ctl.COPHeaHrc_nominal),
    capHeaHrc_min=0.3 * 0.5 * sum(ctl.capHeaHp_nominal))
    "Plant controller-1"
    annotation (Placement(transformation(extent={{30,-22},{70,50}})));

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
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTHeaWat(
    final k=(THeaWatRet_nominal - THeaWatSup_nominal) *(if ctl.have_hrc then 0.5
      else 1))
    "HW Delta-T"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTChiWat(
    final k=(TChiWatRet_nominal - TChiWatSup_nominal) *(if ctl.have_hrc then 0.5
      else 1))
    "CHW Delta-T"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VHeaWat_flow(
    final k=VHeaWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VChiWat_flow(
    final k=VChiWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Components.Controls.StatusEmulator y1Hp_actual[ctl.nHp]
    "HP status"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Components.Controls.StatusEmulator y1PumHeaWatPri_actual1[ctl.nPumHeaWatPri]
    if ctl.have_heaWat and ctl.have_pumHeaWatPri
    "Primary HW pump status"
    annotation (Placement(transformation(extent={{130,30},{150,50}})));
  Components.Controls.StatusEmulator y1PumChiWatPri_actual[ctl.nPumChiWatPri]
    if ctl.have_chiWat and ctl.have_pumChiWatPri
    "Primary CHW pump status"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Components.Controls.StatusEmulator y1PumHeaWatSec_actual[ctl.nPumHeaWatSec]
    if ctl.have_heaWat and ctl.have_pumHeaWatSec
    "Secondary HW pump status"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Components.Controls.StatusEmulator y1PumChiWatSec_actual[ctl.nPumChiWatSec]
    if ctl.have_chiWat and ctl.have_pumChiWatSec
    "Secondary CHW pump status"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    amplitude=10,
    freqHz=0.5 / 24 / 3600,
    phase=- 0.43633231299858,
    offset=10 + 273.15)
    "OAT"
    annotation (Placement(transformation(extent={{-160,82},{-140,102}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemHea(
    t=1E-2,
    h=0.5E-2)
    "Return true if heating demand"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemCoo(
    t=1E-2,
    h=0.5E-2)
    "Return true if cooling demand"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaHeaWat
    "Generate HW plant request"
    annotation (Placement(transformation(extent={{-50,100},{-30,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaChiWat
    "Generate CHW plant request"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[2](
    each k=5)
    "Use fraction of flow rate as a proxy for plant reset request"
    annotation (Placement(transformation(extent={{-78,30},{-58,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reqResHeaWat
    "Generate HW reset request"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reqResChiWat
    "Generate CHW reset request"
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin[1](
    amplitude=0.1 * ctl.dpHeaWatRemSet_max,
    freqHz={4 / 8000},
    each phase=3.1415926535898)
    if ctl.have_heaWat
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-130,-96},{-110,-76}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpHeaWatRem[1]
    if ctl.have_heaWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpChiWatRem[1]
    if ctl.have_chiWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpHeaWatLoc[1](
    each dpLocSet_max=20E4)
    if ctl.have_heaWat
    "Local HW DP reset"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpChiWatLoc[1](
    each dpLocSet_max=15E4)
    if ctl.have_chiWat
    "Local CHW DP reset"
    annotation (Placement(transformation(extent={{-10,-190},{10,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1[1](
    amplitude=0.1 * ctl.dpChiWatRemSet_max,
    freqHz={3 / 8000},
    each phase=3.1415926535898)
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-130,-136},{-110,-116}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpHeaWatLoc(
    final k=4)
    if ctl.have_heaWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpChiWatLoc(
    final k=3)
    if ctl.have_chiWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-50,-210},{-30,-190}})));
  Components.Controls.StatusEmulator y1Hrc_actual
    if ctl.have_hrc
    "Sidestream HRC status"
    annotation (Placement(transformation(extent={{130,-50},{150,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTHeaWatUpsHrc(
    final k=THeaWatRet_nominal - THeaWatSup_nominal)
    "HW Delta-T as measured upstream of HRC"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTChiWatUpsHrc(
    final k=TChiWatRet_nominal - TChiWatSup_nominal)
    "CHW Delta-T as measured upstream of HRC"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Reals.Add THeaWatRet
    if ctl.have_heaWat
    "HWRT"
    annotation (Placement(transformation(extent={{-50,150},{-30,170}})));
  Buildings.Controls.OBC.CDL.Reals.Add THeaWatRetUpsHrc
    if ctl.have_heaWat
    "HWRT upstream of HRC"
    annotation (Placement(transformation(extent={{-50,190},{-30,210}})));
  Buildings.Controls.OBC.CDL.Reals.Add TChiWatRet
    if ctl.have_chiWat
    "CHWRT"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Reals.Add TChiWatRetUpsHrc
    if ctl.have_chiWat
    "CHWRT upstream of HRC"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));

equation
  connect(ratV_flow.y[1], VHeaWat_flow.u)
    annotation (Line(points={{-108,-40},{-90,-40},{-90,-20},{-82,-20}},   color={0,0,127}));
  connect(ratV_flow.y[2], VChiWat_flow.u)
    annotation (Line(points={{-108,-40},{-52,-40}},color={0,0,127}));
  connect(ctl.y1Hp, y1Hp_actual.y1)
    annotation (Line(points={{72,45.9091},{88,45.9091},{88,60},{98,60}},
                                                              color={255,0,255}));
  connect(y1Hp_actual.y1_actual, ctl.u1Hp_actual)
    annotation (Line(points={{122,60},{130,60},{130,80},{26,80},{26,41.1636},{
          28,41.1636}},
      color={255,0,255}));
  connect(ctl.y1PumHeaWatPri, y1PumHeaWatPri_actual1.y1)
    annotation (Line(points={{72,31.1818},{90,31.1818},{90,40},{128,40}},
                                                              color={255,0,255}));
  connect(ctl.y1PumChiWatPri, y1PumChiWatPri_actual.y1)
    annotation (Line(points={{72,29.5455},{90,29.5455},{90,20},{98,20}},
                                                              color={255,0,255}));
  connect(ctl.y1PumHeaWatSec, y1PumHeaWatSec_actual.y1)
    annotation (Line(points={{72,27.9091},{90,27.9091},{90,0},{128,0}},
                                                            color={255,0,255}));
  connect(ctl.y1PumChiWatSec, y1PumChiWatSec_actual.y1)
    annotation (Line(points={{72,26.2727},{88,26.2727},{88,-20},{98,-20}},
                                                                color={255,0,255}));
  connect(y1PumHeaWatPri_actual1.y1_actual, ctl.u1PumHeaWatPri_actual)
    annotation (Line(points={{152,40},{164,40},{164,82},{24,82},{24,37.8909},{
          28,37.8909}},
      color={255,0,255}));
  connect(y1PumHeaWatSec_actual.y1_actual, ctl.u1PumHeaWatSec_actual)
    annotation (Line(points={{152,0},{168,0},{168,86},{20,86},{20,31.3455},{28,
          31.3455}},
      color={255,0,255}));
  connect(y1PumChiWatPri_actual.y1_actual, ctl.u1PumChiWatPri_actual)
    annotation (Line(points={{122,20},{166,20},{166,84},{22,84},{22,36.2545},{
          28,36.2545}},
      color={255,0,255}));
  connect(y1PumChiWatSec_actual.y1_actual, ctl.u1PumChiWatSec_actual)
    annotation (Line(points={{122,-20},{170,-20},{170,88},{18,88},{18,29.7091},
          {28,29.7091}},
      color={255,0,255}));
  connect(TOut.y, ctl.TOut)
    annotation (Line(points={{-138,92},{10,92},{10,16.4545},{28,16.4545}},
                                                                  color={0,0,127}));
  connect(ratV_flow.y[1], isDemHea.u)
    annotation (Line(points={{-108,-40},{-90,-40},{-90,110},{-82,110}},   color={0,0,127}));
  connect(ratV_flow.y[2], isDemCoo.u)
    annotation (Line(points={{-108,-40},{-90,-40},{-90,70},{-82,70}},   color={0,0,127}));
  connect(isDemCoo.y, reqPlaChiWat.u)
    annotation (Line(points={{-58,70},{-52,70}},color={255,0,255}));
  connect(isDemHea.y, reqPlaHeaWat.u)
    annotation (Line(points={{-58,110},{-52,110}},color={255,0,255}));
  connect(reqPlaHeaWat.y, ctl.nReqPlaHeaWat)
    annotation (Line(points={{-28,110},{-6,110},{-6,23},{28,23}},  color={255,127,0}));
  connect(reqPlaChiWat.y, ctl.nReqPlaChiWat)
    annotation (Line(points={{-28,70},{-10,70},{-10,21.3636},{28,21.3636}},
                                                                 color={255,127,0}));
  connect(VHeaWat_flow.y, ctl.VHeaWatPri_flow)
    annotation (Line(points={{-58,-20},{4,-20},{4,11.5455},{28,11.5455}},
                                                                   color={0,0,127}));
  connect(VHeaWat_flow.y, ctl.VHeaWatSec_flow)
    annotation (Line(points={{-58,-20},{4,-20},{4,0.0909091},{28,0.0909091}},
                                                                 color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatPri_flow)
    annotation (Line(points={{-28,-40},{6,-40},{6,6.63636},{28,6.63636}},
                                                                 color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatSec_flow)
    annotation (Line(points={{-28,-40},{6,-40},{6,-6.45455},{28,-6.45455}},
                                                                   color={0,0,127}));
  connect(ratV_flow.y, gai.u)
    annotation (Line(points={{-108,-40},{-90,-40},{-90,40},{-80,40}},   color={0,0,127}));
  connect(gai[1].y, reqResHeaWat.u)
    annotation (Line(points={{-56,40},{-52,40}},color={0,0,127}));
  connect(gai[2].y, reqResChiWat.u)
    annotation (Line(points={{-56,40},{-54,40},{-54,10},{-52,10}},color={0,0,127}));
  connect(reqResHeaWat.y, ctl.nReqResHeaWat)
    annotation (Line(points={{-28,40},{12,40},{12,19.7273},{28,19.7273}},
                                                                 color={255,127,0}));
  connect(reqResChiWat.y, ctl.nReqResChiWat)
    annotation (Line(points={{-28,10},{-10,10},{-10,18.0909},{28,18.0909}},
                                                                 color={255,127,0}));
  connect(sin.y, dpHeaWatRem.u2)
    annotation (Line(points={{-108,-86},{-52,-86}},color={0,0,127}));
  connect(dpChiWatRem.y, ctl.dpChiWatRem)
    annotation (Line(points={{-28,-120},{12,-120},{12,-13},{28,-13}},  color={0,0,127}));
  connect(dpHeaWatRem.y, ctl.dpHeaWatRem)
    annotation (Line(points={{-28,-80},{10,-80},{10,-8.09091},{28,-8.09091}},
                                                                     color={0,0,127}));
  connect(ctl.dpHeaWatRemSet, dpHeaWatRem.u1)
    annotation (Line(points={{72,6.63636},{80,6.63636},{80,-60},{-70,-60},{-70,
          -74},{-52,-74}},
      color={0,0,127}));
  connect(ctl.dpChiWatRemSet, dpChiWatRem.u1)
    annotation (Line(points={{72,5},{78,5},{78,-100},{-60,-100},{-60,-114},{-52,
          -114}},
      color={0,0,127}));
  connect(sin1.y, dpChiWatRem.u2)
    annotation (Line(points={{-108,-126},{-52,-126}},color={0,0,127}));
  connect(dpHeaWatRem[1].y, dpHeaWatLoc.u)
    annotation (Line(points={{-28,-80},{-22,-80},{-22,-140},{-56,-140},{-56,-160},
          {-52,-160}},
      color={0,0,127}));
  connect(ctl.dpHeaWatRemSet, resDpHeaWatLoc.dpRemSet)
    annotation (Line(points={{72,6.63636},{80,6.63636},{80,-60},{-70,-60},{-70,
          -134},{-12,-134}},
      color={0,0,127}));
  connect(dpChiWatRem[1].y, dpChiWatLoc.u)
    annotation (Line(points={{-28,-120},{-24,-120},{-24,-180},{-60,-180},{-60,-200},
          {-52,-200}},
      color={0,0,127}));
  connect(ctl.dpChiWatRemSet, resDpChiWatLoc.dpRemSet)
    annotation (Line(points={{72,5},{77.9167,5},{77.9167,-100},{-60,-100},{-60,
          -174},{-12,-174}},
      color={0,0,127}));
  connect(dpHeaWatRem.y, resDpHeaWatLoc.dpRem)
    annotation (Line(points={{-28,-80},{-22,-80},{-22,-146},{-12,-146}},color={0,0,127}));
  connect(dpChiWatRem.y, resDpChiWatLoc.dpRem)
    annotation (Line(points={{-28,-120},{-24,-120},{-24,-186},{-12,-186}},color={0,0,127}));
  connect(resDpChiWatLoc.dpLocSet, ctl.dpChiWatLocSet)
    annotation (Line(points={{11.8,-180},{16,-180},{16,-14.6364},{28,-14.6364}},
                                                                         color={0,0,127}));
  connect(dpChiWatLoc.y, ctl.dpChiWatLoc)
    annotation (Line(points={{-28,-200},{18,-200},{18,-16.2727},{28,-16.2727}},
                                                                       color={0,0,127}));
  connect(dpHeaWatLoc.y, ctl.dpHeaWatLoc)
    annotation (Line(points={{-28,-160},{14,-160},{14,-11.3636},{28,-11.3636}},
                                                                       color={0,0,127}));
  connect(resDpHeaWatLoc.dpLocSet, ctl.dpHeaWatLocSet)
    annotation (Line(points={{11.8,-140},{20,-140},{20,-9.72727},{28,-9.72727}},
                                                                         color={0,0,127}));
  connect(ctl.y1Hrc, y1Hrc_actual.y1)
    annotation (Line(points={{72,-4.81818},{86,-4.81818},{86,-40},{128,-40}},
                                                                  color={255,0,255}));
  connect(y1Hrc_actual.y1_actual, ctl.u1Hrc_actual)
    annotation (Line(points={{152,-40},{172,-40},{172,90},{16,90},{16,28.0727},
          {28,28.0727}},
      color={255,0,255}));
  connect(ctl.TChiWatSupSet, ctl.TChiWatSecSup)
    annotation (Line(points={{72,-1.54545},{74,-1.54545},{74,-30},{-2,-30},{-2,
          -1.54545},{28,-1.54545}},
      color={0,0,127}));
  connect(ctl.TChiWatSupSet, ctl.TChiWatPriSup)
    annotation (Line(points={{72,-1.54545},{74,-1.54545},{74,-30},{-2,-30},{-2,
          9.90909},{28,9.90909}},
      color={0,0,127}));
  connect(ctl.THeaWatSupSet, ctl.THeaWatPriSup)
    annotation (Line(points={{72,0.0909091},{76,0.0909091},{76,-32},{-4,-32},{
          -4,14.8182},{28,14.8182}},
      color={0,0,127}));
  connect(ctl.THeaWatSupSet, ctl.THeaWatSecSup)
    annotation (Line(points={{72,0.0909091},{76,0.0909091},{76,-32},{-4,-32},{
          -4,5},{28,5}},
      color={0,0,127}));
  connect(ctl.THeaWatSupSet, THeaWatRet.u1)
    annotation (Line(points={{72,0.0909091},{76,0.0909091},{76,176},{-56,176},{
          -56,166},{-52,166}},
      color={0,0,127}));
  connect(dTHeaWat.y, THeaWatRet.u2)
    annotation (Line(points={{-138,160},{-56,160},{-56,154},{-52,154}},color={0,0,127}));
  connect(ctl.TChiWatSupSet, TChiWatRet.u2)
    annotation (Line(points={{72,-1.54545},{74,-1.54545},{74,126},{-90,126},{
          -90,134},{-82,134}},
      color={0,0,127}));
  connect(dTChiWat.y, TChiWatRet.u1)
    annotation (Line(points={{-98,140},{-94,140},{-94,146},{-82,146}},    color={0,0,127}));
  connect(dTChiWatUpsHrc.y, TChiWatRetUpsHrc.u1)
    annotation (Line(points={{-98,180},{-94,180},{-94,186},{-82,186}},    color={0,0,127}));
  connect(TChiWatRetUpsHrc.u2, ctl.TChiWatSupSet)
    annotation (Line(points={{-82,174},{-90,174},{-90,126},{74,126},{74,
          -1.54545},{72,-1.54545}},
      color={0,0,127}));
  connect(THeaWatRetUpsHrc.u2, ctl.THeaWatSupSet)
    annotation (Line(points={{-52,194},{-56,194},{-56,176},{76,176},{76,
          0.0909091},{72,0.0909091}},
      color={0,0,127}));
  connect(dTHeaWatUpsHrc.y, THeaWatRetUpsHrc.u1)
    annotation (Line(points={{-138,200},{-70,200},{-70,206},{-52,206}},  color={0,0,127}));
  connect(THeaWatRet.y, ctl.THeaWatPriRet)
    annotation (Line(points={{-28,160},{4,160},{4,13.1818},{28,13.1818}},
                                                                   color={0,0,127}));
  connect(THeaWatRet.y, ctl.THeaWatSecRet)
    annotation (Line(points={{-28,160},{4,160},{4,3.36364},{28,3.36364}},
                                                                 color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatSecRet)
    annotation (Line(points={{-58,140},{2,140},{2,-3.18182},{28,-3.18182}},
                                                                   color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatPriRet)
    annotation (Line(points={{-58,140},{2,140},{2,8.27273},{28,8.27273}},
                                                                   color={0,0,127}));
  connect(TChiWatRetUpsHrc.y, ctl.TChiWatRetUpsHrc)
    annotation (Line(points={{-58,180},{0,180},{0,-4.81818},{28,-4.81818}},
                                                                   color={0,0,127}));
  connect(THeaWatRetUpsHrc.y, ctl.THeaWatRetUpsHrc)
    annotation (Line(points={{-28,200},{8,200},{8,1.72727},{28,1.72727}},
                                                                 color={0,0,127}));
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
        extent={{-240,-240},{240,240}})),
    Documentation(
      revisions="<html>
<ul>
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
in a configuration with three equally sized lead/lag alternate
heat pumps and a sidestream heat recovery chiller.
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
