within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block EventSequencingSingle
  "Staging event sequencing for a single heat pump"
  parameter Boolean is_php = false
    "Set to true for polyvalent heat pumps"
    annotation(Evaluate=true);
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation(Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true);
  parameter Boolean have_valInlIso
    "Set to true if the system has inlet isolation valves"
    annotation(Evaluate=true);
  parameter Boolean have_valOutIso
    "Set to true if the system has outlet isolation valves"
    annotation(Evaluate=true);
  parameter Boolean have_pumHeaWatPri(start=false)
    "Set to true for plants with primary HW pumps"
    annotation(Evaluate=true,
      Dialog(enable=have_heaWat));
  parameter Boolean have_pumChiWatPri(start=false)
    "Set to true for plants with separate primary CHW pumps"
    annotation(Evaluate=true,
      Dialog(enable=have_chiWat));
  parameter Real dtVal(min=0, start=90, unit="s") = 90
    "Nominal valve timing"
    annotation(Dialog(enable=have_valInlIso or have_valOutIso));
  parameter Real dtOff(min=0, unit="s") = 180
    "Heat pump internal shutdown cycle timing";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Shc
    if is_php
    "Enable command in SHC mode"
    annotation(Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    if have_heaWat
    "Enable command from heating mode sequence"
    annotation(Placement(transformation(extent={{-260,100},{-220,140}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual
    if have_heaWat and have_pumHeaWatPri
    "Primary HW pump status – Lead headered or dedicated pump"
    annotation(Placement(transformation(extent={{-260,-180},{-220,-140}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual
    if have_chiWat and have_pumChiWatPri
    "Primary CHW pump status – Lead headered or dedicated pump"
    annotation(Placement(transformation(extent={{-260,-200},{-220,-160}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatInlIso
    if have_heaWat
    "Inlet HW isolation valve command"
    annotation(Placement(transformation(extent={{220,-60},{260,-20}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatOutIso
    if have_heaWat
    "Outlet HW isolation valve command"
    annotation(Placement(transformation(extent={{220,-80},{260,-40}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatInlIso
    if have_chiWat
    "Inlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{220,-100},{260,-60}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatOutIso
    if have_chiWat
    "Outlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{220,-120},{260,-80}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPri
    "Primary HW pump request to pump staging logic"
    annotation(Placement(transformation(extent={{220,-140},{260,-100}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPri
    "Primary CHW pump request to pump staging logic"
    annotation(Placement(transformation(extent={{220,-160},{260,-120}}),
      iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Enable command"
    annotation(Placement(transformation(extent={{220,160},{260,200}}),
      iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea
    if have_heaWat and have_chiWat
    "Heating mode command"
    annotation(Placement(transformation(extent={{220,140},{260,180}}),
      iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    if have_chiWat
    "Enable command from cooling mode sequence"
    annotation(Placement(transformation(extent={{-260,60},{-220,100}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1AndHea
    if have_heaWat
    "Equipment commanded on in heating mode"
    annotation(Placement(transformation(extent={{220,80},{260,120}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1AndCoo
    if have_chiWat
    "Equipment commanded on in cooling mode"
    annotation(Placement(transformation(extent={{220,40},{260,80}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timValHea(final t=dtVal)
    if have_heaWat and (have_valInlIso or have_valOutIso)
    "Return true when nominal valve timing elapsed"
    annotation(Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd heaValPum(nin=3)
    "Return true if heating AND valve timing elapsed AND lead HW pumps on"
    annotation(Placement(transformation(extent={{70,130},{90,150}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCooMet
    "True if either heating or cooling enable clause met"
    annotation(Placement(transformation(extent={{180,170},{200,190}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd cooValPum(nin=3)
    "Return true if cooling AND valve timing elapsed AND lead CHW pumps on"
    annotation(Placement(transformation(extent={{70,70},{90,90}})));
  Utilities.PlaceholderLogical timValHea_internal(
    final have_inp=have_heaWat and (have_valInlIso or have_valOutIso),
    final have_inpPh=true,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{20,130},{40,150}})));
  Utilities.PlaceholderLogical u1Coo_internal(
    final have_inp=have_chiWat,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{-210,70},{-190,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or u1HeaOrCoo
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Return true if enabled from heating or cooling mode sequence"
    annotation(Placement(transformation(extent={{-110,-130},{-90,-110}})));
  Utilities.PlaceholderLogical u1Hea_internal(
    final have_inp=have_heaWat,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{-210,110},{-190,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rou(final nout=1)
    if have_heaWat and (have_chiWat and have_pumChiWatPri or not have_chiWat)
    "Signal routing for plants with dedicated primary CHW pumps"
    annotation(Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rou1(final nout=1)
    if have_heaWat and have_chiWat and not have_pumChiWatPri
    "Signal routing for plants without dedicated primary CHW pumps"
    annotation(Placement(transformation(extent={{-70,-130},{-50,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Nor off
    "Return true if disabled from heating and cooling mode sequence"
    annotation(Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timHp(final t=dtOff)
    "Return true when heat pump internal shutdown cycle times out"
    annotation(Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latValHeaWatIso
    if have_heaWat
    "Keep valve open until heat pump internal shutdown cycle times out"
    annotation(Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latValChiWatIso
    if have_chiWat
    "Keep valve open until heat pump internal shutdown cycle times out"
    annotation(Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latPumHeaWatPri
    if have_heaWat
    "Keep pump running until heat pump internal shutdown cycle times out"
    annotation(Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latPumChiWatPri
    if have_chiWat and have_pumChiWatPri
    "Keep pump running until heat pump internal shutdown cycle times out"
    annotation(Placement(transformation(extent={{130,-150},{150,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timValCoo(final t=dtVal)
    if have_chiWat and (have_valInlIso or have_valOutIso)
    "Return true when nominal valve timing elapsed"
    annotation(Placement(transformation(extent={{-20,50},{0,70}})));
  Utilities.PlaceholderLogical timValCoo_internal(
    final have_inp=have_chiWat and (have_valInlIso or have_valOutIso),
    final have_inpPh=true,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHea
    "Return true if disabled from heating sequence"
    annotation(Placement(transformation(extent={{-110,10},{-90,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCoo
    "Return true if disabled from cooling sequence"
    annotation(Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd isPhpAndNotCooAndHea(nin=3)
    "Return true if polyvalent HP disabled for cooling and enabled for heating"
    annotation(Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or timHpOrPhpNotCooAndHea
    "Return true if HP shutdown cycle ended or polyvalent HP switching to cooling disabled"
    annotation(Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd isPhpAndNotHeaAndCoo(nin=3)
    "Return true if polyvalent HP disabled for heating and enabled for cooling"
    annotation(Placement(transformation(extent={{-50,10},{-30,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or timHpOrPhpNotHeaAndCoo
    "Return true if HP shutdown cycle ended or polyvalent HP switching to heating disabled"
    annotation(Placement(transformation(extent={{10,-30},{30,-10}})));
  Utilities.PlaceholderLogical u1ShcHea_internal(
    final have_inp=is_php,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{-210,30},{-190,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or u1HeaOrShcHea
    "Return true if heating enabled"
    annotation(Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or u1CooOrShcCoo
    "Return true if cooling enabled"
    annotation(Placement(transformation(extent={{-150,70},{-130,90}})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndCooMet
    "True if both heating and cooling enable clauses met"
    annotation(Placement(transformation(extent={{110,130},{130,150}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1AndHeaPre
    if have_heaWat and have_chiWat
    "True if heating previously enabled"
    annotation(Placement(transformation(extent={{200,130},{180,150}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1AndCooPre
    if have_heaWat and have_chiWat
    "True if cooling previously enabled"
    annotation(Placement(transformation(extent={{200,10},{180,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiShcHea
    "Switch to conditions on both modes being met to transition from off to SHC"
    annotation(Placement(transformation(extent={{140,90},{160,110}})));
  Buildings.Controls.OBC.CDL.Logical.Nor offPre
    if have_heaWat and have_chiWat
    "True if heating and cooling previously disabled"
    annotation(Placement(transformation(extent={{160,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Logical.And u1ShcAndOffPre
    "True if SHC command with heating and cooling previously disabled"
    annotation(Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiShcCoo
    "Switch to conditions on both modes being met to transition from off to SHC"
    annotation(Placement(transformation(extent={{140,50},{160,70}})));
  Utilities.PlaceholderLogical offPre_internal(
    final have_inp=have_heaWat and have_chiWat,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{130,10},{110,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant isPhp(final k=is_php)
    "Return true for polyvalent HP"
    annotation(Placement(transformation(extent={{-210,170},{-190,190}})));
  Utilities.PlaceholderLogical y1ValHeaWatInlIso_internal(
    final have_inp=have_heaWat and have_valInlIso,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{150,-50},{170,-30}})));
  Utilities.PlaceholderLogical y1ValHeaWatOutIso_internal(
    final have_inp=have_heaWat and have_valOutIso,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{180,-70},{200,-50}})));
  Utilities.PlaceholderLogical y1ValChiWatInlIso_internal(
    final have_inp=have_chiWat and have_valInlIso,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{150,-90},{170,-70}})));
  Utilities.PlaceholderLogical y1ValChiWatOutIso_internal(
    final have_inp=have_chiWat and have_valOutIso,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{180,-110},{200,-90}})));
  Utilities.PlaceholderLogical y1PumHeaWatPri_internal(
    final have_inp=have_heaWat and have_pumHeaWatPri,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{152,-130},{172,-110}})));
  Utilities.PlaceholderLogical y1PumChiWatPri_internal(
    final have_inp=have_chiWat and have_pumChiWatPri,
    final have_inpPh=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{180,-150},{200,-130}})));
  Utilities.PlaceholderLogical u1PumChiWatPri_internal(
    final have_inp=have_chiWat and have_pumChiWatPri,
    final have_inpPh=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{-180,-190},{-160,-170}})));
  Utilities.PlaceholderLogical u1PumHeaWatPri_internal(
    final have_inp=have_heaWat and have_pumHeaWatPri,
    final have_inpPh=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation(Placement(transformation(extent={{-210,-170},{-190,-150}})));
equation
  connect(timValHea.passed, timValHea_internal.u)
    annotation(Line(points={{2,132},{8,132},{8,140},{18,140}},
      color={255,0,255}));
  connect(u1PumHeaWatPri_internal.y, heaValPum.u[1])
    annotation(Line(
      points={{-188,-160},{56,-160},{56,138},{68,138},{68,137.667}},
      color={255,0,255}));
  connect(u1PumChiWatPri_internal.y, cooValPum.u[1])
    annotation(Line(points={{-158,-180},{58,-180},{58,77.6667},{68,77.6667}},
      color={255,0,255}));
  connect(heaOrCooMet.y, y1)
    annotation(Line(points={{202,180},{240,180}},
      color={255,0,255}));
  connect(u1Hea, u1Hea_internal.u)
    annotation(Line(points={{-240,120},{-212,120}},
      color={255,0,255}));
  connect(u1Coo, u1Coo_internal.u)
    annotation(Line(points={{-240,80},{-212,80}},
      color={255,0,255}));
  connect(u1HeaOrCoo.y, rou1.u)
    annotation(Line(points={{-88,-120},{-72,-120}},
      color={255,0,255}));
  connect(off.y, timHp.u)
    annotation(Line(points={{-88,-60},{-52,-60}},
      color={255,0,255}));
  connect(rou1.y[1], latPumHeaWatPri.u)
    annotation(Line(points={{-48,-120},{98,-120}},
      color={255,0,255}));
  connect(rou.y[1], latPumHeaWatPri.u)
    annotation(Line(points={{-18,-100},{60,-100},{60,-120},{98,-120}},
      color={255,0,255}));
  connect(timValHea_internal.y, heaValPum.u[2])
    annotation(Line(points={{42,140},{58,140},{68,140}},
      color={255,0,255}));
  connect(timValCoo_internal.y, cooValPum.u[2])
    annotation(Line(points={{42,60},{52,60},{52,82},{68,82},{68,80}},
      color={255,0,255}));
  connect(timHp.passed, timHpOrPhpNotCooAndHea.u2)
    annotation(Line(points={{-28,-68},{8,-68}},
      color={255,0,255}));
  connect(timHpOrPhpNotCooAndHea.y, latValChiWatIso.clr)
    annotation(Line(points={{32,-60},{80,-60},{80,-86},{98,-86}},
      color={255,0,255}));
  connect(timHpOrPhpNotCooAndHea.y, latPumChiWatPri.clr)
    annotation(Line(points={{32,-60},{80,-60},{80,-146},{128,-146}},
      color={255,0,255}));
  connect(isPhpAndNotCooAndHea.y, timHpOrPhpNotCooAndHea.u1)
    annotation(Line(points={{-28,-20},{-24,-20},{-24,-60},{8,-60}},
      color={255,0,255}));
  connect(timHp.passed, timHpOrPhpNotHeaAndCoo.u2)
    annotation(Line(points={{-28,-68},{0,-68},{0,-28},{8,-28}},
      color={255,0,255}));
  connect(isPhpAndNotHeaAndCoo.y, timHpOrPhpNotHeaAndCoo.u1)
    annotation(Line(points={{-28,20},{-20,20},{-20,-20},{8,-20}},
      color={255,0,255}));
  connect(timHpOrPhpNotHeaAndCoo.y, latValHeaWatIso.clr)
    annotation(Line(points={{32,-20},{90,-20},{90,-46},{98,-46}},
      color={255,0,255}));
  connect(timHpOrPhpNotHeaAndCoo.y, latPumHeaWatPri.clr)
    annotation(Line(points={{32,-20},{90,-20},{90,-126},{98,-126}},
      color={255,0,255}));
  connect(u1Shc, u1ShcHea_internal.u)
    annotation(Line(points={{-240,40},{-212,40}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, timValHea.u)
    annotation(Line(points={{-128,120},{-40,120},{-40,140},{-22,140}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, y1Hea)
    annotation(Line(points={{-128,120},{-120,120},{-120,160},{240,160}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, timValHea_internal.uPh)
    annotation(Line(points={{-128,120},{14,120},{14,134},{18,134}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, notHea.u)
    annotation(Line(points={{-128,120},{-120,120},{-120,20},{-112,20}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, off.u1)
    annotation(Line(points={{-128,120},{-120,120},{-120,-60},{-112,-60}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, rou.u)
    annotation(Line(points={{-128,120},{-120,120},{-120,-100},{-42,-100}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, heaValPum.u[3])
    annotation(Line(points={{-128,120},{60,120},{60,136},{68,136},{68,142.333}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, u1HeaOrCoo.u1)
    annotation(Line(points={{-128,120},{-120,120},{-120,-120},{-112,-120}},
      color={255,0,255}));
  connect(u1CooOrShcCoo.y, timValCoo.u)
    annotation(Line(points={{-128,80},{-40,80},{-40,60},{-22,60}},
      color={255,0,255}));
  connect(u1CooOrShcCoo.y, timValCoo_internal.uPh)
    annotation(Line(points={{-128,80},{14,80},{14,54},{18,54}},
      color={255,0,255}));
  connect(u1CooOrShcCoo.y, cooValPum.u[3])
    annotation(Line(points={{-128,80},{68,80},{68,82.3333}},
      color={255,0,255}));
  connect(u1CooOrShcCoo.y, notCoo.u)
    annotation(Line(points={{-128,80},{-124,80},{-124,-20},{-112,-20}},
      color={255,0,255}));
  connect(u1CooOrShcCoo.y, off.u2)
    annotation(Line(points={{-128,80},{-124,80},{-124,-68},{-112,-68}},
      color={255,0,255}));
  connect(u1CooOrShcCoo.y, u1HeaOrCoo.u2)
    annotation(Line(points={{-128,80},{-124,80},{-124,-128},{-112,-128}},
      color={255,0,255}));
  connect(u1CooOrShcCoo.y, latValChiWatIso.u)
    annotation(Line(points={{-128,80},{-124,80},{-124,-80},{98,-80}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, latValHeaWatIso.u)
    annotation(Line(points={{-128,120},{-120,120},{-120,-40},{98,-40}},
      color={255,0,255}));
  connect(u1CooOrShcCoo.y, latPumChiWatPri.u)
    annotation(Line(points={{-128,80},{-124,80},{-124,-140},{128,-140}},
      color={255,0,255}));
  connect(heaValPum.y, heaAndCooMet.u1)
    annotation(Line(points={{92,140},{108,140}},
      color={255,0,255}));
  connect(cooValPum.y, heaAndCooMet.u2)
    annotation(Line(points={{92,80},{104,80},{104,132},{108,132}},
      color={255,0,255}));
  connect(y1AndHea, y1AndHeaPre.u)
    annotation(Line(points={{240,100},{210,100},{210,140},{202,140}},
      color={255,0,255}));
  connect(y1AndCoo, y1AndCooPre.u)
    annotation(Line(points={{240,60},{210,60},{210,20},{202,20}},
      color={255,0,255}));
  connect(y1AndCooPre.y, offPre.u2)
    annotation(Line(points={{178,20},{176,20},{176,12},{162,12}},
      color={255,0,255}));
  connect(y1AndHeaPre.y, offPre.u1)
    annotation(Line(points={{178,140},{174,140},{174,20},{162,20}},
      color={255,0,255}));
  connect(heaAndCooMet.y, swiShcHea.u1)
    annotation(Line(points={{132,140},{134,140},{134,108},{138,108}},
      color={255,0,255}));
  connect(heaValPum.y, swiShcHea.u3)
    annotation(Line(points={{92,140},{100,140},{100,92},{138,92}},
      color={255,0,255}));
  connect(swiShcHea.y, y1AndHea)
    annotation(Line(points={{162,100},{240,100}},
      color={255,0,255}));
  connect(cooValPum.y, swiShcCoo.u3)
    annotation(Line(points={{92,80},{104,80},{104,52},{138,52}},
      color={255,0,255}));
  connect(swiShcCoo.y, y1AndCoo)
    annotation(Line(points={{162,60},{240,60}},
      color={255,0,255}));
  connect(heaAndCooMet.y, swiShcCoo.u1)
    annotation(Line(points={{132,140},{134,140},{134,68},{138,68}},
      color={255,0,255}));
  connect(timValCoo.passed, timValCoo_internal.u)
    annotation(Line(points={{2,52},{8,52},{8,60},{18,60}},
      color={255,0,255}));
  connect(offPre.y, offPre_internal.u)
    annotation(Line(points={{138,20},{132,20}},
      color={255,0,255}));
  connect(offPre_internal.y, u1ShcAndOffPre.u2)
    annotation(Line(points={{108,20},{60,20},{60,32},{68,32}},
      color={255,0,255}));
  connect(u1ShcAndOffPre.y, swiShcCoo.u2)
    annotation(Line(points={{92,40},{96,40},{96,60},{138,60}},
      color={255,0,255}));
  connect(u1ShcAndOffPre.y, swiShcHea.u2)
    annotation(Line(points={{92,40},{96,40},{96,100},{138,100}},
      color={255,0,255}));
  connect(notCoo.y, isPhpAndNotCooAndHea.u[1])
    annotation(Line(points={{-88,-20},{-52,-20},{-52,-22.3333}},
      color={255,0,255}));
  connect(notHea.y, isPhpAndNotHeaAndCoo.u[1])
    annotation(Line(points={{-88,20},{-52,20},{-52,17.6667}},
      color={255,0,255}));
  connect(isPhp.y, isPhpAndNotHeaAndCoo.u[2])
    annotation(Line(points={{-188,180},{-80,180},{-80,18},{-52,18},{-52,20}},
      color={255,0,255}));
  connect(u1CooOrShcCoo.y, isPhpAndNotHeaAndCoo.u[3])
    annotation(Line(points={{-128,80},{-60,80},{-60,22.3333},{-52,22.3333}},
      color={255,0,255}));
  connect(isPhp.y, isPhpAndNotCooAndHea.u[2])
    annotation(Line(points={{-188,180},{-80,180},{-80,-20},{-52,-20}},
      color={255,0,255}));
  connect(u1HeaOrShcHea.y, isPhpAndNotCooAndHea.u[3])
    annotation(Line(
      points={{-128,120},{-120,120},{-120,0},{-82,0},{-82,-18},{-52,-18},{-52,-17.6667}},
      color={255,0,255}));
  connect(latValHeaWatIso.y, y1ValHeaWatInlIso_internal.u)
    annotation(Line(points={{122,-40},{148,-40}},
      color={255,0,255}));
  connect(y1ValHeaWatInlIso_internal.y, y1ValHeaWatInlIso)
    annotation(Line(points={{172,-40},{240,-40}},
      color={255,0,255}));
  connect(latValHeaWatIso.y, y1ValHeaWatOutIso_internal.u)
    annotation(Line(points={{122,-40},{140,-40},{140,-60},{178,-60}},
      color={255,0,255}));
  connect(y1ValHeaWatOutIso_internal.y, y1ValHeaWatOutIso)
    annotation(Line(points={{202,-60},{240,-60}},
      color={255,0,255}));
  connect(latValChiWatIso.y, y1ValChiWatInlIso_internal.u)
    annotation(Line(points={{122,-80},{148,-80}},
      color={255,0,255}));
  connect(y1ValChiWatInlIso_internal.y, y1ValChiWatInlIso)
    annotation(Line(points={{172,-80},{240,-80}},
      color={255,0,255}));
  connect(latValChiWatIso.y, y1ValChiWatOutIso_internal.u)
    annotation(Line(points={{122,-80},{140,-80},{140,-100},{178,-100}},
      color={255,0,255}));
  connect(y1ValChiWatOutIso_internal.y, y1ValChiWatOutIso)
    annotation(Line(points={{202,-100},{240,-100}},
      color={255,0,255}));
  connect(swiShcHea.y, heaOrCooMet.u1)
    annotation(Line(points={{162,100},{164,100},{164,180},{178,180}},
      color={255,0,255}));
  connect(swiShcCoo.y, heaOrCooMet.u2)
    annotation(Line(points={{162,60},{168,60},{168,172},{178,172}},
      color={255,0,255}));
  connect(u1ShcHea_internal.y, u1ShcAndOffPre.u1)
    annotation(Line(points={{-188,40},{68,40}},
      color={255,0,255}));
  connect(u1Hea_internal.y, u1HeaOrShcHea.u1)
    annotation(Line(points={{-188,120},{-152,120}},
      color={255,0,255}));
  connect(u1Coo_internal.y, u1CooOrShcCoo.u1)
    annotation(Line(points={{-188,80},{-152,80}},
      color={255,0,255}));
  connect(u1ShcHea_internal.y, u1CooOrShcCoo.u2)
    annotation(Line(points={{-188,40},{-160,40},{-160,72},{-152,72}},
      color={255,0,255}));
  connect(u1ShcHea_internal.y, u1HeaOrShcHea.u2)
    annotation(Line(points={{-188,40},{-160,40},{-160,112},{-152,112}},
      color={255,0,255}));
  connect(latPumHeaWatPri.y, y1PumHeaWatPri_internal.u)
    annotation(Line(points={{122,-120},{150,-120}},
      color={255,0,255}));
  connect(y1PumHeaWatPri_internal.y, y1PumHeaWatPri)
    annotation(Line(points={{174,-120},{240,-120}},
      color={255,0,255}));
  connect(latPumChiWatPri.y, y1PumChiWatPri_internal.u)
    annotation(Line(points={{152,-140},{178,-140}},
      color={255,0,255}));
  connect(y1PumChiWatPri_internal.y, y1PumChiWatPri)
    annotation(Line(points={{202,-140},{240,-140}},
      color={255,0,255}));
  connect(u1PumHeaWatPri_actual, u1PumHeaWatPri_internal.u)
    annotation(Line(points={{-240,-160},{-212,-160}},
      color={255,0,255}));
  connect(u1PumChiWatPri_actual, u1PumChiWatPri_internal.u)
    annotation(Line(points={{-240,-180},{-182,-180}},
      color={255,0,255}));
annotation(defaultComponentName="seqEve",
  Icon(coordinateSystem(preserveAspectRatio=true,
    extent={{-100,-140},{100,140}},
    grid={2,2}),
    graphics={Rectangle(extent={{-100,140},{100,-142}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,190},{150,150}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(extent={{-220,-200},{220,200}})),
  Documentation(
    info="<html>
<p>If a heat pump is commanded on in a desired heating or cooling mode:</p>
<ul>
  <li>
    The isolation valves for desired heating or cooling mode are commanded
    open.
  </li>
  <li>
    <b>Plants with dedicated primary pumps</b>: The dedicated primary pumps
    are commanded on when the associated isolation valves are commanded open.
  </li>
  <li>
    <b>Plants with headered primary pumps</b>: The headered primary pumps are
    commanded on as described in
    <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
      Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>.
  </li>
  <li>
    Once the isolation valves are fully open (based on nominal valve timing
    <code>dtVal</code>) and the lead pumps are proven on, the heat pump is
    enabled in heating or cooling mode.
  </li>
</ul>
<p>If a heat pump is commanded off:</p>
<ul>
  <li>The heat pump is disabled.</li>
  <li>
    After the time required for the internal shutdown cycle to time out
    (<code>dtOff</code> to be determined empirically, defaulting to
    <i>3</i>&nbsp;min), all isolation valves are commanded closed.
  </li>
  <li>
    <b>Plants with dedicated primary pumps</b>: The dedicated primary pumps
    are commanded off when the associated isolation valves are commanded
    closed.
  </li>
  <li>
    <b>Plants with headered primary pumps</b>: The headered primary pumps are
    commanded off as described in
    <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
      Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>.
  </li>
</ul>
<h5>Polyvalent heat pumps</h5>
<p>
  Note: For polyvalent heat pumps with dedicated primary pumps, no isolation
  valves are required. This is in contrast with two-pipe reversible heat
  pumps, which require changeover valves regardless of the primary pump
  arrangement.
</p>
<p>
  If a polyvalent heat pump is commanded on in either heating-only or
  cooling-only mode:
</p>
<ul>
  <li>
    <b>Plants with dedicated primary pumps</b>: The associated primary pumps
    are commanded on. Once the associated primary pumps are proven on, the
    polyvalent heat pump command for the desired mode is switched on.
  </li>
  <li>
    <b>Plants with headered primary pumps</b>: The isolation valves for the
    desired mode are commanded open. The headered primary pumps are commanded
    on as described in
    <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
      Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>.
    Once the isolation valves are fully open (based on nominal valve timing
    <code>dtVal</code>) and the lead pumps are proven on, the polyvalent heat
    pump command for the desired mode is switched on.
  </li>
</ul>
<p>
  If a polyvalent heat pump is commanded on in simultaneous heating and
  cooling mode, the enable interlocking logic described above applies to both
  the CHW and HW sides. Once both the CHW and HW isolation valves, if any, are
  fully open (based on nominal valve timing <code>dtVal</code>) and the
  associated CHW and HW primary pumps are proven on, the polyvalent heat pump
  commands for both modes are switched on.
</p>
<p>
  If a polyvalent heat pump switches from heating-only or cooling-only mode to
  simultaneous heating and cooling mode, the enable interlocking logic
  described above applies to the side being enabled: the polyvalent heat pump
  command for the newly enabled mode is switched on once the isolation valves
  of that side, if any, are fully open (based on nominal valve timing
  <code>dtVal</code>) and the associated primary pumps are proven on.
</p>
<p>
  If a polyvalent heat pump switches from simultaneous heating and cooling
  mode to heating-only or cooling-only mode:
</p>
<ul>
  <li>
    The polyvalent heat pump command for the disabled mode is switched off.
  </li>
  <li>
    <b>Plants with dedicated primary pumps</b>: The associated primary pumps
    of the disabled side are commanded off without delay.
  </li>
  <li>
    <b>Plants with headered primary pumps</b>: The isolation valves of the
    disabled side are commanded closed without delay. The headered primary
    pumps of the disabled side are commanded off as described in
    <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
      Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>.
  </li>
</ul>
<p>If a polyvalent heat pump is commanded off:</p>
<ul>
  <li>The polyvalent heat pump commands for both modes are switched off.</li>
  <li>
    <b>Plants with dedicated primary pumps</b>: After the time required for
    the internal shutdown cycle to time out (<code>dtOff</code> to be
    determined empirically, defaulting to <i>3</i>&nbsp;min), the dedicated
    primary pumps are commanded off.
  </li>
  <li>
    <b>Plants with headered primary pumps</b>: After the time required for the
    internal shutdown cycle to time out (<code>dtOff</code> to be determined
    empirically, defaulting to <i>3</i>&nbsp;min), all isolation valves are
    commanded closed. The headered primary pumps are commanded off as
    described in
    <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
      Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>.
  </li>
</ul>
<h4>Implementation details</h4>
<p>
  The timer tracking the heat pump shutdown cycle is reset if the heat pump is
  enabled in any mode. This implies that the isolation valves remain open
  unless the heat pump stays disabled for at least <code>dtOff</code>. The
  heat pump enable sequence must therefore guarantee that the heat pump
  remains off for at least <code>dtOff</code> before being enabled in the
  opposite mode. For polyvalent heat pumps, this requirement is not needed for
  valve and pump control: when one mode is disabled while the other remains
  enabled, the isolation valves and pumps of the disabled side are commanded
  off without delay. However, any minimum off time required by the heat pump
  between opposite operating modes must still be enforced by the enable
  sequence.
</p>
<p>
  To facilitate integration into plant controllers serving both reversible and
  polyvalent heat pumps, the output connectors for the isolation valve
  commands and the primary pump enable commands are always instantiated, and
  set to <code>false</code> when the corresponding equipment is not present.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 10, 2026, by Antoine Gautier:<br />
    Refactored to support polyvalent heat pumps.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end EventSequencingSingle;
