within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
model CoolingCoil "Controller for cooling coil valve"
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Cooling coil loop signal"));
  parameter Real kCooCoi(final unit="1/K")=0.1
    "Gain for cooling coil control loop signal"
    annotation(Dialog(group="Cooling coil loop signal"));

  parameter Modelica.SIunits.Time TiCooCoi=900
    "Time constant of integrator block for cooling coil control loop signal"
    annotation(Dialog(group="Cooling coil loop signal",
    enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdCooCoi=0.1
    "Time constant of derivative block for cooling coil control loop signal"
    annotation (Dialog(group="Cooling coil loop signal",
      enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  CDL.Integers.Equal intEqu
    "Logical block to check if zone is in cooling state"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  CDL.Integers.Sources.Constant conInt(final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.cooling)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Continuous.LimPID cooCoiPI(
    reverseAction=true,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    yMax=1,
    yMin=0,
    controllerType=controllerTypeCooCoi,
    k=kCooCoi,
    Ti=TiCooCoi,
    Td=TdCooCoi)
            "Cooling coil control singal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Logical.Switch switch
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  CDL.Continuous.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  CDL.Interfaces.IntegerInput uZonSta "Zone state"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput TSupCoo "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  CDL.Interfaces.RealInput TSup "Supply air temperature measurement"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.RealOutput yCooCoi "Cooling coil control signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-59,40},{-50,40},{-50,42},
          {-12,42}}, color={255,127,0}));
  connect(const.y, switch.u3) annotation (Line(points={{11,-60},{24,-60},{24,-8},
          {70,-8}}, color={0,0,127}));
  connect(switch.u1, cooCoiPI.y)
    annotation (Line(points={{70,8},{24,8},{24,0},{11,0}}, color={0,0,127}));
  connect(intEqu.u1, uZonSta) annotation (Line(points={{-12,50},{-50,50},{-50,80},
          {-120,80}}, color={255,127,0}));
  connect(cooCoiPI.trigger, uSupFan) annotation (Line(points={{-8,-12},{-8,-38},
          {-40,-38},{-40,-80},{-120,-80}}, color={255,0,255}));
  connect(cooCoiPI.u_s, TSupCoo) annotation (Line(points={{-12,0},{-80,0},{-80,20},
          {-120,20}}, color={0,0,127}));
  connect(cooCoiPI.u_m, TSup)
    annotation (Line(points={{0,-12},{0,-20},{-120,-20}}, color={0,0,127}));
  connect(switch.y, yCooCoi)
    annotation (Line(points={{93,0},{110,0}}, color={0,0,127}));
  connect(intEqu.y, and2.u1) annotation (Line(points={{11,50},{30,50},{30,-30},{
          38,-30}}, color={255,0,255}));
  connect(and2.u2, uSupFan) annotation (Line(points={{38,-38},{-40,-38},{-40,-80},
          {-120,-80}}, color={255,0,255}));
  connect(and2.y, switch.u2) annotation (Line(points={{61,-30},{64,-30},{64,0},{
          70,0}}, color={255,0,255}));
  annotation (defaultComponentName="cooCoi",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255})}),
        Diagram(coordinateSystem(
          preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This block outputs the cooling coil control signal.
</p>
</html>",revisions="<html>
<ul>
<li>
August 1, 2019, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingCoil;
