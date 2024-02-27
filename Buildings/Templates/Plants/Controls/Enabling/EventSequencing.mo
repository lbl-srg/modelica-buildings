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
  parameter Boolean have_pumHeaWatPri
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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea if have_heaWat
    "Enable command from heating mode sequence" annotation (Placement(
        transformation(extent={{-200,120},{-160,160}}), iconTransformation(
          extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual
    if have_pumHeaWatPri
    "Primary HW pump status (dedicated or lead headered pump)"
    annotation (
      Placement(transformation(extent={{-200,10},{-160,50}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual
    if have_pumChiWatPri
    "Primary CHW pump status – Dedicated or lead headered pump"
    annotation (
      Placement(transformation(extent={{-200,-30},{-160,10}}),
                                                             iconTransformation(
          extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual
    if have_pumHeaWatSec
    "Lead headered secondary HW pump status" annotation (Placement(
        transformation(extent={{-200,-70},{-160,-30}}),
                                                      iconTransformation(extent={{-140,
            -80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual
    if have_pumChiWatSec
    "Lead headered secondary CHW pump status" annotation (Placement(
        transformation(extent={{-200,-110},{-160,-70}}),iconTransformation(
          extent={{-140,-100},{-100,-60}})));
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
    "Equipment enable command" annotation (Placement(transformation(extent={{160,120},
            {200,160}}),       iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea
    if have_heaWat and have_chiWat
    "Heating/cooling mode command: true=heating, false=cooling" annotation (
      Placement(transformation(extent={{160,80},{200,120}}),
        iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timVal(final t=dtVal_nominal)
    "Return true when nominal valve timing elapsed"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd heaValPum(nin=3)
    "Return true if heating AND valve timing elapsed AND lead HW pumps on"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or ena "Return true if enabled"
    annotation (Placement(transformation(extent={{110,110},{130,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd cooValPum(nin=4)
    "Return true if cooling AND valve timing elapsed AND lead CHW pumps on"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Utilities.PlaceHolder u1PumChiWatSec_internal(
    final have_inp=have_pumChiWatSec,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
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
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Utilities.PlaceHolder u1PumChiWatPri_internal(
    final have_inp=have_pumChiWatPri,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Utilities.PlaceHolder u1PumHeaWatPri_internal(
    final have_inp=have_pumHeaWatPri,
    final have_inpPla=false,
    final u_internal=true)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo if have_chiWat
    "Enable command from cooling mode sequence" annotation (Placement(
        transformation(extent={{-200,60},{-160,100}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Utilities.PlaceHolder u1Coo_internal(
    final have_inp=have_chiWat,
    final have_inpPla=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or u1HeaOrCoo
    "Return true if enabled from heating or cooling mode sequence"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Utilities.PlaceHolder u1Hea_internal(
    final have_inp=have_heaWat,
    final have_inpPla=false,
    final u_internal=false)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
equation
  connect(heaValPum.y, ena.u1) annotation (Line(points={{82,120},{108,120}},
                     color={255,0,255}));
  connect(cooValPum.y, ena.u2) annotation (Line(points={{82,80},{100,80},{100,
          112},{108,112}},
                     color={255,0,255}));
  connect(timVal.passed, timVal_internal.u) annotation (Line(points={{-28,92},{
          -16,92},{-16,100},{-12,100}},     color={255,0,255}));
  connect(timVal_internal.y, heaValPum.u[1]) annotation (Line(points={{12,100},
          {54,100},{54,117.667},{58,117.667}},    color={255,0,255}));
  connect(u1PumChiWatSec_actual, u1PumChiWatSec_internal.u)
    annotation (Line(points={{-180,-90},{-142,-90}},   color={255,0,255}));
  connect(u1PumHeaWatPri_actual, u1PumHeaWatPri_internal.u) annotation (Line(
        points={{-180,30},{-142,30}},           color={255,0,255}));
  connect(u1PumChiWatPri_actual, u1PumChiWatPri_internal.u)
    annotation (Line(points={{-180,-10},{-142,-10}}, color={255,0,255}));
  connect(u1PumHeaWatSec_actual, u1PumHeaWatSec_internal.u)
    annotation (Line(points={{-180,-50},{-142,-50}}, color={255,0,255}));
  connect(u1PumHeaWatPri_internal.y, heaValPum.u[2]) annotation (Line(points={{-118,30},
          {44,30},{44,120},{58,120}},                color={255,0,255}));
  connect(u1PumHeaWatSec_internal.y, heaValPum.u[3]) annotation (Line(points={{-118,
          -50},{50,-50},{50,122},{56,122},{56,122.333},{58,122.333}},
                                                       color={255,0,255}));
  connect(timVal_internal.y, cooValPum.u[1]) annotation (Line(points={{12,100},
          {48,100},{48,77.375},{58,77.375}},      color={255,0,255}));
  connect(u1PumChiWatPri_internal.y, cooValPum.u[2]) annotation (Line(points={{-118,
          -10},{48,-10},{48,79.125},{58,79.125}},      color={255,0,255}));
  connect(u1PumChiWatSec_internal.y, cooValPum.u[3]) annotation (Line(points={{-118,
          -90},{54,-90},{54,80.875},{58,80.875}},        color={255,0,255}));
  connect(ena.y, y1) annotation (Line(points={{132,120},{148,120},{148,140},{
          180,140}},
                 color={255,0,255}));
  connect(u1Hea, u1Hea_internal.u)
    annotation (Line(points={{-180,140},{-142,140}}, color={255,0,255}));
  connect(u1Coo_internal.y, u1HeaOrCoo.u2) annotation (Line(points={{-118,80},{
          -100,80},{-100,112},{-92,112}}, color={255,0,255}));
  connect(u1Hea_internal.y, u1HeaOrCoo.u1) annotation (Line(points={{-118,140},
          {-100,140},{-100,120},{-92,120}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, timVal.u) annotation (Line(points={{-68,120},{-60,120},
          {-60,100},{-52,100}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, timVal_internal.uPla) annotation (Line(points={{-68,120},
          {-20,120},{-20,96},{-12,96}}, color={255,0,255}));
  connect(u1Coo, u1Coo_internal.u)
    annotation (Line(points={{-180,80},{-142,80}}, color={255,0,255}));
  connect(u1Coo_internal.y, cooValPum.u[4]) annotation (Line(points={{-118,80},
          {58,80},{58,82.625}}, color={255,0,255}));
  connect(u1Hea_internal.y, y1Hea) annotation (Line(points={{-118,140},{140,140},
          {140,100},{180,100}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, y1ValHeaWatInlIso) annotation (Line(points={{-68,120},{
          -60,120},{-60,40},{180,40}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, y1ValHeaWatOutIso) annotation (Line(points={{-68,120},{
          -60,120},{-60,20},{180,20}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, y1ValChiWatInlIso) annotation (Line(points={{-68,120},{
          -60,120},{-60,0},{180,0}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, y1ValChiWatOutIso) annotation (Line(points={{-68,120},{
          -60,120},{-60,-20},{180,-20}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, y1PumHeaWatPri) annotation (Line(points={{-68,120},{-60,
          120},{-60,-60},{180,-60}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, y1PumChiWatPri) annotation (Line(points={{-68,120},{-60,
          120},{-60,-80},{180,-80}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, y1PumHeaWatSec) annotation (Line(points={{-68,120},{-60,
          120},{-60,-120},{180,-120}}, color={255,0,255}));
  connect(u1HeaOrCoo.y, y1PumChiWatSec) annotation (Line(points={{-68,120},{-60,
          120},{-60,-140},{180,-140}}, color={255,0,255}));
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
