within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block ReliefFanControl
  CDL.Continuous.Constant buiPreSetpoint(k=buiPreSet)
    "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  CDL.Continuous.LimPID buiStaPreController(
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.P,
    yMax=1,
    yMin=0) annotation (Placement(transformation(extent={{-80,110},{-60,130}})));

  CDL.Interfaces.RealInput uBuiPre "Measured building static pressure"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}})));
  CDL.Continuous.Abs abs
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Math.Mean mean(f=1/sliTim, x0=uBuiPre)
    "fixme: there is no mean block in current CDL package."
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  CDL.Interfaces.BooleanInput uSupFans[numSupFan]
    "Status of supply fans that associated with relief fans"
    annotation (Placement(transformation(extent={{-180,30},{-140,70}})));
equation
  connect(buiPreSetpoint.y, buiStaPreController.u_s) annotation (Line(points={{-99,120},
          {-90.5,120},{-82,120}},          color={0,0,127}));
  connect(uBuiPre, abs.u)
    annotation (Line(points={{-160,80},{-122,80}}, color={0,0,127}));
  connect(abs.y, mean.u)
    annotation (Line(points={{-99,80},{-82,80}}, color={0,0,127}));
  connect(mean.y, buiStaPreController.u_m) annotation (Line(points={{-59,80},{
          -52,80},{-52,100},{-70,100},{-70,108}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,140}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-140,-100},{100,140}})));
end ReliefFanControl;
