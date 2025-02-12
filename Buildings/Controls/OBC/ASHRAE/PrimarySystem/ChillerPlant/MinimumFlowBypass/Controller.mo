within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass;
block Controller
  "Controller for chilled water minimum flow bypass valve"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Real minFloSet[nChi](
    final min=fill(0,nChi),
    final unit=fill("m3/s",nChi),
    quantity=fill("VolumeFlowRate",nChi))
    "Minimum chilled water flow through each chiller"
    annotation (Evaluate=true);
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Controller", enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                  controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final unit="s",
    final quantity="Time")=0 "Time constant of derivative block"
    annotation (Dialog(group="Controller", enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                  controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax=1 "Upper limit of output"
    annotation (Dialog(group="Controller"));
  parameter Real yMin=0.1 "Lower limit of output"
    annotation (Dialog(group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum
    "Maximum status feedback of all the chilled water pumps: true means at least one pump is proven on"
    annotation (Placement(transformation(extent={{-180,30},{-140,70}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Measured chilled water flow rate through chillers"
    annotation (Placement(transformation(extent={{-180,-10},{-140,30}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatSet_flow(
    final min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Chiller water minimum flow setpoint"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValPos(
    final min=0,
    final max=1,
    final unit="1") "Chilled water minimum flow bypass valve position"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset valPos(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final y_reset=1) "Bypass valve position PI controller"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minFlo[nChi](
    final k=minFloSet) "Minimum bypass flow rate at each stage"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    final nin=nChi)
    "Sum of minimum chilled water flow of all chillers"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div
    "Normalized minimum flow setpoint"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    "Normalized minimum bypass flow "
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant opeVal(
    final k=1) "Valve open"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  connect(minFlo.y, mulSum.u)
    annotation (Line(points={{-98,-80},{-82,-80}},color={0,0,127}));
  connect(VChiWat_flow, div1.u1)
    annotation (Line(points={{-160,10},{-80,10},{-80,-4},{-22,-4}},color={0,0,127}));
  connect(mulSum.y, div1.u2)
    annotation (Line(points={{-58,-80},{-40,-80},{-40,-16},{-22,-16}},
      color={0,0,127}));
  connect(mulSum.y, div.u2)
    annotation (Line(points={{-58,-80},{-40,-80},{-40,-66},{-22,-66}},
      color={0,0,127}));
  connect(div1.y, valPos.u_m)
    annotation (Line(points={{2,-10},{50,-10},{50,68}},  color={0,0,127}));
  connect(div.y, valPos.u_s)
    annotation (Line(points={{2,-60},{20,-60},{20,80},{38,80}},
      color={0,0,127}));
  connect(uChiWatPum, swi.u2)
    annotation (Line(points={{-160,50},{98,50}}, color={255,0,255}));
  connect(opeVal.y, swi.u3)
    annotation (Line(points={{-38,30},{80,30},{80,42},{98,42}}, color={0,0,127}));
  connect(swi.y, yValPos)
    annotation (Line(points={{122,50},{160,50}},color={0,0,127}));
  connect(div.u1, VChiWatSet_flow)
    annotation (Line(points={{-22,-54},{-80,-54},{-80,-40},{-160,-40}},
      color={0,0,127}));
  connect(uChiWatPum, valPos.trigger)
    annotation (Line(points={{-160,50},{44,50},{44,68}},
      color={255,0,255}));
  connect(valPos.y, swi.u1)
    annotation (Line(points={{62,80},{80,80},{80,58},{98,58}},
      color={0,0,127}));

annotation (
  defaultComponentName="minBypValCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-60,40},{80,-40}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-60,40},{-20,0},{-60,-40},{-60,40}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,88},{-54,74}},
          textColor={255,0,255},
          textString="uChiWatPum"),
        Text(
          extent={{-98,6},{-54,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{68,6},{102,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yValPos"),
        Text(
          extent={{-98,-74},{-42,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWatSet_flow")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-100},{140,100}})),
  Documentation(info="<html>
<p>
Block that controls chilled water minimum flow for primary-only
plants with a minimum flow bypass valve,
according to ASHRAE Guideline36-2021,
section 5.20.8 Chilled water minimum flow bypass valve.
</p>
<p>
The minimum chilled water flow setpoint <code>VChiWatSet_flow</code> is specified by block
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.FlowSetpoint</a>.
</p>
<p>
When any chilled water pump is proven on (<code>uChiWatPum</code> = true),
the bypass valve PID loop shall be enabled. The valve shall be opened 100% otherwise.
When enabled, the bypass valve loop shall be biased to start with the valve
100% open.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 31, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
