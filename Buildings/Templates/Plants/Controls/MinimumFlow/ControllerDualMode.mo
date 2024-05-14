within Buildings.Templates.Plants.Controls.MinimumFlow;
block ControllerDualMode "CHW and/or HW minimum flow bypass valve controller"
    parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation (Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation (Evaluate=true);
  parameter Boolean have_pumChiWatPri(start=true)
    "Set to true for plants with separate primary CHW pumps"
    annotation (Evaluate=true, Dialog(enable=have_heaWat and have_chiWat));
  parameter Boolean have_valInlIso
    "Set to true to enable control loop based on inlet isolation valve command"
    annotation (Evaluate=true);
  parameter Boolean have_valOutIso
    "Set to true to enable control loop based on outlet isolation valve command"
    annotation (Evaluate=true);
  parameter Integer nEqu
    "Number of plant equipment"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  parameter Integer nEnaHeaWat(final min=if have_heaWat then 1 else 0)=0
    "Number of enable signals for HW loop – Valve command or pump status"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  parameter Integer nEnaChiWat(final min=if have_chiWat then 1 else 0)=0
    "Number of enable signals for CHW loop – Valve command or pump status"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  parameter Real VHeaWat_flow_nominal[:](
    each final unit="m3/s",
    each start=0)
    "Design HW flow rate – Each unit"
    annotation (Dialog(enable=have_heaWat));
  parameter Real VHeaWat_flow_min[:](
    each final unit="m3/s",
    each start=0)
    "Minimum HW flow rate – Each unit"
    annotation (Dialog(enable=have_heaWat));
  parameter Real VChiWat_flow_nominal[:](
    each final unit="m3/s",
    each start=0)
    "Design CHW flow rate – Each unit"
    annotation (Dialog(enable=have_chiWat));
  parameter Real VChiWat_flow_min[:](
    each final unit="m3/s",
    each start=0)
    "Minimum CHW flow rate – Each unit"
    annotation (Dialog(enable=have_chiWat));
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small)=0.5
    "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatPri_flow(final unit="m3/s")
    if have_chiWat
    "Primary CHW volume flow rate" annotation (Placement(transformation(extent={
            {-140,-120},{-100,-80}}), iconTransformation(extent={{-140,-100},{-100,
            -60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWatPri_flow(final unit="m3/s")
    if have_heaWat
    "Primary HW volume flow rate" annotation (Placement(transformation(extent={{
            -140,-100},{-100,-60}}), iconTransformation(extent={{-140,-80},{-100,
            -40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual[nEnaHeaWat]
    if have_heaWat and not (have_valInlIso or have_valOutIso)
    "Primary HW pump status" annotation (Placement(transformation(extent={{-140,
            -40},{-100,0}}),   iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValHeaWatInlIso[nEnaHeaWat]
    if have_heaWat and have_valInlIso
    "Equipment inlet HW isolation valve command" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}),iconTransformation(extent={{-140,40},
            {-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValHeaWatOutIso[nEnaHeaWat]
    if have_heaWat and have_valOutIso
    "Equipment outlet HW isolation valve command" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),  iconTransformation(
          extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValHeaWatMinByp(final unit="1")
    if have_heaWat "HW minimum flow bypass valve command" annotation (Placement(
        transformation(extent={{100,20},{140,60}}), iconTransformation(extent={{
            100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Equ[nEqu]
    "Equipment enable command" annotation (Placement(transformation(extent={{-140,80},
            {-100,120}}),     iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHeaWatPriSet_flow(final
      unit="m3/s") if have_heaWat "Primary HW flow setpoint" annotation (
      Placement(transformation(extent={{100,60},{140,100}}), iconTransformation(
          extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaEqu[nEqu]
    if have_heaWat and have_chiWat "Equipment heating/cooling mode command"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual[nEnaChiWat] if
    have_chiWat and have_pumChiWatPri and not have_valInlIso and not
    have_valOutIso "Primary CHW pump status" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValChiWatInlIso[nEnaChiWat]
    if have_chiWat and have_valInlIso
    "Equipment inlet CHW isolation valve command" annotation (Placement(
        transformation(extent={{-140,0},{-100,40}}), iconTransformation(extent={{-140,0},
            {-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValChiWatOutIso[nEnaChiWat]
    if have_chiWat and have_valOutIso
    "Equipment uutlet CHW isolation valve command" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValChiWatMinByp(final unit="1")
    if have_chiWat "CHW minimum flow bypass valve command" annotation (
      Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VChiWatPriSet_flow(final
      unit="m3/s") if have_chiWat "Primary CHW flow setpoint" annotation (
      Placement(transformation(extent={{100,-60},{140,-20}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Controller ctlFloMinHeaWat(
    final have_valInlIso=have_valInlIso,
    final have_valOutIso=have_valOutIso,
    final V_flow_nominal=VHeaWat_flow_nominal,
    final V_flow_min=VHeaWat_flow_min,
    final k=k,
    final Ti=Ti,
    final nEqu=nEqu,
    final nEna=nEnaHeaWat) if have_heaWat
    "HW minimum flow control"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Controller ctlFloMinChiWat(
    final have_valInlIso=have_valInlIso,
    final have_valOutIso=have_valOutIso,
    final V_flow_nominal=VChiWat_flow_nominal,
    final V_flow_min=VChiWat_flow_min,
    final k=k,
    final Ti=Ti,
    final nEqu=nEqu,
    final nEna=nEnaChiWat) if have_chiWat
    "CHW minimum flow control"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Utilities.PlaceholderLogical phHeaCoo[nEqu](
    each final have_inp=have_heaWat and have_chiWat,
    each final have_inpPh=false,
    each final u_internal=have_heaWat)
    "Placeholder signal for single mode applications"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1Coo[nEqu] "True if cooling mode"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea[nEqu] if have_heaWat
    "True if commanded on in heating mode"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCoo[nEqu] if have_chiWat
    "True if commanded on in cooling mode"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Utilities.PlaceholderLogical phPumChiWatPri[nEnaChiWat](each final have_inp=
        have_pumChiWatPri,
    each final have_inpPh=true)
    if have_chiWat and not (have_valInlIso or have_valOutIso)
    "Placeholder signal for common primary HW/CHW pump"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And pumOnAndCoo[nEqu]
    if have_chiWat and not (have_valInlIso or have_valOutIso)
    "True if pump proven on and equipment in cooling mode"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
equation
  connect(ctlFloMinHeaWat.y, yValHeaWatMinByp) annotation (Line(points={{72,40},
          {120,40}},                 color={0,0,127}));
  connect(ctlFloMinHeaWat.VPriSet_flow, VHeaWatPriSet_flow) annotation (Line(
        points={{72,46},{80,46},{80,80},{120,80}}, color={0,0,127}));
  connect(ctlFloMinChiWat.y, yValChiWatMinByp)
    annotation (Line(points={{72,-40},{80,-40},{80,-80},{120,-80}},
                                                  color={0,0,127}));
  connect(ctlFloMinChiWat.VPriSet_flow, VChiWatPriSet_flow) annotation (Line(
        points={{72,-34},{90,-34},{90,-40},{120,-40}}, color={0,0,127}));
  connect(u1HeaEqu, phHeaCoo.u)
    annotation (Line(points={{-120,80},{-92,80}}, color={255,0,255}));
  connect(phHeaCoo.y, u1Coo.u)
    annotation (Line(points={{-68,80},{-52,80}}, color={255,0,255}));
  connect(u1Equ, onAndHea.u1) annotation (Line(points={{-120,100},{-120,100},{0,
          100},{0,80},{8,80}},    color={255,0,255}));
  connect(onAndHea.y, ctlFloMinHeaWat.u1Equ) annotation (Line(points={{32,80},{44,
          80},{44,48},{48,48}}, color={255,0,255}));
  connect(onAndCoo.y, ctlFloMinChiWat.u1Equ) annotation (Line(points={{32,-20},
          {40,-20},{40,-32},{48,-32}},
                                 color={255,0,255}));
  connect(u1ValHeaWatInlIso, ctlFloMinHeaWat.u1ValInlIso) annotation (Line(
        points={{-120,60},{40,60},{40,44},{48,44}}, color={255,0,255}));
  connect(u1ValHeaWatOutIso, ctlFloMinHeaWat.u1ValOutIso) annotation (Line(
        points={{-120,40},{48,40}},                 color={255,0,255}));
  connect(u1PumHeaWatPri_actual, ctlFloMinHeaWat.u1PumPri_actual) annotation (
      Line(points={{-120,-20},{-80,-20},{-80,36},{48,36}}, color={255,0,255}));
  connect(VChiWatPri_flow, ctlFloMinChiWat.VPri_flow) annotation (Line(points={{-120,
          -100},{40,-100},{40,-48},{48,-48}},      color={0,0,127}));
  connect(u1ValChiWatInlIso, ctlFloMinChiWat.u1ValInlIso) annotation (Line(
        points={{-120,20},{-4,20},{-4,-36},{48,-36}},   color={255,0,255}));
  connect(u1ValChiWatOutIso, ctlFloMinChiWat.u1ValOutIso) annotation (
      Line(points={{-120,0},{-8,0},{-8,-40},{48,-40}},   color={255,0,255}));
  connect(VHeaWatPri_flow, ctlFloMinHeaWat.VPri_flow) annotation (Line(points={{-120,
          -80},{-76,-80},{-76,32},{48,32}},      color={0,0,127}));
  connect(u1Equ, onAndCoo.u1) annotation (Line(points={{-120,100},{0,100},{0,
          -20},{8,-20}},         color={255,0,255}));
  connect(u1Coo.y, onAndCoo.u2) annotation (Line(points={{-28,80},{-20,80},{-20,
          -28},{8,-28}},color={255,0,255}));
  connect(u1PumChiWatPri_actual, phPumChiWatPri.u) annotation (Line(
        points={{-120,-40},{-90,-40},{-90,-60},{8,-60}},   color={255,0,255}));
  connect(phPumChiWatPri.y, ctlFloMinChiWat.u1PumPri_actual) annotation (
      Line(points={{32,-60},{36,-60},{36,-44},{48,-44}}, color={255,0,255}));
  connect(u1Coo.y, pumOnAndCoo.u1) annotation (Line(points={{-28,80},{-20,80},{
          -20,-20},{-50,-20},{-50,-80},{-32,-80}},
                                               color={255,0,255}));
  connect(u1PumHeaWatPri_actual, pumOnAndCoo.u2) annotation (Line(points={{-120,
          -20},{-80,-20},{-80,-88},{-32,-88}}, color={255,0,255}));
  connect(pumOnAndCoo.y, phPumChiWatPri.uPh) annotation (Line(points={{-8,-80},{
          0,-80},{0,-66},{8,-66}},        color={255,0,255}));
  connect(phHeaCoo.y, onAndHea.u2) annotation (Line(points={{-68,80},{-60,80},{
          -60,66},{4,66},{4,72},{8,72}}, color={255,0,255}));
  annotation (
    defaultComponentName="ctlFloMin",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-120},{100,120}}),
      graphics={
        Rectangle(
          extent={{-100,120},{100,-120}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,170},{150,130}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
The minimum flow bypass valve is modulated based on a reverse acting control loop 
to maintain the primary flow rate at setpoint.
</p>
<p>
<b>When using isolation valve command signals</b>
(<code>have_valInlIso=true</code> or <code>have_valOutIso=true</code>):
When any valve is commanded open, the bypass valve control loop is enabled. 
The valve is opened <i>100&nbsp;%</i> otherwise. 
When enabled, the bypass valve loop shall be biased to start with the valve <i>100&nbsp;%</i> open.
</p>
<p>
<b>Otherwise</b>
(<code>have_valInlIso=false</code> and <code>have_valOutIso=false</code>):
When any primary pump is proven on, the bypass valve control loop is enabled. 
The valve is opened <i>100&nbsp;%</i> otherwise. 
When enabled, the bypass valve loop shall be biased to start with the valve <i>100&nbsp;%</i> open.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})));
end ControllerDualMode;
