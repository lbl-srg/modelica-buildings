within Buildings.Templates.Plants.Controls.HeatRecoveryChillers;
block Controller
  parameter Boolean have_reqFlo=false
    "Set to true if HRC provides flow request point via network interface"
    annotation (Evaluate=true);
  parameter Real TChiWatSup_min(
    min=273.15,
    start=4 + 273.15,
    unit="K",
    displayUnit="degC")
    "Minimum allowable CHW supply temperature"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real THeaWatSup_max(
    min=273.15,
    start=60 + 273.15,
    unit="K",
    displayUnit="degC")
    "Maximum allowable HW supply temperature"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real COPHea_nominal(
    min=1.1,
    unit="1")
    "Heating COP at design heating conditions"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real capCoo_min(
    min=0,
    unit="W")
    "Minimum cooling capacity below which cycling occurs"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real capHea_min(
    min=0,
    unit="W")
    "Minimum heating capacity below which cycling occurs"
    annotation (Dialog(group="Information provided by designer"));
  parameter Real cp_default(
    min=0,
    unit="J/(kg.K)")
    "Default specific heat capacity used to compute required capacity";
  parameter Real rho_default(
    min=0,
    unit="kg/m3")
    "Default fluid density used to compute required capacity";
  parameter Real dtMea(
    min=0,
    unit="s")=300
    "Duration used to compute the moving average of required capacity";
  parameter Real dtRun(
    min=0,
    unit="s")=15 * 60
    "Minimum runtime of enable and disable states";
  parameter Real dtLoa(
    min=0,
    unit="s")=10 * 60
    "Runtime with sufficient load before enabling";
  parameter Real dtTem1(
    min=0,
    unit="s")=3 * 60
    "Runtime with first temperature threshold exceeded before disabling";
  parameter Real dtTem2(
    min=0,
    unit="s")=1 * 60
    "Runtime with second temperature threshold exceeded before disabling";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRetUpsHrc(
    final unit="K",
    displayUnit="degC")
    "CHW return temperature upstream of HRC"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Active CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatLoa_flow(
    final unit="m3/s") "CHW volume flow rate distributed to the loads"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatRetUpsHrc(
    final unit="K",
    displayUnit="degC")
    "HW return temperature upstream of HRC"
    annotation (Placement(transformation(extent={{-160,-180},{-120,-140}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Active HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWatLoa_flow(
    final unit="m3/s") "HW volume flow rate distributed to the loads"
    annotation (Placement(transformation(extent={{-160,-220},{-120,-180}}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));
  StagingRotation.LoadAverage loaChiWat(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    final cp_default=cp_default,
    final rho_default=rho_default,
    final dtMea=dtMea)
    "CHW load"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  StagingRotation.LoadAverage loaHeaWat(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    final cp_default=cp_default,
    final rho_default=rho_default,
    final dtMea=dtMea)
    "HW load"
    annotation (Placement(transformation(extent={{-90,-170},{-70,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatHrcLvg(
    final unit="K",
    displayUnit="degC")
    "HRC leaving CHW temperature"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatHrcLvg(
    final unit="K",
    displayUnit="degC")
    "HRC leaving HW temperature"
    annotation (Placement(transformation(extent={{-160,-140},{-120,-100}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    "Cooling plant enable"
    annotation (Placement(transformation(extent={{-160,180},{-120,220}}),
      iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating plant enable"
    annotation (Placement(transformation(extent={{-160,160},{-120,200}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hrc_actual
    "HRC status"
    annotation (Placement(transformation(extent={{-160,140},{-120,180}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ReqFloChiWat
    if have_reqFlo
    "CHW flow request from HRC"
    annotation (Placement(transformation(extent={{-160,120},{-120,160}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ReqFloConWat
    if have_reqFlo
    "CW flow request from HRC"
    annotation (Placement(transformation(extent={{-160,100},{-120,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Enable command"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo
    "Mode command: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{120,-60},{160,-20}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWat
    "HRC CHW pump enable command"
    annotation (Placement(transformation(extent={{120,100},{160,140}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWat
    "HRC HW pump enable command"
    annotation (Placement(transformation(extent={{120,60},{160,100}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Active supply temperature setpoint"
    annotation (Placement(transformation(extent={{120,-100},{160,-60}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Enable ena(
    final TChiWatSup_min=TChiWatSup_min,
    final THeaWatSup_max=THeaWatSup_max,
    final capCoo_min=capCoo_min,
    final capHea_min=capHea_min,
    final dtLoa=dtLoa,
    final dtRun=dtRun,
    final dtTem1=dtTem1,
    final dtTem2=dtTem2)
    "Compute enable command"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  ModeControl setMod(
    final COPHea_nominal=COPHea_nominal)
    "Set mode"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Pumps.Primary.EnableDedicated pumChiWat(
    final have_reqFlo=have_reqFlo)
    "CHW pump control"
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Pumps.Primary.EnableDedicated pumHeaWat(
    final have_reqFlo=have_reqFlo)
    "HW pump control"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preMod
    "Previous mode setting"
    annotation (Placement(transformation(extent={{50,-30},{30,-10}})));
equation
  connect(TChiWatSupSet, loaChiWat.TSupSet)
    annotation (Line(points={{-140,80},{-100,80},{-100,6},{-92,6}},color={0,0,127}));
  connect(TChiWatRetUpsHrc, loaChiWat.TRet)
    annotation (Line(points={{-140,0},{-92,0}},color={0,0,127}));
  connect(VChiWatLoa_flow, loaChiWat.V_flow)
    annotation (Line(points={{-140,-40},{-98,-40},{-98,-6},{-92,-6}},color={0,0,127}));
  connect(THeaWatSupSet, loaHeaWat.TSupSet)
    annotation (Line(points={{-140,-80},{-100,-80},{-100,-154},{-92,-154}},color={0,0,127}));
  connect(THeaWatRetUpsHrc, loaHeaWat.TRet)
    annotation (Line(points={{-140,-160},{-92,-160}},color={0,0,127}));
  connect(VHeaWatLoa_flow, loaHeaWat.V_flow)
    annotation (Line(points={{-140,-200},{-100,-200},{-100,-166},{-92,-166}},
      color={0,0,127}));
  connect(u1Coo, ena.u1Coo)
    annotation (Line(points={{-140,200},{-40,200},{-40,8},{-32,8}},color={255,0,255}));
  connect(u1Hea, ena.u1Hea)
    annotation (Line(points={{-140,180},{-42,180},{-42,6},{-32,6}},color={255,0,255}));
  connect(u1Hrc_actual, ena.u1Hrc_actual)
    annotation (Line(points={{-140,160},{-44,160},{-44,4},{-32,4}},color={255,0,255}));
  connect(loaChiWat.QReq_flow, ena.QChiWatReq_flow)
    annotation (Line(points={{-68,0},{-60,0},{-60,-2},{-32,-2}},color={0,0,127}));
  connect(loaHeaWat.QReq_flow, ena.QHeaWatReq_flow)
    annotation (Line(points={{-68,-160},{-64,-160},{-64,-4},{-32,-4}},color={0,0,127}));
  connect(TChiWatHrcLvg, ena.TChiWatHrcLvg)
    annotation (Line(points={{-140,40},{-62,40},{-62,-6},{-32,-6}},color={0,0,127}));
  connect(THeaWatHrcLvg, ena.THeaWatHrcLvg)
    annotation (Line(points={{-140,-120},{-62,-120},{-62,-8},{-32,-8}},color={0,0,127}));
  connect(loaChiWat.QReq_flow, setMod.QChiWatReq_flow)
    annotation (Line(points={{-68,0},{-60,0},{-60,-56},{28,-56}},color={0,0,127}));
  connect(loaHeaWat.QReq_flow, setMod.QHeaWatReq_flow)
    annotation (Line(points={{-68,-160},{-64,-160},{-64,-60},{28,-60}},color={0,0,127}));
  connect(TChiWatSupSet, setMod.TChiWatSupSet)
    annotation (Line(points={{-140,80},{-100,80},{-100,-64},{28,-64}},color={0,0,127}));
  connect(THeaWatSupSet, setMod.THeaWatSupSet)
    annotation (Line(points={{-140,-80},{-100,-80},{-100,-68},{28,-68}},color={0,0,127}));
  connect(setMod.y1Coo, y1Coo)
    annotation (Line(points={{52,-60},{60,-60},{60,-40},{140,-40}},color={255,0,255}));
  connect(setMod.TSupSet, TSupSet)
    annotation (Line(points={{52,-66},{60,-66},{60,-80},{140,-80}},color={0,0,127}));
  connect(ena.y1, y1)
    annotation (Line(points={{-8,0},{140,0}},color={255,0,255}));
  connect(ena.y1SetMod, setMod.u1SetMod)
    annotation (Line(points={{-8,-6},{0,-6},{0,-52},{28,-52}},color={255,0,255}));
  connect(ena.y1, pumChiWat.u1)
    annotation (Line(points={{-8,0},{0,0},{0,128},{28,128}},color={255,0,255}));
  connect(ena.y1, pumChiWat.u1Equ)
    annotation (Line(points={{-8,0},{0,0},{0,124},{28,124}},color={255,0,255}));
  connect(u1ReqFloChiWat, pumChiWat.u1ReqFlo)
    annotation (Line(points={{-140,140},{20,140},{20,116},{28,116}},color={255,0,255}));
  connect(u1Hrc_actual, pumChiWat.u1Equ_actual)
    annotation (Line(points={{-140,160},{22,160},{22,120},{28,120}},color={255,0,255}));
  connect(ena.y1, pumHeaWat.u1)
    annotation (Line(points={{-8,0},{0,0},{0,88},{28,88}},color={255,0,255}));
  connect(ena.y1, pumHeaWat.u1Equ)
    annotation (Line(points={{-8,0},{0,0},{0,84},{28,84}},color={255,0,255}));
  connect(u1ReqFloConWat, pumHeaWat.u1ReqFlo)
    annotation (Line(points={{-140,120},{18,120},{18,76},{28,76}},color={255,0,255}));
  connect(u1Hrc_actual, pumHeaWat.u1Equ_actual)
    annotation (Line(points={{-140,160},{22,160},{22,80},{28,80}},color={255,0,255}));
  connect(pumHeaWat.y1, y1PumHeaWat)
    annotation (Line(points={{52,80},{140,80}},color={255,0,255}));
  connect(pumChiWat.y1, y1PumChiWat)
    annotation (Line(points={{52,120},{140,120}},color={255,0,255}));
  connect(setMod.y1Coo, preMod.u)
    annotation (Line(points={{52,-60},{60,-60},{60,-20},{52,-20}},color={255,0,255}));
  connect(preMod.y, ena.u1CooHrc)
    annotation (Line(points={{28,-20},{-40,-20},{-40,2},{-32,2}},color={255,0,255}));
  annotation (
    Diagram(
      coordinateSystem(
        extent={{-120,-220},{120,220}})),
    defaultComponentName="ctlHrc",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-160},{100,160}}),
      graphics={
        Rectangle(
          extent={{-100,160},{100,-160}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,210},{150,170}},
          textString="%name",
          textColor={0,0,255})}));
end Controller;
