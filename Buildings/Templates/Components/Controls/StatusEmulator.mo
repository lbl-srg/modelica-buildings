within Buildings.Templates.Components.Controls;
block StatusEmulator "Block that emulates the status of an equipment"
  parameter Modelica.Units.SI.Time riseTime=10
    "Rise time of the filter (time to reach 99.6 % of the speed)";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation (
      Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real y_start=0.0
    "Initial value of output (remaining states are in steady state)"
    annotation(Dialog(enable=initType == Modelica.Blocks.Types.Init.InitialOutput, group=
          "Initialization"));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1 "Equipment run command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1_actual
    "Equipment status" annotation (Placement(transformation(extent={{100,-20},{140,
            20}}), iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(final realTrue=1,
      final realFalse=0) "Convert to real"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Fluid.BaseClasses.ActuatorFilter fil(
    final f=fCut,
    final initType=initType,
    final y_start=y_start)
    "Filter signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr
    "Compare filtered signal to zero to trigger true status"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
protected
  final parameter Modelica.Units.SI.Frequency fCut=5/(2*Modelica.Constants.pi*
      riseTime) "Cut-off frequency of filter";
equation
  connect(y1, booToRea.u)
    annotation (Line(points={{-120,0},{-72,0}}, color={255,0,255}));
  connect(booToRea.y,fil. u)
    annotation (Line(points={{-48,0},{-12,0}}, color={0,0,127}));
  connect(greThr.y, y1_actual) annotation (Line(points={{72,0},{120,0}},
               color={255,0,255}));
  connect(fil.y, greThr.u)
    annotation (Line(points={{11,0},{48,0}}, color={0,0,127}));
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}));
end StatusEmulator;
