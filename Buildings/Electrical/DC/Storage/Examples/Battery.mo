within Buildings.Electrical.DC.Storage.Examples;
model Battery "Test model for battery"
  extends Modelica.Icons.Example;
  Buildings.Electrical.DC.Storage.Battery     bat(EMax=40e3*3600, V_nominal=12)
    "Battery"
    annotation (Placement(transformation(extent={{120,-48},{140,-28}})));
  Buildings.Electrical.DC.Sources.ConstantVoltage    sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={98,-80})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{76,-120},{96,-100}})));
  Buildings.Electrical.DC.Loads.Conductor             loa(
    P_nominal=0, mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=12) "Electrical load"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Modelica.Blocks.Sources.Constant const1(k=-10e3)
    "Power consumption of the load"
    annotation (Placement(transformation(extent={{200,-90},{180,-70}})));
  Modelica.Blocks.Sources.SampleTrigger startCharge(period=24*3600,
      startTime=23*3600)
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
       0.99)
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Modelica.Blocks.Sources.SampleTrigger startDischarge(period=24*3600,
      startTime=14*3600)
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold=
        0.01)
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Modelica.Blocks.Logical.Switch chaSwi "Switch to charge battery"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Logical.Switch disSwi "Switch to discharge battery"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Modelica.Blocks.Sources.Constant PCha(k=1e4) "Charging power"
    annotation (Placement(transformation(extent={{0,-58},{20,-38}})));
  Modelica.Blocks.Sources.Constant POff(k=0) "Off power"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant PDis(k=-1e4) "Discharging power"
    annotation (Placement(transformation(extent={{0,18},{20,38}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Buildings.Electrical.DC.Sensors.GeneralizedSensor powSen "Power sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,-60})));
  Modelica.StateGraph.InitialStep off(nIn=1, nOut=1)
                                      "Off state" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-130,80})));
  Modelica.StateGraph.TransitionWithSignal toOn "Transition to on" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-100,80})));
  Modelica.StateGraph.StepWithSignal charge(nIn=1, nOut=1)
                                            "State to charge battery"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.StateGraph.TransitionWithSignal toHold "Transition to hold"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Modelica.StateGraph.Step hold(nIn=1, nOut=1)
                                "Battery charge is hold"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Modelica.StateGraph.TransitionWithSignal toDischarge
    "Transition to discharge"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Modelica.StateGraph.StepWithSignal discharge(nIn=1, nOut=1)
                                               "State to discharge battery"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.StateGraph.TransitionWithSignal toOff "Transition to off"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
equation

  connect(POff.y, disSwi.u3) annotation (Line(
      points={{21,0},{40,0},{40,12},{58,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(POff.y, chaSwi.u3) annotation (Line(
      points={{21,0},{40,0},{40,-38},{58,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PDis.y, disSwi.u1) annotation (Line(
      points={{21,28},{58,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCha.y, chaSwi.u1) annotation (Line(
      points={{21,-48},{30,-48},{30,-22},{58,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, bat.P) annotation (Line(
      points={{121,10},{130,10},{130,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bat.SOC, greaterEqualThreshold.u) annotation (Line(
      points={{141,-32},{160,-32},{160,108},{-160,108},{-160,0},{-142,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bat.SOC, lessEqualThreshold.u) annotation (Line(
      points={{141,-32},{160,-32},{160,108},{-160,108},{-160,-60},{-142,-60}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(const1.y, loa.Pow) annotation (Line(
      points={{179,-80},{160,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa.terminal, sou.terminal) annotation (Line(
      points={{140,-80},{108,-80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bat.terminal, powSen.terminal_p) annotation (Line(
      points={{120,-38},{120,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(powSen.terminal_n, sou.terminal) annotation (Line(
      points={{120,-70},{120,-80},{108,-80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n, ground.p) annotation (Line(
      points={{88,-80},{86,-80},{86,-100}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(startCharge.y, toOn.condition) annotation (Line(
      points={{-119,30},{-100,30},{-100,68}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(charge.active, chaSwi.u2) annotation (Line(points={{-70,69},{-70,69},{
          -70,50},{-70,-30},{58,-30}}, color={255,0,255}));
  connect(greaterEqualThreshold.y, toHold.condition) annotation (Line(
      points={{-119,0},{-90,0},{-90,60},{-40,60},{-40,68}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(startDischarge.y, toDischarge.condition) annotation (Line(
      points={{-119,-30},{-80,-30},{-80,54},{20,54},{20,68}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(disSwi.u2, discharge.active) annotation (Line(points={{58,20},{58,20},
          {50,20},{50,46},{50,69}}, color={255,0,255}));
  connect(discharge.outPort[1], toOff.inPort)
    annotation (Line(points={{60.5,80},{76,80}}, color={0,0,0}));
  connect(lessEqualThreshold.y, toOff.condition) annotation (Line(
      points={{-119,-60},{-60,-60},{-60,48},{80,48},{80,68}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(off.outPort[1], toOn.inPort) annotation (Line(points={{-119.5,80},{-111.75,
          80},{-104,80}}, color={0,0,0}));
  connect(toOn.outPort, charge.inPort[1])
    annotation (Line(points={{-98.5,80},{-81,80},{-81,80}}, color={0,0,0}));
  connect(charge.outPort[1], toHold.inPort)
    annotation (Line(points={{-59.5,80},{-44,80},{-44,80}}, color={0,0,0}));
  connect(toHold.outPort, hold.inPort[1])
    annotation (Line(points={{-38.5,80},{-21,80},{-21,80}}, color={0,0,0}));
  connect(hold.outPort[1], toDischarge.inPort)
    annotation (Line(points={{0.5,80},{8,80},{16,80}}, color={0,0,0}));
  connect(toDischarge.outPort, discharge.inPort[1])
    annotation (Line(points={{21.5,80},{39,80},{39,80}}, color={0,0,0}));
  connect(toOff.outPort, off.inPort[1]) annotation (Line(points={{81.5,80},{92,80},
          {92,100},{-150,100},{-150,80},{-141,80}}, color={0,0,0}));
  connect(disSwi.y, add.u1) annotation (Line(points={{81,20},{90,20},{90,16},{98,
          16}}, color={0,0,127}));
  connect(chaSwi.y, add.u2) annotation (Line(points={{81,-30},{90,-30},{90,4},{98,
          4}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -120},{220,120}})),
    experiment(Tolerance=1e-06, StopTime=432000),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Storage/Examples/Battery.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates use of a battery connected to an DC voltage source
and a constant load.
The battery is charged every night at 23:00 until it is full.
At 14:00, it is discharged until it is empty.
This control is implemented using a finite state machine.
The charging and discharging power is assumed to be controlled to
a constant value of <i>10,000</i> Watts.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 6, 2016, by Michael Wetter:<br/>
Replaced <code>Modelica_StateGraph2</code> with <code>Modelica.StateGraph</code>.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
</li>
<li>
January 10, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Battery;
