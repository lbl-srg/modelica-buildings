within Buildings.Electrical.AC.OnePhase.Storage.Examples;
model AcBattery "This example shows how to use the AC battery model"
  extends Modelica.Icons.Example;
  Battery bat_ideal(
    eta_DCAC=1,
    etaCha=1,
    etaDis=1,
    SOC_start=0.5,
    EMax=749999.88,
    V_nominal=120) "Ideal battery without losses"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Sources.FixedVoltage fixVol(f=60, V=120)
    annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
  Modelica.Blocks.Sources.Pulse pow(
    offset=-500,
    amplitude=1000,
    width=50,
    period=1200)
    "Signal that indicates how much power should be stored in the battery"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Battery bat_loss_acdc(
    etaCha=1,
    etaDis=1,
    SOC_start=0.5,
    eta_DCAC=0.95,
    EMax=749999.88,
    V_nominal=120) "Battery with losses for AC/DC conversion"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Battery bat(
    SOC_start=0.5,
    eta_DCAC=0.95,
    EMax=749999.88,
    V_nominal=120)
    "Battery with losses for AC/DC conversion and charge/discharge"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
equation
  connect(fixVol.terminal, bat_ideal.terminal) annotation (Line(
      points={{-22,0},{0,0},{0,30},{20,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pow.y, bat_ideal.P) annotation (Line(
      points={{1,70},{30,70},{30,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixVol.terminal, bat_loss_acdc.terminal) annotation (Line(
      points={{-22,0},{20,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(fixVol.terminal, bat.terminal) annotation (Line(
      points={{-22,0},{0,0},{0,-30},{20,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pow.y, bat_loss_acdc.P) annotation (Line(
      points={{1,70},{50,70},{50,20},{30,20},{30,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pow.y, bat.P) annotation (Line(
      points={{1,70},{66,70},{66,-10},{30,-10},{30,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (            experiment(
      StopTime=3600,
      Tolerance=1e-05),
            __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Storage/Examples/ACOnePhaseBattery.mos"
        "Simulate and plot"),
          Documentation(revisions="<html>
<ul>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example shows how to use an AC battery model.
</p>
<p>
The example compares three different batteries. The battery named
<code>bat_ideal</code> is ideal and it does not account for any losses.
The battery named <code>bat_loss_acdc</code> accounts for conversion losses when converting
between AC and DC.
The battery named <code>bat</code> accounts for both conversion losses and inefficiencies
during both the charge and discharge phases.
</p>
<p>
All the batteries start from the same initial condition, which is 50% of their total capacity.
The batteries are charged and discharged in the same way. The input signal <code>pow.y</code>
is the power that each battery should store or release. The signal has a duty cycle equal to 50%.
Therefore, if there are no losses the same amount of power stored into the battery will be
released and after one cycle the State of Charge (SOC) has to be equal.
</p>
<p>
The image below shows the SOC of the three batteries.
</p>
<p align=\"center\">
<img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/Storage/Examples/SOCs.png\"/>
</p>
<p>
As expected the red line (ideal battery) maintains the SOC over the time.
The other two batteries loose some
of the initial energy due to the losses.
</p>
</html>"));
end AcBattery;
