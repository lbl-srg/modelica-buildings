within Buildings.Templates.Plants.Controls.Pumps.Primary;
block DisableDedicated
  "Pump disable for plants with dedicated primary pumps"
  parameter Boolean have_reqFlo=false
    "Set to true if plant equipment provides flow request point via network interface"
    annotation (Evaluate=true);
  parameter Real dtOff(
    min=0,
    unit="s")=if not have_reqFlo then 3 * 60 else 10 * 60
    "Runtime with lead equipment proven off before disabling";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ReqFlo
    if have_reqFlo
    "Flow request from equipment"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "Enable signal from system enable logic"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Equ
    "Equipment enable signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Equ_actual
    "Equipment status"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Lead pump enable signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Clear enable signal if disable conditions are met"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not dis
    "Return true if lead equipment is disabled"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not off
    "Return true if lead equipment is proven off"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false)
    if not have_reqFlo
    "Placeholder constant"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrNotReq
    "Return true if lead equipment proven off OR not requesting flow"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOff(
    final t=dtOff)
    "Return true if lead equipment is proven off for specified duration"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Logical.And disAndOffOrNotReq
    "Return true if lead equipment disbaled AND (proven off OR not requesting flow)"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Trigger true signal when disable conditions turn true"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not noReq
    if have_reqFlo
    "Return true if no flow request"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Utilities.Initialization ini(
    final yIni=false)
    "Force false clear signal at initial time"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
equation
  connect(lat.y, y1)
    annotation (Line(points={{94,0},{120,0}},color={255,0,255}));
  connect(u1, lat.u)
    annotation (Line(points={{-120,80},{40,80},{40,0},{70,0}},color={255,0,255}));
  connect(u1Equ, dis.u)
    annotation (Line(points={{-120,40},{-82,40}},color={255,0,255}));
  connect(u1Equ_actual, off.u)
    annotation (Line(points={{-120,0},{-82,0}},color={255,0,255}));
  connect(fal.y, offOrNotReq.u2)
    annotation (Line(points={{-58,-80},{-40,-80},{-40,-68},{-12,-68}},color={255,0,255}));
  connect(off.y, timOff.u)
    annotation (Line(points={{-58,0},{-52,0}},color={255,0,255}));
  connect(timOff.passed, offOrNotReq.u1)
    annotation (Line(points={{-28,-8},{-20,-8},{-20,-60},{-12,-60}},color={255,0,255}));
  connect(u1ReqFlo, noReq.u)
    annotation (Line(points={{-120,-40},{-82,-40}},color={255,0,255}));
  connect(noReq.y, offOrNotReq.u2)
    annotation (Line(points={{-58,-40},{-40,-40},{-40,-68},{-12,-68}},color={255,0,255}));
  connect(dis.y, disAndOffOrNotReq.u1)
    annotation (Line(points={{-58,40},{20,40},{20,-60},{28,-60}},color={255,0,255}));
  connect(offOrNotReq.y, disAndOffOrNotReq.u2)
    annotation (Line(points={{12,-60},{14,-60},{14,-68},{28,-68}},color={255,0,255}));
  connect(disAndOffOrNotReq.y, edg.u)
    annotation (Line(points={{52,-60},{58,-60}},color={255,0,255}));
  connect(edg.y, ini.u)
    annotation (Line(points={{82,-60},{88,-60},{88,-40},{30,-40},{30,-20},{38,-20}},
      color={255,0,255}));
  connect(ini.y, lat.clr)
    annotation (Line(points={{62,-20},{66,-20},{66,-6},{70,-6}},color={255,0,255}));
  annotation (
    defaultComponentName="enaDed",
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
      info="<html>
<p>
The pump is disabled when the associated plant equipment is disabled and:
</p>
<ul>
<li>
if the equipment has a flow request network point
(<code>have_req=true</code>): either the equipment has been proven 
off for <code>dtOff</code> or is not requesting flow.
</li>
<li>
otherwise (<code>have_req=false</code>): the equipment has been 
proven off for <code>dtOff</code>.
</li>
</ul>
<p>
When the flow request point is available, the default value for the pump
disable delay <code>dtOff</code> is increased from <i>3</i>&nbsp;min
to <i>10</i>&nbsp;min to ensure that flow is not cut off too soon.
</p>
<h4>Details</h4>
<p>Used in Guideline 36 for disabling
dedicated primary pumps in chiller and boiler plants.
</p>
<p>
The enable signal <code>u1</code> is yielded by the staging event sequencing logic.
</p>
</html>"));
end DisableDedicated;
