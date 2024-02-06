within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.DoubleSpeed;
record Lennox_TCA240S =
  Buildings.Fluid.DXSystems.Cooling.AirSource.Data.DoubleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200,
   nomVal = Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -49207.2,
    COP_nominal =           3.47,
    SHR_nominal =           0.71,
    m_flow_nominal =        1.2*3.776),
    perCur=
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.9914722,-0.0108810,0.0010999,-0.0007210,-0.0000305,-0.0001953},
    capFunFF =             {0.7797619,0.3244048,-0.1041667},
    EIRFunT =              {0.5325300,0.0033859,-0.0001823,0.0107895,0.0003050,-0.0004131},
    EIRFunFF =             {1.1888341,-0.2942931,0.1054590},
    TConInMin =            273.15 + 18.33,
    TConInMax =            273.15 + 35,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2)),
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200*71174.7/49207.2,
   nomVal = Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -71174.7,
    COP_nominal =           3.45,
    SHR_nominal =           0.77,
    m_flow_nominal =        1.2*3.776),
    perCur=
       Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.0116786,-0.0156968,0.0012604,0.0009509,-0.0000422,-0.0002417},
    capFunFF =             {0.7860082,0.3117284,-0.0977366},
    EIRFunT =              {0.6088217,0.0104053,-0.0002803,0.0009889,0.0004927,-0.0005063},
    EIRFunFF =             {1.1739773,-0.2636802,0.0897028},
    TConInMin =            273.15 + 29.44,
    TConInMax =            273.15 + 46.11,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2))})
"Lennox TCA240S" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Performance data for double speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox TCA240S,               !- Name
    CoolingCoilAvailSched,        !- Availability Schedule Name
    DXCoilAirInletNode,           !- Air Inlet Node Name
    DXCoilAirOutletNode,          !- Air Outlet Node Name
    ,                             !- Crankcase Heater Capacity {W}
    ,                             !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                            !- Number of Capacity Stages
    0,                            !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,   !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox TCA240S Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,   !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox TCA240S Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));
