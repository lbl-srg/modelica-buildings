within Buildings.Controls.OBC.ChilledBeams.System;
block Controller
  "Main chilled beam system controller"

  parameter Integer nPum(
    final min=1)
    "Number of chilled water pumps"
    annotation (Dialog(group="System parameters"));

  parameter Integer nVal(
    final min=1)
    "Total number of chilled water control valves on chilled beams"
    annotation (Dialog(group="System parameters"));

  parameter Integer nSenRemDP=1
    "Total number of remote differential pressure sensors"
    annotation (Dialog(group="System parameters"));

  parameter Real minPumSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=maxPumSpe) = 0.1
    "Minimum pump speed"
    annotation (Dialog(group="Pump parameters"));

  parameter Real maxPumSpe(
    final unit="1",
    displayUnit="1",
    final min=minPumSpe,
    final max=1) = 1
    "Maximum pump speed"
    annotation (Dialog(group="Pump parameters"));

  parameter Real valPosClo(
    final unit="1",
    displayUnit="1")=0.05
    "Valve position at which it is deemed to be closed"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump enable parameters"));

  parameter Real valPosOpe(
    final unit="1",
    displayUnit="1")=0.1
    "Valve position at which it is deemed to be open"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump enable parameters"));

  parameter Real valOpeThr(
    final unit="s",
    displayUnit="s",
    final quantity="time")=30
    "Minimum threshold time for which a valve has to be open to enable lead pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump enable parameters"));

  parameter Real valCloThr(
    final unit="s",
    displayUnit="s",
    final quantity="time")=60
    "Minimum threshold time for which all valves have to be closed to disable lead pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump enable parameters"));

  parameter Real speLim(
    final unit="1",
    displayUnit="1") = 0.75
    "Speed limit with longer enable delay for enabling next lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters"));

  parameter Real speLim1(
    final unit="1",
    displayUnit="1") = 0.9
    "Speed limit with shorter enable delay for enabling next lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters"));

  parameter Real speLim2(
    final unit="1",
    displayUnit="1") = 0.25
    "Speed limit for disabling last lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters"));

  parameter Real timPer1(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 120
    "Delay time period for enabling next lag pump at speed limit speLim"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters"));

  parameter Real timPer2(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Delay time period for enabling next lag pump at speed limit speLim1"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters"));

  parameter Real timPer3(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 120
    "Delay time period for disabling last lag pump"
    annotation (Dialog(tab="Pump control parameters",
      group="Pump staging parameters"));

  parameter Real kPumSpe(
    final unit="1",
    displayUnit="1",
    final min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters"));

  parameter Real TiPumSpe(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters",
      enable = controllerTypePumSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerTypePumSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdPumSpe(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters",
      enable = controllerTypePumSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerTypePumSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real dPChiWatMax(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Maximum allowed differential pressure in the chilled water loop"
    annotation(Dialog(group="System parameters"));

  parameter Real kBypVal(
    final unit="1",
    displayUnit="1") = 1
    "Gain of controller"
    annotation (Dialog(tab="Bypass valve parameters",
      group="PID parameters"));

  parameter Real TiBypVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Bypass valve parameters",
      group="PID parameters",
      enable = controllerTypeBypVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerTypeBypVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdBypVal(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Bypass valve parameters",
      group="PID parameters",
      enable = controllerTypeBypVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerTypeBypVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real sigDifPumSpe(
    final unit="1",
    displayUnit="1")=0.01
    "Constant value used in hysteresis for checking pump speed"
    annotation (Dialog(tab="Pump control parameters",
      group="Advanced"));

  parameter Real samplePeriodUniDelPumSpe(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=60
    "Sample period of unit delay for pump speed feedback"
    annotation (Dialog(tab="Pump control parameters",
      group="Advanced"));

  parameter Real valPosLowClo(
    final unit="1",
    displayUnit="1") = 0.45
    "Lower limit for sending one request to Trim-and-Respond logic"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Control valve parameters"));

  parameter Real valPosLowOpe(
    final unit="1",
    displayUnit="1") = 0.5
    "Upper limit for sending one request to Trim-and-Respond logic"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Control valve parameters"));

  parameter Real valPosHigClo(
    final unit="1",
    displayUnit="1") = 0.95
    "Lower limit for sending two requests to Trim-and-Respond logic"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Control valve parameters"));

  parameter Real valPosHigOpe(
    final unit="1",
    displayUnit="1") = 0.99
    "Upper limit for sending two requests to Trim-and-Respond logic"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Control valve parameters"));

  parameter Real chiWatStaPreMax(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="Pressure") = 30000
    "Maximum chilled water loop static pressure setpoint"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Trim-and-Respond parameters"));

  parameter Real chiWatStaPreMin(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="Pressure") = 20000
    "Minimum chilled water loop static pressure setpoint"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Trim-and-Respond parameters"));

  parameter Real triAmoVal(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") = -500
    "Static pressure trim amount"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Trim-and-Respond parameters"));

  parameter Real resAmoVal(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") = 750
    "Static pressure respond amount"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Trim-and-Respond parameters"));

  parameter Real maxResVal(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") = 1000
    "Static pressure maximum respond amount"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Trim-and-Respond parameters"));

  parameter Real samPerVal(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 30
    "Sample period duration"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Trim-and-Respond parameters"));

  parameter Real delTimVal(
    final unit="s",
    displayUnit="min",
    final quantity="Duration") = 120
    "Delay period duration"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Trim-and-Respond parameters"));

  parameter Real thrTimLow(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 60
    "Threshold time for generating one request"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Control valve parameters"));

  parameter Real thrTimHig(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 30
    "Threshold time for generating two requests"
    annotation(Dialog(tab="Chilled water static pressure reset", group="Control valve parameters"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeBypVal=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for bypass valve position"
    annotation (Dialog(tab="Bypass valve parameters",
      group="PID parameters"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypePumSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller type for pump speed control"
    annotation (Dialog(tab="Pump control parameters",
      group="PID parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[nPum]
    "Pump status from plant"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dPChiWatLoo
    "Measured chilled water loop differential pressure from remote sensors"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uValPos[nVal]
    "Measured chilled beam manifold control valve position"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiWatPum[nPum]
    "Chilled water pump enable signal"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe
    "Chilled water pump speed signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBypValPos
    "Bypass valve position signal"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterStaticPressureSetpointReset chiWatStaPreSetRes(
    final nVal=nVal,
    final nPum=nPum,
    final valPosLowClo=valPosLowClo,
    final valPosLowOpe=valPosLowOpe,
    final valPosHigClo=valPosHigClo,
    final valPosHigOpe=valPosHigOpe,
    final chiWatStaPreMax=chiWatStaPreMax,
    final chiWatStaPreMin=chiWatStaPreMin,
    final triAmoVal=triAmoVal,
    final resAmoVal=resAmoVal,
    final maxResVal=maxResVal,
    final samPerVal=samPerVal,
    final delTimVal=delTimVal,
    final thrTimLow=thrTimLow,
    final thrTimHig=thrTimHig)
    "Chilled water static pressure setpoint reset"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

protected
  parameter Integer pumStaOrd[nPum]={i for i in 1:nPum}
    "Chilled water pump staging order";

  Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Controller secPumCon(
    final nPum=nPum,
    final nVal=nVal,
    final minPumSpe=minPumSpe,
    final maxPumSpe=maxPumSpe,
    valPosClo=valPosClo,
    valPosOpe=valPosOpe,
    valOpeThr=valOpeThr,
    valCloThr=valCloThr,
    final speLim=speLim,
    final speLim1=speLim1,
    final speLim2=speLim2,
    final timPer1=timPer1,
    final timPer2=timPer2,
    final timPer3=timPer3,
    final k=kPumSpe,
    final Ti=TiPumSpe,
    final Td=TdPumSpe,
    sigDif=sigDifPumSpe,
    samplePeriodUniDelPumSpe=samplePeriodUniDelPumSpe,
    controllerTypePumSpe=controllerTypePumSpe)
    "Secondary pump controller"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.ChilledBeams.SetPoints.BypassValvePosition bypValPos(
    final nPum=nPum,
    final minPumSpe=minPumSpe,
    final dPumSpe=sigDifPumSpe,
    final dPChiWatMax=dPChiWatMax,
    final k=kBypVal,
    final Ti=TiBypVal,
    final Td=TdBypVal,
    final controllerType=controllerTypeBypVal)
    "Bypass valve position controller"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nPum](
    final k=pumStaOrd)
    "Chilled water pump staging order"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

equation
  connect(chiWatStaPreSetRes.yStaPreSetPoi, secPumCon.dpChiWatSet) annotation (
      Line(points={{-18,-60},{-10,-60},{-10,22},{-2,22}}, color={0,0,127}));
  connect(uPumSta, bypValPos.uPumSta) annotation (Line(points={{-120,60},{-50,60},
          {-50,-24},{38,-24}},
                            color={255,0,255}));
  connect(uPumSta, secPumCon.uChiWatPum) annotation (Line(points={{-120,60},{
          -50,60},{-50,34},{-2,34}}, color={255,0,255}));
  connect(uPumSta, chiWatStaPreSetRes.uPumSta) annotation (Line(points={{-120,60},
          {-50,60},{-50,-56},{-42,-56}},   color={255,0,255}));
  connect(conInt.y, secPumCon.uPumLeaLag) annotation (Line(points={{-58,80},{
          -40,80},{-40,38},{-2,38}}, color={255,127,0}));
  connect(secPumCon.yPumSpe, bypValPos.uPumSpe) annotation (Line(points={{22,28},
          {30,28},{30,-30},{38,-30}},
                                    color={0,0,127}));
  connect(dPChiWatLoo, bypValPos.dpChiWatLoo) annotation (Line(points={{-120,0},
          {-90,0},{-90,-36},{38,-36}},color={0,0,127}));
  connect(uValPos, secPumCon.uValPos) annotation (Line(points={{-120,-60},{-60,
          -60},{-60,30},{-2,30}},              color={0,0,127}));
  connect(uValPos, chiWatStaPreSetRes.uValPos) annotation (Line(points={{-120,
          -60},{-60,-60},{-60,-64},{-42,-64}},
                                        color={0,0,127}));
  connect(secPumCon.yChiWatPum, yChiWatPum) annotation (Line(points={{22,32},{
          30,32},{30,60},{120,60}},
                                 color={255,0,255}));
  connect(secPumCon.yPumSpe, yPumSpe) annotation (Line(points={{22,28},{30,28},{
          30,0},{120,0}}, color={0,0,127}));
  connect(bypValPos.yBypValPos, yBypValPos) annotation (Line(points={{62,-30},{
          80,-30},{80,-60},{120,-60}},
                                    color={0,0,127}));
  connect(dPChiWatLoo, secPumCon.dpChiWat_remote) annotation (Line(points={{-120,
          0},{-90,0},{-90,26},{-2,26}}, color={0,0,127}));
  annotation (defaultComponentName="sysCon",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-120,160},{114,108}},
          textString="%name",
          lineColor={0,0,255}),
                 Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,70},{-56,52}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uPumSta"),
        Text(
          extent={{-94,12},{-36,-12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dPChiWatLoo"),
        Text(
          extent={{-96,-50},{-56,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uValPos"),
        Text(
          extent={{50,76},{96,44}},
          textColor={255,85,255},
          textString="yChiWatPum"),
        Text(
          extent={{62,6},{96,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yPumSpe"),
        Text(
          extent={{56,-50},{96,-70}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yBypValPos")}),                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Sequences for operating the main chilled beam system.
</p>
<p>
This block generates signals for enabling the secondary chilled water pump
<code>yChiWatPum</code>, pump speed <code>yPumSpe</code> and bypass valve 
position signal <code>yBypValPos</code>. It consists of the following components:
<ol>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Controller\">
Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Controller</a>:
This block generates <code>yChiWatPum</code> and <code>yPumSpe</code> based on 
the chilled beam manifold control valve position <code>uValPos</code> and the 
measured chilled water loop differential pressure <code>dPChiWatLoo</code>.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterStaticPressureSetpointReset\">
Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterStaticPressureSetpointReset</a>:
This block generates the chilled water loop differential pressure setpoint based 
on <code>uValPos</code> and the pump proven on status <code>uPumSta</code>.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SetPoints.BypassValvePosition\">
Buildings.Controls.OBC.ChilledBeams.SetPoints.BypassValvePosition</a>:
This block generates <code>yBypValPos</code> based on <code>yChiWatPum</code>, 
<code>yPumSpe</code> and <code>dPChiWatLoo</code>.
</li>
</ol>
</p>
</html>",
revisions="<html>
<ul>
<li>
September 13, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
