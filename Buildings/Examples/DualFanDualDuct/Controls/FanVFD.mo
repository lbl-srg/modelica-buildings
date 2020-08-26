within Buildings.Examples.DualFanDualDuct.Controls;
block FanVFD "Controller for fan revolution"
  extends Modelica.Blocks.Interfaces.SISO;
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  Buildings.Controls.Continuous.LimPID con(
    yMax=1,
    yMin=0,
    Td=60,
    Ti=10) "Controller"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Math.Gain gaiMea(k=1/xSet_nominal)
    "Gain to normalize measurement signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  parameter Real xSet_nominal "Nominal setpoint (used for normalization)";
  VAVReheat.Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Routing.Extractor extractor(nin=6)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.Constant off(k=r_N_min) "Off signal"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Sources.Constant on(k=1) "On signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Math.Gain gaiSet(k=1/xSet_nominal)
    "Gain to normalize setpoint signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Interfaces.RealInput u_m
    "Connector of measurement input signal" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  parameter Real r_N_min=0.01 "Minimum normalized fan speed";
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=r_N_min,
    T=60)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
equation
  connect(gaiMea.y, con.u_m) annotation (Line(
      points={{-39,6.10623e-16},{-10,6.10623e-16},{-10,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, extractor.u[OperationModes.occupied]) annotation (Line(
      points={{1,30},{20,30},{20,-8},{-20,-8},{-20,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, extractor.u[OperationModes.unoccupiedWarmUp]) annotation (Line(
      points={{1,30},{20,30},{20,-8},{-20,-8},{-20,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, extractor.u[OperationModes.unoccupiedPreCool]) annotation (Line(
      points={{1,30},{20,30},{20,-8},{-20,-8},{-20,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, extractor.u[OperationModes.unoccupiedOff])  annotation (Line(
      points={{-39,-70},{-20,-70},{-20,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, extractor.u[OperationModes.safety])  annotation (Line(
      points={{-39,-70},{-20,-70},{-20,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on.y, extractor.u[OperationModes.unoccupiedNightSetBack]) annotation (Line(
      points={{-39,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlBus.controlMode, extractor.index) annotation (Line(
      points={{-70,80},{-70,-52},{30,-52},{30,-42}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(gaiSet.y, con.u_s) annotation (Line(
      points={{-39,30},{-22,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u_m, gaiMea.u) annotation (Line(
      points={{1.11022e-15,-120},{1.11022e-15,-92},{-80,-92},{-80,0},{-62,0},{
          -62,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gaiSet.u, u) annotation (Line(
      points={{-62,30},{-90,30},{-90,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extractor.y, firstOrder.u) annotation (Line(
      points={{41,-30},{58,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y, extractor.y) annotation (Line(
      points={{110,5.55112e-16},{80,0},{50,0},{50,-30},{41,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(graphics={Text(
          extent={{-90,-50},{96,-96}},
          lineColor={0,0,255},
          textString="r_N_min=%r_N_min")}));
end FanVFD;
