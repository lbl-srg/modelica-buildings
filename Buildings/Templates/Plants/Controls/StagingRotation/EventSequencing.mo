within Buildings.Templates.Plants.Controls.StagingRotation;
block EventSequencing "Staging event sequencing"
  parameter Boolean is_php
    "Set to true for polyvalent heat pumps"
    annotation (Evaluate=true);
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation (Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation (Evaluate=true);
  parameter Boolean have_valInlIso
    "Set to true if the system as inlet isolation valves"
    annotation (Evaluate=true);
  parameter Boolean have_valOutIso
    "Set to true if the system as outlet isolation valves"
    annotation (Evaluate=true);
  parameter Boolean have_pumHeaWatPri(start=false)
    "Set to true for plants with primary HW pumps"
    annotation (Evaluate=true,
    Dialog(enable=have_heaWat));
  parameter Boolean have_pumChiWatPri(start=false)
    "Set to true for plants with separate primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(enable=have_chiWat));
  parameter Boolean have_pumHeaWatSec(start=false)
    "Set to true for plants with secondary HW pumps"
    annotation (Evaluate=true,
    Dialog(enable=have_heaWat));
  parameter Boolean have_pumChiWatSec(start=false)
    "Set to true for plants with secondary CHW pumps"
    annotation (Evaluate=true,
    Dialog(enable=have_chiWat));
  parameter Real dtVal(
    min=0,
    start=90,
    unit="s")=90
    "Nominal valve timing"
    annotation (Dialog(enable=have_valInlIso or have_valOutIso));
  parameter Real dtOff(
    min=0,
    unit="s")=180
    "Heat pump internal shutdown cycle timing";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea if have_heaWat
    "Enable command from heating mode sequence"
    annotation (Placement(transformation(extent={{-220,140},{-180,180}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual
    if have_heaWat and have_pumHeaWatPri
    "Primary HW pump status (dedicated or lead headered pump)"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual
    if have_chiWat and have_pumChiWatPri
    "Primary CHW pump status – Dedicated or lead headered pump"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual
    if have_heaWat and have_pumHeaWatSec
    "Lead headered secondary HW pump status"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual
    if have_chiWat and have_pumChiWatSec
    "Lead headered secondary CHW pump status"
    annotation (Placement(transformation(extent={{-220,-200},{-180,-160}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatInlIso
    if have_heaWat and have_valInlIso
    "Inlet HW inlet isolation valve command"
    annotation (Placement(transformation(extent={{180,20},{220,60}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatOutIso
    if have_heaWat and have_valOutIso
    "Outlet HW isolation valve command"
    annotation (Placement(transformation(extent={{180,0},{220,40}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatInlIso
    if have_chiWat and have_valInlIso
    "Inlet CHW isolation valve command"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatOutIso
    if have_chiWat and have_valOutIso
    "Outlet CHW isolation valve command"
    annotation (Placement(transformation(extent={{180,-40},{220,0}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPri
    if have_heaWat and have_pumHeaWatPri
    "Primary HW pump start command – Dedicated or lead headered pump"
    annotation (Placement(transformation(extent={{180,-80},{220,-40}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPri
    if have_chiWat and have_pumChiWatPri
    "Primary CHW pump start command – Dedicated or lead headered pump"
    annotation (Placement(transformation(extent={{180,-100},{220,-60}}),
      iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Equipment enable command"
    annotation (Placement(transformation(extent={{180,160},{220,200}}),
      iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea
    if have_heaWat and have_chiWat
    "Heating/cooling mode command: true=heating, false=cooling"
    annotation (Placement(transformation(extent={{180,140},{220,180}}),
      iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timValHea(final t=dtVal)
    if have_heaWat "Return true when nominal valve timing elapsed"
    annotation (Placement(transformation(extent={{-30,170},{-10,190}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd heaValPum(
    nin=4)
    "Return true if heating AND valve timing elapsed AND lead HW pumps on"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Or ena
    "Return true if enabled"
    annotation (Placement(transformation(extent={{140,170},{160,190}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd cooValPum(
    nin=4)
    "Return true if cooling AND valve timing elapsed AND lead CHW pumps on"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Utilities.PlaceholderLogical u1PumChiWatSec_internal(
    final have_inp=have_chiWat and have_pumChiWatSec,
    final have_inpPh=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-170,-190},{-150,-170}})));
  Utilities.PlaceholderLogical timValHea_internal(
    final have_inp=have_heaWat and (have_valInlIso or have_valOutIso),
    final have_inpPh=true,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{12,170},{32,190}})));
  Utilities.PlaceholderLogical u1PumHeaWatSec_internal(
    final have_inp=have_heaWat and have_pumHeaWatSec,
    final have_inpPh=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-170,-150},{-150,-130}})));
  Utilities.PlaceholderLogical u1PumChiWatPri_internal(
    final have_inp=have_chiWat and have_pumChiWatPri,
    final have_inpPh=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-170,-110},{-150,-90}})));
  Utilities.PlaceholderLogical u1PumHeaWatPri_internal(
    final have_inp=have_heaWat and have_pumHeaWatPri,
    final have_inpPh=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-170,-70},{-150,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    if have_chiWat
    "Enable command from cooling mode sequence"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Utilities.PlaceholderLogical u1Coo_internal(
    final have_inp=have_chiWat,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-170,70},{-150,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or u1HeaOrCoo
    "Return true if enabled from heating or cooling mode sequence"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Utilities.PlaceholderLogical u1Hea_internal(
    final have_inp=have_heaWat,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-170,150},{-150,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1AndHea
    if have_heaWat
    "Equipment commanded on in heating mode"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1AndCoo
    if have_chiWat
    "Equipment commanded on in cooling mode"
    annotation (Placement(transformation(extent={{180,60},{220,100}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rou(
    final nout=1)
    if have_pumChiWatPri
    "Signal routing for plants with dedicated primary CHW pumps"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rou1(
    final nout=1)
    if not have_pumChiWatPri
    "Signal routing for plants without dedicated primary CHW pumps"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Nor off
    "Return true if disabled from heating and cooling mode sequence"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timHp(final t=dtOff) if not is_php
    "Return true when heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latValHeaWatIso
    if have_heaWat
    "Keep valve open until heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latValChiWatIso
    if have_chiWat
    "Keep valve open until heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latPumHeaWatPri
    if have_heaWat
    "Keep pump running until heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latPumChiWatPri
    if have_chiWat and have_pumChiWatPri
    "Keep pump running until heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{150,-90},{170,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timValCoo(final t=dtVal)
    if have_chiWat "Return true when nominal valve timing elapsed"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
  Utilities.PlaceholderLogical timValCoo_internal(
    final have_inp=have_chiWat and (have_valInlIso or have_valOutIso),
    final have_inpPh=true,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{12,90},{32,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHea
    "Return true if disabled from heating sequence"
    annotation (Placement(transformation(extent={{-90,130},{-70,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCoo
    "Return true if disabled from cooling sequence"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd isPhpAndNotCooAndHea(nin=4)
    "Return true if polyvalent HP disabled for cooling and enabled for heating"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant isPhp(final k=is_php)
    "Return true in case of polyvalent HP"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or timHpOrPhpNotCooAndHea
    "Return true if HP shutdown cycle ended or polyvalent HP switching to cooling disabled"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd isPhpAndNotHeaAndCoo(nin=3)
    "Return true if polyvalent HP disabled for heating and enabled for cooling"
    annotation (Placement(transformation(extent={{-52,130},{-32,150}})));
  Buildings.Controls.OBC.CDL.Logical.Or timHpOrPhpNotHeaAndCoo
    "Return true if HP shutdown cycle ended or polyvalent HP switching to heating disabled"
    annotation (Placement(transformation(extent={{32,50},{52,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ShcHea if is_php
    "Enable command in SHC mode from heating mode sequence" annotation (
      Placement(transformation(extent={{-220,20},{-180,60}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ShcCoo if is_php
    "Enable command in SHC mode from cooling mode sequence" annotation (
      Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Utilities.PlaceholderLogical u1ShcHea_internal(
    final have_inp=is_php,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-170,30},{-150,50}})));
  Utilities.PlaceholderLogical u1ShcCoo_internal(
    final have_inp=is_php,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-170,-10},{-150,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr u1HeaOrShcHea(nin=2)
    "Return true if heating enabled"
    annotation (Placement(transformation(extent={{-130,150},{-110,170}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr u1CooOrShcCoo(nin=2)
    "Return true if cooling enabled"
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or u1Shc "Return true if SHC mode enabled"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
equation
  connect(heaValPum.y, ena.u1)
    annotation (Line(points={{102,140},{110,140},{110,180},{138,180}},
                                                                  color={255,0,255}));
  connect(cooValPum.y, ena.u2)
    annotation (Line(points={{102,80},{120,80},{120,172},{138,172}},
                                                              color={255,0,255}));
  connect(timValHea.passed, timValHea_internal.u) annotation (Line(points={{-8,172},
          {-4,172},{-4,180},{10,180}},         color={255,0,255}));
  connect(u1PumChiWatSec_actual, u1PumChiWatSec_internal.u)
    annotation (Line(points={{-200,-180},{-172,-180}},color={255,0,255}));
  connect(u1PumHeaWatPri_actual, u1PumHeaWatPri_internal.u)
    annotation (Line(points={{-200,-60},{-172,-60}},color={255,0,255}));
  connect(u1PumChiWatPri_actual, u1PumChiWatPri_internal.u)
    annotation (Line(points={{-200,-100},{-172,-100}},
                                                    color={255,0,255}));
  connect(u1PumHeaWatSec_actual, u1PumHeaWatSec_internal.u)
    annotation (Line(points={{-200,-140},{-172,-140}},
                                                    color={255,0,255}));
  connect(u1PumHeaWatPri_internal.y, heaValPum.u[1])
    annotation (Line(points={{-148,-60},{66,-60},{66,137.375},{78,137.375}},
                                                                    color={255,0,255}));
  connect(u1PumHeaWatSec_internal.y, heaValPum.u[2])
    annotation (Line(points={{-148,-140},{70,-140},{70,139.125},{78,139.125}},
      color={255,0,255}));
  connect(u1PumChiWatPri_internal.y, cooValPum.u[1])
    annotation (Line(points={{-148,-100},{68,-100},{68,77.375},{78,77.375}},
                                                                          color={255,0,255}));
  connect(u1PumChiWatSec_internal.y, cooValPum.u[2])
    annotation (Line(points={{-148,-180},{72,-180},{72,79.125},{78,79.125}},
      color={255,0,255}));
  connect(ena.y, y1)
    annotation (Line(points={{162,180},{200,180}},                    color={255,0,255}));
  connect(u1Hea, u1Hea_internal.u)
    annotation (Line(points={{-200,160},{-172,160}},color={255,0,255}));
  connect(u1Coo, u1Coo_internal.u)
    annotation (Line(points={{-200,80},{-172,80}},color={255,0,255}));
  connect(u1HeaOrCoo.y, rou1.u)
    annotation (Line(points={{-68,-40},{-52,-40}},                   color={255,0,255}));
  connect(off.y, timHp.u)
    annotation (Line(points={{-68,20},{-32,20}},color={255,0,255}));
  connect(latValHeaWatIso.y, y1ValHeaWatInlIso)
    annotation (Line(points={{142,40},{200,40}},color={255,0,255}));
  connect(latValChiWatIso.y, y1ValChiWatInlIso)
    annotation (Line(points={{142,0},{200,0}},color={255,0,255}));
  connect(latValHeaWatIso.y, y1ValHeaWatOutIso)
    annotation (Line(points={{142,40},{160,40},{160,20},{200,20}},color={255,0,255}));
  connect(latValChiWatIso.y, y1ValChiWatOutIso)
    annotation (Line(points={{142,0},{160,0},{160,-20},{200,-20}},color={255,0,255}));
  connect(rou1.y[1], latPumHeaWatPri.u)
    annotation (Line(points={{-28,-40},{80,-40},{80,-60},{118,-60}},
                                                color={255,0,255}));
  connect(rou.y[1], latPumHeaWatPri.u)
    annotation (Line(points={{2,-20},{80,-20},{80,-60},{118,-60}},color={255,0,255}));
  connect(latPumHeaWatPri.y, y1PumHeaWatPri)
    annotation (Line(points={{142,-60},{200,-60}},                    color={255,0,255}));
  connect(latPumChiWatPri.y, y1PumChiWatPri)
    annotation (Line(points={{172,-80},{200,-80}},color={255,0,255}));
  connect(heaValPum.y, y1AndHea) annotation (Line(points={{102,140},{110,140},{
          110,100},{200,100}},
                           color={255,0,255}));
  connect(cooValPum.y, y1AndCoo)
    annotation (Line(points={{102,80},{200,80}},color={255,0,255}));
  connect(timValCoo.passed, timValCoo_internal.u) annotation (Line(points={{-8,92},
          {-4,92},{-4,100},{10,100}},        color={255,0,255}));
  connect(timValHea_internal.y, heaValPum.u[3]) annotation (Line(points={{34,180},
          {68,180},{68,142},{78,142},{78,140.875}},      color={255,0,255}));
  connect(timValCoo_internal.y, cooValPum.u[3]) annotation (Line(points={{34,100},
          {60,100},{60,80.875},{78,80.875}},      color={255,0,255}));
  connect(timHp.passed, timHpOrPhpNotCooAndHea.u2)
    annotation (Line(points={{-8,12},{28,12}}, color={255,0,255}));
  connect(timHpOrPhpNotCooAndHea.y, latValChiWatIso.clr) annotation (Line(
        points={{52,20},{100,20},{100,-6},{118,-6}}, color={255,0,255}));
  connect(timHpOrPhpNotCooAndHea.y, latPumChiWatPri.clr) annotation (Line(
        points={{52,20},{100,20},{100,-86},{148,-86}},   color={255,0,255}));
  connect(isPhpAndNotCooAndHea.y, timHpOrPhpNotCooAndHea.u1) annotation (Line(
        points={{-28,60},{0,60},{0,20},{28,20}}, color={255,0,255}));
  connect(isPhp.y, isPhpAndNotCooAndHea.u[1]) annotation (Line(points={{-148,
          120},{-60,120},{-60,57.375},{-52,57.375}},   color={255,0,255}));
  connect(notCoo.y, isPhpAndNotCooAndHea.u[2]) annotation (Line(points={{-68,60},
          {-60,60},{-60,59.125},{-52,59.125}},
                                       color={255,0,255}));
  connect(isPhp.y, isPhpAndNotHeaAndCoo.u[1]) annotation (Line(points={{-148,
          120},{-60,120},{-60,137.667},{-54,137.667}}, color={255,0,255}));
  connect(notHea.y, isPhpAndNotHeaAndCoo.u[2]) annotation (Line(points={{-68,
          140},{-62,140},{-62,140},{-54,140}}, color={255,0,255}));
  connect(timHp.passed, timHpOrPhpNotHeaAndCoo.u2) annotation (Line(points={{-8,
          12},{20,12},{20,52},{30,52}}, color={255,0,255}));
  connect(isPhpAndNotHeaAndCoo.y, timHpOrPhpNotHeaAndCoo.u1) annotation (Line(
        points={{-30,140},{6,140},{6,60},{30,60}}, color={255,0,255}));
  connect(timHpOrPhpNotHeaAndCoo.y, latValHeaWatIso.clr) annotation (Line(
        points={{54,60},{110,60},{110,34},{118,34}}, color={255,0,255}));
  connect(timHpOrPhpNotHeaAndCoo.y, latPumHeaWatPri.clr) annotation (Line(
        points={{54,60},{110,60},{110,-66},{118,-66}}, color={255,0,255}));
  connect(u1ShcHea, u1ShcHea_internal.u)
    annotation (Line(points={{-200,40},{-172,40}}, color={255,0,255}));
  connect(u1ShcCoo, u1ShcCoo_internal.u)
    annotation (Line(points={{-200,0},{-172,0}}, color={255,0,255}));
  connect(u1HeaOrShcHea.y, timValHea.u) annotation (Line(points={{-108,160},{
          -40,160},{-40,180},{-32,180}}, color={255,0,255}));
  connect(u1HeaOrShcHea.y, y1Hea)
    annotation (Line(points={{-108,160},{200,160}}, color={255,0,255}));
  connect(u1HeaOrShcHea.y, timValHea_internal.uPh) annotation (Line(points={{
          -108,160},{0,160},{0,174},{10,174}}, color={255,0,255}));
  connect(u1HeaOrShcHea.y, notHea.u) annotation (Line(points={{-108,160},{-100,
          160},{-100,140},{-92,140}}, color={255,0,255}));
  connect(u1HeaOrShcHea.y, isPhpAndNotCooAndHea.u[3]) annotation (Line(points={{-108,
          160},{-100,160},{-100,46},{-60,46},{-60,60.875},{-52,60.875}},
        color={255,0,255}));
  connect(u1HeaOrShcHea.y, off.u1) annotation (Line(points={{-108,160},{-100,
          160},{-100,20},{-92,20}}, color={255,0,255}));
  connect(u1HeaOrShcHea.y, rou.u) annotation (Line(points={{-108,160},{-100,160},
          {-100,-20},{-22,-20}}, color={255,0,255}));
  connect(u1HeaOrShcHea.y, heaValPum.u[4]) annotation (Line(points={{-108,160},
          {66,160},{66,142.625},{78,142.625},{78,142.625}},
                                                          color={255,0,255}));
  connect(u1HeaOrShcHea.y, u1HeaOrCoo.u1) annotation (Line(points={{-108,160},{
          -100,160},{-100,-40},{-92,-40}}, color={255,0,255}));
  connect(u1CooOrShcCoo.y, isPhpAndNotHeaAndCoo.u[3]) annotation (Line(points={{-108,80},
          {-62,80},{-62,142.333},{-54,142.333}},           color={255,0,255}));
  connect(u1CooOrShcCoo.y, timValCoo.u) annotation (Line(points={{-108,80},{-40,
          80},{-40,100},{-32,100}}, color={255,0,255}));
  connect(u1CooOrShcCoo.y, timValCoo_internal.uPh) annotation (Line(points={{
          -108,80},{0,80},{0,94},{10,94}}, color={255,0,255}));
  connect(u1CooOrShcCoo.y, cooValPum.u[4]) annotation (Line(points={{-108,80},{
          78,80},{78,82.625}}, color={255,0,255}));
  connect(u1CooOrShcCoo.y, notCoo.u) annotation (Line(points={{-108,80},{-104,
          80},{-104,60},{-92,60}}, color={255,0,255}));
  connect(u1CooOrShcCoo.y, off.u2) annotation (Line(points={{-108,80},{-104,80},
          {-104,12},{-92,12}}, color={255,0,255}));
  connect(u1CooOrShcCoo.y, u1HeaOrCoo.u2) annotation (Line(points={{-108,80},{
          -104,80},{-104,-48},{-92,-48}}, color={255,0,255}));
  connect(u1Hea_internal.y, u1HeaOrShcHea.u[1]) annotation (Line(points={{-148,
          160},{-140,160},{-140,158.25},{-132,158.25}},   color={255,0,255}));
  connect(u1Coo_internal.y, u1CooOrShcCoo.u[1]) annotation (Line(points={{-148,80},
          {-140,80},{-140,78.25},{-132,78.25}},         color={255,0,255}));
  connect(u1CooOrShcCoo.y, latValChiWatIso.u) annotation (Line(points={{-108,80},
          {-104,80},{-104,0},{118,0}}, color={255,0,255}));
  connect(u1HeaOrShcHea.y, isPhpAndNotCooAndHea.u[4]) annotation (Line(points={
          {-108,160},{-100,160},{-100,46},{-60,46},{-60,62.3333},{-52,62.3333},
          {-52,62.625}}, color={255,0,255}));
  connect(u1HeaOrShcHea.y, latValHeaWatIso.u) annotation (Line(points={{-108,
          160},{-100,160},{-100,40},{118,40}}, color={255,0,255}));
  connect(u1CooOrShcCoo.y, latPumChiWatPri.u) annotation (Line(points={{-108,80},
          {-104,80},{-104,-80},{148,-80}}, color={255,0,255}));
  connect(u1ShcHea_internal.y, u1Shc.u1) annotation (Line(points={{-148,40},{
          -146,40},{-146,20},{-142,20}}, color={255,0,255}));
  connect(u1ShcCoo_internal.y, u1Shc.u2) annotation (Line(points={{-148,0},{
          -146,0},{-146,12},{-142,12}}, color={255,0,255}));
  connect(u1Shc.y, u1CooOrShcCoo.u[2]) annotation (Line(points={{-118,20},{-112,
          20},{-112,60},{-140,60},{-140,81.75},{-132,81.75}}, color={255,0,255}));
  connect(u1Shc.y, u1HeaOrShcHea.u[2]) annotation (Line(points={{-118,20},{-112,
          20},{-112,60},{-140,60},{-140,161.75},{-132,161.75}}, color={255,0,
          255}));
  annotation (
    defaultComponentName="seqEve",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-140},{100,140}},
        grid={2,2}),
      graphics={
        Rectangle(
          extent={{-100,140},{100,-142}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,190},{150,150}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-180,-200},{180,200}}, grid={2,2})),
    Documentation(
      info="<html>
<p>
If a heat pump is commanded on in a desired heating or cooling mode:
</p>
<ul>
<li>
The isolation valves for desired heating or cooling mode are commanded
open.
</li>
<li>
<b>Plants with dedicated primary pumps</b>:
The dedicated primary pumps are commanded on when the 
associated isolation valves are commanded open.
</li>
<li>
<b>Plants with headered primary pumps</b>:
The headered primary pumps are commanded on as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>.
</li>
<li>
Once the isolation valves are fully open (based on nominal valve timing <code>dtVal</code>)
and the lead pumps are proven on, the heat pump is enabled in heating or cooling
mode.
</li>
</ul>
<p>
If a heat pump is commanded off:
</p>
<ul>
<li>
The heat pump is disabled.
</li>
<li>
After the time required for the internal shutdown cycle to time out 
(<code>dtOff</code> to be determined empirically, defaulting to <i>3</i>&nbsp;min),
all isolation valves are commanded closed.
</li>
<li>
<b>Plants with dedicated primary pumps</b>:
The dedicated primary pumps are commanded off when the associated
isolation valves are commanded closed.
</li>
<li>
<b>Plants with headered primary pumps</b>:
The headered primary pumps are commanded off as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>.
</li>
</ul>
<h5>Polyvalent heat pumps</h5>
<p>
In addition to the above logic, when the polyvalent heat pump 
switches operating mode:
<ul>
<li>
The isolation valves of the disabled side are commanded closed
without delay
</li>
<li>
<b>Plants with dedicated primary pumps</b>:
The dedicated primary pumps of the disabled side are commanded 
off when the associated isolation valves are commanded closed.
</li>
<li>
<b>Plants with headered primary pumps</b>:
The headered primary pumps of the disabled side are commanded off 
as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>.
</li>
</ul>
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end EventSequencing;
