within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Examples;
model MinimalFlowRate
  "Example for usage of minimal flow rate safety control"
  extends BaseClasses.PartialSafety;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate minFloRatSaf(
      mEvaMin_flow=0.1, mConMin_flow=0.1)
    "Safety block for minimal flow rate safety"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Pulse ySetPul(amplitude=1, period=50)
    "Pulse signal for ySet"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Modelica.Blocks.Sources.Pulse mConEmu_flow(amplitude=1, period=20)
    "Emulator for condenser mass flow rate"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Modelica.Blocks.Sources.Pulse mEvaEmu_flow(amplitude=1, period=15)
    "Emulator for evaporator mass flow rate"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Modelica.Blocks.Sources.Constant conZer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Logical.Switch swiErr
    "Switches to zero when an error occurs"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Logical.Hysteresis ySetOn(
    final pre_y_start=false,
    final uHigh=0.01,
    final uLow=0.01/2)       "=true if device is set on after on off control"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(sigBus, minFloRatSaf.sigBus) annotation (Line(
      points={{-50,-50},{-46,-50},{-46,4},{0.0833333,4},{0.0833333,3.91667}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(mConEmu_flow.y, sigBus.mConMea_flow) annotation (Line(points={{-69,-10},
          {-50,-10},{-50,-50}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(mEvaEmu_flow.y, sigBus.mEvaMea_flow) annotation (Line(points={{-69,-50},
          {-50,-50}},           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conZer.y,swiErr. u3) annotation (Line(points={{21,-20},{30,-20},{30,2},
          {38,2}},          color={0,0,127}));
  connect(swiErr.y, yOut) annotation (Line(points={{61,10},{96,10},{96,-40},{
          110,-40}}, color={0,0,127}));
  connect(ySetOn.u, ySetPul.y)
    annotation (Line(points={{-42,30},{-69,30}}, color={0,0,127}));
  connect(ySetOn.y, minFloRatSaf.onOffSet) annotation (Line(points={{-19,30},{
          -8,30},{-8,10},{-1.66667,10}}, color={255,0,255}));
  connect(swiErr.u2, minFloRatSaf.canOpe)
    annotation (Line(points={{38,10},{20.8333,10}}, color={255,0,255}));
  connect(swiErr.u1, ySetPul.y) annotation (Line(points={{38,18},{26,18},{26,46},
          {-58,46},{-58,30},{-69,30}}, color={0,0,127}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-69,30},{-58,30},{-58,46},
          {26,46},{26,40},{110,40}}, color={0,0,127}));
  connect(swiErr.y, hys.u) annotation (Line(points={{61,10},{96,10},{96,-58},{
          32,-58},{32,-50},{22,-50}}, color={0,0,127}));
  annotation (
      Documentation(info="<html>
<p>
  This example shows the usage of the model
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate\">
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate</a>.
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
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Controls/Safety/Examples/MinimalFlowRate.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=100,
      Interval=1,
      Tolerance=1e-08));
end MinimalFlowRate;
