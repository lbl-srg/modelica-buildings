within Buildings.Templates.Plants.Controls.Enabling;
block EventSequencing "Events sequencing when the system is enabled"
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation(Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true);
  parameter Boolean have_valInlIso
    "Set to true if the system as inlet isolation valves"
    annotation(Evaluate=true);
  parameter Boolean have_valOutIso
    "Set to true if the system as outlet isolation valves"
    annotation(Evaluate=true);
  final parameter Boolean have_pumHeaWatPri=have_heaWat
    "Set to true for plants with primary HW pumps"
    annotation(Evaluate=true);
  parameter Boolean have_pumChiWatPri(start=false)
    "Set to true for plants with separate primary CHW pumps"
    annotation(Evaluate=true,
    Dialog(enable=have_chiWat));
  parameter Boolean have_pumHeaWatSec
    "Set to true for plants with secondary HW pumps"
    annotation(Evaluate=true,
    Dialog(enable=have_heaWat));
  parameter Boolean have_pumChiWatSec
    "Set to true for plants with secondary CHW pumps"
    annotation(Evaluate=true,
    Dialog(enable=have_chiWat));
  parameter Real dtVal_nominal(
    start=90,
    min=0,
    unit="s")=90
    "Nominal valve timing"
    annotation(Dialog(enable=have_valInlIso or have_valOutIso));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Enable command"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual
    if have_pumHeaWatPri
    "Primary HW pump status (dedicated or lead headered pump)"
    annotation (
      Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual
    if have_pumChiWatPri
    "Primary CHW pump status – Dedicated or lead headered pump"
    annotation (
      Placement(transformation(extent={{-200,-40},{-160,0}}),iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual
    if have_pumHeaWatSec
    "Lead headered secondary HW pump status" annotation (Placement(
        transformation(extent={{-200,-80},{-160,-40}}),
                                                      iconTransformation(extent={{-140,
            -120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual
    if have_pumChiWatSec
    "Lead headered secondary CHW pump status" annotation (Placement(
        transformation(extent={{-200,-120},{-160,-80}}),iconTransformation(
          extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    if have_heaWat and have_chiWat
    "Heating/cooling mode command: true=heating, false=cooling"
    annotation (Placement(transformation(extent={
            {-200,80},{-160,120}}), iconTransformation(extent={{-140,78},{-100,118}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatInlIso
    if have_heaWat and have_valInlIso "Inlet HW inlet isolation valve command"
                                             annotation (Placement(
        transformation(extent={{160,20},{200,60}}),   iconTransformation(extent={{100,40},
            {140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatOutIso
    if have_heaWat and have_valOutIso "Outlet HW isolation valve command"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatInlIso
    if have_chiWat and have_valInlIso "Inlet CHW isolation valve command"
                                        annotation (Placement(transformation(
          extent={{160,-20},{200,20}}), iconTransformation(extent={{100,0},{140,
            40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatOutIso
    if have_chiWat and have_valOutIso "Outlet CHW isolation valve command"
                                         annotation (Placement(transformation(
          extent={{160,-40},{200,0}}),  iconTransformation(extent={{100,-20},{140,
            20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPri
    if have_pumHeaWatPri
    "Primary HW pump start command – Dedicated or lead headered pump"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPri
    if have_pumChiWatPri
    "Primary CHW pump start command – Dedicated or lead headered pump"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatSec
    if have_pumHeaWatSec "Lead headered secondary HW pump start command"
                                                    annotation (Placement(
        transformation(extent={{160,-140},{200,-100}}),
                                                    iconTransformation(extent={{100,
            -120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatSec
    if have_pumChiWatSec
    "Lead headered secondary CHW pump start command" annotation (Placement(
        transformation(extent={{160,-160},{200,-120}}),
                                                      iconTransformation(extent={{100,
            -140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Equipment enable command" annotation (Placement(transformation(extent={{160,100},
            {200,140}}),       iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea
    if have_heaWat and have_chiWat
    "Heating/cooling mode command: true=heating, false=cooling" annotation (
      Placement(transformation(extent={{160,80},{200,120}}),
        iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timVal(final t=dtVal_nominal)
    "Return true when nominal valve timing elapsed"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd heaValPum(nin=4)
    "Return true if heating AND valve timing elapsed AND lead HW pumps on"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or ena "Return true if enabled"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd cooValPum(nin=4)
    "Return true if cooling AND valve timing elapsed AND lead CHW pumps on"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not coo if have_heaWat and have_chiWat
    "Return true if cooling mode enabled"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Utilities.PlaceHolder u1PumChiWatSec_internal(
    final have_inp=have_pumChiWatSec,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Utilities.PlaceHolder timVal_internal(
    final have_inp=not
                      (have_valInlIso or have_valOutIso),
    final have_inpPla=true,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Utilities.PlaceHolder coo_internal(
    final have_inp=have_heaWat and have_chiWat,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Utilities.PlaceHolder hea_internal(
    final have_inp=have_heaWat and have_chiWat,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Utilities.PlaceHolder u1PumHeaWatSec_internal(
    final have_inp=have_pumHeaWatSec,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Utilities.PlaceHolder u1PumChiWatPri_internal(
    final have_inp=have_pumChiWatPri,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Utilities.PlaceHolder u1PumHeaWatPri_internal(
    final have_inp=have_pumHeaWatPri,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
equation
  connect(u1, y1ValHeaWatInlIso)
    annotation (Line(points={{-180,140},{140,140},{140,42},{160,42},{160,40},{180,
          40}},                                     color={255,0,255}));
  connect(u1, y1ValHeaWatOutIso) annotation (Line(points={{-180,140},{140,140},
          {140,20},{180,20}}, color={255,0,255}));
  connect(u1, y1ValChiWatInlIso) annotation (Line(points={{-180,140},{140,140},{
          140,0},{180,0}},     color={255,0,255}));
  connect(u1, y1ValChiWatOutIso) annotation (Line(points={{-180,140},{140,140},{
          140,-20},{180,-20}},
                             color={255,0,255}));
  connect(u1, y1PumHeaWatPri) annotation (Line(points={{-180,140},{140,140},{140,
          -60},{180,-60}},
                         color={255,0,255}));
  connect(u1, y1PumChiWatPri) annotation (Line(points={{-180,140},{140,140},{140,
          -80},{180,-80}},
                         color={255,0,255}));
  connect(u1, y1PumHeaWatSec) annotation (Line(points={{-180,140},{140,140},{140,
          -120},{180,-120}},
                           color={255,0,255}));
  connect(u1, y1PumChiWatSec) annotation (Line(points={{-180,140},{140,140},{140,
          -140},{180,-140}},
                           color={255,0,255}));
  connect(u1, timVal.u) annotation (Line(points={{-180,140},{-140,140},{-140,120},
          {-132,120}}, color={255,0,255}));
  connect(u1Hea, y1Hea) annotation (Line(points={{-180,100},{180,100}},
                       color={255,0,255}));
  connect(u1Hea, coo.u) annotation (Line(points={{-180,100},{-150,100},{-150,60},
          {-142,60}}, color={255,0,255}));
  connect(heaValPum.y, ena.u1) annotation (Line(points={{12,120},{38,120}},
                     color={255,0,255}));
  connect(cooValPum.y, ena.u2) annotation (Line(points={{12,60},{20,60},{20,112},
          {38,112}}, color={255,0,255}));
  connect(timVal.passed, timVal_internal.u) annotation (Line(points={{-108,112},
          {-100,112},{-100,120},{-82,120}}, color={255,0,255}));
  connect(u1, timVal_internal.uPla) annotation (Line(points={{-180,140},{-90,
          140},{-90,116},{-82,116}},
                                color={255,0,255}));
  connect(coo.y, coo_internal.u)
    annotation (Line(points={{-118,60},{-112,60}},color={255,0,255}));
  connect(u1Hea, hea_internal.u) annotation (Line(points={{-180,100},{-90,100},
          {-90,80},{-82,80}},color={255,0,255}));
  connect(hea_internal.y, heaValPum.u[1]) annotation (Line(points={{-58,80},{-20,
          80},{-20,117.375},{-12,117.375}}, color={255,0,255}));
  connect(timVal_internal.y, heaValPum.u[2]) annotation (Line(points={{-58,120},
          {-18,120},{-18,119.125},{-12,119.125}}, color={255,0,255}));
  connect(u1PumChiWatSec_actual, u1PumChiWatSec_internal.u)
    annotation (Line(points={{-180,-100},{-112,-100}}, color={255,0,255}));
  connect(u1PumHeaWatPri_actual, u1PumHeaWatPri_internal.u) annotation (Line(
        points={{-180,20},{-112,20}},           color={255,0,255}));
  connect(u1PumChiWatPri_actual, u1PumChiWatPri_internal.u)
    annotation (Line(points={{-180,-20},{-112,-20}}, color={255,0,255}));
  connect(u1PumHeaWatSec_actual, u1PumHeaWatSec_internal.u)
    annotation (Line(points={{-180,-60},{-112,-60}}, color={255,0,255}));
  connect(u1PumHeaWatPri_internal.y, heaValPum.u[3]) annotation (Line(points={{-88,20},
          {-28,20},{-28,120.875},{-12,120.875}},     color={255,0,255}));
  connect(u1PumHeaWatSec_internal.y, heaValPum.u[4]) annotation (Line(points={{-88,-60},
          {-22,-60},{-22,122},{-16,122},{-16,122.625},{-12,122.625}},
                                                       color={255,0,255}));
  connect(coo_internal.y, cooValPum.u[1]) annotation (Line(points={{-88,60},{-22,
          60},{-22,57.375},{-12,57.375}},   color={255,0,255}));
  connect(timVal_internal.y, cooValPum.u[2]) annotation (Line(points={{-58,120},
          {-24,120},{-24,59.125},{-12,59.125}},   color={255,0,255}));
  connect(u1PumChiWatPri_internal.y, cooValPum.u[3]) annotation (Line(points={{-88,-20},
          {-24,-20},{-24,60.875},{-12,60.875}},        color={255,0,255}));
  connect(u1PumChiWatSec_internal.y, cooValPum.u[4]) annotation (Line(points={{-88,
          -100},{-18,-100},{-18,62.625},{-12,62.625}},   color={255,0,255}));
  connect(ena.y, y1) annotation (Line(points={{62,120},{180,120}},
                 color={255,0,255}));
  annotation (
    defaultComponentName="eveSeqEna",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-140},{100,140}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,140},{100,-142}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,190},{150,150}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(extent={{-160,-160},{160,160}})));
end EventSequencing;
