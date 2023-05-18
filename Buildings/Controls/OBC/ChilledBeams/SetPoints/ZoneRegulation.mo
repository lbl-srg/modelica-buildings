within Buildings.Controls.OBC.ChilledBeams.SetPoints;
block ZoneRegulation
  "Controller for zone CAV box and chilled beam manifold"

  parameter Real conSenOnThr(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 60
    "Threshold time for condensation sensor signal before CAV damper is completely opened";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=
     Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Cooling loop signal"));

  parameter Real kCoo(final unit="1/K") = 0.1
    "Gain for cooling control loop signal"
    annotation(Dialog(group="Cooling loop signal"));

  parameter Real TiCoo(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for cooling control loop signal"
    annotation(Dialog(group="Cooling loop signal",
      enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdCoo(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(group="Cooling loop signal",
      enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Heating loop signal"));

  parameter Real kHea(final unit="1/K")=0.1
    "Gain for heating control loop signal"
    annotation(Dialog(group="Heating loop signal"));

  parameter Real TiHea(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for heating control loop signal"
    annotation(Dialog(group="Heating loop signal",
    enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdHea(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for heating control loop signal"
    annotation (Dialog(group="Heating loop signal",
      enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Damper"));

  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation (Dialog(group="Damper"));

  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation (Dialog(group="Damper",
      enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper",
      enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real VDes_occ(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Design air volume flow rate when zone is occupied"
    annotation (Dialog(group="Airflow setpoints"));

  parameter Real VDes_unoccSch(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Design air volume flow rate when zone is unoccupied during scheduled unoccupancy"
    annotation (Dialog(group="Airflow setpoints"));

  parameter Real VDes_unoccUnsch(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Design air volume flow rate when zone is unoccupied during scheduled occupancy"
    annotation (Dialog(group="Airflow setpoints"));

  parameter Real zonOccHeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")=293.15
    "Zone heating setpoint when it is occupied"
    annotation (Dialog(tab="Setpoints", group="Zone temperature setpoints"));

  parameter Real zonUnoccHeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")=290.15
    "Zone heating setpoint when it is unoccupied"
    annotation (Dialog(tab="Setpoints", group="Zone temperature setpoints"));

  parameter Real zonOccCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")=296.15
    "Zone cooling setpoint when it is occupied"
    annotation (Dialog(tab="Setpoints", group="Zone temperature setpoints"));

  parameter Real zonUnoccCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")=299.15
    "Zone cooling setpoint when it is unoccupied"
    annotation (Dialog(tab="Setpoints", group="Zone temperature setpoints"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConSen
    "Signal from condensation sensor in zone"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-140,-34},{-100,6}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-180,-190},{-140,-150}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
      iconTransformation(extent={{-140,32},{-100,72}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
      iconTransformation(extent={{-140,-68},{-100,-28}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiVal(
    final min=0,
    final max=1,
    final unit="1")
    "Signal for chilled beam manifold valve"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final max=1,
    final unit="1")
    "Signal for CAV damper"
    annotation (Placement(transformation(extent={{140,-50},{180,-10}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yReh(
    final min=0,
    final max=1,
    final unit="1")
    "Reheat signal to CAV terminal"
    annotation (Placement(transformation(extent={{140,140},{180,180}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=3)
    "Find required volume flow rate"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));

  CDL.Interfaces.RealInput TZonCooSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="K") "Zone cooling setpoint temperature" annotation (Placement(
        transformation(extent={{-180,60},{-140,100}}), iconTransformation(
          extent={{-140,0},{-100,40}})));
  CDL.Interfaces.RealInput TZonHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="K") "Zone heating setpoint temperature" annotation (Placement(
        transformation(extent={{-180,140},{-140,180}}), iconTransformation(
          extent={{-140,62},{-100,102}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conHeaLoo(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final yMax=1,
    final yMin=0)
    "Heating loop signal"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conCooLoo(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final yMax=1,
    final yMin=0,
    reverseActing=false)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdHea,
    final yMax=1,
    final yMin=0)
    "Damper control to regulate measured air flowrate at required air flowrate"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro[3]
    "Product of required volume flow rate for a given mode and the current mode status"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[3](
    final k={VDes_occ,VDes_unoccSch,VDes_unoccUnsch})
    "Design volume fliow rates for each operation mode"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=3)
    "Integer replicator"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[3]
    "Find current mode from all possible modes"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[3]
    "Output real \"one\" signal for currently active mode and \"zero\" for others"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1
    "Product to close chilled beam manifold valve due to condensation"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Condensation detected in the zone")
    "Zone condensation warning"
    annotation (Placement(transformation(extent={{50,60},{70,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch to completely open damper when condensation is detected, and regulate its position otherwise"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1)
    "Constant CAV damper open signal"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=conSenOnThr)
    "Check if condensation sensor signal has been on for time beyond threshold"
    annotation (Placement(transformation(extent={{-48,30},{-28,50}})));

  Buildings.Controls.OBC.CDL.Integers.Equal isUnOcc
    "Reset PI controllers at start of zone non-occupancy"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntUn(
 final k=Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.occupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
 final k={
  Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.occupied,
  Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.unoccupiedScheduled,
  Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.unoccupiedUnscheduled})
    "List of possible modes"
    annotation (Placement(transformation(extent={{-110,-120},{-90,-100}})));

equation
  connect(TZon, conHeaLoo.u_m)
    annotation (Line(points={{-160,120},{-130,120},{-130,140},{10,140},{10,148}},
                   color={0,0,127}));

  connect(TZon, conCooLoo.u_m)
    annotation (Line(points={{-160,120},{-130,120},{-130,100},{10,100},{10,108}},
                   color={0,0,127}));

  connect(conIntUn.y, isUnOcc.u1)
    annotation (Line(points={{-38,-150},{-22,-150}}, color={255,127,0}));

  connect(uOpeMod, isUnOcc.u2) annotation (Line(points={{-160,-170},{-32,-170},{
          -32,-158},{-22,-158}}, color={255,127,0}));

  connect(conHeaLoo.y, yReh)
    annotation (Line(points={{22,160},{160,160}}, color={0,0,127}));

  connect(VDis_flow, conDam.u_m)
    annotation (Line(points={{-160,-50},{10,-50},{10,-42}}, color={0,0,127}));

  connect(conDam.u_s, mulSum.y)
    annotation (Line(points={{-2,-30},{-8,-30}}, color={0,0,127}));

  connect(pro.y, mulSum.u[1:3]) annotation (Line(points={{-38,-30},{-36,-30},{
          -36,-29.3333},{-32,-29.3333}},
                                     color={0,0,127}));

  connect(con.y, pro.u1) annotation (Line(points={{-78,-10},{-70,-10},{-70,-24},
          {-62,-24}}, color={0,0,127}));

  connect(uOpeMod, intRep.u) annotation (Line(points={{-160,-170},{-120,-170},{-120,
          -80},{-112,-80}}, color={255,127,0}));

  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-88,-80},{-82,-80}}, color={255,127,0}));

  connect(isUnOcc.y, conDam.trigger) annotation (Line(points={{2,-150},{12,-150},
          {12,-60},{4,-60},{4,-42}}, color={255,0,255}));

  connect(isUnOcc.y, conCooLoo.trigger) annotation (Line(points={{2,-150},{12,-150},
          {12,-60},{-110,-60},{-110,90},{4,90},{4,108}}, color={255,0,255}));

  connect(isUnOcc.y, conHeaLoo.trigger) annotation (Line(points={{2,-150},{12,-150},
          {12,-60},{-110,-60},{-110,144},{4,144},{4,148}}, color={255,0,255}));

  connect(conInt.y, intEqu.u2) annotation (Line(points={{-88,-110},{-86,-110},{-86,
          -88},{-82,-88}}, color={255,127,0}));

  connect(intEqu.y, booToRea.u)
    annotation (Line(points={{-58,-80},{-52,-80}}, color={255,0,255}));

  connect(booToRea.y, pro.u2) annotation (Line(points={{-28,-80},{-20,-80},{-20,
          -56},{-80,-56},{-80,-36},{-62,-36}}, color={0,0,127}));

  connect(not1.y, booToRea1.u)
    annotation (Line(points={{32,40},{48,40}}, color={255,0,255}));

  connect(booToRea1.y, pro1.u2) annotation (Line(points={{72,40},{80,40},{80,34},
          {88,34}}, color={0,0,127}));

  connect(conCooLoo.y, pro1.u1) annotation (Line(points={{22,120},{80,120},{80,46},
          {88,46}}, color={0,0,127}));

  connect(pro1.y, yChiVal)
    annotation (Line(points={{112,40},{160,40}}, color={0,0,127}));

  connect(not1.y, assMes.u) annotation (Line(points={{32,40},{40,40},{40,70},{48,
          70}}, color={255,0,255}));

  connect(swi.y, yDam)
    annotation (Line(points={{102,-30},{160,-30}}, color={0,0,127}));

  connect(conDam.y, swi.u3) annotation (Line(points={{22,-30},{60,-30},{60,-38},
          {78,-38}}, color={0,0,127}));

  connect(con1.y, swi.u1) annotation (Line(points={{22,10},{70,10},{70,-22},{78,
          -22}}, color={0,0,127}));

  connect(uConSen, tim.u) annotation (Line(points={{-160,40},{-50,40}},
                     color={255,0,255}));

  connect(tim.passed, swi.u2) annotation (Line(points={{-26,32},{-10,32},{-10,-8},
          {66,-8},{66,-30},{78,-30}},
                     color={255,0,255}));

  connect(tim.passed, not1.u) annotation (Line(points={{-26,32},{-10,32},{-10,40},
          {8,40}}, color={255,0,255}));

  connect(conCooLoo.u_s, TZonCooSet) annotation (Line(points={{-2,120},{-56,120},
          {-56,80},{-160,80}}, color={0,0,127}));
  connect(conHeaLoo.u_s, TZonHeaSet)
    annotation (Line(points={{-2,160},{-160,160}}, color={0,0,127}));
annotation (defaultComponentName="zonRegCon",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,160},{114,108}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-100,58},{-76,48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,-42},{-66,-54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,-74},{-68,-88}},
          textColor={244,125,35},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{74,44},{98,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yReh"),
        Text(
          extent={{72,6},{98,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiVal"),
        Text(
          extent={{74,-34},{98,-44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDam"),
        Text(
          extent={{-96,-6},{-60,-22}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uConSen"),
        Text(
          extent={{-98,94},{-54,68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSet"),
        Text(
          extent={{-98,30},{-52,12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet")}),
    Diagram(coordinateSystem(extent={{-140,-180},{140,180}})),
Documentation(info="<html>
<p>
Zone temperature regulation controller for terminal box of CAV DOAS system with
reheat and chilled beam mainfold valves. It outputs damper position <code>yDam</code>,
reheat signal <code>yReh</code>, and chilled water manifold control valve position
<code>yVal</code>.
</p>
<p>
Each signal is calculated as follows.
<ol>
<li>
Reheat signal
<ul>
<li>
The CAV reheat signal <code>yReh</code> is generated using a PI-controller to
maintain the measured zone temperature <code>TZon</code> at or above the zone heating
setpoint <code>TZonHeaSet</code> from
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SetPoints.ZoneTemperature\">
Buildings.Controls.OBC.ChilledBeams.SetPoints.ZoneTemperature</a>.
</li>
</ul>
</li>
<li>
Damper signal
<ul>
<li>
The CAV damper position signal <code>yDam</code> is modified based on the operating
mode signal <code>uOpeMod</code>.
</li>
<li>
When the operating mode is <code>occupied</code>, <code>yDam</code> is adjusted
to supply air at volume flow rate <code>VDes_occ</code>.
</li>
<li>
When the operating mode is <code>unoccupiedUnscheduled</code>, <code>yDam</code>
is adjusted to supply air at volume flow rate <code>VDes_unoccUnsch</code>.
</li>
<li>
When the operating mode is <code>unoccupiedScheduled</code>, <code>yDam</code>
is adjusted to supply air at volume flow rate <code>VDes_unoccSch</code>.
</li>
<li>
When a continuous signal is received from the condensation sensor in the zone
<code>uConSen</code> for time <code>conSenOnThr</code>, <code>yDam</code> is set
to fully open.
</li>
</ul>
</li>
<li>
Chilled beam control valve position
<ul>
<li>
The chilled beam control valve position <code>yVal</code> is adjusted using a
PI-controller to regulate <code>TZon</code> at or below the zone cooling setpoint
<code>TZonCooSet</code> from
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SetPoints.ZoneTemperature\">
Buildings.Controls.OBC.ChilledBeams.SetPoints.ZoneTemperature</a>.
</li>
<li>
If <code>uConSen</code> is continuously enabled for time <code>conSenOnThr</code>,
<code>yVal</code> is set to fully closed. An alarm is generated for the operator.
</li>
</ul>
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
September 9, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneRegulation;
