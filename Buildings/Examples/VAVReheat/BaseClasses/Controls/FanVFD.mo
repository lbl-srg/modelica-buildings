within Buildings.Examples.VAVReheat.BaseClasses.Controls;
block FanVFD "Controller for fan revolution"
  extends Modelica.Blocks.Interfaces.SISO;
  import Buildings.Examples.VAVReheat.BaseClasses.Controls.OperationModes;
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset con(
    r=xSet_nominal,
    yMax=1,
    Td=60,
    yMin=r_N_min,
    k=k,
    Ti=Ti,
    controllerType=controllerType)
    "Controller"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  parameter Real xSet_nominal "Nominal setpoint (used for normalization)";
  Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
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
    controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Setpoint tracking"));
  parameter Real k=0.5 "Gain of controller"
    annotation (Dialog(group="Setpoint tracking"));
  parameter Modelica.Units.SI.Time Ti=15 "Time constant of integrator block"
    annotation (Dialog(group="Setpoint tracking"));

  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Set to true to enable the fan on"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
equation
  connect(con.y, swi.u1)
    annotation (Line(points={{12,30},{18,30},{18,8},{38,8}},color={0,0,127}));
  connect(off.y, swi.u3) annotation (Line(points={{-19,-30},{10,-30},{10,-8},{
          38,-8}}, color={0,0,127}));
  connect(swi.u2, uFan) annotation (Line(points={{38,0},{-28,0},{-28,60},{-120,
          60}},
        color={255,0,255}));
  connect(swi.y, y) annotation (Line(points={{62,0},{110,0}}, color={0,0,127}));
  connect(con.trigger, uFan) annotation (Line(points={{-6,18},{-6,10},{-28,10},
          {-28,60},{-120,60}}, color={255,0,255}));
  connect(con.u_s, u) annotation (Line(points={{-12,30},{-90,30},{-90,0},{-120,
          0}}, color={0,0,127}));
  connect(u_m, con.u_m)
    annotation (Line(points={{0,-120},{0,18}}, color={0,0,127}));
  annotation ( Icon(graphics={Text(
          extent={{-90,-50},{96,-96}},
          textColor={0,0,255},
          textString="r_N_min=%r_N_min")}), Documentation(revisions="<html>
<ul>
<li>
May 2, 2021, by Michael Wetter:<br/>
Changed controller to the version from <code>Buildings.Controls.OBC.CDL</code>,
and enabled reset trigger.
</li>
<li>
December 20, 2016, by Michael Wetter:<br/>
Added type conversion for enumeration when used as an array index.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/602\">#602</a>.
</li>
</ul>
</html>", info="<html>
<p>
PI controller for the fan speed. The controller outputs <i>y = 0</i> if the fan control signal is off, e.g., if <code>uFan = false</code>.
</p>
</html>"));
end FanVFD;
