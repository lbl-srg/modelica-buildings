within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChilledWaterPump "Sequences to control chilled water pumps"

  parameter Integer num=2 "Total number of chilled water pumps"
    annotation (Dialog(group="Pumps"));
  parameter Integer iniLeaLagArr[num] = {1,0}
    "Initial arragement of lead pump, lead 1"
    annotation(Dialog(group="Pumps"));
  parameter Integer swiLeaLagArr[num]=
    {(-1)*iniLeaLagArr[i] + 1 for i in 1:num}
    "Initial arrangement of lag pump"
     annotation(Dialog(group="Pumps", enable=false));
  parameter Modelica.SIunits.Time tPumOn = 7*24*3600
    "Maximum lead pump running time"
    annotation(Dialog(group="Pumps"));
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
  parameter Modelica.SIunits.PressureDifference dpChiWatPum_norminal(
    final min=0,
    final displayUnit="Pa")=10000
    "Norminal chilled water pump differential pressure"
    annotation(Dialog(group="Chilled water pump controller"));
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
    annotation (Placement(transformation(extent={{-260,-90},{-220,-50}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-260,0},{-220,40}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure"
    annotation (Placement(transformation(extent={{-260,-40},{-220,0}}),
       iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable-disable status"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe[num](
    each final min=0,
    each final max=1,
    each final unit="1") "Chilled water pump speed"
    annotation (Placement(transformation(extent={{220,-20},{240,0}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Division chiWatFloRat
    "Chilled water flow ratio"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysChiWatFloRat(
    final uLow=chiWatFloRatSet - 0.05,
    final uHigh=chiWatFloRatSet + 0.05)
    "Check if chilled water flow ratio is above setpoint"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latLagPum "Lag pump control"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final controllerType=controllerTypePum,
    final k=kPum,
    final Ti=TiPum,
    final Td=TdPum,
    final yMax=1,
    u_s(final unit="Pa"),
    u_m(final unit="Pa"),
    final yMin=minPumSpe,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    y_reset=minPumSpe)  "Pumps controller"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomChiWatFlo(
    final k=VEva_nominal) "Total plant design flow"
    annotation (Placement(transformation(extent={{-220,-120},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch pumSpe
    "Switch between pump speed when plant enable and disable "
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain dpSetNor(
    k=1/dpChiWatPum_norminal)
    "Normalized chilled water pump differential pressure setpoint"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain dpNor(
    k=1/dpChiWatPum_norminal)
    "Normalized chilled water pump differential pressure"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Logical.Toggle tog
    "Change output only when input changes from false to true"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerPum(
    final k=0) "Pump not running"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) "Shut off lag pump"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    "Switch between lag status when plant enable and disable"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant iniLeaLag[num](
    final k=iniLeaLagArr)
    "Initial lead and lag pumps setting"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant swiLeaLag[num](
    final k=swiLeaLagArr)
    "Switched lead and lag pumps setting"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[num] "Switch lead and lag pumps setting"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=num) "Replicate input"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro[num] "Find product of inputs"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=num) "Replicate input "
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[num](
    each final k1=-1) "Add inputs"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1[num] "Add inputs"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3[num]
    "Switch between only lead pump is ON to both lead and lag pumps are ON"
    annotation (Placement(transformation(extent={{180,-20},{200,0}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=num) "Replicate input "
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=tStaLagPum)
    "Duration time threshold to check if flow ratio has been above setpoint for enough long time"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay shuLagPum(
    final delayTime=tShuLagPum)
    "Duration time threshold to check if flow ratio has been below setpoint for enough long time"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Modulo mod
    "Output the remainder of first input divided by second input"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timLeaPum
    "Duration time of lead pumps ON status"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant swiInt(
    final k=tPumOn)
    "Threshold time interval for lead-lag pump switch"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(
    final threshold=0.05)
    "Check if lead pump ON time achieves lead-lag switch point"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=5)
    "To ensure no lead-lag switch at initial time"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false) "False constant"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

equation
  connect(VEva_flow, chiWatFloRat.u1)
    annotation (Line(points={{-240,-70},{-200,-70},{-200,-74},{-182,-74}},
      color={0,0,127}));
  connect(nomChiWatFlo.y, chiWatFloRat.u2)
    annotation (Line(points={{-199,-110},{-188,-110},{-188,-86},{-182,-86}},
      color={0,0,127}));
  connect(chiWatFloRat.y, hysChiWatFloRat.u)
    annotation (Line(points={{-159,-80},{-142,-80}}, color={0,0,127}));
  connect(hysChiWatFloRat.y, not1.u)
    annotation (Line(points={{-119,-80},{-110,-80},{-110,-100},{-160,-100},
      {-160,-120},{-142,-120}}, color={255,0,255}));
  connect(uPla, pumSpe.u2)
    annotation (Line(points={{-240,120},{-200,120},{-200,60},{-100,60},
      {-100,20},{-82,20}}, color={255,0,255}));
  connect(latLagPum.y, logSwi.u1)
    annotation (Line(points={{1,-80},{6,-80},{6,-72},{18,-72}},
      color={255,0,255}));
  connect(con.y, logSwi.u3)
    annotation (Line(points={{1,-120},{10,-120},{10,-88},{18,-88}},
      color={255,0,255}));
  connect(zerPum.y, pumSpe.u3)
    annotation (Line(points={{-119,-20},{-100,-20},{-100,12},{-82,12}},
      color={0,0,127}));
  connect(conPID.y, pumSpe.u1)
    annotation (Line(points={{-139,20},{-120,20},{-120,28},{-82,28}},
      color={0,0,127}));
  connect(dpChiWatPumSet, dpSetNor.u)
    annotation (Line(points={{-240,20},{-202,20}}, color={0,0,127}));
  connect(dpSetNor.y, conPID.u_s)
    annotation (Line(points={{-179,20},{-162,20}}, color={0,0,127}));
  connect(dpChiWatPum, dpNor.u)
    annotation (Line(points={{-240,-20},{-202,-20}}, color={0,0,127}));
  connect(dpNor.y, conPID.u_m)
    annotation (Line(points={{-179,-20},{-150,-20},{-150,8}}, color={0,0,127}));
  connect(uPla, conPID.trigger)
    annotation (Line(points={{-240,120},{-200,120},{-200,60},{-170,60},
      {-170,0},{-158,0},{-158,8}}, color={255,0,255}));
  connect(booRep.y, swi2.u2)
    annotation (Line(points={{41,90},{58,90}}, color={255,0,255}));
  connect(swiLeaLag.y, swi2.u1)
    annotation (Line(points={{41,120},{50,120},{50,98},{58,98}},
      color={0,0,127}));
  connect(iniLeaLag.y, swi2.u3)
    annotation (Line(points={{41,60},{50,60},{50,82},{58,82}},
      color={0,0,127}));
  connect(swi2.y, pro.u1)
    annotation (Line(points={{81,90},{100,90},{100,96},{118,96}},
      color={0,0,127}));
  connect(pumSpe.y, reaRep.u)
    annotation (Line(points={{-59,20},{-42,20}}, color={0,0,127}));
  connect(reaRep.y, add2.u2)
    annotation (Line(points={{-19,20},{0,20},{0,4},{58,4}}, color={0,0,127}));
  connect(add2.y, add1.u2)
    annotation (Line(points={{81,10},{100,10},{100,4},{118,4}}, color={0,0,127}));
  connect(add1.y, swi3.u1)
    annotation (Line(points={{141,10},{150,10},{150,-2},{178,-2}},
      color={0,0,127}));
  connect(logSwi.y, booRep1.u)
    annotation (Line(points={{41,-80},{78,-80}}, color={255,0,255}));
  connect(booRep1.y, swi3.u2)
    annotation (Line(points={{101,-80},{120,-80},{120,-10},{178,-10}},
      color={255,0,255}));
  connect(swi3.y, yChiWatPumSpe)
    annotation (Line(points={{201,-10},{230,-10}}, color={0,0,127}));
  connect(hysChiWatFloRat.y, truDel.u)
    annotation (Line(points={{-119,-80},{-102,-80}}, color={255,0,255}));
  connect(truDel.y, latLagPum.u)
    annotation (Line(points={{-79,-80},{-21,-80}}, color={255,0,255}));
  connect(not1.y, shuLagPum.u)
    annotation (Line(points={{-119,-120},{-102,-120}}, color={255,0,255}));
  connect(shuLagPum.y, latLagPum.u0)
    annotation (Line(points={{-79,-120},{-38,-120},{-38,-86},{-21,-86}},
      color={255,0,255}));
  connect(uPla, timLeaPum.u)
    annotation (Line(points={{-240,120},{-182,120}}, color={255,0,255}));
  connect(timLeaPum.y, mod.u1)
    annotation (Line(points={{-159,120},{-150,120},{-150,96},{-142,96}},
      color={0,0,127}));
  connect(swiInt.y, mod.u2)
    annotation (Line(points={{-159,90},{-150,90},{-150,84},{-142,84}},
      color={0,0,127}));
  connect(mod.y, lesEquThr.u)
    annotation (Line(points={{-119,90},{-114.5,90},{-114.5,90},{-102,90}},
                  color={0,0,127}));
  connect(timLeaPum.y, greEquThr.u)
    annotation (Line(points={{-159,120},{-102,120}}, color={0,0,127}));
  connect(lesEquThr.y, and2.u2)
    annotation (Line(points={{-79,90},{-70,90},{-70,112},{-62,112}},
      color={255,0,255}));
  connect(greEquThr.y, and2.u1)
    annotation (Line(points={{-79,120},{-62,120}}, color={255,0,255}));
  connect(and2.y, tog.u)
    annotation (Line(points={{-39,120},{-30,120},{-30,110},{-21,110}},
      color={255,0,255}));
  connect(tog.y, booRep.u)
    annotation (Line(points={{1,110},{10,110},{10,90},{18,90}}, color={255,0,255}));
  connect(con1.y, tog.u0)
    annotation (Line(points={{-39,90},{-30,90},{-30,104},{-21,104}},
      color={255,0,255}));
  connect(reaRep.y, pro.u2)
    annotation (Line(points={{-19,20},{0,20},{0,40},{100,40},{100,84},
      {118,84}}, color={0,0,127}));
  connect(pro.y, add2.u1)
    annotation (Line(points={{141,90},{160,90},{160,36},{20,36},{20,16},
      {58,16}}, color={0,0,127}));
  connect(pro.y, add1.u1)
    annotation (Line(points={{141,90},{160,90},{160,36},{100,36},{100,16},
      {118,16}}, color={0,0,127}));
  connect(pro.y, swi3.u3)
    annotation (Line(points={{141,90},{160,90},{160,-18},{178,-18}}, color={0,0,127}));
  connect(uPla, logSwi.u2)
    annotation (Line(points={{-240,120},{-200,120},{-200,60},{-4,60},{-4,-60},
      {10,-60},{10,-80},{18,-80}}, color={255,0,255}));

annotation (
  defaultComponentName="chiWatPum",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-220,-140},{220,140}}),
  graphics={                         Rectangle(
          extent={{-218,138},{158,82}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-218,58},{-42,-38}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-218,-62},{58,-138}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-104,-26},{-46,-36}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Pump speed control"),
        Text(
          extent={{12,-122},{54,-140}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Lag pump status"),
                                     Rectangle(
          extent={{2,82},{158,-18}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{84,136},{148,122}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Lead-lag pumps switch")}),
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
          extent={{-94,-24},{-24,-52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPum"),
        Text(
          extent={{-94,-62},{-6,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPumSet"),
        Text(
          extent={{-96,50},{-42,28}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VEva_flow"),
        Text(
          extent={{26,16},{96,-12}},
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
