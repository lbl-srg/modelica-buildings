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
equation
  connect(antFre.sigBus, sigBus) annotation (Line(
      points={{0.0833333,3.91667},{-50,3.91667},{-50,-50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetPul.y, antFre.ySet) annotation (Line(points={{-69,30},{-8,30},{-8,
          11.6667},{-1.33333,11.6667}},
                          color={0,0,127}));
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
  connect(hys.u, antFre.yOut) annotation (Line(points={{22,-50},{44,-50},{44,
          11.6667},{20.8333,11.6667}},
                    color={0,0,127}));
  connect(antFre.yOut, yOut) annotation (Line(points={{20.8333,11.6667},{44,
          11.6667},{44,-40},{110,-40}},
                      color={0,0,127}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-69,30},{-8,30},{-8,40},{110,
          40}},     color={0,0,127}));
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
