within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.DoubleSpeed;
record Lennox_TCA120S =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.DoubleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -18276.96,
    COP_nominal =           3.54,
    SHR_nominal =           0.71,
    m_flow_nominal =        1.2*1.888),
    perCur=
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.9945773,-0.0149279,0.0011358,0.0023510,-0.0001038,-0.0001298},
    capFunFF =             {0.7756410,0.3245192,-0.1001603},
    EIRFunT =              {0.6121724,0.0075378,-0.0002892,0.0056946,0.0003564,-0.0004210},
    EIRFunFF =             {1.1786830,-0.2662820,0.0875989},
    TConInMin =            273.15 + 18.33,
    TConInMax =            273.15 + 35,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2)),
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200*37139.72/18276.96,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -37139.72,
    COP_nominal =           3.68,
    SHR_nominal =           0.72,
    m_flow_nominal =        1.2*1.888),
    perCur=
       Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.0746975,-0.0187470,0.0013175,-0.0005737,-0.0000298,-0.0002236},
    capFunFF =             {0.7752366,0.3233438,-0.0985804},
    EIRFunT =              {0.4749267,0.0251138,-0.0006690,0.0021468,0.0004483,-0.0004911},
    EIRFunFF =             {1.2030577,-0.3137318,0.1106741},
    TConInMin =            273.15 + 29.44,
    TConInMax =            273.15 + 46.11,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2))})
"Lennox TCA120S" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Performance data for double speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox TCA120S,                !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    ,                              !- Crankcase Heater Capacity {W}
    ,                              !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                             !- Number of Capacity Stages
    0,                             !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox TCA120S Stage 1,        !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox TCA120S Stage 1&amp;2;      !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));
