within Buildings.Examples.VAVReheat.Controls;
block EconomizerTemperatureControl
  "Controller for economizer mixed air temperature"
  extends Modelica.Blocks.Icons.Block;
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  Buildings.Controls.Continuous.LimPID con(
    k=k,
    Ti=Ti,
    yMax=0.995,
    yMin=0.005,
    Td=60,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Controller for mixed air temperature"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  parameter Real k=1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti "Time constant of Integrator block";
  Modelica.Blocks.Logical.Greater signGain "Sign of control gain"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Logical.Switch swi1
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Logical.Switch swi2
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Interfaces.RealOutput yOA
    "Control signal for outside air damper"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TRet "Return air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TOut "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput TMix "Mixed air temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput TMixSet
    "Setpoint for mixed air temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
equation
  connect(signGain.y, swi1.u2)
                              annotation (Line(
      points={{-39,60},{-12,60},{-12,6.66134e-16},{-2,6.66134e-16}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(swi1.y, con.u_s)    annotation (Line(
      points={{21,6.10623e-16},{30,0},{40,1.27676e-15},{40,6.66134e-16},{58,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi2.y, con.u_m)    annotation (Line(
      points={{21,-40},{70,-40},{70,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(signGain.y, swi2.u2) annotation (Line(
      points={{-39,60},{-12,60},{-12,-40},{-2,-40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(con.y, yOA)    annotation (Line(
      points={{81,6.10623e-16},{90.5,6.10623e-16},{90.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(signGain.u1, TRet) annotation (Line(
      points={{-62,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(signGain.u2, TOut) annotation (Line(
      points={{-62,52},{-80,52},{-80,20},{-120,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi1.u1, TMix) annotation (Line(
      points={{-2,8},{-80,8},{-80,-20},{-120,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi2.u3, TMix) annotation (Line(
      points={{-2,-48},{-80,-48},{-80,-20},{-120,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi1.u3, TMixSet) annotation (Line(
      points={{-2,-8},{-60,-8},{-60,-60},{-120,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi2.u1, TMixSet) annotation (Line(
      points={{-2,-32},{-60,-32},{-60,-60},{-120,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-92,78},{-66,50}},
          lineColor={0,0,127},
          textString="TRet"),
        Text(
          extent={{-88,34},{-62,6}},
          lineColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{-86,-6},{-60,-34}},
          lineColor={0,0,127},
          textString="TMix"),
        Text(
          extent={{-84,-46},{-58,-74}},
          lineColor={0,0,127},
          textString="TMixSet"),
        Text(
          extent={{64,14},{90,-14}},
          lineColor={0,0,127},
          textString="yOA")}));
end EconomizerTemperatureControl;
