within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences;
block Dampers
  "Output signals for controlling VAV cooling only box damper position"

  parameter Boolean have_pressureIndependentDamper=true
    "True: the VAV damper is pressure independent (with built-in flow controller)"
    annotation(Dialog(group="Damper control"));
  parameter Real V_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1E-10)
    "Nominal volume flow rate, used to normalize control error"
    annotation(Dialog(group="Damper control"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController damCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Damper control", enable=not have_pressureIndependentDamper));
  parameter Real kDam(
    final unit="1")=0.5
    "Gain of controller for damper control"
    annotation(Dialog(group="Damper control", enable=not have_pressureIndependentDamper));
  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation(Dialog(group="Damper control",
      enable=(damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
           and not have_pressureIndependentDamper));
  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper control",
       enable=(damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
            or damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
            and not have_pressureIndependentDamper));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Delta between the temperature hysteresis high and low limit"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-240,110},{-200,150}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Supply air temperature from the air handler"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") "Measured zone temperature"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1") "Cooling loop signal"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-240,-50},{-200,-10}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta
    "Current zone state"
    annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if not have_pressureIndependentDamper
    "Measured discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-240,-150},{-200,-110}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active airflow setpoint"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDamSet(
    final min=0,
    final max=1,
    final unit="1")
    "Signal for VAV damper"
    annotation (Placement(transformation(extent={{200,-90},{240,-50}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Map cooling loop output to the active airflow setpoint"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=dTHys)
    "Check if supplyair temperature from the air handler is greater than room temperature"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Select active airfow setpoint based on difference between supply and zone temperature"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch actFlo
    "Specify active flow setpoint based on the zone status"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=damCon,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam) if not have_pressureIndependentDamper
    annotation (Placement(transformation(extent={{150,-80},{170,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.cooling)
    "Cooling state value"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal cooSta
    "Check if zone is in cooling state"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomFlow(
    final k=V_flow_nominal)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Division VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Division VDis_flowNor
    if not have_pressureIndependentDamper
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=1) if have_pressureIndependentDamper
    "Block that can be disabled so remove the connection"
    annotation (Placement(transformation(extent={{150,-40},{170,-20}})));

equation
  connect(conInt.y, cooSta.u1)
    annotation (Line(points={{-158,-60},{-142,-60}}, color={255,127,0}));
  connect(uZonSta, cooSta.u2) annotation (Line(points={{-220,-90},{-150,-90},{-150,
          -68},{-142,-68}}, color={255,127,0}));
  connect(con.y, lin.x1) annotation (Line(points={{-118,60},{-110,60},{-110,38},
          {-42,38}}, color={0,0,127}));
  connect(con1.y, lin.x2) annotation (Line(points={{-78,60},{-60,60},{-60,26},{-42,
          26}}, color={0,0,127}));
  connect(uCoo, lin.u) annotation (Line(points={{-220,10},{-120,10},{-120,30},{-42,
          30}}, color={0,0,127}));
  connect(TSup, gre.u1)
    annotation (Line(points={{-220,100},{-142,100}}, color={0,0,127}));
  connect(TZon, gre.u2) annotation (Line(points={{-220,60},{-180,60},{-180,92},{
          -142,92}}, color={0,0,127}));
  connect(gre.y, swi.u2)
    annotation (Line(points={{-118,100},{18,100}}, color={255,0,255}));
  connect(lin.y, swi.u3) annotation (Line(points={{-18,30},{0,30},{0,92},{18,92}},
        color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-220,130},{-160,130},{
          -160,34},{-42,34}}, color={0,0,127}));
  connect(VActMin_flow, swi.u1) annotation (Line(points={{-220,130},{0,130},{0,108},
          {18,108}}, color={0,0,127}));
  connect(VActCooMax_flow, lin.f2) annotation (Line(points={{-220,-30},{-100,-30},
          {-100,22},{-42,22}}, color={0,0,127}));
  connect(cooSta.y, actFlo.u2) annotation (Line(points={{-118,-60},{-60,-60},{-60,
          0},{58,0}}, color={255,0,255}));
  connect(VActMin_flow, actFlo.u3) annotation (Line(points={{-220,130},{-160,130},
          {-160,-8},{58,-8}}, color={0,0,127}));
  connect(swi.y, actFlo.u1) annotation (Line(points={{42,100},{50,100},{50,8},{58,
          8}}, color={0,0,127}));
  connect(actFlo.y, VActSet_flow)
    annotation (Line(points={{82,0},{220,0}}, color={0,0,127}));
  connect(actFlo.y, VDisSet_flowNor.u1) annotation (Line(points={{82,0},{90,0},{
          90,-64},{98,-64}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{22,-60},{60,-60},
          {60,-76},{98,-76}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{22,-60},{60,-60},
          {60,-116},{98,-116}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-220,-130},{40,-130},
          {40,-104},{98,-104}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conPID.u_s)
    annotation (Line(points={{122,-70},{148,-70}}, color={0,0,127}));
  connect(VDis_flowNor.y, conPID.u_m) annotation (Line(points={{122,-110},{160,-110},
          {160,-82}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, gai.u) annotation (Line(points={{122,-70},{140,-70},
          {140,-30},{148,-30}}, color={0,0,127}));
  connect(conPID.y, yDamSet)
    annotation (Line(points={{172,-70},{220,-70}}, color={0,0,127}));
  connect(gai.y, yDamSet) annotation (Line(points={{172,-30},{180,-30},{180,-70},
          {220,-70}}, color={0,0,127}));

annotation (
  defaultComponentName="damCon",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{200,160}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,-24},{-52,-36}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-100,-56},{-70,-64}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uZonSta"),
        Text(
          extent={{-98,96},{-62,86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,4},{-80,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,-86},{-68,-94}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-100,64},{-80,56}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-100,34},{-80,26}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=not have_pressureIndependentDamper,
          extent={{-11.5,4.5},{11.5,-4.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={39.5,-85.5},
          rotation=90,
          textString="VDis_flow"),
        Text(
          extent={{70,6},{98,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yDamSet"),
        Line(points={{-50,64},{-50,-48},{62,-48}}, color={95,95,95}),
        Line(
          points={{-2,-22},{-2,-48}},
          color={215,215,215},
          pattern=LinePattern.Dash),
    Polygon(
      points={{-64,-58},{-42,-52},{-42,-64},{-64,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{-2,-58},{-60,-58}}, color={95,95,95}),
    Line(points={{16,-58},{78,-58}},  color={95,95,95}),
    Polygon(
      points={{80,-58},{58,-52},{58,-64},{80,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{60,68},{98,56}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VActSet_flow"),
        Line(
          points={{-50,-20},{-2,-20},{18,-20},{64,40}},
          color={0,0,255},
          thickness=0.5)}),
Documentation(info="<html>
<p>
This sequence sets the damper position for VAV cooling only terminal unit. The
implementation is according to Section 5.5.5 of ASHRAE Guideline 36 (G36), May 2020.
</p>
<ol>
<li>
When the zone state (<code>uZonSta</code>) is cooling, the cooling-loop output 
(<code>uCoo</code>) shall be mapped to the active airflow setpoint from the
minimum (<code>VActMin_flow</code>) to the cooling maximum airflow setpoints
(<code>VActCooMax_flow</code>).
<ul>
<li>
If supply air temperature <code>TSup</code> from the air handler is greater than
room temperature <code>TZon</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</li>
</ul>
</li>
<li>
When the zone state is deadband or heating, the active airflow setpoint shall be
the minimum airflow setpoint.
</li>
<li>
The VAV damper <code>yDamSet</code> shall be modulated by a control loop to maintain
the measured airflow <code>VDis_flow</code> at the active setpoint.
</li>
</ol>
<p>The sequences of controlling damper position for the cooling only terminal
unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper control for VAV cooling only unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly/Subsequences/Damper.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Dampers;
