within Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses;
model Pump_m_flow
  "Pump with prescribed mass flow rate"
  extends Buildings.Fluid.Movers.FlowControlled_m_flow(
    per(pressure(
              V_flow=m_flow_nominal/rho_default*{0, 1, 2},
              dp=if rho_default < 500
                   then dp_nominal*{1.12, 1, 0}
                   else dp_nominal*{1.14, 1, 0.42}),
            powerOrEfficiencyIsHydraulic=true,
            etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
            etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve,
      motorCooledByFluid=false),
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    nominalValuesDefineDefaultPressureCurve=true,
    init=Modelica.Blocks.Types.Init.InitialOutput);
  annotation (
    Icon(
      graphics={
        Ellipse(
          extent={{-58,58},{58,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Polygon(
          points={{-2,52},{-2,-48},{52,2},{-2,52}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}),
    Documentation(
      info="<html>
<p>
This is a steady-state model of a pump with ideally controlled 
mass flow rate as input signal, and no heat added to the medium.
</p>
</html>"));
end Pump_m_flow;
