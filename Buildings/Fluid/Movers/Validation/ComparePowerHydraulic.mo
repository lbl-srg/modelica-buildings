within Buildings.Fluid.Movers.Validation;
model ComparePowerHydraulic
  "Compare power estimation with hydraulic power curve"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Movers.Validation.BaseClasses.ComparePower(
    redeclare replaceable Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW15 per(
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      motorEfficiency(V_flow={0}, eta={0.7}))
      constrainedby Buildings.Fluid.Movers.Data.Generic,
    redeclare Buildings.Fluid.Movers.SpeedControlled_y mov1(
      redeclare final package Medium = Medium,
      per=per,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      addPowerToMedium=false,
      use_riseTime=false),
    redeclare Buildings.Fluid.Movers.SpeedControlled_y mov2(
      redeclare final package Medium = Medium,
      per(
        powerOrEfficiencyIsHydraulic=per.powerOrEfficiencyIsHydraulic,
        pressure=per.pressure,
        etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
        peak=peak,
        etaMotMet=per.etaMotMet),
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      addPowerToMedium=false,
      use_riseTime=false),
    redeclare Buildings.Fluid.Movers.SpeedControlled_y mov3(
      redeclare final package Medium = Medium,
      per(
        powerOrEfficiencyIsHydraulic=per.powerOrEfficiencyIsHydraulic,
        pressure=per.pressure,
        etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate,
        efficiency(V_flow={peak.V_flow}, eta={peak.eta}),
        etaMotMet=per.etaMotMet),
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      addPowerToMedium=false,
      use_riseTime=false));

  final parameter Buildings.Fluid.Movers.BaseClasses.Euler.peak peak =
    Buildings.Fluid.Movers.BaseClasses.Euler.getPeak(
      pressure=per.pressure,
      power=per.power)
    "Peak operating point";

equation
  connect(ramSpe.y, mov2.y) annotation (Line(points={{-59,80},{-52,80},{-52,0},
          {-30,0},{-30,-8}},    color={0,0,127}));
  connect(ramSpe.y, mov3.y) annotation (Line(points={{-59,80},{-52,80},{-52,-50},
          {-30,-50},{-30,-58}}, color={0,0,127}));
  connect(ramSpe.y, mov1.y)
    annotation (Line(points={{-59,80},{-30,80},{-30,52}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/ComparePowerHydraulic.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
The purpose of this validation is two-fold.
</p>
<p>
First, it validates that efficiency computation is implemented correctly
for <code>per.powerOrEfficiencyIsHydraulic=true</code>.
The results should show that
<i>&eta; = &eta;<sub>hyd</sub>&nbsp;&eta;<sub>mot</sub></i>
holds.
</p>
<p>
Second, it compares the power estimation results using different selections
of <code>per.etaHydMet</code>.
</p>
<ul>
<li>
The fan <code>mov1</code> directly uses the power curve of the fan.
</li>
<li>
The fan <code>mov2</code> uses the Euler number method to estimate
the hydraulic efficiency and computer the power consumption.
</li>
<li>
The fan <code>mov3</code> assumes a constant hydraulic efficiency
to compute the power consumption.
</li>
</ul>
<p>
The three methods agree with each other when the three fans operate
at different speeds under constant system condition.
Their power estimates diverge when the damper closes and the system curve is
changed. The Euler number method was able to produce results close
to the power curves and maintained positive power consumption as the flow rate
approached zero. However, the constant efficiency assumption was not able
to capture this characteristic.
</p>
</html>", revisions="<html>
<ul>
<li>
August 20, 2024, by Hongxiang Fu:<br/>
Added standalone declaration for the peak operating condition to ensure that
the same values are used for each mover.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1912\">IBPSA, #1912</a>.
</li>
<li>
May 15, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1880\">IBPSA, #1880</a>.
</li>
</ul>
</html>"));
end ComparePowerHydraulic;
