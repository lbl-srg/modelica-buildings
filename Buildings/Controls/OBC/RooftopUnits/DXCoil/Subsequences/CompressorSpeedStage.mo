within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block CompressorSpeedStage
  "Sequence for regulating compressor speed corresponding to previously enabled DX coil signal"
  extends Modelica.Blocks.Icons.Block;

  parameter Real conCooCoiLow(
    final min=0,
    final max=1)=0.2
    "Constant lower cooling coil valve position signal";

  parameter Real conCooCoiHig(
    final min=0,
    final max=1)=0.8
    "Constant higher cooling coil valve position signal";

  parameter Real minComSpe(
    final min=0,
    final max=maxComSpe) = 0.1
    "Minimum compressor speed"
    annotation (Dialog(group="Compressor parameters"));

  parameter Real maxComSpe(
    final min=minComSpe,
    final max=1) = 1
    "Maximum compressor speed"
    annotation (Dialog(group="Compressor parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPreDXCoi
    "Previously enabled DX coil signal"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,38},{-100,78}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Compressor commanded speed"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.Continuous.LimPID conP(
    final controllerType=controllerType,
    final k=k,
    final yMax=1,
    final yMin=0,
    final reverseActing=false)
    "Regulate compressor speed"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add
    "Logical Add"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMinSpe(
    final k=minComSpe)
    "Minimum compressor speed"
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch between the speed calculated by the P controller and the maximum speed"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conDXCoi(
    final k=conCooCoiLow)
    "Constant DX coil signal with lower value"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMaxSpe(
    final k=maxComSpe)
    "Maximum compressor speed"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min
    "Pass through the minimum compressor speed"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

protected
  parameter Real k = (maxComSpe - minComSpe) / (conCooCoiHig- conCooCoiLow)
    "Gain of DX coil controller"
    annotation (Dialog(group="P controller"));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P
    "Type of DX coil controller"
    annotation (Dialog(group="P controller"));

equation
  connect(conP.u_m, uCooCoi) annotation (Line(points={{-50,-42},{-50,-60},{
          -140,-60}},                  color={0,0,127}));
  connect(conDXCoi.y, conP.u_s)
    annotation (Line(points={{-78,-30},{-62,-30}}, color={0,0,127}));
  connect(uPreDXCoi, swi.u2) annotation (Line(points={{-140,40},{60,40},{60,
          0},{78,0}}, color={255,0,255}));
  connect(swi.y, yComSpe)
    annotation (Line(points={{102,0},{140,0}},color={0,0,127}));
  connect(conP.y, add.u2) annotation (Line(points={{-39,-30},{-30,-30},{-30,
          -36},{-22,-36}},
                    color={0,0,127}));
  connect(conMinSpe.y, add.u1) annotation (Line(points={{-38,12},{-30,12},{
          -30,-24},{-22,-24}},
                     color={0,0,127}));
  connect(conMaxSpe.y, swi.u1)
    annotation (Line(points={{42,60},{70,60},{70,8},{78,8}}, color={0,0,127}));
  connect(min.y, swi.u3) annotation (Line(points={{42,-50},{60,-50},{60,-8},
          {78,-8}}, color={0,0,127}));
  connect(add.y, min.u2) annotation (Line(points={{2,-30},{8,-30},{8,-56},{
          18,-56}}, color={0,0,127}));
  connect(conMaxSpe.y, min.u1) annotation (Line(points={{42,60},{50,60},{50,
          0},{14,0},{14,-44},{18,-44}}, color={0,0,127}));

  annotation (
    defaultComponentName="ComSpeSta",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255}),
       Text(extent={{-94,66},{-44,50}},
          textColor={255,0,255},
          textString="uPreDXCoi"),
          Text(
            extent={{-94,-52},{-50,-68}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uCooCoi"),
          Text(
            extent={{40,8},{90,-8}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="yComSpe")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
  Documentation(info="<html>
  <p>
  This is a control module for regulating compressor speed, utilizing a previously enabled DX coil signal. 
  The control module is operated as follows: 
  </p>
  <ul>
  <li>
  Run compressor speed <code>yComSpe</code> at its maximum level when the previously enabled DX coil signal
  is true <code>uPreDXCoi = true</code>.
  </li>
  <li>
  Implement a linear mapping to modulate <code>yComSpe</code>, aligning its minimum and maximum speed 
  with a lower cooling coil valve position signal <code>conCooCoiLow</code> and a higher one 
  <code>conCooCoiHig</code> from the cooling coil signal <code>uCooCoi</code> when <code>uPreDXCoi = false</code>.
  </li>
  </ul>
  </html>", revisions="<html>
  <ul>
  <li>
  August 4, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end CompressorSpeedStage;
