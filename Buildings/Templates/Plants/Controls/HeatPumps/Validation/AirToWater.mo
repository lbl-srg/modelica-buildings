within Buildings.Templates.Plants.Controls.HeatPumps.Validation;
model AirToWater
  final parameter Real capHea_nominal(final unit="W")=sum(ctl.capHeaHp_nominal)
    "Installed heating capacity"
    annotation(Dialog(group="Nominal condition"));
  parameter Real THeaWatSup_nominal(final unit="K", displayUnit="degC")=50+273.15
    "Design HW supply temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Real THeaWatRet_nominal(final unit="K", displayUnit="degC")=42 + 273.15
    "Design HW return temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VHeaWat_flow_nominal(final unit="m3/s")=
    capHea_nominal / abs(THeaWatSup_nominal - THeaWatRet_nominal) / ctl.cp_default / ctl.rho_default
    "Design HW volume flow rate"
    annotation(Dialog(group="Nominal condition"));
  final parameter Real capCoo_nominal(final unit="W")=sum(ctl.capCooHp_nominal)
    "Installed cooling capacity"
    annotation(Dialog(group="Nominal condition"));
  parameter Real TChiWatSup_nominal(final unit="K", displayUnit="degC")=7+273.15
    "Design CHW supply temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Real TChiWatRet_nominal(final unit="K", displayUnit="degC")=12 + 273.15
    "Design CHW return temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VChiWat_flow_nominal(final unit="m3/s")=
    capHea_nominal / abs(TChiWatSup_nominal - TChiWatRet_nominal) / ctl.cp_default / ctl.rho_default
    "Design CHW volume flow rate"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Templates.Plants.Controls.HeatPumps.AirToWater ctl(
    have_heaWat=true,
    have_chiWat=true,
    have_valInlIso=true,
    have_valOutIso=true,
    have_pumChiWatPri=true,
    have_pumHeaWatSec=true,
    have_pumChiWatSec=true,
    is_pumPriHdr=true,
    have_senPri_select=false,
    nHp=3,
    nSenDpHeaWatRem=1,
    nSenDpChiWatRem=1,
    final THeaWatSup_nominal=THeaWatSup_nominal,
    final VHeaWatSec_flow_nominal=VHeaWat_flow_nominal,
    capHeaHp_nominal=1E3*{100,450,450},
    dpHeaWatRemSet_nominal={5E4},
    dpHeaWatLocSet_nominal=15E4,
    final TChiWatSup_nominal=TChiWatSup_nominal,
    final VChiWatSec_flow_nominal=VChiWat_flow_nominal,
    capCooHp_nominal=1E3*{100,450,450},
    dpChiWatRemSet_nominal={5E4},
    dpChiWatLocSet_nominal=15E4,
    staEqu=[1,0,0; 0,0.5,0.5; 1,0.5,0.5; 0,1,1; 1,1,1],
    idxEquAlt={2,3}) "Plant controller"
    annotation (Placement(transformation(extent={{-14,-24},{14,24}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratV_flow(table=[0,0,0; 5,
        0,0; 6,1,0; 12,0.2,0.2; 15,0,1; 22,0.1,0.1; 24,0,0],
                                                           timeScale=3600)
    "Source signal for volume flow rate ratio – Index 1 for heating, 2 for cooling"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatRet(final k=
        THeaWatRet_nominal) "HWRT"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Ava[ctl.nHp](each k=true)
    "HP available signal"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRet(final k=
        TChiWatRet_nominal) "CHWRT"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VHeaWat_flow(final k=
        VHeaWat_flow_nominal) "Scale by design flow"
    annotation (Placement(transformation(extent={{-110,-130},{-90,-110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VChiWat_flow(final k=
        VChiWat_flow_nominal) "Scale by design flow"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Components.Controls.StatusEmulator y1Hp_actual[ctl.nHp] "HP status"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Components.Controls.StatusEmulator y1PumHeaWatPri_actual1[ctl.nPumHeaWatPri]
    if ctl.have_pumHeaWatPri "Primary HW pump status"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Components.Controls.StatusEmulator y1PumChiWatPri_actual[ctl.nPumChiWatPri]
    if ctl.have_pumChiWatPri "Primary CHW pump status"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Components.Controls.StatusEmulator y1PumHeaWatSec_actual[ctl.nPumHeaWatSec]
    if ctl.have_pumHeaWatSec "Secondary HW pump status"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Components.Controls.StatusEmulator y1PumChiWatSec_actual[ctl.nPumChiWatSec]
    if ctl.have_pumChiWatSec "Secondary CHW pump status"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    amplitude=10,
    freqHz=0.5/24/3600,
    phase=-0.43633231299858,
    offset=10 + 273.15) "OAT"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemHea(t=1E-2, h=0.5E-2)
    "Return true if heating demand"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isDemCoo(t=1E-2, h=0.5E-2)
    "Return true if cooling demand"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaHeaWat
    "Generate HW plant request"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqPlaChiWat
    "Generate CHW plant request"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(ratV_flow.y[1], VHeaWat_flow.u) annotation (Line(points={{-138,-140},{
          -120,-140},{-120,-120},{-112,-120}}, color={0,0,127}));
  connect(ratV_flow.y[2], VChiWat_flow.u)
    annotation (Line(points={{-138,-140},{-82,-140}}, color={0,0,127}));
  connect(ctl.y1Hp, y1Hp_actual.y1)
    annotation (Line(points={{16,20},{28,20}}, color={255,0,255}));
  connect(y1Hp_actual.y1_actual, ctl.u1Hp_actual) annotation (Line(points={{52,
          20},{60,20},{60,40},{-20,40},{-20,16},{-16,16}}, color={255,0,255}));
  connect(ctl.y1PumHeaWatPri, y1PumHeaWatPri_actual1.y1) annotation (Line(
        points={{16,4},{20,4},{20,0},{58,0}},   color={255,0,255}));
  connect(ctl.y1PumChiWatPri, y1PumChiWatPri_actual.y1) annotation (Line(points={{16,2},{
          20,2},{20,-20},{28,-20}},           color={255,0,255}));
  connect(ctl.y1PumHeaWatSec, y1PumHeaWatSec_actual.y1) annotation (Line(points={{16,-2},
          {18,-2},{18,-40},{58,-40}},           color={255,0,255}));
  connect(ctl.y1PumChiWatSec, y1PumChiWatSec_actual.y1) annotation (Line(points={{16,-4},
          {16,-60},{28,-60}},                   color={255,0,255}));
  connect(y1PumHeaWatPri_actual1.y1_actual, ctl.u1PumHeaWatPri_actual)
    annotation (Line(points={{82,0},{84,0},{84,42},{-22,42},{-22,14},{-16,14}},
        color={255,0,255}));
  connect(y1PumHeaWatSec_actual.y1_actual, ctl.u1PumHeaWatSec_actual)
    annotation (Line(points={{82,-40},{88,-40},{88,46},{-26,46},{-26,10},{-16,10}},
        color={255,0,255}));
  connect(y1PumChiWatPri_actual.y1_actual, ctl.u1PumChiWatPri_actual)
    annotation (Line(points={{52,-20},{86,-20},{86,44},{-24,44},{-24,12},{-16,12}},
        color={255,0,255}));
  connect(y1PumChiWatSec_actual.y1_actual, ctl.u1PumChiWatSec_actual)
    annotation (Line(points={{52,-60},{90,-60},{90,48},{-28,48},{-28,8},{-16,8}},
        color={255,0,255}));
  connect(u1Ava.y, ctl.u1HpAva) annotation (Line(points={{-138,60},{-18,60},{-18,
          18},{-16,18}}, color={255,0,255}));
  connect(TOut.y, ctl.TOut) annotation (Line(points={{-138,-20},{-32,-20},{-32,-2},
          {-16,-2}}, color={0,0,127}));
  connect(ratV_flow.y[1], isDemHea.u) annotation (Line(points={{-138,-140},{
          -120,-140},{-120,40},{-112,40}}, color={0,0,127}));
  connect(ratV_flow.y[2], isDemCoo.u) annotation (Line(points={{-138,-140},{
          -120,-140},{-120,0},{-112,0}}, color={0,0,127}));
  connect(isDemCoo.y, reqPlaChiWat.u)
    annotation (Line(points={{-88,0},{-82,0}}, color={255,0,255}));
  connect(isDemHea.y, reqPlaHeaWat.u)
    annotation (Line(points={{-88,40},{-82,40}}, color={255,0,255}));
  connect(reqPlaHeaWat.y, ctl.nReqHeaWat) annotation (Line(points={{-58,40},{-40,
          40},{-40,4},{-16,4}},       color={255,127,0}));
  connect(reqPlaChiWat.y, ctl.nReqChiWat) annotation (Line(points={{-58,0},{-40,
          0},{-40,2},{-16,2}},   color={255,127,0}));
  connect(THeaWatRet.y, ctl.THeaWatSecRet) annotation (Line(points={{-138,-60},{
          -30,-60},{-30,-12},{-16,-12}}, color={0,0,127}));
  connect(THeaWatRet.y, ctl.THeaWatPriRet) annotation (Line(points={{-138,-60},{
          -30,-60},{-30,-4},{-16,-4}}, color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatSecRet) annotation (Line(points={{-138,-100},
          {-28,-100},{-28,-16.2},{-16,-16.2}}, color={0,0,127}));
  connect(TChiWatRet.y, ctl.TChiWatPriRet) annotation (Line(points={{-138,-100},
          {-28,-100},{-28,-8},{-16,-8}}, color={0,0,127}));
  connect(VHeaWat_flow.y, ctl.VHeaWatPri_flow) annotation (Line(points={{-88,
          -120},{-26,-120},{-26,-6},{-16,-6}}, color={0,0,127}));
  connect(VHeaWat_flow.y, ctl.VHeaWatSec_flow) annotation (Line(points={{-88,
          -120},{-26,-120},{-26,-14.2},{-16,-14.2}}, color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatPri_flow) annotation (Line(points={{-58,
          -140},{-24,-140},{-24,-10},{-16,-10}}, color={0,0,127}));
  connect(VChiWat_flow.y, ctl.VChiWatSec_flow) annotation (Line(points={{-58,
          -140},{-24,-140},{-24,-18},{-16,-18},{-16,-18.2}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-200,-200},{200,200}})));
end AirToWater;
