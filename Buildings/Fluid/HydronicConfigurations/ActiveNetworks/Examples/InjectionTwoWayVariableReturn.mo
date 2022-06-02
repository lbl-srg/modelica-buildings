within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayVariableReturn
  "Model illustrating the operation of an inversion circuit with two-way valve and variable secondary with return temperature control"
  extends
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionTwoWayVariable(
      TAirEnt_nominal=299.15,
      TLiqEnt_nominal=280.15,
      TLiqLvg_nominal=285.15,
      TLiqSup_nominal=278.15,
      con(
      typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Cooling,
      typCtl=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.ReturnTemperature),
      set(k=TLiqLvg_nominal));

   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayVariableReturn.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of an injection circuit with a two-way valve
that serves as the interface between a variable flow primary circuit at constant
supply temperature and a constant flow secondary circuit at variable supply
temperature.
Two identical terminal units circuits are served by the secondary circuit.
Each terminal unit has its own hourly load profile.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The design conditions are defined without
considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions.
</li>
</ul>

</html>"),
    Diagram(coordinateSystem(extent={{-160,-160},{160,160}})));
end InjectionTwoWayVariableReturn;
