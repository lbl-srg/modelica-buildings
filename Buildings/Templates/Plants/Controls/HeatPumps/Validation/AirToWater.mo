within Buildings.Templates.Plants.Controls.HeatPumps.Validation;
model AirToWater
  final parameter Real capHea_nominal(
    final unit="W")=sum(ctl.capHeaHp_nominal)
    "Installed heating capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Real THeaWatSup_nominal(
    final unit="K",
    displayUnit="degC")=50 + 273.15
    "Design HW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real THeaWatRet_nominal(
    final unit="K",
    displayUnit="degC")=42 + 273.15
    "Design HW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real VHeaWat_flow_nominal(
    final unit="m3/s")=capHea_nominal / abs(THeaWatSup_nominal -
    THeaWatRet_nominal) / ctl.cp_default / ctl.rho_default
    "Design HW volume flow rate"
    annotation (Dialog(group="Nominal condition"));
  final parameter Real capCoo_nominal(
    final unit="W")=sum(ctl.capCooHp_nominal)
    "Installed cooling capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Real TChiWatSup_nominal(
    final unit="K",
    displayUnit="degC")=7 + 273.15
    "Design CHW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real TChiWatRet_nominal(
    final unit="K",
    displayUnit="degC")=12 + 273.15
    "Design CHW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real VChiWat_flow_nominal(
    final unit="m3/s")=capHea_nominal / abs(TChiWatSup_nominal -
    TChiWatRet_nominal) / ctl.cp_default / ctl.rho_default
    "Design CHW volume flow rate"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Templates.Plants.Controls.HeatPumps.AirToWater ctl(
    have_heaWat=true,
    have_chiWat=true,
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
    have_senTHeaWatSecRet=true,
    have_senTChiWatSecRet=false,
    nHp=3,
    have_senDpHeaWatRemWir=false,
    nSenDpHeaWatRem=1,
    have_senDpChiWatRemWir=false,
    nSenDpChiWatRem=1,
    final THeaWatSup_nominal=THeaWatSup_nominal,
    THeaWatSupSet_min=298.15,
    final VHeaWatSec_flow_nominal=VHeaWat_flow_nominal,
    capHeaHp_nominal=fill(350, ctl.nHp),
    dpHeaWatRemSet_max={5E4},
    final TChiWatSup_nominal=TChiWatSup_nominal,
    TChiWatSupSet_max=288.15,
    final VChiWatSec_flow_nominal=VChiWat_flow_nominal,
    capCooHp_nominal=fill(350, ctl.nHp),
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.7,
    dpChiWatRemSet_max={5E4},
    staEqu=[1/3,1/3,1/3; 2/3,2/3,2/3; 1,1,1],
    idxEquAlt={1,2,3}) "Plant controller"
    annotation (Placement(transformation(extent={{0,0},{40,68}})));
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
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatRet(
    final k=THeaWatRet_nominal) "HWRT"
    annotation (Placement(transformation(extent={{-150,50},{-130,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRet(
    final k=TChiWatRet_nominal) "CHWRT"
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VHeaWat_flow(
    final k=VHeaWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VChiWat_flow(
    final k=VChiWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Components.Controls.StatusEmulator y1Hp_actual[ctl.nHp]
    "HP status"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Components.Controls.StatusEmulator y1PumHeaWatPri_actual1[ctl.nPumHeaWatPri]
    if ctl.have_heaWat and ctl.have_pumHeaWatPri
    "Primary HW pump status"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Components.Controls.StatusEmulator y1PumChiWatPri_actual[ctl.nPumChiWatPri]
    if ctl.have_chiWat and ctl.have_pumChiWatPri
    "Primary CHW pump status"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Components.Controls.StatusEmulator y1PumHeaWatSec_actual[ctl.nPumHeaWatSec]
    if ctl.have_heaWat and ctl.have_pumHeaWatSec
    "Secondary HW pump status"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Components.Controls.StatusEmulator y1PumChiWatSec_actual[ctl.nPumChiWatSec]
    if ctl.have_chiWat and ctl.have_pumChiWatSec
    "Secondary CHW pump status"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    amplitude=10,
    freqHz=0.5 / 24 / 3600,
    phase=- 0.43633231299858,
    offset=10 + 273.15)
    "OAT"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemHea(
    t=1E-2,
    h=0.5E-2)
    "Return true if heating demand"
    annotation (Placement(transformation(extent={{-110,170},{-90,190}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemCoo(
    t=1E-2,
    h=0.5E-2)
    "Return true if cooling demand"
    annotation (Placement(transformation(extent={{-110,130},{-90,150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaHeaWat
    "Generate HW plant request"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaChiWat
    "Generate CHW plant request"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[2](
    each k=5)
    "Use fraction of flow rate as a proxy for plant reset request"
    annotation (Placement(transformation(extent={{-108,90},{-88,110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reqResHeaWat
    "Generate HW reset request"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reqResChiWat
    "Generate CHW reset request"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin[1](
    amplitude=0.1 * ctl.dpHeaWatRemSet_max,
    freqHz={4 / 8000},
    each phase=3.1415926535898)
    if ctl.have_heaWat
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-160,-76},{-140,-56}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpHeaWatRem[1]
    if ctl.have_heaWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Add dpChiWatRem[1]
    if ctl.have_chiWat
    "Differential pressure at remote location"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpHeaWatLoc[1](each
      dpLocSet_max=20E4)
    if ctl.have_heaWat
    "Local HW DP reset"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Pumps.Generic.ResetLocalDifferentialPressure resDpChiWatLoc[1](each
      dpLocSet_max=15E4)
    if ctl.have_chiWat
    "Local CHW DP reset"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1[1](
    amplitude=0.1 * ctl.dpChiWatRemSet_max,
    freqHz={3 / 8000},
    each phase=3.1415926535898)
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-160,-116},{-140,-96}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpHeaWatLoc(final k=4)
    if ctl.have_heaWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpChiWatLoc(final k=3)
    if ctl.have_chiWat
    "Differential pressure local to the plant"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSup(final k=
        THeaWatSup_nominal) "HWST"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSup(final k=
        TChiWatSup_nominal) "CHWST"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
equation
  connect(ratV_flow.y[1], VHeaWat_flow.u)
    annotation (Line(points={{-138,-20},{-120,-20},{-120,0},{-112,0}},color={0,0,127}));
  connect(ratV_flow.y[2], VChiWat_flow.u)
    annotation (Line(points={{-138,-20},{-82,-20}},color={0,0,127}));
  connect(ctl.y1Hp, y1Hp_actual.y1)
    annotation (Line(points={{42,60},{44,60},{44,80},{68,80}},color={255,0,255}));
  connect(y1Hp_actual.y1_actual, ctl.u1Hp_actual)
    annotation (Line(points={{92,80},{100,80},{100,100},{-4,100},{-4,60},{-2,60}},
      color={255,0,255}));
  connect(ctl.y1PumHeaWatPri, y1PumHeaWatPri_actual1.y1)
    annotation (Line(points={{42,44},{60,44},{60,60},{98,60}},color={255,0,255}));
  connect(ctl.y1PumChiWatPri, y1PumChiWatPri_actual.y1)
    annotation (Line(points={{42,42},{62,42},{62,40},{68,40}},color={255,0,255}));
  connect(ctl.y1PumHeaWatSec, y1PumHeaWatSec_actual.y1)
    annotation (Line(points={{42,38},{62,38},{62,20},{98,20}},color={255,0,255}));
  connect(ctl.y1PumChiWatSec, y1PumChiWatSec_actual.y1)
    annotation (Line(points={{42,36},{60,36},{60,0},{68,0}},color={255,0,255}));
  connect(y1PumHeaWatPri_actual1.y1_actual, ctl.u1PumHeaWatPri_actual)
    annotation (Line(points={{122,60},{134,60},{134,102},{-6,102},{-6,58},{-2,
          58}},
      color={255,0,255}));
  connect(y1PumHeaWatSec_actual.y1_actual, ctl.u1PumHeaWatSec_actual)
    annotation (Line(points={{122,20},{138,20},{138,106},{-10,106},{-10,54},{-2,
          54}},
      color={255,0,255}));
  connect(y1PumChiWatPri_actual.y1_actual, ctl.u1PumChiWatPri_actual)
    annotation (Line(points={{92,40},{136,40},{136,104},{-8,104},{-8,56},{-2,56}},
      color={255,0,255}));
  connect(y1PumChiWatSec_actual.y1_actual, ctl.u1PumChiWatSec_actual)
    annotation (Line(points={{92,0},{140,0},{140,108},{-12,108},{-12,52},{-2,52}},
      color={255,0,255}));
  connect(TOut.y, ctl.TOut)
    annotation (Line(points={{-138,120},{-122,120},{-122,38},{-2,38}},  color={0,0,127}));
  connect(ratV_flow.y[1], isDemHea.u)
    annotation (Line(points={{-138,-20},{-120,-20},{-120,180},{-112,180}},color={0,0,127}));
  connect(ratV_flow.y[2], isDemCoo.u)
    annotation (Line(points={{-138,-20},{-120,-20},{-120,140},{-112,140}},color={0,0,127}));
  connect(isDemCoo.y, reqPlaChiWat.u)
    annotation (Line(points={{-88,140},{-82,140}},color={255,0,255}));
  connect(isDemHea.y, reqPlaHeaWat.u)
    annotation (Line(points={{-88,180},{-82,180}},color={255,0,255}));
  connect(reqPlaHeaWat.y, ctl.nReqPlaHeaWat) annotation (Line(points={{-58,180},
          {-40,180},{-40,48},{-2,48}}, color={255,127,0}));
  connect(reqPlaChiWat.y, ctl.nReqPlaChiWat) annotation (Line(points={{-58,140},
          {-40,140},{-40,46},{-2,46}}, color={255,127,0}));
  connect(THeaWatRet.y, ctl.THeaWatSecRet)
    annotation (Line(points={{-128,60},{-100,60},{-100,22},{-2,22}},  color={0,0,127}));
  connect(THeaWatRet.y, ctl.THeaWatPriRet)
    annotation (Line(points={{-128,60},{-100,60},{-100,34},{-2,34}},  color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatSecRet)
    annotation (Line(points={{-128,20},{-28,20},{-28,16},{-2,16}},color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatPriRet)
    annotation (Line(points={{-128,20},{-28,20},{-28,28},{-2,28}},    color={0,0,127}));
  connect(VHeaWat_flow.y, ctl.VHeaWatPri_flow)
    annotation (Line(points={{-88,0},{-26,0},{-26,32},{-2,32}},    color={0,0,127}));
  connect(VHeaWat_flow.y, ctl.VHeaWatSec_flow)
    annotation (Line(points={{-88,0},{-26,0},{-26,20},{-2,20}},color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatPri_flow)
    annotation (Line(points={{-58,-20},{-24,-20},{-24,26},{-2,26}},    color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatSec_flow)
    annotation (Line(points={{-58,-20},{-22,-20},{-22,14},{-2,14}},color={0,0,127}));
  connect(ratV_flow.y, gai.u)
    annotation (Line(points={{-138,-20},{-120,-20},{-120,100},{-110,100}},
                                                                        color={0,0,127}));
  connect(gai[1].y, reqResHeaWat.u)
    annotation (Line(points={{-86,100},{-82,100}},
                                                color={0,0,127}));
  connect(gai[2].y, reqResChiWat.u)
    annotation (Line(points={{-86,100},{-84,100},{-84,70},{-82,70}},
                                                                  color={0,0,127}));
  connect(reqResHeaWat.y,ctl.nReqResHeaWat)
    annotation (Line(points={{-58,100},{-38,100},{-38,44},{-2,44}},
                                                                 color={255,127,0}));
  connect(reqResChiWat.y,ctl.nReqResChiWat)
    annotation (Line(points={{-58,70},{-36,70},{-36,42},{-2,42}},color={255,127,0}));
  connect(sin.y, dpHeaWatRem.u2)
    annotation (Line(points={{-138,-66},{-82,-66}},color={0,0,127}));
  connect(dpChiWatRem.y, ctl.dpChiWatRem)
    annotation (Line(points={{-58,-100},{-18,-100},{-18,6},{-2,6}},color={0,0,127}));
  connect(dpHeaWatRem.y, ctl.dpHeaWatRem)
    annotation (Line(points={{-58,-60},{-20,-60},{-20,12},{-2,12}},color={0,0,127}));
  connect(ctl.dpHeaWatRemSet, dpHeaWatRem.u1)
    annotation (Line(points={{42,18},{50,18},{50,-40},{-100,-40},{-100,-54},{
          -82,-54}},
      color={0,0,127}));
  connect(ctl.dpChiWatRemSet, dpChiWatRem.u1)
    annotation (Line(points={{42,16},{48,16},{48,-80},{-90,-80},{-90,-94},{-82,
          -94}},
      color={0,0,127}));
  connect(sin1.y, dpChiWatRem.u2)
    annotation (Line(points={{-138,-106},{-82,-106}},color={0,0,127}));
  connect(dpHeaWatRem[1].y, dpHeaWatLoc.u)
    annotation (Line(points={{-58,-60},{-52,-60},{-52,-120},{-86,-120},{-86,-140},{-82,-140}},
      color={0,0,127}));
  connect(ctl.dpHeaWatRemSet, resDpHeaWatLoc.dpRemSet)
    annotation (Line(points={{42,18},{50,18},{50,-40},{-100,-40},{-100,-114},{
          -42,-114}},
      color={0,0,127}));
  connect(dpChiWatRem[1].y, dpChiWatLoc.u)
    annotation (Line(points={{-58,-100},{-54,-100},{-54,-160},{-90,-160},{-90,-180},{-82,-180}},
      color={0,0,127}));
  connect(ctl.dpChiWatRemSet, resDpChiWatLoc.dpRemSet)
    annotation (Line(points={{42,16},{47.9167,16},{47.9167,-80},{-90,-80},{-90,
          -154},{-42,-154}},
      color={0,0,127}));
  connect(dpHeaWatRem.y, resDpHeaWatLoc.dpRem)
    annotation (Line(points={{-58,-60},{-52,-60},{-52,-126},{-42,-126}},color={0,0,127}));
  connect(dpChiWatRem.y, resDpChiWatLoc.dpRem)
    annotation (Line(points={{-58,-100},{-54,-100},{-54,-166},{-42,-166}},color={0,0,127}));
  connect(resDpChiWatLoc.dpLocSet, ctl.dpChiWatLocSet)
    annotation (Line(points={{-18.2,-160},{-14,-160},{-14,4},{-2,4}},color={0,0,127}));
  connect(dpChiWatLoc.y, ctl.dpChiWatLoc)
    annotation (Line(points={{-58,-180},{-12,-180},{-12,2},{-2,2}},color={0,0,127}));
  connect(dpHeaWatLoc.y, ctl.dpHeaWatLoc)
    annotation (Line(points={{-58,-140},{-16,-140},{-16,8},{-2,8}},color={0,0,127}));
  connect(resDpHeaWatLoc.dpLocSet, ctl.dpHeaWatLocSet)
    annotation (Line(points={{-18.2,-120},{-10,-120},{-10,10},{-2,10}},color={0,0,127}));
  connect(TChiWatSup.y, ctl.TChiWatPriSup) annotation (Line(points={{-158,40},{
          -102,40},{-102,30},{-2,30}}, color={0,0,127}));
  connect(THeaWatSup.y, ctl.THeaWatPriSup) annotation (Line(points={{-158,80},{
          -98,80},{-98,36},{-2,36}}, color={0,0,127}));
  connect(TChiWatSup.y, ctl.TChiWatSecSup) annotation (Line(points={{-158,40},{
          -102,40},{-102,18},{-2,18}}, color={0,0,127}));
  connect(THeaWatSup.y, ctl.THeaWatSecSup) annotation (Line(points={{-158,80},{
          -98,80},{-98,24},{-2,24}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Validation/AirToWater.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400.0,
      Tolerance=1e-06),
    Icon(
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
        extent={{-200,-240},{200,240}})),
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
</html>"));
end AirToWater;
