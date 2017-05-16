within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block ActuatedReliefDamperWithoutFan
  "Control of actuated relief  dampers without fans"

  parameter Integer numOfZon = 5 "Total number of zones that the system serves";
  parameter Modelica.SIunit.Pressure buiPreSet(unit="Pa") = 0.05*248.84 "Building static pressure setpoint";
  parameter Real minRelDamPos = 0.1 "Relief damper position that maintains a building pressure of 0.05 inchWC (12.44 Pa) 
    while the system is at MinPosMin (i.e., the economizer damper is positioned to provide MinOA while the supply fan is at minimum speed)."
    annotation(Evaluate=true, Dialog(group="For Single-Zone AHU settings"));
  parameter Real maxRelDamPos = 0.9 "Relief damper position that maintains a building pressure of 0.05 inchWC (12.44 Pa) 
    while the economizer damper is fully open and the fan speed is at cooling maximum."
    annotation(Evaluate=true, Dialog(group="For Single-Zone AHU settings"));
  parameter Real minPosMin(min=0, max=1, unit="1") = 0.4
    "Outdoor air damper position, when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation(Evaluate=true, Dialog(group="For Single-Zone AHU settings"));
  parameter Real outDamPhyPosMax(min=0, max=1, unit="1")=1 "Physical or at the comissioning fixed maximum position of the economizer damper"
    annotation(Evaluate=true, Dialog(group="For Single-Zone AHU settings"));

  CDL.Continuous.Constant zerDam(k=0) "Close damper when disabled"
    annotation (Placement(transformation(extent={{-60,-28},{-40,-8}})));
  CDL.Continuous.Constant buiPreSetpoint(k=buiPreSet)
    "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-60,52},{-40,72}})));
  CDL.Continuous.LimPID damPosController(
    yMax=1,
    yMin=0,
    Td=0.1,
    Nd=1,
    k=1,
    Ti=300,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.P)
    "Contoller that outputs a signal based on the error between the measured "
    annotation (Placement(transformation(extent={{-20,52},{0,72}})));
  CDL.Interfaces.RealInput uBuiPre(unit="Pa") "Measured building static pressure" annotation (Placement(transformation(extent={{-140,18},
            {-100,58}}),     iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Interfaces.RealOutput yRelDamPos "Relief damper position" annotation (
      Placement(transformation(extent={{140,-10},{160,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));
  CDL.Interfaces.RealInput uOutDamPos(unit="1") "Outdoor damper position"
    annotation (Placement(transformation(extent={{-140,-94},{-100,-54}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Continuous.Constant minRelDam(k=minRelDamPos)
    "The relief damper position that maintains a building pressure of 0.05 inchWC (12.44 Pa) 
    while the system is at MinPosMin (i.e., the economizer damper is positioned to provide MinOA while the supply fan is at minimum speed)."
    annotation (Placement(transformation(extent={{-80,-126},{-60,-106}})));
  CDL.Continuous.Constant maxRelDam(k=maxRelDamPos)
    "The relief damper position that maintains a building pressure of 0.05 inchWC (12.44 Pa) while the economizer damper is fully open (physical maximum) and the fan speed is at cooling maximum."
    annotation (Placement(transformation(extent={{-80,-172},{-60,-152}})));
  CDL.Continuous.Constant minPosAtMinSpd(k=minPosMin)
    "Outdoor air damper position, when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-40,-104},{-20,-84}})));
  CDL.Continuous.Line relDamPos(limitBelow=true, limitAbove=true)
    "Relief damper position shall be reest linearly from minRelDamPos to maxRelDamPos as the commanded economizer damper position is goes from minPosMin to its physical maximum"
    annotation (Placement(transformation(extent={{20,-84},{40,-64}})));
  CDL.Continuous.Constant outDamPhyPosMaxSig(k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum position of the economizer damper - economizer damper fully open. "
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{60,-22},{80,-42}})));
  CDL.Logical.GreaterThreshold greThr
    annotation (Placement(transformation(extent={{-60,-68},{-40,-48}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  CDL.Continuous.Constant zonNum(k=numOfZon) "Number of zone"
    annotation (Placement(transformation(extent={{40,74},{60,94}})));
  CDL.Logical.GreaterThreshold greThr1(threshold=1)
    "Single zone or multiple zone?"
    annotation (Placement(transformation(extent={{80,74},{100,94}})));
  CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{100,-34},{120,-14}})));
equation
  connect(buiPreSetpoint.y, damPosController.u_s)
    annotation (Line(points={{-39,62},{-39,62},{-22,62}}, color={0,0,127}));
  connect(uBuiPre, damPosController.u_m) annotation (Line(points={{-120,38},{
          -64,38},{-10,38},{-10,50}},
                                  color={0,0,127}));
  connect(uSupFan, swi.u2)
    annotation (Line(points={{-120,0},{58,0}},         color={255,0,255}));
  connect(damPosController.y, swi.u1)
    annotation (Line(points={{1,62},{22,62},{22,8},{58,8}}, color={0,0,127}));
  connect(zerDam.y, swi.u3) annotation (Line(points={{-39,-18},{22,-18},{22,-8},
          {58,-8}}, color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, relDamPos.x2) annotation (Line(points={{-19,-140},
          {4,-140},{4,-78},{18,-78}}, color={0,0,127}));
  connect(maxRelDam.y, relDamPos.f2) annotation (Line(points={{-59,-162},{-59,-162},
          {12,-162},{12,-82},{18,-82}}, color={0,0,127}));
  connect(uOutDamPos, relDamPos.u) annotation (Line(points={{-120,-74},{-120,-74},
          {-4,-74},{18,-74}}, color={0,0,127}));
  connect(zerDam.y, swi1.u3) annotation (Line(points={{-39,-18},{-8,-18},{22,-18},
          {22,-24},{58,-24}}, color={0,0,127}));
  connect(greThr.y, and2.u2) annotation (Line(points={{-39,-58},{-32,-58},{-32,-48},
          {-22,-48}}, color={255,0,255}));
  connect(uSupFan, and2.u1) annotation (Line(points={{-120,0},{-80,0},{-80,-40},
          {-22,-40}}, color={255,0,255}));
  connect(and2.y, swi1.u2) annotation (Line(points={{1,-40},{20,-40},{20,-32},{58,
          -32}}, color={255,0,255}));
  connect(relDamPos.y, swi1.u1) annotation (Line(points={{41,-74},{48,-74},{48,-40},
          {58,-40}}, color={0,0,127}));
  connect(uOutDamPos, greThr.u) annotation (Line(points={{-120,-74},{-80,-74},{-80,
          -58},{-62,-58}}, color={0,0,127}));
  connect(minPosAtMinSpd.y, relDamPos.x1) annotation (Line(points={{-19,-94},{-12,
          -94},{-12,-66},{18,-66}}, color={0,0,127}));
  connect(minRelDam.y, relDamPos.f1) annotation (Line(points={{-59,-116},{-59,-116},
          {-4,-116},{-4,-70},{18,-70}}, color={0,0,127}));
  connect(zonNum.y, greThr1.u)
    annotation (Line(points={{61,84},{78,84}},     color={0,0,127}));
  connect(swi1.y, swi2.u3)
    annotation (Line(points={{81,-32},{89.5,-32},{98,-32}}, color={0,0,127}));
  connect(greThr1.y, swi2.u2) annotation (Line(
      points={{101,84},{108,84},{108,24},{92,24},{92,-24},{98,-24}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(swi.y, swi2.u1) annotation (Line(points={{81,0},{88,0},{88,-16},{98,-16}},
        color={0,0,127}));
  connect(swi2.y, yRelDamPos) annotation (Line(points={{121,-24},{126,-24},{126,
          0},{150,0}}, color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,64},{-56,28}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uBuiPre"),
        Text(
          extent={{-96,-12},{-52,-48}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan"),
        Text(
          extent={{34,22},{96,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRelDamPos"),
        Polygon(
          points={{-80,92},{-88,70},{-72,70},{-80,92}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,80},{-80,-88}}, color={192,192,192}),
        Line(points={{-90,-78},{82,-78}}, color={192,192,192}),
        Polygon(
          points={{90,-78},{68,-70},{68,-86},{90,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-78},{-80,-78},{14,62},{80,62}}, color={0,0,127})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{140,100}}),
        graphics={                   Rectangle(
          extent={{-100,-180},{140,-20}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{60,-138},{128,-166}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          fontSize=14,
          textStyle={TextStyle.Bold},
          horizontalAlignment=TextAlignment.Left,
          textString="Relief damper position 
control for single zone AHU"),
        Text(
          extent={{-98,100},{2,80}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          fontSize=14,
          textStyle={TextStyle.Bold},
          horizontalAlignment=TextAlignment.Left,
          textString="Relief damper position control for 
multiple zone AHU")}),
 Documentation(info="<html>      
<p>
This atomic sequence controls actuated relief dampers without fans. It is implemented according to ASHRAE Guidline 35 (G36), PART5.N.8.

This atomic sequence sets the minimum outdoor airflow setpoint. The implementation is according
to ASHRAE Guidline 36 (G36), PART5.N.3.a, PART5.B.2.b, PART3.1-D.2.a.
</p>   

</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActuatedReliefDamperWithoutFan;
