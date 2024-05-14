within Buildings.Templates.Plants.Controls.MinimumFlow;
block Controller "Minimum flow bypass valve controller"
  parameter Boolean have_valInlIso
    "Set to true to enable control loop based on inlet isolation valve command"
    annotation (Evaluate=true);
  parameter Boolean have_valOutIso
    "Set to true to enable control loop based on outlet isolation valve command"
    annotation (Evaluate=true);
  parameter Integer nEqu(
    final min=1)=0
    "Number of plant equipment"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  parameter Integer nEna(
    final min=1)=0
    "Number of enable signals – Valve command or pump status"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  parameter Real V_flow_nominal[:](
    each final unit="m3/s")
    "Design flow rate – Each unit";
  parameter Real V_flow_min[:](
    each final unit="m3/s")
    "Minimum flow rate – Each unit";
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small)=0.5
    "Time constant of integrator block";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final unit="m3/s")
    "Primary volume flow rate"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPri_actual[nEna]
    if not have_valInlIso and not have_valOutIso
    "Primary pump status"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValInlIso[nEna]
    if have_valInlIso
    "Inlet isolation valve command"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValOutIso[nEna]
    if have_valOutIso
    "Outlet isolation valve command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1") "Valve command"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Utilities.PIDWithEnable ctl(
    final k=k,
    final Ti=Ti,
    final reverseActing=true,
    y_reset=1,
    y_neutral=1)
    "PI controller"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyValInlIso(
    final nin=nEna)
    if have_valInlIso
    "True if any valve commanded open"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyValOutIso(
    final nin=nEna)
    if have_valOutIso
    "True if any valve commanded open"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumPri(
    final nin=nEna)
    if not have_valInlIso and not have_valOutIso
    "True if any pump proven on"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Utilities.PlaceholderLogical phValInlIso(
    final have_inp=have_valInlIso,
    u_internal=false)
    "Placeholder signal"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Utilities.PlaceholderLogical phValOutIso(
    final have_inp=have_valOutIso,
    u_internal=false)
    "Placeholder signal"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Utilities.PlaceholderLogical phPrumPri(
    final have_inp=not have_valInlIso and not have_valOutIso,
    u_internal=false)
    "Placeholder signal"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr any(
    nin=3)
    "True if any enable condition met"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Equ[nEqu]
    "Equipment enable command" annotation (Placement(transformation(extent={{-140,
            60},{-100,100}}), iconTransformation(extent={{-140,60},{-100,100}})));
  Setpoint setFloMin(
    final V_flow_nominal=V_flow_nominal,
    final V_flow_min=V_flow_min,
    nEqu=nEqu) "Calculate minimum flow setpoint"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VPriSet_flow(final unit="m3/s")
    "Primary flow setpoint" annotation (Placement(transformation(extent={{100,60},
            {140,100}}), iconTransformation(extent={{100,40},{140,80}})));
equation
  connect(anyValInlIso.u, u1ValInlIso)
    annotation (Line(points={{-92,40},{-120,40}},color={255,0,255}));
  connect(anyValOutIso.u, u1ValOutIso)
    annotation (Line(points={{-92,0},{-120,0}},  color={255,0,255}));
  connect(anyPumPri.u, u1PumPri_actual)
    annotation (Line(points={{-92,-40},{-120,-40}},
                                               color={255,0,255}));
  connect(VPri_flow, ctl.u_m)
    annotation (Line(points={{-120,-80},{40,-80},{40,-12}},color={0,0,127}));
  connect(anyValInlIso.y, phValInlIso.u)
    annotation (Line(points={{-68,40},{-52,40}},color={255,0,255}));
  connect(anyValOutIso.y, phValOutIso.u)
    annotation (Line(points={{-68,0},{-52,0}},  color={255,0,255}));
  connect(anyPumPri.y, phPrumPri.u)
    annotation (Line(points={{-68,-40},{-52,-40}},
                                              color={255,0,255}));
  connect(phValInlIso.y, any.u[1])
    annotation (Line(points={{-28,40},{-18,40},{-18,-22.3333},{-12,-22.3333}},
      color={255,0,255}));
  connect(phValOutIso.y, any.u[2])
    annotation (Line(points={{-28,0},{-20,0},{-20,-20},{-12,-20}},
                                                                color={255,0,255}));
  connect(phPrumPri.y, any.u[3])
    annotation (Line(points={{-28,-40},{-16,-40},{-16,-17.6667},{-12,-17.6667}},
                                                                          color={255,0,255}));
  connect(any.y, ctl.uEna)
    annotation (Line(points={{12,-20},{36,-20},{36,-12}},              color={255,0,255}));
  connect(ctl.y, y)
    annotation (Line(points={{52,0},{120,0}},    color={0,0,127}));
  connect(u1Equ, setFloMin.u1)
    annotation (Line(points={{-120,80},{-12,80}}, color={255,0,255}));
  connect(setFloMin.VPriSet_flow, ctl.u_s)
    annotation (Line(points={{12,80},{20,80},{20,0},{28,0}}, color={0,0,127}));
  connect(setFloMin.VPriSet_flow, VPriSet_flow)
    annotation (Line(points={{12,80},{120,80}}, color={0,0,127}));
  annotation (
    defaultComponentName="ctlFloMin",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
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
</html>"));
end Controller;
