within Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Validation;
model EnableAndModeControl
  "Validation model for sidestream HRC enable and mode control"
  parameter Real cp_default(
    final min=0,
    final unit="J/(kg.K)")=4184
    "Default specific heat capacity used to compute required capacity";
  parameter Real rho_default(
    final min=0,
    final unit="kg/m3")=996
    "Default fluid density used to compute required capacity";
  parameter Real COPHea_nominal(
    final min=1.1,
    final unit="1")=2.8
    "Heating COP at design heating conditions"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real capHea_nominal(
    final unit="W")=1E6
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
    cp_default / rho_default
    "Design HW volume flow rate"
    annotation (Dialog(group="Nominal condition"));
  final parameter Real capCoo_nominal(
    final unit="W")=capHea_nominal *(1 - 1 / COPHea_nominal)
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
    cp_default / rho_default
    "Design CHW volume flow rate"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratV_flow(
    table=[
      0, 0, 0;
      5, 0, 0;
      6, 1, 0;
      15, 0, 1;
      22, 0, 0.1;
      24, 0, 0],
    timeScale=3600)
    "Source signal for volume flow rate ratio – Index 1 for HW, 2 for CHW"
    annotation (Placement(transformation(extent={{-150,-80},{-130,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatRet(
    final k=THeaWatRet_nominal,
    y(
      final unit="K",
      displayUnit="degC"))
    "HWRT"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRet(
    final k=TChiWatRet_nominal,
    y(
      final unit="K",
      displayUnit="degC"))
    "CHWRT"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VHeaWat_flow(
    final k=VHeaWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter VChiWat_flow(
    final k=VChiWat_flow_nominal)
    "Scale by design flow"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSup(
    final k=THeaWatSup_nominal,
    y(
      final unit="K",
      displayUnit="degC"))
    "HWST"
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSup(
    final k=TChiWatSup_nominal,
    y(
      final unit="K",
      displayUnit="degC"))
    "CHWST"
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold u1Hea
    "Compute heating plant enable signal"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold u1Coo
    "Compute cooling plant enable signal"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  StagingRotation.LoadAverage loaChiWat(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    final cp_default=cp_default,
    final rho_default=rho_default)
    "Available CHW load"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Enable ena(
    TChiWatSup_min=277.15,
    THeaWatSup_max=328.15,
    capCoo_min=0.3 * capCoo_nominal,
    capHea_min=0.3 * 0.3 * capHea_nominal)
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  StagingRotation.LoadAverage loaHeaWat(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    final cp_default=cp_default,
    final rho_default=rho_default)
    "Available HW load"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Components.Controls.StatusEmulator sta
    "Emulate HRC status"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  ModeControl setMod(
    COPHea_nominal=2.8)
    "Set mode"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin dTHeaWat(
    amplitude=THeaWatSup_nominal - THeaWatRet_nominal,
    freqHz=3 / 50000,
    offset=(THeaWatSup_nominal - THeaWatRet_nominal))
    "HW Delta_T across HRC condenser"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Controls.OBC.CDL.Reals.Add THeaWatHrcLvg
    "HRC leaving HWT"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Divide ratFlo
    "Flow ratio"
    annotation (Placement(transformation(extent={{-72,-150},{-52,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply dTRatFlo
    "HW Delta-T times flow ratio"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dTChiWat(
    k=-(1 - 1 / COPHea_nominal))
    "HRC leaving CHWT"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preMod
    "Previous mode setting"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Max bou
    "Bound to avoid division by zero"
    annotation (Placement(transformation(extent={{-110,-150},{-90,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cst(
    k=1E-4)
    "Constant"
    annotation (Placement(transformation(extent={{-150,-150},{-130,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Max bou1
    "Bound to avoid unrealistic values"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cst1(
    k=3 + 273.15)
    "Constant"
    annotation (Placement(transformation(extent={{30,80},{50,100}})));
  Buildings.Controls.OBC.CDL.Reals.Add TChiWatHrcLvg
    "HRC leaving CHWT"
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal staToReal
    "Convert status to real"
    annotation (Placement(transformation(extent={{-60,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply dTEna
    "Non-zero HW Delta-T when HRC on"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    nin=3)
    "Make status come and go at low load"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greLoaChiWat(
    final t=ena.capCoo_min)
    "True if load greater than minimum before cycling"
    annotation (Placement(transformation(extent={{30,-150},{50,-130}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greLoaHeaWat(
    final t=ena.capHea_min)
    "True if load greater than minimum before cycling"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
equation
  connect(ratV_flow.y[1], VHeaWat_flow.u)
    annotation (Line(points={{-128,-70},{-120,-70},{-120,-40},{-112,-40}},color={0,0,127}));
  connect(ratV_flow.y[2], VChiWat_flow.u)
    annotation (Line(points={{-128,-70},{-120,-70},{-120,-100},{-112,-100}},
      color={0,0,127}));
  connect(VHeaWat_flow.y, u1Hea.u)
    annotation (Line(points={{-88,-40},{-80,-40},{-80,-60},{-32,-60}},color={0,0,127}));
  connect(VChiWat_flow.y, u1Coo.u)
    annotation (Line(points={{-88,-100},{-32,-100}},color={0,0,127}));
  connect(TChiWatSup.y, loaChiWat.TSupSet)
    annotation (Line(points={{-128,20},{-50,20},{-50,6},{-32,6}},color={0,0,127}));
  connect(TChiWatRet.y, loaChiWat.TRet)
    annotation (Line(points={{-98,0},{-32,0}},color={0,0,127}));
  connect(THeaWatSup.y, loaHeaWat.TSupSet)
    annotation (Line(points={{-128,80},{-42,80},{-42,66},{-32,66}},color={0,0,127}));
  connect(THeaWatRet.y, loaHeaWat.TRet)
    annotation (Line(points={{-98,60},{-32,60}},color={0,0,127}));
  connect(VHeaWat_flow.y, loaHeaWat.V_flow)
    annotation (Line(points={{-88,-40},{-80,-40},{-80,54},{-32,54}},color={0,0,127}));
  connect(loaChiWat.QReq_flow, ena.QChiWatReq_flow)
    annotation (Line(points={{-8,0},{16,0},{16,28},{28,28}},color={0,0,127}));
  connect(loaHeaWat.QReq_flow, ena.QHeaWatReq_flow)
    annotation (Line(points={{-8,60},{8,60},{8,26},{28,26}},color={0,0,127}));
  connect(VChiWat_flow.y, loaChiWat.V_flow)
    annotation (Line(points={{-88,-100},{-70,-100},{-70,-6},{-32,-6}},color={0,0,127}));
  connect(u1Hea.y, ena.u1Hea)
    annotation (Line(points={{-8,-60},{12,-60},{12,36},{28,36}},color={255,0,255}));
  connect(u1Coo.y, ena.u1Coo)
    annotation (Line(points={{-8,-100},{10,-100},{10,38},{28,38}},color={255,0,255}));
  connect(ena.y1, sta.y1)
    annotation (Line(points={{52,30},{60,30},{60,40},{68,40}},color={255,0,255}));
  connect(ena.y1SetMod, setMod.u1SetMod)
    annotation (Line(points={{52,24},{60,24},{60,-12},{68,-12}},color={255,0,255}));
  connect(loaChiWat.QReq_flow, setMod.QChiWatReq_flow)
    annotation (Line(points={{-8,0},{16,0},{16,-16},{68,-16}},color={0,0,127}));
  connect(loaHeaWat.QReq_flow, setMod.QHeaWatReq_flow)
    annotation (Line(points={{-8,60},{8,60},{8,-20},{68,-20}},color={0,0,127}));
  connect(TChiWatSup.y, setMod.TChiWatSupSet)
    annotation (Line(points={{-128,20},{-50,20},{-50,-24},{68,-24}},color={0,0,127}));
  connect(THeaWatSup.y, setMod.THeaWatSupSet)
    annotation (Line(points={{-128,80},{-42,80},{-42,-28},{68,-28}},color={0,0,127}));
  connect(THeaWatRet.y, THeaWatHrcLvg.u2)
    annotation (Line(points={{-98,60},{-86,60},{-86,94},{-82,94}},color={0,0,127}));
  connect(THeaWatHrcLvg.y, ena.THeaWatHrcLvg)
    annotation (Line(points={{-58,100},{-40,100},{-40,22},{28,22}},color={0,0,127}));
  connect(VHeaWat_flow.y, ratFlo.u1)
    annotation (Line(points={{-88,-40},{-80,-40},{-80,-134},{-74,-134}},color={0,0,127}));
  connect(dTRatFlo.y, dTChiWat.u)
    annotation (Line(points={{-8,120},{-2,120}},color={0,0,127}));
  connect(setMod.y1Coo, preMod.u)
    annotation (Line(points={{92,-20},{96,-20},{96,-60},{52,-60}},color={255,0,255}));
  connect(preMod.y, ena.u1CooHrc)
    annotation (Line(points={{28,-60},{20,-60},{20,32},{28,32}},color={255,0,255}));
  connect(VChiWat_flow.y, bou.u1)
    annotation (Line(points={{-88,-100},{-70,-100},{-70,-120},{-120,-120},{-120,-134},{-112,-134}},
      color={0,0,127}));
  connect(cst.y, bou.u2)
    annotation (Line(points={{-128,-140},{-122,-140},{-122,-146},{-112,-146}},
      color={0,0,127}));
  connect(bou.y, ratFlo.u2)
    annotation (Line(points={{-88,-140},{-82,-140},{-82,-146},{-74,-146}},color={0,0,127}));
  connect(ratFlo.y, dTRatFlo.u2)
    annotation (Line(points={{-50,-140},{-40,-140},{-40,114},{-32,114}},color={0,0,127}));
  connect(TChiWatRet.y, TChiWatHrcLvg.u2)
    annotation (Line(points={{-98,0},{-66,0},{-66,86},{20,86},{20,114},{28,114}},
      color={0,0,127}));
  connect(bou1.y, ena.TChiWatHrcLvg)
    annotation (Line(points={{82,120},{90,120},{90,62},{18,62},{18,24},{28,24}},
      color={0,0,127}));
  connect(dTChiWat.y, TChiWatHrcLvg.u1)
    annotation (Line(points={{22,120},{26,120},{26,126},{28,126}},color={0,0,127}));
  connect(dTHeaWat.y, dTEna.u2)
    annotation (Line(points={{-128,120},{-120,120},{-120,114},{-112,114}},color={0,0,127}));
  connect(staToReal.y, dTEna.u1)
    annotation (Line(points={{-82,140},{-120,140},{-120,126},{-112,126}},color={0,0,127}));
  connect(dTEna.y, THeaWatHrcLvg.u1)
    annotation (Line(points={{-88,120},{-86,120},{-86,106},{-82,106}},color={0,0,127}));
  connect(dTEna.y, dTRatFlo.u1)
    annotation (Line(points={{-88,120},{-40,120},{-40,126},{-32,126}},color={0,0,127}));
  connect(TChiWatHrcLvg.y, bou1.u1)
    annotation (Line(points={{52,120},{56,120},{56,126},{58,126}},color={0,0,127}));
  connect(cst1.y, bou1.u2)
    annotation (Line(points={{52,90},{56,90},{56,114},{58,114}},color={0,0,127}));
  connect(sta.y1_actual, mulAnd.u[1])
    annotation (Line(points={{92,40},{96,40},{96,37.6667},{108,37.6667}},color={255,0,255}));
  connect(loaChiWat.QReq_flow, greLoaChiWat.u)
    annotation (Line(points={{-8,0},{0,0},{0,-140},{28,-140}},color={0,0,127}));
  connect(loaHeaWat.QReq_flow, greLoaHeaWat.u)
    annotation (Line(points={{-8,60},{8,60},{8,-100},{28,-100}},color={0,0,127}));
  connect(greLoaHeaWat.y, mulAnd.u[2])
    annotation (Line(points={{52,-100},{98,-100},{98,40},{108,40}},color={255,0,255}));
  connect(greLoaChiWat.y, mulAnd.u[3])
    annotation (Line(points={{52,-140},{100,-140},{100,42.3333},{108,42.3333}},
      color={255,0,255}));
  connect(mulAnd.y, ena.u1Hrc_actual)
    annotation (Line(points={{132,40},{140,40},{140,60},{20,60},{20,34},{28,34}},
      color={255,0,255}));
  connect(mulAnd.y, staToReal.u)
    annotation (Line(points={{132,40},{140,40},{140,140},{-58,140}},color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatRecoveryChillers/Validation/EnableAndModeControl.mos"
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
        extent={{-180,-180},{180,180}})),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Enable\">
Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Enable</a>
and 
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatRecoveryChillers.ModeControl\">
Buildings.Templates.Plants.Controls.HeatRecoveryChillers.ModeControl</a>.
Consequently, it also validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Controller\">
Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Controller</a>,
which is composed of the two former blocks.
</p>
<p>
The validation uses varying ∆T for HW across the HRC condenser 
and CHW across the HRC evaporator.
The model verifies that:
</p>
<ul>
<li>
The HRC is effectively disabled when it is controlled in cooling mode 
and the leaving HW temperature is high.
</li>
<li>
The HRC control mode switches from cooling to heating when the 
cooling load exceeds the calculated evaporator heat flow rate in heating mode.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableAndModeControl;
