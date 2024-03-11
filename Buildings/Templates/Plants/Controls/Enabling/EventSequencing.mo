within Buildings.Templates.Plants.Controls.Enabling;
block EventSequencing
  "Events sequencing when the system is enabled"
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
  parameter Boolean have_pumHeaWatPri
    "Set to true for plants with primary HW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_pumChiWatPri(start=false)
    "Set to true for plants with separate primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(enable=have_chiWat));
  parameter Boolean have_pumHeaWatSec
    "Set to true for plants with secondary HW pumps"
    annotation (Evaluate=true,
    Dialog(enable=have_heaWat));
  parameter Boolean have_pumChiWatSec
    "Set to true for plants with secondary CHW pumps"
    annotation (Evaluate=true,
    Dialog(enable=have_chiWat));
  parameter Real dtVal(
    min=0,
    start=90,
    unit="s")=90
    "Nominal valve timing"
    annotation (Dialog(enable=have_valInlIso or have_valOutIso));
  parameter Real dtHp(
    min=0,
    unit="s")=180
    "Heat pump internal shutdown cycle timing";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    if have_heaWat
    "Enable command from heating mode sequence"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual
    if have_pumHeaWatPri
    "Primary HW pump status (dedicated or lead headered pump)"
    annotation (Placement(transformation(extent={{-200,-30},{-160,10}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual
    if have_pumChiWatPri
    "Primary CHW pump status – Dedicated or lead headered pump"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual
    if have_pumHeaWatSec
    "Lead headered secondary HW pump status"
    annotation (Placement(transformation(extent={{-200,-110},{-160,-70}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual
    if have_pumChiWatSec
    "Lead headered secondary CHW pump status"
    annotation (Placement(transformation(extent={{-200,-150},{-160,-110}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatInlIso
    if have_heaWat and have_valInlIso
    "Inlet HW inlet isolation valve command"
    annotation (Placement(transformation(extent={{160,20},{200,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatOutIso
    if have_heaWat and have_valOutIso
    "Outlet HW isolation valve command"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatInlIso
    if have_chiWat and have_valInlIso
    "Inlet CHW isolation valve command"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatOutIso
    if have_chiWat and have_valOutIso
    "Outlet CHW isolation valve command"
    annotation (Placement(transformation(extent={{160,-40},{200,0}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPri
    if have_pumHeaWatPri
    "Primary HW pump start command – Dedicated or lead headered pump"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPri
    if have_pumChiWatPri
    "Primary CHW pump start command – Dedicated or lead headered pump"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Equipment enable command"
    annotation (Placement(transformation(extent={{160,120},{200,160}}),
      iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea
    if have_heaWat and have_chiWat
    "Heating/cooling mode command: true=heating, false=cooling"
    annotation (Placement(transformation(extent={{160,100},{200,140}}),
      iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timVal(
    final t=dtVal)
    "Return true when nominal valve timing elapsed"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd heaValPum(
    nin=3)
    "Return true if heating AND valve timing elapsed AND lead HW pumps on"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or ena
    "Return true if enabled"
    annotation (Placement(transformation(extent={{90,90},{110,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd cooValPum(
    nin=4)
    "Return true if cooling AND valve timing elapsed AND lead CHW pumps on"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Utilities.PlaceHolder u1PumChiWatSec_internal(
    final have_inp=have_pumChiWatSec,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-150,-140},{-130,-120}})));
  Utilities.PlaceHolder timVal_internal(
    final have_inp=have_valInlIso or have_valOutIso,
    final have_inpPla=true,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Utilities.PlaceHolder u1PumHeaWatSec_internal(
    final have_inp=have_pumHeaWatSec,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-150,-100},{-130,-80}})));
  Utilities.PlaceHolder u1PumChiWatPri_internal(
    final have_inp=have_pumChiWatPri,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-150,-60},{-130,-40}})));
  Utilities.PlaceHolder u1PumHeaWatPri_internal(
    final have_inp=have_pumHeaWatPri,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-150,-20},{-130,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    if have_chiWat
    "Enable command from cooling mode sequence"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Utilities.PlaceHolder u1Coo_internal(
    final have_inp=have_chiWat,
    final have_inpPla=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or u1HeaOrCoo
    "Return true if enabled from heating or cooling mode sequence"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Utilities.PlaceHolder u1Hea_internal(
    final have_inp=have_heaWat,
    final have_inpPla=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-150,130},{-130,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1AndHea
    if have_heaWat
    "Equipment commanded on in heating mode"
    annotation (Placement(transformation(extent={{160,80},{200,120}}),
      iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1AndCoo
    if have_chiWat
    "Equipment commanded on in cooling mode"
    annotation (Placement(transformation(extent={{160,60},{200,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndHea
    "Return true if enabled in heating mode"
    annotation (Placement(transformation(extent={{130,90},{150,110}})));
  Buildings.Controls.OBC.CDL.Logical.And enaAndCoo
    "Return true if enabled in cooling mode"
    annotation (Placement(transformation(extent={{130,60},{150,80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rou(
    final nout=1)
    if have_pumChiWatPri
    "Signal routing for plants with dedicated primary CHW pumps"
    annotation (Placement(transformation(extent={{60,-76},{80,-56}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rou1(
    final nout=1)
    if not have_pumChiWatPri
    "Signal routing for plants without dedicated primary CHW pumps"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Nor off
    "Return true if disabled from heating and cooling mode sequence"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timHp(
    final t=dtHp)
    "Return true when heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latValHeaWatIso
    if have_heaWat
    "Keep valve open until heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latValChiWatIso
    if have_chiWat
    "Keep valve open until heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latPumHeaWatPri
    if have_heaWat
    "Keep pump running until heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latPumChiWatPri
    if have_pumChiWatPri
    "Keep pump running until heat pump internal shutdown cycle times out"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
equation
  connect(heaValPum.y, ena.u1)
    annotation (Line(points={{82,120},{84,120},{84,100},{88,100}},color={255,0,255}));
  connect(cooValPum.y, ena.u2)
    annotation (Line(points={{82,80},{84,80},{84,92},{88,92}},color={255,0,255}));
  connect(timVal.passed, timVal_internal.u)
    annotation (Line(points={{-28,92},{-16,92},{-16,100},{-12,100}},color={255,0,255}));
  connect(timVal_internal.y, heaValPum.u[1])
    annotation (Line(points={{12,100},{54,100},{54,117.667},{58,117.667}},color={255,0,255}));
  connect(u1PumChiWatSec_actual, u1PumChiWatSec_internal.u)
    annotation (Line(points={{-180,-130},{-152,-130}},color={255,0,255}));
  connect(u1PumHeaWatPri_actual, u1PumHeaWatPri_internal.u)
    annotation (Line(points={{-180,-10},{-152,-10}},color={255,0,255}));
  connect(u1PumChiWatPri_actual, u1PumChiWatPri_internal.u)
    annotation (Line(points={{-180,-50},{-152,-50}},color={255,0,255}));
  connect(u1PumHeaWatSec_actual, u1PumHeaWatSec_internal.u)
    annotation (Line(points={{-180,-90},{-152,-90}},color={255,0,255}));
  connect(u1PumHeaWatPri_internal.y, heaValPum.u[2])
    annotation (Line(points={{-128,-10},{44,-10},{44,120},{58,120}},color={255,0,255}));
  connect(u1PumHeaWatSec_internal.y, heaValPum.u[3])
    annotation (Line(points={{-128,-90},{50,-90},{50,122},{56,122},{56,122.333},
          {58,122.333}},
      color={255,0,255}));
  connect(timVal_internal.y, cooValPum.u[1])
    annotation (Line(points={{12,100},{48,100},{48,77.375},{58,77.375}},color={255,0,255}));
  connect(u1PumChiWatPri_internal.y, cooValPum.u[2])
    annotation (Line(points={{-128,-50},{48,-50},{48,79.125},{58,79.125}},color={255,0,255}));
  connect(u1PumChiWatSec_internal.y, cooValPum.u[3])
    annotation (Line(points={{-128,-130},{54,-130},{54,80.875},{58,80.875}},
      color={255,0,255}));
  connect(ena.y, y1)
    annotation (Line(points={{112,100},{124,100},{124,140},{180,140}},color={255,0,255}));
  connect(u1Hea, u1Hea_internal.u)
    annotation (Line(points={{-180,140},{-152,140}},color={255,0,255}));
  connect(u1Coo_internal.y, u1HeaOrCoo.u2)
    annotation (Line(points={{-128,80},{-100,80},{-100,112},{-92,112}},color={255,0,255}));
  connect(u1Hea_internal.y, u1HeaOrCoo.u1)
    annotation (Line(points={{-128,140},{-120,140},{-120,120},{-92,120}},color={255,0,255}));
  connect(u1HeaOrCoo.y, timVal.u)
    annotation (Line(points={{-68,120},{-60,120},{-60,100},{-52,100}},color={255,0,255}));
  connect(u1HeaOrCoo.y, timVal_internal.uPla)
    annotation (Line(points={{-68,120},{-20,120},{-20,96},{-12,96}},color={255,0,255}));
  connect(u1Coo, u1Coo_internal.u)
    annotation (Line(points={{-180,80},{-152,80}},color={255,0,255}));
  connect(u1Coo_internal.y, cooValPum.u[4])
    annotation (Line(points={{-128,80},{58,80},{58,82.625}},color={255,0,255}));
  connect(u1Hea_internal.y, y1Hea)
    annotation (Line(points={{-128,140},{120,140},{120,120},{180,120}},color={255,0,255}));
  connect(ena.y, enaAndHea.u1)
    annotation (Line(points={{112,100},{128,100}},color={255,0,255}));
  connect(u1Hea_internal.y, enaAndHea.u2)
    annotation (Line(points={{-128,140},{120,140},{120,92},{128,92}},color={255,0,255}));
  connect(enaAndHea.y, y1AndHea)
    annotation (Line(points={{152,100},{180,100}},color={255,0,255}));
  connect(ena.y, enaAndCoo.u1)
    annotation (Line(points={{112,100},{124,100},{124,70},{128,70}},color={255,0,255}));
  connect(u1Coo_internal.y, enaAndCoo.u2)
    annotation (Line(points={{-128,80},{-100,80},{-100,48},{60,48},{60,62},{128,62}},
      color={255,0,255}));
  connect(enaAndCoo.y, y1AndCoo)
    annotation (Line(points={{152,70},{156,70},{156,80},{180,80}},color={255,0,255}));
  connect(u1Hea_internal.y, rou.u)
    annotation (Line(points={{-128,140},{-120,140},{-120,-66},{58,-66}},color={255,0,255}));
  connect(u1HeaOrCoo.y, rou1.u)
    annotation (Line(points={{-68,120},{-60,120},{-60,-40},{58,-40}},color={255,0,255}));
  connect(u1Hea_internal.y, off.u1)
    annotation (Line(points={{-128,140},{-120,140},{-120,20},{-92,20}},color={255,0,255}));
  connect(u1Coo_internal.y, off.u2)
    annotation (Line(points={{-128,80},{-100,80},{-100,12},{-92,12}},color={255,0,255}));
  connect(off.y, timHp.u)
    annotation (Line(points={{-68,20},{-52,20}},color={255,0,255}));
  connect(timHp.passed, latValHeaWatIso.clr)
    annotation (Line(points={{-28,12},{40,12},{40,34},{98,34}},color={255,0,255}));
  connect(latValHeaWatIso.y, y1ValHeaWatInlIso)
    annotation (Line(points={{122,40},{180,40}},color={255,0,255}));
  connect(u1Hea_internal.y, latValHeaWatIso.u)
    annotation (Line(points={{-128,140},{-120,140},{-120,40},{98,40}},color={255,0,255}));
  connect(latValChiWatIso.y, y1ValChiWatInlIso)
    annotation (Line(points={{122,0},{180,0}},color={255,0,255}));
  connect(timHp.passed, latValChiWatIso.clr)
    annotation (Line(points={{-28,12},{40,12},{40,-6},{98,-6}},color={255,0,255}));
  connect(latValHeaWatIso.y, y1ValHeaWatOutIso)
    annotation (Line(points={{122,40},{140,40},{140,20},{180,20}},color={255,0,255}));
  connect(latValChiWatIso.y, y1ValChiWatOutIso)
    annotation (Line(points={{122,0},{140,0},{140,-20},{180,-20}},color={255,0,255}));
  connect(rou1.y[1], latPumHeaWatPri.u)
    annotation (Line(points={{82,-40},{98,-40}},color={255,0,255}));
  connect(rou.y[1], latPumHeaWatPri.u)
    annotation (Line(points={{82,-66},{90,-66},{90,-40},{98,-40}},color={255,0,255}));
  connect(timHp.passed, latPumHeaWatPri.clr)
    annotation (Line(points={{-28,12},{40,12},{40,-20},{94,-20},{94,-46},{98,-46}},
      color={255,0,255}));
  connect(latPumHeaWatPri.y, y1PumHeaWatPri)
    annotation (Line(points={{122,-40},{140,-40},{140,-60},{180,-60}},color={255,0,255}));
  connect(latPumChiWatPri.y, y1PumChiWatPri)
    annotation (Line(points={{122,-80},{180,-80}},color={255,0,255}));
  connect(timHp.passed, latPumChiWatPri.clr)
    annotation (Line(points={{-28,12},{40,12},{40,-86},{98,-86}},color={255,0,255}));
  connect(u1Coo_internal.y, latPumChiWatPri.u)
    annotation (Line(points={{-128,80},{-100,80},{-100,-80},{98,-80}},color={255,0,255}));
  connect(u1Coo_internal.y, latValChiWatIso.u)
    annotation (Line(points={{-128,80},{-100,80},{-100,0},{98,0}},color={255,0,255}));
  annotation (
    defaultComponentName="eveSeqEna",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-140},{100,140}}),
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
        extent={{-160,-160},{160,160}})),
    Documentation(
      info="<html>

</html>"));
end EventSequencing;
