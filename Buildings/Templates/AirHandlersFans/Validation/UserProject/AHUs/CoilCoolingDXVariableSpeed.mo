within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilCoolingDXVariableSpeed
  extends NoFanNoReliefSingleDamper(
    nZon=1,
    nGro=1,
    redeclare Buildings.Templates.Components.Coils.DirectExpansion coiCoo(
        redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.DXVariableSpeed hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXVariableSpeed;
