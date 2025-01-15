within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Examples;
model OperationalEnvelope "Example for usage of operational envelope model"
  extends BaseClasses.PartialSafety;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OperationalEnvelope opeEnv(
    tabUppHea=[233.15,333.15; 313.15,333.15],
    tabLowCoo=[233.15,288.15; 313.15,288.15]) "Safety control for operational envelope"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Constant
                                ySetPul(k=1) "Always on"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Modelica.Blocks.Sources.Trapezoid
                                TConOutEmu(
    amplitude=60,
    rising=5,
    width=20,
    falling=5,
    period=50,
    offset=283.15,
    y(unit="K", displayUnit="degC"))
                   "Emulator for condenser outlet temperature"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Modelica.Blocks.Sources.Pulse TEvaInEmu(
    amplitude=-10,
    period=15,
    offset=283.15,
    y(unit="K", displayUnit="degC"))
                   "Emulator for evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Modelica.Blocks.Sources.BooleanStep hea(startTime=50, startValue=true)
    "Heating mode"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
equation
  connect(opeEnv.sigBus, sigBus) annotation (Line(
      points={{0.0833333,3.91667},{-50,3.91667},{-50,-52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetPul.y, opeEnv.ySet) annotation (Line(points={{-69,30},{-8,30},{-8,
          11.6667},{-1.33333,11.6667}},
                          color={0,0,127}));
  connect(hys.u, opeEnv.yOut) annotation (Line(points={{22,-50},{44,-50},{44,
          11.6667},{20.8333,11.6667}},
                    color={0,0,127}));
  connect(opeEnv.yOut, yOut) annotation (Line(points={{20.8333,11.6667},{44,
          11.6667},{44,-40},{110,-40}},
                      color={0,0,127}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-69,30},{-8,30},{-8,40},{110,
          40}},     color={0,0,127}));
  connect(TConOutEmu.y, sigBus.TConOutMea) annotation (Line(points={{-69,-10},{
          -50,-10},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TEvaInEmu.y, sigBus.TEvaInMea) annotation (Line(points={{-69,-50},{-52,
          -50},{-52,-52},{-50,-52}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hea.y, sigBus.hea) annotation (Line(points={{-69,70},{-50,70},{-50,-52}},
                 color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TConOutEmu.y, sigBus.TConInMea) annotation (Line(points={{-69,-10},{-50,
          -10},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TEvaInEmu.y, sigBus.TEvaOutMea) annotation (Line(points={{-69,-50},{-52,
          -50},{-52,-52},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>
  This example shows the usage of the model
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OperationalEnvelope\">
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OperationalEnvelope</a>.
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
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Controls/Safety/Examples/OperationalEnvelope.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=100,
      Interval=1,
      Tolerance=1e-08));
end OperationalEnvelope;
