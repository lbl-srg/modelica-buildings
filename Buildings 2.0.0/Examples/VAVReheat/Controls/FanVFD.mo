within Buildings.Examples.VAVReheat.Controls;
block FanVFD "Controller for fan revolution"
  extends Modelica.Blocks.Interfaces.SISO;
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  Buildings.Controls.Continuous.LimPID con(
    yMax=1,
    Td=60,
    yMin=r_N_min,
    k=k,
    Ti=Ti,
    controllerType=controllerType) "Controller"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Math.Gain gaiMea(k=1/xSet_nominal)
    "Gain to normalize measurement signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  parameter Real xSet_nominal "Nominal setpoint (used for normalization)";
  ControlBus controlBus
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Routing.Extractor extractor(
    nin=6,
    index(start=1, fixed=true)) "Extractor for control signal"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
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
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (1: no init, 2: steady state, 3/4: initial output)";
  parameter Real y_start=0 "Initial or guess value of output (= state)";

  parameter Modelica.Blocks.Types.SimpleController
    controllerType=.Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Setpoint tracking"));
  parameter Real k=0.5 "Gain of controller"
    annotation (Dialog(group="Setpoint tracking"));
  parameter Modelica.SIunits.Time Ti=15 "Time constant of Integrator block"
    annotation (Dialog(group="Setpoint tracking"));

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
      string="%first",
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
  connect(extractor.y, y) annotation (Line(
      points={{41,-30},{70,-30},{70,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(graphics={Text(
          extent={{-90,-50},{96,-96}},
          lineColor={0,0,255},
          textString="r_N_min=%r_N_min")}));
end FanVFD;
