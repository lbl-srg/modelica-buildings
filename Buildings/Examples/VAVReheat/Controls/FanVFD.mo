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
    controllerType=controllerType,
    reset=Buildings.Types.Reset.Disabled)
                                   "Controller"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Math.Gain gaiMea(k=1/xSet_nominal)
    "Gain to normalize measurement signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  parameter Real xSet_nominal "Nominal setpoint (used for normalization)";
  Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
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
  parameter Modelica.SIunits.Time Ti=15 "Time constant of integrator block"
    annotation (Dialog(group="Setpoint tracking"));

  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Set to true to enable the fan on"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
equation
  connect(gaiMea.y, con.u_m) annotation (Line(
      points={{-39,6.10623e-16},{-10,6.10623e-16},{-10,18}},
      color={0,0,127},
      smooth=Smooth.None));
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
  connect(con.y, swi.u1)
    annotation (Line(points={{1,30},{18,30},{18,8},{38,8}}, color={0,0,127}));
  connect(off.y, swi.u3) annotation (Line(points={{-39,-50},{20,-50},{20,-8},{
          38,-8}}, color={0,0,127}));
  connect(swi.u2, uFan) annotation (Line(points={{38,0},{12,0},{12,60},{-120,60}},
        color={255,0,255}));
  connect(swi.y, y) annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  annotation ( Icon(graphics={Text(
          extent={{-90,-50},{96,-96}},
          lineColor={0,0,255},
          textString="r_N_min=%r_N_min")}), Documentation(revisions="<html>
<ul>
<li>
December 20, 2016, by Michael Wetter:<br/>
Added type conversion for enumeration when used as an array index.<br/>
This is for
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/602\">#602</a>.
</li>
</ul>
</html>"));
end FanVFD;
