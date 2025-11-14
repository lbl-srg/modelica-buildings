within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Examples;
model AntiFreeze "Example for usage of antifreeze model"
  extends BaseClasses.PartialSafety;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.AntiFreeze antFre
    "Safety control for antifreeze"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Pulse ySetPul(amplitude=1, period=50)
    "Pulse signal for ySet"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Modelica.Blocks.Sources.Pulse TConInEmu(
    amplitude=-10,
    period=20,
    offset=283.15,
    y(unit="K", displayUnit="K"))   "Emulator for condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Modelica.Blocks.Sources.Pulse TEvaOutEmu(
    amplitude=-10,
    period=15,
    offset=283.15,
    y(unit="K", displayUnit="K"))
                   "Emulator for evaporator outlet temperature"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Modelica.Blocks.Logical.Hysteresis ySetOn(
    final pre_y_start=false,
    final uHigh=0.01,
    final uLow=0.01/2)       "=true if device is set on after on off control"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant conZer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Logical.Switch swiErr
    "Switches to zero when an error occurs"
    annotation (Placement(transformation(extent={{40,-2},{60,18}})));
equation
  connect(antFre.sigBus, sigBus) annotation (Line(
      points={{0.0833333,3.91667},{-50,3.91667},{-50,-50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TEvaOutEmu.y, sigBus.TEvaOutMea) annotation (Line(points={{-69,-50},{
          -50,-50}},                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TConInEmu.y, sigBus.TConInMea) annotation (Line(points={{-69,-10},{-50,
          -10},{-50,-50}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conZer.y,swiErr. u3) annotation (Line(points={{21,-20},{30,-20},{30,0},
          {38,0}},          color={0,0,127}));
  connect(antFre.canOpe, swiErr.u2) annotation (Line(points={{20.8333,10},{30,
          10},{30,8},{38,8}}, color={255,0,255}));
  connect(swiErr.y, hys.u) annotation (Line(points={{61,8},{96,8},{96,-58},{32,
          -58},{32,-50},{22,-50}}, color={0,0,127}));
  connect(swiErr.y, yOut) annotation (Line(points={{61,8},{96,8},{96,-40},{110,
          -40}}, color={0,0,127}));
  connect(antFre.onOffSet, ySetOn.y) annotation (Line(points={{-1.66667,10},{
          -16,10},{-16,30},{-19,30}}, color={255,0,255}));
  connect(ySetPul.y, ySetOn.u)
    annotation (Line(points={{-69,30},{-42,30}}, color={0,0,127}));
  connect(ySetPul.y, swiErr.u1) annotation (Line(points={{-69,30},{-50,30},{-50,
          46},{30,46},{30,16},{38,16}}, color={0,0,127}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-69,30},{-50,30},{-50,46},
          {30,46},{30,40},{110,40}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  This example shows the usage of the model
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.AntiFreeze\">
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.AntiFreeze</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"),
   __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Controls/Safety/Examples/AntiFreeze.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=100,
      Interval=1,
      Tolerance=1e-08));
end AntiFreeze;
