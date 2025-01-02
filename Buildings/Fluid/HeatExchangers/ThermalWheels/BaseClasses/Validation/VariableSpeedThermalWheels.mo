within Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Validation;
model VariableSpeedThermalWheels
  "Model that tests the variable-speed thermal wheels"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.ASHRAE
    perSenWhe(
    motorEfficiency(uSpe={0.1,0.6,0.8,1}, eta={0.3,0.8,0.85,1}),
    haveLatentHeatExchange=false,
    useDefaultMotorEfficiencyCurve=false)
    "Performance record for the sensible heat wheel"
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.ASHRAE perLatWhe(
    motorEfficiency(uSpe={0.1,0.6,0.8,1}, eta={0.3,0.8,0.85,1}),
    haveLatentHeatExchange=true,
    useDefaultMotorEfficiencyCurve=false)
    "Performance record for the enthalpy wheel"
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.ASHRAE perLatWheDefMotCur(
    haveLatentHeatExchange=true,
    useDefaultMotorEfficiencyCurve=true)
    "Performance record for the enthalpy wheel with default motor dataset"
    annotation (Placement(transformation(extent={{0,74},{20,94}})));    
  Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Sensible
    senWhe(per=perSenWhe)
    "Sensible heat wheel"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));

  Modelica.Blocks.Sources.Ramp uSpe(
    duration=1,
    startTime=0,
    offset=0,
    height=1)
    "Speed ratio"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Latent latWhe(
    per=perLatWhe)
    "Enthalpy wheel"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Latent latWheDefMotCur(
    per=perLatWheDefMotCur)
    "Enthalpy wheel with default motor curve"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

equation
  connect(uSpe.y, senWhe.uSpe)
    annotation (Line(points={{-39,0},{-28,0},{-28,50},
          {-12,50}}, color={0,0,127}));
  connect(latWhe.uSpe, uSpe.y)
    annotation (Line(points={{-12,0},{-39,0}}, color={0,0,127}));
  connect(latWheDefMotCur.uSpe, uSpe.y)
    annotation (Line(points={{-12,-50},{-28,
          -50},{-28,0},{-39,0}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ThermalWheels/BaseClasses/Validation/VariableSpeedThermalWheels.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example for the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Sensible\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Sensible</a> and the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.Latent\">
Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses.latent</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The wheel speed <code>uSpe</code> changes from <i>0</i> to <i>1</i> 
during the period from 0 to 1 second.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
The power consumption of all three wheels increases over time
and equals the nominal value when <code>uSpe=1</code>.
</li>
<li>
The heat exchange effectiveness corrections increase by time
and equal 1 when <code>uSpe=1</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 28, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end VariableSpeedThermalWheels;
