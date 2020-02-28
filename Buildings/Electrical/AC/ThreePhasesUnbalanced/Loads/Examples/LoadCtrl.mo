within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Examples;
model LoadCtrl
  extends Modelica.Icons.Example;
  Sources.FixedVoltage_N sou(f=60, V=480) "Voltage source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Sine pow_1(
    f=0.1,
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
      points={{39,20},{30,20},{30,8},{14,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pow_1.y, load.Pow1) annotation (Line(
      points={{39,20},{30,20},{30,-22},{14,-22}},
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
  annotation (    experiment(Tolerance=1e-6, StopTime=10.0),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Loads/Examples/LoadCtrl.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example model shows how the voltage controller can act on a three-phase unbalanced load.
</p>
<p>
This model contains two loads: one with voltage control and one without.
The loads produce power only on the first phase that is connected through a transmission line to a voltage
source. When the power production increases, the losses on the line cause an increase of the voltage
at the load. The load with voltage controller detects when the overvoltage happens
and unplugs the load for 2 seconds. After 2 seconds the load is plugged again and if this causes an other
overvoltage it will be unplugged again.
</p>
<p>
The model contains both a controlled and a not controlled load so the user can
compare the difference in the voltages and powers when the load is unplugged.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2015, by Michael Wetter:<br/>
Removed assignment of <code>P_nominal</code> to avoid the warning
\"The following parameters with fixed = false also have a binding\"
in Dymola 2016.
</li>
<li>
March 10, 2015, by Marco Bonvini:<br/>
Revised documentation of the example.
</li>
</ul>
</html>"));
end LoadCtrl;
