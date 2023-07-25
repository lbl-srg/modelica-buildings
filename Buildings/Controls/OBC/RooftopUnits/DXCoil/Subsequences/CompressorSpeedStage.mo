within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block CompressorSpeedStage
    "Compressor speed controller corresponding to DX coil staging status"
  extends Modelica.Blocks.Icons.Block;

  parameter Real conCooCoiLow=0.2
    "Constant lower DX coil signal";

  parameter Real conCooCoiHig=0.8
    "Constant higher DX coil signal";

  parameter Real minComSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=maxComSpe) = 0.1
    "Minimum compressor speed"
    annotation (Dialog(group="Compressor parameters"));

  parameter Real maxComSpe(
    final unit="1",
    displayUnit="1",
    final min=minComSpe,
    final max=1) = 1
    "Maximum compressor speed"
    annotation (Dialog(group="Compressor parameters"));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P
    "Type of DX coil controller"
    annotation (Dialog(group="P controller"));

  parameter Real k = (maxComSpe - minComSpe) / (conCooCoiHig- conCooCoiLow)
    "Gain of DX coil controller"
    annotation (Dialog(group="P controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Compressor commanded speed"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.Continuous.LimPID conP(
    controllerType=controllerType,
    k=k,
    yMax=1,
    yMin=0,
    reverseActing=false)
    "Regulate compressor speed"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add "Logical Add"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMinSpe(
    k=minComSpe)
    "Minimum compressor speed"
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch between the speed calculated by the P controller and the maximum speed"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPreDXCoi
    "Previous enable DX coil signal" annotation (Placement(transformation(
          extent={{-160,20},{-120,60}}), iconTransformation(extent={{-140,
            38},{-100,78}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conDXCoi(
    k=conCooCoiLow) "Constant DX coil signal with lower value"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMaxSpe(
    k=maxComSpe)
    "Maximum compressor speed"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  CDL.Continuous.Min min "Pass through the minimum compressor speed"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})));
end CompressorSpeedStage;
