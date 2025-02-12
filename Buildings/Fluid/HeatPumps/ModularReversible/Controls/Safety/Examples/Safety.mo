within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Examples;
model Safety "Example for usage of all safety controls"
  extends BaseClasses.PartialSafety;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Safety safCtr(
    mEva_flow_nominal=0.01,
    mCon_flow_nominal=0.01,
    ySet_small=0.01,
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrPar(
      minOnTime=5,
      minOffTime=5,
      use_antFre=true,
      TAntFre=276.15)) "Safety control"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Pulse ySetPul(amplitude=1, period=50)
    "Pulse signal for ySet"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Blocks.Sources.Pulse TConInEmu(
    amplitude=10,
    period=20,
    offset=303.15,
    y(unit="K", displayUnit="degC"))
                   "Emulator for condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Sources.Pulse TEvaOutEmu(
    amplitude=-10,
    period=15,
    offset=287.15,
    y(unit="K", displayUnit="degC"))
                   "Emulator for evaporator outlet temperature"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Blocks.Sources.Pulse TConOutEmu(
    amplitude=40,
    period=20,
    offset=313.15,
    y(unit="K", displayUnit="degC"))
                   "Emulator for condenser outlet temperature"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Modelica.Blocks.Sources.Pulse TEvaInEmu(
    amplitude=-10,
    period=15,
    offset=288.15,
    y(unit="K", displayUnit="degC"))
                   "Emulator for evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-58,-90},{-38,-70}})));
  Modelica.Blocks.Sources.Pulse mConEmu_flow(
    amplitude=1,
    width=80,
    period=100) "Emulator for condenser mass flow rate"
    annotation (Placement(transformation(extent={{22,-90},{42,-70}})));
  Modelica.Blocks.Sources.Pulse mEvaEmu_flow(amplitude=1, period=100)
    "Emulator for evaporator mass flow rate"
    annotation (Placement(transformation(extent={{-18,-90},{2,-70}})));
  Modelica.Blocks.Sources.BooleanConstant conHea(final k=true)
    "Constant heating mode" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,80})));
equation
  connect(safCtr.sigBus, sigBus) annotation (Line(
      points={{0.0833333,3.91667},{-50,3.91667},{-50,-50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetPul.y, safCtr.ySet) annotation (Line(points={{-69,40},{-8,40},{-8,
          11.6667},{-1.33333,11.6667}},
                          color={0,0,127}));
  connect(TEvaOutEmu.y, sigBus.TEvaOutMea) annotation (Line(points={{-69,-40},{
          -50,-40},{-50,-50}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TConInEmu.y, sigBus.TConInMea) annotation (Line(points={{-69,0},{-50,0},
          {-50,-50}},          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hys.u, safCtr.yOut) annotation (Line(points={{22,-50},{44,-50},{44,
          11.6667},{20.8333,11.6667}},
                    color={0,0,127}));
  connect(safCtr.yOut, yOut) annotation (Line(points={{20.8333,11.6667},{44,
          11.6667},{44,-40},{110,-40}},
                      color={0,0,127}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-69,40},{110,40}},
                    color={0,0,127}));
  connect(TConOutEmu.y, sigBus.TConOutMea) annotation (Line(points={{-69,-80},{
          -64,-80},{-64,-50},{-50,-50}},                     color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TEvaInEmu.y, sigBus.TEvaInMea) annotation (Line(points={{-37,-80},{-34,
          -80},{-34,-50},{-50,-50}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(mEvaEmu_flow.y, sigBus.mEvaMea_flow) annotation (Line(points={{3,-80},{
          4,-80},{4,-64},{-50,-64},{-50,-50}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(mConEmu_flow.y, sigBus.mConMea_flow) annotation (Line(points={{43,-80},
          {50,-80},{50,-64},{-50,-64},{-50,-50}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conHea.y, sigBus.hea) annotation (Line(points={{-69,80},{-50,80},{-50,
          -50}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>
  This example shows the usage and effect of
  all safety controls aggregates into the model
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Safety\">
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Safety</a>.
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
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Controls/Safety/Examples/Safety.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=100,
      Interval=1,
      Tolerance=1e-08));
end Safety;
