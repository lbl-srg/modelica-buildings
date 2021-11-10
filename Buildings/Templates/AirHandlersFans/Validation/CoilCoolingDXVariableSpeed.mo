within Buildings.Templates.AirHandlersFans.Validation;
model CoilCoolingDXVariableSpeed
  extends NoEconomizer(   redeclare
    UserProject.AHUs.CoilCoolingDXVariableSpeed ahu(
      coiCoo(redeclare replaceable
          Buildings.Templates.Components.HeatExchangers.DXVariableSpeed hex(
            redeclare
            Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.SingleSpeed.Carrier_Centurion_50PG06
            datCoi))));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilCoolingDXVariableSpeed;
