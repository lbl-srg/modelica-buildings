within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.DoubleSpeed;
record Lennox_KCA240S4 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.DoubleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -46951.87,
    COP_nominal =           3.74,
    SHR_nominal =           0.75,
    m_flow_nominal =        1.2*3.776),
    perCur=
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.6774110,0.0279341,0.0001421,-0.0020862,-0.0000337,-0.0002350},
    capFunFF =             {0.6631316,0.4928260,-0.1559576},
    EIRFunT =              {0.7433676,-0.0189703,0.0003270,0.0118669,0.0003111,-0.0004329},
    EIRFunFF =             {1.3251503,-0.4910623,0.1659119},
    TConInMin =            273.15 + 18.33,
    TConInMax =            273.15 + 35,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2)),
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200*69944.52/46951.87,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -69944.52,
    COP_nominal =           3.83,
    SHR_nominal =           0.78,
    m_flow_nominal =        1.2*3.776),
    perCur=
       Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.8015587,0.0136475,0.0005406,-0.0001875,-0.0000475,-0.0003036},
    capFunFF =             {0.6880235,0.4533082,-0.1413317},
    EIRFunT =              {0.6483859,0.0034675,-0.0000671,0.0026918,0.0005166,-0.0006149},
    EIRFunFF =             {1.2930771,-0.4396936,0.1466166},
    TConInMin =            273.15 + 29.44,
    TConInMax =            273.15 + 46.11,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2))})
"Lennox KCA240S4" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Performance data for double speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox KCA240S4,               !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    ,                              !- Crankcase Heater Capacity {W}
    ,                              !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                             !- Number of Capacity Stages
    0,                             !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox KCA240S4 Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox KCA240S4 Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));
