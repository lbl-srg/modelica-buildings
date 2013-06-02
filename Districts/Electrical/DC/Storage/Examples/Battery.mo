within Districts.Electrical.DC.Storage.Examples;
model Battery "Test model for battery"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.DC.Storage.Battery     bat(EMax=40e3*3600) "Battery"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Districts.Electrical.DC.Sources.ConstantVoltage    sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={78,-20})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{58,-60},{78,-40}})));
  Districts.Electrical.DC.Loads.VariableConductor     loa "Electrical load"
    annotation (Placement(transformation(extent={{124,-30},{144,-10}})));
  Modelica.Blocks.Sources.Constant const1(k=10e3)
    annotation (Placement(transformation(extent={{144,0},{124,20}})));
  Modelica.Blocks.Sources.SampleTrigger startCharge(period=24*3600,
      startTime=23*3600)
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Modelica_StateGraph2.Step off(initialStep=true, nOut=1,
    nIn=1,
    use_activePort=true) "Battery is disconnected"
    annotation (Placement(transformation(extent={{-104,76},{-96,84}})));
  Modelica_StateGraph2.Transition THold(use_conditionPort=true,
      delayedTransition=false)
    annotation (Placement(transformation(extent={{-104,-4},{-96,4}})));
  Modelica_StateGraph2.Step charge(
    nIn=1,
    use_activePort=true,
    initialStep=false,
    nOut=1) "Battery is charged"
    annotation (Placement(transformation(extent={{-104,16},{-96,24}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
       0.99)
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Modelica_StateGraph2.Transition TOn(
    use_conditionPort=true,
    delayedTransition=false,
    loopCheck=false)
    annotation (Placement(transformation(extent={{-104,46},{-96,54}})));
  Modelica_StateGraph2.Step discharge(
    nOut=1,
    use_activePort=true,
    initialStep=false,
    nIn=1) "Battery is discharged"
    annotation (Placement(transformation(extent={{-104,-64},{-96,-56}})));
  Modelica_StateGraph2.Step hold(
    nOut=1,
    initialStep=false,
    use_activePort=false,
    nIn=1) "Battery charge is hold"
    annotation (Placement(transformation(extent={{-104,-24},{-96,-16}})));
  Modelica.Blocks.Sources.SampleTrigger startDischarge(period=24*3600,
      startTime=14*3600)
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Modelica_StateGraph2.Transition TDischarge(use_conditionPort=true,
      delayedTransition=false)
    annotation (Placement(transformation(extent={{-104,-44},{-96,-36}})));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold=
        0.01)
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Modelica_StateGraph2.Transition TOff(use_conditionPort=true,
      delayedTransition=false) "Battery is empty and switched off"
    annotation (Placement(transformation(extent={{-104,-84},{-96,-76}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.Constant PCha(k=1e4) "Charging power"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.Constant POff(k=0) "Off power"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Modelica.Blocks.Sources.Constant PDis(k=-1e4) "Discharging power"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
equation
  connect(startCharge.y, TOn.conditionPort) annotation (Line(
      points={{-119,50},{-105,50}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TOn.outPort, charge.inPort[1]) annotation (Line(
      points={{-100,45},{-100,24}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(hold.outPort[1], TDischarge.inPort) annotation (Line(
      points={{-100,-24.6},{-100,-36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(TDischarge.outPort, discharge.inPort[1]) annotation (Line(
      points={{-100,-45},{-100,-56}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(TOff.conditionPort, lessEqualThreshold.y) annotation (Line(
      points={{-105,-80},{-119,-80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(off.outPort[1], TOn.inPort) annotation (Line(
      points={{-100,75.4},{-100,54}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(discharge.outPort[1], TOff.inPort) annotation (Line(
      points={{-100,-64.6},{-100,-76}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(TOff.outPort, off.inPort[1]) annotation (Line(
      points={{-100,-85},{-100,-90},{-80,-90},{-80,92},{-100,92},{-100,84}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(charge.activePort, switch1.u2) annotation (Line(
      points={{-95.28,20},{-12,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(discharge.activePort, switch2.u2) annotation (Line(
      points={{-95.28,-60},{-12,-60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(POff.y, switch2.u3) annotation (Line(
      points={{-39,-80},{-20,-80},{-20,-68},{-12,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(POff.y, switch1.u3) annotation (Line(
      points={{-39,-80},{-20,-80},{-20,12},{-12,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PDis.y, switch2.u1) annotation (Line(
      points={{-39,-40},{-32,-40},{-32,-52},{-12,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCha.y, switch1.u1) annotation (Line(
      points={{-39,40},{-32,40},{-32,28},{-12,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, add.u1) annotation (Line(
      points={{11,20},{14,20},{14,-4},{18,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch2.y, add.u2) annotation (Line(
      points={{11,-60},{14,-60},{14,-16},{18,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, bat.P) annotation (Line(
      points={{41,-10},{52,-10},{52,50},{110,50},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bat.SOC, greaterEqualThreshold.u) annotation (Line(
      points={{121,36},{140,36},{140,100},{-160,100},{-160,0},{-142,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bat.SOC, lessEqualThreshold.u) annotation (Line(
      points={{121,36},{140,36},{140,100},{-160,100},{-160,-80},{-142,-80}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(greaterEqualThreshold.y, THold.conditionPort) annotation (Line(
      points={{-119,0},{-105,0}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(charge.outPort[1], THold.inPort) annotation (Line(
      points={{-100,15.4},{-100,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(THold.outPort, hold.inPort[1]) annotation (Line(
      points={{-100,-5},{-100,-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(startDischarge.y, TDischarge.conditionPort) annotation (Line(
      points={{-119,-40},{-105,-40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(const1.y, loa.P) annotation (Line(
      points={{123,10},{112,10},{112,-12},{122,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ground.p, sou.n) annotation (Line(
      points={{68,-40},{68,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.dcPlug, bat.dcPlug) annotation (Line(
      points={{88,-20},{94,-20},{94,30},{100,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.dcPlug, loa.dcPlug) annotation (Line(
      points={{88,-20},{124,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -100},{180,120}}),      graphics),
    experiment(StopTime=432000),
    __Dymola_experimentSetupOutput,
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/DC/Storage/Examples/Battery.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-180,-100},{180,120}})),
    Documentation(info="<html>
<p>
This model illustrates use of a battery connected to an DC voltage source
and a constant load.
The battery is charged every night at 23:00 until it is full. 
At 14:00, it is discharged until it is empty.
This control is implemented using a finite state machine.
The charging and discharing power is assumed to be controlled to 
a constant value of <i>10,000</i> Watts.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 10, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Battery;
