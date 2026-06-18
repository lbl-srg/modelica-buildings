within Buildings.Templates.Plants.Controls.MinimumFlow;
block Controller
  "Minimum flow bypass valve controller"
  // use_val = Modelica.Math.BooleanVectors.anyTrue(use_valEqu) but not valid CDL.
  parameter Boolean use_val
    "Set to true to use isolation valve command to enable control loop – Any unit"
    annotation (Evaluate=true);
  parameter Boolean use_valEqu[nEqu](start=fill(false, nEqu))
    "Set to true to use isolation valve command to enable control loop – Each unit"
    annotation (Evaluate=true, Dialog(enable=use_val));
  // use_pumPriDed = Modelica.Math.BooleanVectors.anyTrue(use_pumPriDedEqu) but not valid CDL.
  parameter Boolean use_pumPriDed(start=false)
    "Set to true to use dedicated primary pump status to enable control loop – Any unit"
    annotation (Evaluate=true);
  parameter Boolean use_pumPriDedEqu[nEqu](start=fill(false, nEqu))
    "Set to true to use dedicated primary pump status to enable control loop – Each unit"
    annotation (Evaluate=true, Dialog(enable=use_pumPriDed));
  parameter Integer nEqu(
    final min=1)=0
    "Number of plant equipment"
    annotation (Evaluate=true);
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
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPri_actual[nEqu]
    if use_pumPriDed "Dedicated primary pump status" annotation (Placement(
        transformation(extent={{-160,-80},{-120,-40}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValIso[nEqu] if use_val
    "Isolation valve command" annotation (Placement(transformation(extent={{-160,0},
            {-120,40}}),     iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1")
    "Valve command"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithEnable ctl(
    final k=k,
    final Ti=Ti,
    final reverseActing=true,
    y_reset=1,
    y_neutral=1)
    "PI controller"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Equ[nEqu]
    "Equipment enable command"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Setpoint setFloMin(
    final V_flow_nominal=V_flow_nominal,
    final V_flow_min=V_flow_min,
    nEqu=nEqu)
    "Calculate minimum flow setpoint"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VPriSet_flow(
    final unit="m3/s")
    "Primary flow setpoint"
    annotation (Placement(transformation(extent={{120,60},{160,100}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.And valIsoOpeAndPumPriDed[nEqu]
    "Valve commanded open and dedicated primary pump proven on"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant notUseVal[nEqu](final k={
        not use_valEqu[i] for i in 1:nEqu})
    "True if valve command not required"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or valIsoOpeOrNotUse[nEqu] if use_val
    "Valve commanded open or valve signal not required"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant notUsePumPriDed[nEqu](
      final k={not use_pumPriDedEqu[i] for i in 1:nEqu})
    "True if dedicated primary pump status not required"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or pumPriDedOrNotUse[nEqu] if
    use_pumPriDed
    "Dedicated primary pump proven on or pump signal not required"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Utilities.PlaceholderLogical phPumPriDedOrNotUse[nEqu](each final have_inp=
        use_pumPriDed, each final u_internal=true) "Placeholder signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Utilities.PlaceholderLogical phValIsoOpeOrNotUse[nEqu](each final have_inp=
        use_val, each final u_internal=true) "Placeholder signal"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyValIsoOpeAndPumPriDed(final nin
      =nEqu) "True if any isolation valve open and dedicated pump proven on"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
equation
  connect(VPri_flow, ctl.u_m)
    annotation (Line(points={{-140,-100},{100,-100},{100,-12}},
                                                           color={0,0,127}));
  connect(ctl.y, y)
    annotation (Line(points={{112,0},{140,0}},
                                             color={0,0,127}));
  connect(u1Equ, setFloMin.u1)
    annotation (Line(points={{-140,80},{-12,80}},color={255,0,255}));
  connect(setFloMin.VPriSet_flow, ctl.u_s)
    annotation (Line(points={{12,80},{60,80},{60,0},{88,0}},color={0,0,127}));
  connect(setFloMin.VPriSet_flow, VPriSet_flow)
    annotation (Line(points={{12,80},{140,80}},color={0,0,127}));
  connect(notUseVal.y, valIsoOpeOrNotUse.u1) annotation (Line(points={{-88,40},{
          -80,40},{-80,20},{-72,20}}, color={255,0,255}));
  connect(u1ValIso, valIsoOpeOrNotUse.u2) annotation (Line(points={{-140,20},{-100,
          20},{-100,12},{-72,12}}, color={255,0,255}));
  connect(notUsePumPriDed.y, pumPriDedOrNotUse.u1)
    annotation (Line(points={{-88,-20},{-72,-20}}, color={255,0,255}));
  connect(u1PumPri_actual, pumPriDedOrNotUse.u2) annotation (Line(points={{-140,
          -60},{-80,-60},{-80,-28},{-72,-28}}, color={255,0,255}));
  connect(pumPriDedOrNotUse.y, phPumPriDedOrNotUse.u)
    annotation (Line(points={{-48,-20},{-42,-20}}, color={255,0,255}));
  connect(phPumPriDedOrNotUse.y, valIsoOpeAndPumPriDed.u2) annotation (Line(
        points={{-18,-20},{-10,-20},{-10,-28},{8,-28}},color={255,0,255}));
  connect(valIsoOpeOrNotUse.y, phValIsoOpeOrNotUse.u)
    annotation (Line(points={{-48,20},{-42,20}}, color={255,0,255}));
  connect(phValIsoOpeOrNotUse.y, valIsoOpeAndPumPriDed.u1)
    annotation (Line(points={{-18,20},{0,20},{0,-20},{8,-20}},
                                                color={255,0,255}));
  connect(valIsoOpeAndPumPriDed.y, anyValIsoOpeAndPumPriDed.u)
    annotation (Line(points={{32,-20},{38,-20}},
        color={255,0,255}));
  connect(anyValIsoOpeAndPumPriDed.y, ctl.uEna)
    annotation (Line(points={{62,-20},{96,-20},{96,-12}}, color={255,0,255}));
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
The setpoint is calculated as described in 
<a href=\"modelica://Buildings.Templates.Plants.Controls.MinimumFlow.Setpoint\">
Buildings.Templates.Plants.Controls.MinimumFlow.Setpoint</a>.
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
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}}, grid={2,2})));
end Controller;
