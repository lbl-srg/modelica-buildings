within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingDXVariableSpeed
  extends VAVSingleDuct(final id="VAV_1", redeclare
      BaseClasses.Coils.DirectExpansion coiCoo(redeclare replaceable
        Buildings.Templates.AHUs.BaseClasses.Coils.HeatExchangers.DXVariableSpeed
        hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXVariableSpeed;
