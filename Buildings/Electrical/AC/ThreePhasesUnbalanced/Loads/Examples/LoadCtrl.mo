within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Examples;
model LoadCtrl
  extends Modelica.Icons.Example;
  Sources.FixedVoltage_N sou(f=60, V=480) "Voltage source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Sine pow_1(
    freqHz=0.1,
    amplitude=4500,
    offset=6000) "Power on phase 1"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  Resistive_N load_ctrl(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    vThresh=0.05,
    tDelay=2,
    voltageCtrl=true,
    plugPhase2=false,
    plugPhase3=false,
    P_nominal=0,
    V_nominal=480) "Voltage controlled load"
              annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Lines.Line_N line1(
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Cu10
      commercialCable,
    l=400,
    P_nominal=10000,
    V_nominal=480) "Transmission line to voltage controlled load"
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Resistive_N load(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    plugPhase2=false,
    plugPhase3=false,
    P_nominal=0,
    V_nominal=480) "Load"
    annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));
  Lines.Line_N line(
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Cu10
      commercialCable,
    l=400,
    P_nominal=10000,
    V_nominal=480)
    annotation (Placement(transformation(extent={{-46,-40},{-26,-20}})));
equation
  connect(pow_1.y, load_ctrl.Pow1) annotation (Line(
      points={{39,20},{30,20},{30,6},{12,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pow_1.y, load.Pow1) annotation (Line(
      points={{39,20},{30,20},{30,-24},{12,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, line1.terminal_n) annotation (Line(
      points={{-60,0},{-46,0}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, line.terminal_n) annotation (Line(
      points={{-60,0},{-54,0},{-54,-30},{-46,-30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(line.terminal_p, load.terminal) annotation (Line(
      points={{-26,-30},{-8,-30}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(line1.terminal_p, load_ctrl.terminal) annotation (Line(
      points={{-26,0},{-8,0}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics),
    experiment(Tolerance=1e-05, __Dymola_Algorithm="Radau", StopTime=10.0),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Loads/Examples/LoadCtrl.mos"
        "Simulate and plot"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This example model shows how the voltage controller can act on a three phases unbalanced load.
</p>
<p>
This model contains two loads (one with voltage control and one without)
that produce power just on the first phase connected through a transmission line to a voltage
source. When the power production increases the losses on the line cause a voltage increase 
at the load. The load that has the voltage controller activated when detects the problem
unplug the load for a period of time equal to 2 seconds. The load is attached again after it
passed the threshold after a period equal to 2 seconds.
</p>
<p>
The model contains both a controlled and a not controlled load so the user can
compare the difference in the voltages and powers when the load is unplugged.
</p>
</html>"));
end LoadCtrl;
