within Buildings.Examples.VAVReheat.Controls;
model DuctStaticPressureSetpoint "Computes the duct static pressure setpoint"
  extends Modelica.Blocks.Interfaces.MISO;
  parameter Modelica.SIunits.AbsolutePressure pMin(displayUnit="Pa") = 100
    "Minimum duct static pressure setpoint";
  parameter Modelica.SIunits.AbsolutePressure pMax(displayUnit="Pa") = 410
    "Maximum duct static pressure setpoint";
  parameter Real k=0.1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti=60 "Time constant of integrator block";
  parameter Modelica.SIunits.Time Td=60 "Time constant of derivative block";
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PID
    "Type of controller";
                           Buildings.Controls.Continuous.LimPID limPID(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    initType=Modelica.Blocks.Types.InitPID.InitialState)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
protected
  Buildings.Utilities.Math.Max max(final nin=nin)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Constant ySet(k=0.9)
    "Setpoint for maximum damper position"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Math.Add dp(final k2=-1) "Pressure difference"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.Constant pMaxSig(k=pMax)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Constant pMinSig(k=pMin)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Math.Add pSet "Pressure setpoint"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
public
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=283.15, uHigh=284.15)
    "Hysteresis to put fan on minimum revolution"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Interfaces.RealInput TOut "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
protected
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero output signal"
    annotation (Placement(transformation(extent={{20,42},{40,62}})));
public
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
equation
  connect(max.u, u) annotation (Line(
      points={{-62,6.66134e-16},{-80,6.66134e-16},{-80,0},{-120,0},{-120,
          1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ySet.y, limPID.u_s) annotation (Line(
      points={{-39,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(max.y, limPID.u_m) annotation (Line(
      points={{-39,6.10623e-16},{-10,6.10623e-16},{-10,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limPID.y, product.u1) annotation (Line(
      points={{1,50},{10,50},{10,26},{18,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pMaxSig.y, dp.u1) annotation (Line(
      points={{-39,-30},{-32,-30},{-32,-44},{-22,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pMinSig.y, dp.u2) annotation (Line(
      points={{-39,-70},{-30,-70},{-30,-56},{-22,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp.y, product.u2) annotation (Line(
      points={{1,-50},{10,-50},{10,14},{18,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pMinSig.y, pSet.u2) annotation (Line(
      points={{-39,-70},{30,-70},{30,-6},{58,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pSet.y, y) annotation (Line(
      points={{81,6.10623e-16},{90.5,6.10623e-16},{90.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysteresis.u, TOut) annotation (Line(
      points={{-62,80},{-120,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, switch1.u1) annotation (Line(
      points={{41,20},{50,20},{50,68},{58,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zero.y, switch1.u3) annotation (Line(
      points={{41,52},{58,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, pSet.u1) annotation (Line(
      points={{81,60},{90,60},{90,20},{52,20},{52,6},{58,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysteresis.y, switch1.u2) annotation (Line(
      points={{-39,80},{46,80},{46,60},{58,60}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation ( Icon(graphics={
        Text(
          extent={{-76,148},{50,-26}},
          textString="PSet",
          lineColor={0,0,127}),
        Text(
          extent={{-10,8},{44,-82}},
          lineColor={0,0,127},
          textString="%pMax"),
        Text(
          extent={{-16,-54},{48,-90}},
          lineColor={0,0,127},
          textString="%pMin")}));
end DuctStaticPressureSetpoint;
