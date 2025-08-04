within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses;
partial model PartialSafetyWithCounter
   "Safety control which adds an error counter to the I/O"
  extends PartialSafety;
  Modelica.Blocks.Logical.Switch swiErr
    "Switches to zero when an error occurs"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Sources.Constant conZer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.MathInteger.TriggeredAdd disErr(
    y_start=0,
    use_reset=false,
    use_set=false) "Used to show if the error was triggered"
                                                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-100})));
  Modelica.Blocks.Interfaces.IntegerOutput err
    "Integer for displaying number of errors during simulation"
                                               annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, rotation=0,
        origin={130,-100})));
  Modelica.Blocks.Logical.Not notVal "=true indicates a error"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-70})));
  Modelica.Blocks.Sources.IntegerConstant intConOne(final k=1)
    "Used for display of current error"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={48,-100})));
  Modelica.Blocks.Routing.BooleanPassThrough booPasThr
    "Used to keep the connection to the counter"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Logical.Hysteresis ySetOn(
    final pre_y_start=onOffMea_start,
    final uHigh=ySet_small,
    final uLow=ySet_small/2) "=true if device is set on"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Modelica.Blocks.Logical.And errAndSetOn
    "Error occured and the device should be on"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  connect(conZer.y,swiErr. u3) annotation (Line(points={{61,-30},{70,-30},{70,
          -8},{78,-8}},     color={0,0,127}));
  connect(disErr.y,err)  annotation (Line(points={{102,-100},{130,-100}},
                                                 color={255,127,0}));
  connect(intConOne.y, disErr.u) annotation (Line(points={{59,-100},{76,-100}},
                   color={255,127,0}));
  connect(booPasThr.y, swiErr.u2)
    annotation (Line(points={{61,0},{78,0}}, color={255,0,255}));
  connect(booPasThr.y, notVal.u) annotation (Line(points={{61,0},{66,0},{66,-54},
          {-46,-54},{-46,-70},{-42,-70}},   color={255,0,255}));
  connect(swiErr.y, yOut) annotation (Line(points={{101,0},{110,0},{110,0},{130,
          0}},      color={0,0,127}));
  connect(ySetOn.u, ySet) annotation (Line(points={{-42,-100},{-100,-100},{-100,
          0},{-136,0}},
                      color={0,0,127}));
  connect(errAndSetOn.u1, notVal.y) annotation (Line(points={{-2,-80},{-14,-80},
          {-14,-70},{-19,-70}}, color={255,0,255}));
  connect(errAndSetOn.y, disErr.trigger) annotation (Line(points={{21,-80},{28,
          -80},{28,-116},{84,-116},{84,-112}}, color={255,0,255}));
  connect(ySetOn.y, errAndSetOn.u2) annotation (Line(points={{-19,-100},{-10,-100},
          {-10,-88},{-2,-88}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>May 26, 2025</i> by Fabian Wuellhorst and Michael Wetter:<br/>
    Increase error counter only when device should turn on (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/2011\">IBPSA #2011</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This block counts the number of errors occurred in a specific safety block.
</p>
</html>"));
end PartialSafetyWithCounter;
