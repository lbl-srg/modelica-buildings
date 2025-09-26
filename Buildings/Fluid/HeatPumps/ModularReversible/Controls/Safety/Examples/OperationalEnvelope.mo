within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Examples;
model OperationalEnvelope "Example for usage of operational envelope model"
  extends BaseClasses.PartialSafety;
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OperationalEnvelope opeEnv(tabUppHea
      =[233.15,333.15; 313.15,333.15], tabLowCoo=[233.15,288.15; 313.15,288.15])
                                              "Safety control for operational envelope"
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
  Modelica.Blocks.Logical.Hysteresis ySetOn(
    final pre_y_start=false,
    final uHigh=0.01,
    final uLow=0.01/2)       "=true if device is set on after on off control"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Logical.Switch swiErr
    "Switches to zero when an error occurs"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Sources.Constant conZer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
equation
  connect(opeEnv.sigBus, sigBus) annotation (Line(
      points={{0.0833333,3.91667},{-50,3.91667},{-50,-50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TConOutEmu.y, sigBus.TConOutMea) annotation (Line(points={{-69,-10},{
          -50,-10},{-50,-50}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TEvaInEmu.y, sigBus.TEvaInMea) annotation (Line(points={{-69,-50},{
          -52,-50},{-52,-50},{-50,-50}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hea.y, sigBus.hea) annotation (Line(points={{-69,70},{-50,70},{-50,
          -50}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TConOutEmu.y, sigBus.TConInMea) annotation (Line(points={{-69,-10},{
          -50,-10},{-50,-50}},
                           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TEvaInEmu.y, sigBus.TEvaOutMea) annotation (Line(points={{-69,-50},{
          -52,-50},{-52,-50},{-50,-50}},
                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conZer.y, swiErr.u3) annotation (Line(points={{21,-20},{30,-20},{30,2},
          {38,2}}, color={0,0,127}));
  connect(opeEnv.canOpe, swiErr.u2)
    annotation (Line(points={{20.8333,10},{38,10}}, color={255,0,255}));
  connect(swiErr.u1, ySetPul.y) annotation (Line(points={{38,18},{26,18},{26,46},
          {-66,46},{-66,30},{-69,30}}, color={0,0,127}));
  connect(ySetOn.u, ySetPul.y)
    annotation (Line(points={{-42,30},{-69,30}}, color={0,0,127}));
  connect(ySetOn.y, opeEnv.onOffSet) annotation (Line(points={{-19,30},{-8,30},
          {-8,10},{-1.66667,10}}, color={255,0,255}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-69,30},{-66,30},{-66,46},
          {26,46},{26,40},{110,40}}, color={0,0,127}));
  connect(swiErr.y, yOut) annotation (Line(points={{61,10},{96,10},{96,-40},{
          110,-40}}, color={0,0,127}));
  connect(swiErr.y, hys.u) annotation (Line(points={{61,10},{96,10},{96,-58},{
          32,-58},{32,-50},{22,-50}}, color={0,0,127}));
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
