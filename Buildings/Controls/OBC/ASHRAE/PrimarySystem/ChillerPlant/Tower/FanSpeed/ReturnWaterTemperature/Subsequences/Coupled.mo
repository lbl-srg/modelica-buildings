within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences;
block Coupled
  "Sequence of defining cooling tower fan speed when the plant is close coupled"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Integer nConWatPum = 2 "Total number of condenser water pumps";
  parameter Real minSpe = 0.1 "Minimum cooling tower fan speed";
  parameter Real pumSpeChe = 0.005
    "Lower threshold value to check if condenser water pump is proven on";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Controller"));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Controller"));
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Controller", enable=
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax=1 "Upper limit of output"
    annotation (Dialog(group="Controller"));
  parameter Real yMin=0 "Lower limit of output"
    annotation (Dialog(group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRetSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput plrTowMaxSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Tower maximum speed that reset based on plant partial load ratio"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowSpe(
    final min=0,
    final max=1,
    final unit="1") "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{100,-90},{140,-50}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=yMin) "Condenser water return temperature controller"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTowSpe(
    final k=minSpe) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Line CWRTSpd
    "Fan speed calculated based on return water temperature control loop"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "Constant one"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis proOn[nConWatPum](
    final uLow=fill(pumSpeChe, nConWatPum),
    final uHigh=fill(pumSpeChe + 0.005, nConWatPum))
    "Check if the condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyProOn(final nu=nConWatPum)
    "Check if there is any condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin fanSpe(final nin=3)
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin maxSpe(final nin=nChi)
    "Lowest value of the maximum cooling tower speed from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi     "Logical switch"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

equation
  connect(TConWatRet, conPID.u_m)
    annotation (Line(points={{-120,30},{-50,30},{-50,48}}, color={0,0,127}));
  connect(TConWatRetSet, conPID.u_s)
    annotation (Line(points={{-120,60},{-62,60}}, color={0,0,127}));
  connect(conPID.y, CWRTSpd.u)
    annotation (Line(points={{-38,60},{58,60}}, color={0,0,127}));
  connect(zer.y, CWRTSpd.x1)
    annotation (Line(points={{22,100},{40,100},{40,68},{58,68}}, color={0,0,127}));
  connect(minTowSpe.y, CWRTSpd.f1)
    annotation (Line(points={{-38,100},{-20,100},{-20,64},{58,64}}, color={0,0,127}));
  connect(one.y, CWRTSpd.x2)
    annotation (Line(points={{22,40},{40,40},{40,56},{58,56}},
      color={0,0,127}));
  connect(one.y, CWRTSpd.f2)
    annotation (Line(points={{22,40},{40,40},{40,52},{58,52}},
      color={0,0,127}));
  connect(uConWatPumSpe, proOn.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(proOn.y, anyProOn.u)
    annotation (Line(points={{-58,0},{-42,0}}, color={255,0,255}));
  connect(CWRTSpd.y, fanSpe.u[1])
    annotation (Line(points={{82,60},{90,60},{90,-20},{0,-20},{0,-38.6667},{18,
          -38.6667}},
      color={0,0,127}));
  connect(maxSpe.y, fanSpe.u[2])
    annotation (Line(points={{-58,-40},{18,-40}}, color={0,0,127}));
  connect(plrTowMaxSpe, fanSpe.u[3])
    annotation (Line(points={{-120,-70},{-40,-70},{-40,-41.3333},{18,-41.3333}},
      color={0,0,127}));
  connect(uMaxTowSpeSet, maxSpe.u)
    annotation (Line(points={{-120,-40},{-82,-40}}, color={0,0,127}));
  connect(anyProOn.y, conPID.trigger)
    annotation (Line(points={{-18,0},{-10,0},{-10,20},{-58,20},{-58,48}},
      color={255,0,255}));
  connect(swi.y, yTowSpe)
    annotation (Line(points={{82,-70},{120,-70}}, color={0,0,127}));
  connect(anyProOn.y, swi.u2)
    annotation (Line(points={{-18,0},{-10,0},{-10,-70},{58,-70}},
      color={255,0,255}));
  connect(fanSpe.y, swi.u1)
    annotation (Line(points={{42,-40},{50,-40},{50,-62},{58,-62}},
      color={0,0,127}));
  connect(zer1.y, swi.u3)
    annotation (Line(points={{42,-100},{50,-100},{50,-78},{58,-78}},
      color={0,0,127}));

annotation (
  defaultComponentName="couTowSpe",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-20,80},{20,80},{0,10},{-20,80}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,10},{40,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-10},{-20,-80},{20,-80},{0,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
Block that output cooling tower fan speed <code>yTowSpe</code> based on the control
of condenser water return temperature for the plant that is closed coupled. 
This is implemented according to ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft 6 on July 25, 
2019), section 5.2.12.2, item 2.e-f.
</p>
<ul>
<li>
When any condenser water pump is proven on (<code>uConWatPumSpe</code> &gt; 0),
condenser water return temperature <code>TConWatRet</code> shall be maintained at 
setpoint <code>TConWatRetSet</code> by a direct acting PID loop. The loop output 
shall be mapped to the variable tower speed. Map the tower speed from minimum tower
speed <code>minSpe</code> at 0% loop output to 100% speed at 100% loop output.
</li>
<li>
The output tower speed <code>yTowSpe</code> shall be the lowest value of tower speed
from loop mapping, maximum cooling tower speed setpoint from each chiller head 
pressure control loop <code>uMaxTowSpeSet</code>, and tower maximum speed that reset 
based on plant partial load ratio <code>plrTowMaxSpe</code>. All operating fans shall
receive the same speed signal.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 9, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Coupled;
