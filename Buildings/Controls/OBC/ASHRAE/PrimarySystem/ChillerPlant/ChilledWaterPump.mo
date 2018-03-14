within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChilledWaterPump "Sequences to control chilled water pumps"

  parameter Integer num=2 "Total number of chilled water pumps";
  parameter Modelica.SIunits.VolumeFlowRate VEva_nominal
    "Total plant design flow rate";
  parameter Real chiWatFloRatSet(
    final min=0,
    final max=1) = 0.47
    "Chilled water flow ratio setpoint";
  parameter Modelica.SIunits.Time tStaLagPum = 600
    "Minimum duration time that flow ratio is above its setpoint";
  parameter Modelica.SIunits.Time tShuLagPum = 900
    "Minimum duration time that flow ratio is below its setpoint";
  parameter Real minPumSpe(
    final min=0,
    final max=1)=0.1 "Minimum pump speed"
    annotation(Dialog(group="Chilled water pump controller"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypePum=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Chilled water pump controller"));
  parameter Real kPum(final unit="1")=0.5
    "Gain of controller for pump control"
    annotation(Dialog(group="Chilled water pump controller"));
  parameter Modelica.SIunits.Time TiPum=300
    "Time constant of integrator block for pump control"
    annotation(Dialog(group="Chilled water pump controller",
      enable=controllerTypePum == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypePum == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time TdPum=0.1
    "Time constant of derivative block for pump control"
    annotation (Dialog(group="Chilled water pump controller",
      enable=controllerTypePum == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
        or controllerTypePum == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VEva_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure"
     annotation (Placement(transformation(extent={{-180,-30},{-140,10}}),
       iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable-disable status"
     annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
       iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[num]
    "Chilled water pumps status"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{140,20},{160,40}}),
      iconTransformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Status of lead pump"
    annotation (Placement(transformation(extent={{140,90},{160,110}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLagPum "Status of lag pump"
    annotation (Placement(transformation(extent={{140,-70},{160,-50}}),
      iconTransformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Division chiWatFloRat
    "Chilled water flow ratio"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysChiWatFloRat(
    final uLow=chiWatFloRatSet - 0.05,
    final uHigh=chiWatFloRatSet + 0.05)
    "Check if chilled water flow ratio is above setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer onTimer
    "Count the time when chilled water flow ratio becomes above setpoint"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer offTimer
    "Count the time when chilled water flow ratio becomes below setpoint"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold staLagPum(
    final threshold=tStaLagPum)
    "Duration time threshold to check if flow ratio has been above setpoint for enough long time"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold shuLagPum(
    final threshold=tShuLagPum)
    "Duration time threshold to check if flow ratio has been below setpoint for enough long time"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latLagPum "Lag pump control"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final controllerType=controllerTypePum,
    final k=kPum,
    final Ti=TiPum,
    final Td=TdPum,
    final yMax=1,
    final yMin=0,
    u_s(final unit="Pa"),
    u_m(final unit="Pa"))  "Pumps controller"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Ensure pump speed being more than minimum speed"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between pump on and off speed"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minPumSpeCon(
    final k=minPumSpe) "Minimum speed setpoint in VFDs"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerPum(
    final k=0) "Pump not running"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomChiWatFlo(
    final k=VEva_nominal) "Total plant design flow"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) "Shut off lag pump"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[num] "Logical not"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=num) "Check if all pumps are proven off"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Switch between pump speed when plant enable and disable "
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    "Switch between lag status when plant enable and disable"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

equation
  connect(not2.y, mulAnd.u)
    annotation (Line(points={{-99,70},{-82,70}}, color={255,0,255}));
  connect(VEva_flow, chiWatFloRat.u1)
    annotation (Line(points={{-160,-50},{-120,-50},{-120,-54},{-102,-54}},
      color={0,0,127}));
  connect(nomChiWatFlo.y, chiWatFloRat.u2)
    annotation (Line(points={{-119,-90},{-108,-90},{-108,-66},{-102,-66}},
      color={0,0,127}));
  connect(chiWatFloRat.y, hysChiWatFloRat.u)
    annotation (Line(points={{-79,-60},{-62,-60}},color={0,0,127}));
  connect(not1.y, offTimer.u)
    annotation (Line(points={{-39,-100},{-22,-100}},color={255,0,255}));
  connect(onTimer.y, staLagPum.u)
    annotation (Line(points={{1,-60},{18,-60}},  color={0,0,127}));
  connect(offTimer.y, shuLagPum.u)
    annotation (Line(points={{1,-100},{18,-100}},  color={0,0,127}));
  connect(staLagPum.y, latLagPum.u)
    annotation (Line(points={{41,-60},{59,-60}}, color={255,0,255}));
  connect(shuLagPum.y, latLagPum.u0)
    annotation (Line(points={{41,-100},{50,-100},{50,-66},{59,-66}},
      color={255,0,255}));
  connect(dpChiWatPumSet, conPID.u_s)
    annotation (Line(points={{-160,30},{-122,30}},color={0,0,127}));
  connect(dpChiWatPum, conPID.u_m)
    annotation (Line(points={{-160,-10},{-110,-10},{-110,18}}, color={0,0,127}));
  connect(conPID.y, max.u1)
    annotation (Line(points={{-99,30},{-90,30},{-90,36},{-62,36}},
      color={0,0,127}));
  connect(minPumSpeCon.y, max.u2)
    annotation (Line(points={{-79,-10},{-70,-10},{-70,24},{-62,24}},
      color={0,0,127}));
  connect(zerPum.y, swi.u3)
    annotation (Line(points={{-39,-10},{-20,-10},{-20,22},{-2,22}},
      color={0,0,127}));
  connect(max.y, swi.u1)
    annotation (Line(points={{-39,30},{-20,30},{-20,38},{-2,38}},
      color={0,0,127}));
  connect(uChiWatPum, not2.u)
    annotation (Line(points={{-160,70},{-122,70}}, color={255,0,255}));
  connect(mulAnd.y, not3.u)
    annotation (Line(points={{-58.3,70},{-42,70}}, color={255,0,255}));
  connect(not3.y, swi.u2)
    annotation (Line(points={{-19,70},{-10,70},{-10,30},{-2,30}},
      color={255,0,255}));
  connect(uPla, yLeaPum)
    annotation (Line(points={{-160,100},{150,100}}, color={255,0,255}));
  connect(hysChiWatFloRat.y, onTimer.u)
    annotation (Line(points={{-39,-60},{-22,-60}},color={255,0,255}));
  connect(hysChiWatFloRat.y, not1.u)
    annotation (Line(points={{-39,-60},{-30,-60},{-30,-80},{-80,-80},{-80,-100},
      {-62,-100}}, color={255,0,255}));
  connect(uPla, swi1.u2)
    annotation (Line(points={{-160,100},{88,100},{88,30},{98,30}},
      color={255,0,255}));
  connect(swi.y, swi1.u1)
    annotation (Line(points={{21,30},{40,30},{40,38},{98,38}}, color={0,0,127}));
  connect(swi1.y, yChiWatPumSpe)
    annotation (Line(points={{121,30},{150,30}}, color={0,0,127}));
  connect(logSwi.y, yLagPum)
    annotation (Line(points={{121,-60},{150,-60}}, color={255,0,255}));
  connect(latLagPum.y, logSwi.u1)
    annotation (Line(points={{81,-60},{84,-60},{84,-52},{98,-52}},
      color={255,0,255}));
  connect(uPla, logSwi.u2)
    annotation (Line(points={{-160,100},{88,100},{88,-60},{98,-60}},
      color={255,0,255}));
  connect(con.y, logSwi.u3)
    annotation (Line(points={{81,-100},{90,-100},{90,-68},{98,-68}},
      color={255,0,255}));
  connect(zerPum.y, swi1.u3)
    annotation (Line(points={{-39,-10},{40,-10},{40,22},{98,22}},
      color={0,0,127}));

annotation (
  defaultComponentName="chiWatPum",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-140,-120},{140,120}}),
  graphics={Rectangle(
          extent={{-138,78},{138,-18}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-138,-42},{138,-118}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
  Icon(graphics={Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,90},{-66,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uPla"),
        Text(
          extent={{-94,56},{-24,28}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{-94,16},{-24,-12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPum"),
        Text(
          extent={{-94,-22},{-6,-50}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPumSet"),
        Text(
          extent={{-96,-70},{-42,-92}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VEva_flow"),
        Text(
          extent={{50,-58},{96,-80}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yLagPum"),
        Text(
          extent={{50,12},{96,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yLeaPum"),
        Text(
          extent={{26,86},{96,58}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatPumSpe")}),
Documentation(info="<html>
<p>
Block that output chilled water pumps speed <code>yChiWatPumSpe</code>, 
lead and lag pumps status <code>yLeaPum</code>, <code>yLagPum</code>  
according to ASHRAE Fundamentals of Chilled Water Plant 
Design and Control SDL, Chapter 7, Appendix B, 1.01.B.11.
</p>
<p>
a. Chilled water pumps shall be lead-lag alternated.
</p>
<p>
b. Chilled water pumps shall be staged as a function of chilled water flow rate
ratio (CHWFR), which is calculated from actual flow <code>VEva_flow</code> divided by
total plant design flow <code>VEva_nominal</code>. The lead pump shall run 
whenever the plant (<code>uPla</code>) is enabled. When CHWFR is above 
<code>chiWatFloRatSet</code> (e.g. 47%) for <code>tStaLagPum</code> (e.g. 10 
minutes), start the lag pump. When CHWFR is below <code>chiWatFloRatSet</code> 
for <code>tShuLagPum</code> (e.g. 15 minutes), shut off the lag pump.
</p>
<p>
c. When any pump is proven on (<code>uChiWatPum = true</code>), pump speed 
<code>yChiWatPumSpe</code> will be controlled by a PID loop maintaining the
differential pressure signal <code>dpChiWatPum</code> at a setpoint 
<code>dpChiWatPumSet</code>. All pumps receive the same speed signal. Minimum
speed setpoint <code>minPumSpe</code> in VFD shall be 10%.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChilledWaterPump;
