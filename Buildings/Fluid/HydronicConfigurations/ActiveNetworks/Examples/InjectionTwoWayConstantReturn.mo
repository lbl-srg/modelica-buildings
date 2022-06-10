within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayConstantReturn
  extends InjectionTwoWayConstant(
    loa(final mAir_flow_nominal=mAir_flow_nominal),
    loa1(final mAir_flow_nominal=mAir_flow_nominal),
    typ=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Cooling,
    mTer_flow_nominal=2.46,
    TAirEnt_nominal=298.75,
    phiAirEnt_nominal=0.5,
    TLiqEnt_nominal=277.55,
    TLiqLvg_nominal=286.65,
    TLiqSup_nominal=276.15,
    con(typCtl=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.ReturnTemperature));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=6.8
    "Air mass flow rate at design conditions"
    annotation (Dialog(group="Nominal condition"));

  annotation (
    experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayConstantReturn.mos"
    "Simulate and plot"));
end InjectionTwoWayConstantReturn;
