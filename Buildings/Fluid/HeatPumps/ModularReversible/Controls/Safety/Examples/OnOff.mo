within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Examples;
model OnOff "Example for on off controller"
  extends BaseClasses.PartialSafety;
  extends Modelica.Icons.Example;

  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OnOff onOffCtr(
    maxCycRat=2,
    minOffTime(displayUnit="s") = 200,
    minOnTime(displayUnit="s") = 300,
    onOffMea_start=false,
    use_minOffTime=true,
    use_minOnTime=true,
    use_maxCycRat=true,
    ySet_small=hys.uHigh,
    ySetRed=0.5) "Example case for on off control"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Modelica.Blocks.Sources.Sine ySetSin(
    amplitude=0.5,
    f=1/180,
    offset=0.5) "Sine signal for ySet"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
equation
  connect(onOffCtr.yOut, hys.u) annotation (Line(points={{20.8333,10},{40,10},{
          40,-50},{22,-50}},  color={0,0,127}));
  connect(onOffCtr.sigBus, sigBus) annotation (Line(
      points={{0.0833333,3.91667},{-50,3.91667},{-50,-50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetSin.y, onOffCtr.ySet) annotation (Line(points={{-69,10},{-4,10},{
          -4,10},{-1.33333,10}},
                             color={0,0,127}));
  connect(ySetSin.y, ySet) annotation (Line(points={{-69,10},{-56,10},{-56,40},{
          110,40}},  color={0,0,127}));
  connect(onOffCtr.yOut, yOut) annotation (Line(points={{20.8333,10},{40,10},{
          40,-40},{110,-40}},
                      color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  This example shows the usage of the model
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OnOff\">
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OnOff</a>.
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
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Controls/Safety/Examples/OnOff.mos"
        "Simulate and plot"),
  experiment(
      StopTime=7200,
      Interval=1,
      Tolerance=1e-08));
end OnOff;
