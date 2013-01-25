within Districts.Electrical.Analog;
package Storage "Package with models for electrical storage"
  extends Modelica.Icons.Package;
  model Battery "Simple model of a battery"
   extends Modelica.Electrical.Analog.Interfaces.TwoPin;
   parameter Real etaCha(min=0, max=1, unit="1") = 0.9
      "Efficiency during charging";
   parameter Real etaDis(min=0, max=1, unit="1") = 0.9
      "Efficiency during discharging";

   parameter Real SOC_start=0 "Initial charge";
   parameter Modelica.SIunits.Energy EMax(min=0, displayUnit="kWh")
      "Maximum available charge";
   parameter Modelica.SIunits.Energy E_start(min=0, displayUnit="kWh")=0
      "Initial charge";

    Modelica.Blocks.Interfaces.RealInput P(unit="W")
      "Power stored in battery (if positive), or extracted from battery (if negative)"
      annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,108}),
          iconTransformation(extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,100})));

    Modelica.Blocks.Interfaces.RealOutput SOC "State of charge"
      annotation (Placement(transformation(extent={{100,50},{120,70}})));

  protected
    BaseClasses.Charge cha(
      EMax=EMax,
      SOC_start=SOC_start,
      etaCha=etaCha,
      etaDis=etaDis) "Charge model"
      annotation (Placement(transformation(extent={{40,50},{60,70}})));

    BaseClasses.VariableConductor bat "Power exchanged with battery pack"
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  equation
    connect(cha.SOC, SOC)    annotation (Line(
        points={{61,60},{110,60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(bat.P, P) annotation (Line(
        points={{38,8},{0,8},{0,108},{8.88178e-16,108}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(bat.p, p) annotation (Line(
        points={{40,6.66134e-16},{-32,6.66134e-16},{-32,0},{-100,0}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(bat.n, n) annotation (Line(
        points={{60,6.66134e-16},{78,6.66134e-16},{78,0},{100,0}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(cha.P, P)    annotation (Line(
        points={{38,60},{0,60},{0,108},{8.88178e-16,108}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Polygon(
            points={{-62,40},{-62,-40},{72,-40},{72,40},{-62,40}},
            smooth=Smooth.None,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Polygon(
            points={{58,32},{58,-30},{32,-30},{10,32},{58,32}},
            smooth=Smooth.None,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={0,127,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-34,32},{-12,-30},{-32,-30},{-54,32},{-34,32}},
            smooth=Smooth.None,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={0,127,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-2,32},{20,-30},{0,-30},{-22,32},{-2,32}},
            smooth=Smooth.None,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={0,127,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-74,12},{-74,-12},{-62,-12},{-62,12},{-74,12}},
            smooth=Smooth.None,
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Text(
            extent={{-50,68},{-20,100}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            textString="P"),
          Line(
            points={{-74,0},{-100,0},{-100,0}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{98,0},{72,0},{72,0}},
            color={0,0,0},
            smooth=Smooth.None),
          Text(
            extent={{-150,70},{-50,20}},
            lineColor={0,0,255},
            textString="+"),
          Text(
            extent={{40,68},{140,18}},
            lineColor={0,0,255},
            textString="-"),
          Text(
            extent={{44,70},{100,116}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            textString="SOC"),
          Text(
            extent={{44,154},{134,112}},
            lineColor={0,0,255},
            textString="%name")}),
      Documentation(info="<html>
<p>
Simple model of a battery.
</p>
<p>
This model takes as an input the power that should be stored in the battery (if <i>P &gt; 0</i>)
or that should be extracted from the battery.
The model computes a fictitious conductance <i>G</i> such that
<i>P = u &nbsp; i</i> and <i>i = u &nbsp; G,</i> where
<i>u</i> is the voltage difference across the pins and
<i>i</i> is the current at the positive pin.
</p>
<p>
The output connector <code>SOC</code> is the state of charge of the battery.
This model does not enforce that the state of charge is between zero and one.
However, each time the state of charge crosses zero or one, a warning will
be written to the simulation log file.
The model also does not limit the current through the battery. The user should
provide a control so that only a reasonable amount of power is exchanged,
and that the state of charge remains between zero and one.
</p>
</html>", revisions="<html>
<ul>
<li>
January 8, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end Battery;

  package Examples "Package with example models"
    extends Modelica.Icons.ExamplesPackage;
    model Battery "Test model for battery"
      import Districts;
      extends Modelica.Icons.Example;
      Districts.Electrical.Analog.Storage.Battery bat(EMax=40e3*3600) "Battery"
        annotation (Placement(transformation(extent={{100,50},{120,70}})));
      Modelica.Electrical.Analog.Sources.ConstantVoltage sou(V=12)
        "Voltage source"
        annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
      Modelica.Electrical.Analog.Sensors.PowerSensor powSen "Power sensor"
        annotation (Placement(transformation(extent={{130,-30},{150,-10}})));
      Modelica.Electrical.Analog.Basic.Ground ground
        annotation (Placement(transformation(extent={{150,-68},{170,-48}})));
      Districts.Electrical.Analog.Loads.VariableResistor loa "Electrical load"
        annotation (Placement(transformation(extent={{100,10},{120,30}})));
      Modelica.Blocks.Sources.Constant const1(k=10e3)
        annotation (Placement(transformation(extent={{80,30},{100,50}})));
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
      connect(powSen.nv,sou. p) annotation (Line(
          points={{140,-30},{140,-40},{100,-40},{100,-20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(sou.n,powSen. pc) annotation (Line(
          points={{120,-20},{130,-20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(powSen.pv, sou.n) annotation (Line(
          points={{140,-10},{120,-10},{120,-20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(powSen.nc, ground.p) annotation (Line(
          points={{150,-20},{160,-20},{160,-48}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(bat.n, ground.p) annotation (Line(
          points={{120,60},{160,60},{160,-48}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(bat.p, sou.p) annotation (Line(
          points={{100,60},{70,60},{70,-20},{100,-20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(loa.p, sou.p) annotation (Line(
          points={{100,20},{70,20},{70,-20},{100,-20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(loa.n, ground.p) annotation (Line(
          points={{120,20},{160,20},{160,-48}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(const1.y, loa.P) annotation (Line(
          points={{101,40},{110,40},{110,31}},
          color={0,0,127},
          smooth=Smooth.None));
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
          points={{41,-10},{50,-10},{50,80},{110,80},{110,70}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(bat.SOC, greaterEqualThreshold.u) annotation (Line(
          points={{121,66},{140,66},{140,100},{-160,100},{-160,0},{-142,0}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(bat.SOC, lessEqualThreshold.u) annotation (Line(
          points={{121,66},{140,66},{140,100},{-160,100},{-160,-80},{-142,-80}},
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
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,
                -100},{180,120}}),      graphics),
        experiment(StopTime=432000),
        __Dymola_experimentSetupOutput,
        Commands(file=
              "Resources/Scripts/Dymola/Electrical/Analog/Storage/Examples/Battery.mos"
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
</html>", revisions="<html>
<ul>
<li>
January 10, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end Battery;
  end Examples;

  package BaseClasses "Base models for battery package"
    extends Modelica.Icons.BasesPackage;
    model Charge "Model to compute the battery charge"
      extends Modelica.Blocks.Interfaces.BlockIcon;
     parameter Real etaCha(min=0, max=1, unit="1") = 0.9
        "Efficiency during charging";
     parameter Real etaDis(min=0, max=1, unit="1") = 0.9
        "Efficiency during discharging";
     parameter Modelica.SIunits.Energy EMax(displayUnit="kWh")
        "Maximum available charge";
     //Modelica.SIunits.Energy E(min=0, displayUnit="kWh") "Actual charge";
      Modelica.SIunits.Power PAct "Actual power";
      parameter Real SOC_start(min=0, max=1, unit="1")=0 "Initial charge";
      Modelica.Blocks.Interfaces.RealInput P(final quantity="Power",
                                             final unit="W") annotation (Placement(transformation(
              extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{
                -100,20}})));
      Modelica.Blocks.Interfaces.RealOutput SOC(min=0, max=1) "State of charge"
                                                                                annotation (Placement(transformation(
              extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
                10}})));
    protected
      Boolean underCharged "Flag, true if battery is undercharged";
      Boolean overCharged "Flag, true if battery is overcharged";

    initial equation
      pre(underCharged) = SOC_start < 0;
      pre(overCharged)  = SOC_start > 1;

      SOC = SOC_start;
    equation
      // Charge balance of battery
      PAct = if P > 0 then etaCha*P else (2-etaDis)*P;
      der(SOC)=PAct/EMax;

      // Equations to warn if state of charge exceeds 0 and 1
      underCharged = SOC < 0;
      overCharged = SOC > 1;
      when change(underCharged) or change(overCharged) then
        assert(SOC >= 0, "Warning: Battery is below minimum charge.",
        level=AssertionLevel.warning);
        assert(SOC <= 1, "Warning: Battery is above maximum charge.",
        level=AssertionLevel.warning);
      end when;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                {100,100}}), graphics));
    end Charge;

    model VariableConductor "Model of a variable conductive load"
    extends Modelica.Electrical.Analog.Interfaces.OnePort;

      Modelica.Blocks.Interfaces.RealInput P(unit="W")
        "Power stored in battery (if positive) or extracted from battery (if negative)"
        annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
            iconTransformation(extent={{-140,60},{-100,100}})));

    protected
      Modelica.SIunits.Conductance G(start=1) "Conductance";

    equation
      P = v*i;
      i = v*G;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
                lineColor={255,255,255}),
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-70,30},{70,-30}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
              origin={-3.55271e-15,2},
              rotation=180),
              Line(points={{-10,0},{10,0}},  color={0,0,0},
              origin={80,0},
              rotation=180),
              Line(points={{-10,0},{10,0}},color={0,0,0},
              origin={-80,2},
              rotation=180),
            Text(
              extent={{-44,146},{46,104}},
              lineColor={0,0,255},
              textString="%name"),
            Text(
              extent={{-120,98},{-100,126}},
              lineColor={0,0,255},
              textString="P")}),
              Documentation(info="<html>
<p>
Model of a resistive load that takes as an input the dissipated power.
</p>
<p>
The model computes the power as
<i>P = v &nbsp; i</i>,
where <i>v</i> is the voltage and <i>i</i> is the current.
</p>
</html>",     revisions="<html>
<ul>
<li>
January 8, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end VariableConductor;
  end BaseClasses;
end Storage;
