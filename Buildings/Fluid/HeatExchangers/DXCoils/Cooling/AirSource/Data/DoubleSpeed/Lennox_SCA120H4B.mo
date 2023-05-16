within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.DoubleSpeed;
record Lennox_SCA120H4B =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.DoubleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -18218.38,
    COP_nominal =           4.09,
    SHR_nominal =           0.67,
    m_flow_nominal =        1.2*1.888),
    perCur=
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.8197084,0.0064733,0.0008546,0.0002134,-0.0000477,-0.0003191},
    capFunFF =             {0.7266881,0.3938907,-0.1205788},
    EIRFunT =              {0.6505692,-0.0124024,0.0001183,0.0144585,0.0003194,-0.0005187},
    EIRFunFF =             {1.2512370,-0.3652365,0.1139994},
    TConInMin =            273.15 + 18.33,
    TConInMax =            273.15 + 35,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2)),
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200*36436.76/18218.38,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -36436.76,
    COP_nominal =           4.35,
    SHR_nominal =           0.73,
    m_flow_nominal =        1.2*1.888),
    perCur=
       Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.9438524,-0.0094097,0.0013226,0.0038157,-0.0000608,-0.0004721},
    capFunFF =             {0.7266881,0.4139871,-0.1406752},
    EIRFunT =              {0.5476528,0.0268762,-0.0007716,-0.0070535,0.0006878,-0.0005488},
    EIRFunFF =             {1.2731734,-0.4301446,0.1569712},
    TConInMin =            273.15 + 29.44,
    TConInMax =            273.15 + 46.11,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2))})
"Lennox SCA120H4B" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Performance data for double speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox SCA120H4B,               !- Name
    CoolingCoilAvailSched,          !- Availability Schedule Name
    DXCoilAirInletNode,             !- Air Inlet Node Name
    DXCoilAirOutletNode,            !- Air Outlet Node Name
    ,                               !- Crankcase Heater Capacity {W}
    ,                               !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                              !- Number of Capacity Stages
    0,                              !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,     !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox SCA120H4B Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,     !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox SCA120H4B Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));
