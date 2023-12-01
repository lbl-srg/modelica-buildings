within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.DoubleSpeed;
record Lennox_SCA240H4B =
  Buildings.Fluid.DXSystems.Cooling.AirSource.Data.DoubleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200,
   nomVal = Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -35411.61,
    COP_nominal =           3.76,
    SHR_nominal =           0.71,
    m_flow_nominal =        1.2*3.776),
    perCur=
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.0046573,-0.0098458,0.0011934,-0.0002426,-0.0000424,-0.0002981},
    capFunFF =             {0.8014888,0.2708850,-0.0723739},
    EIRFunT =              {0.5020269,0.0044036,-0.0003075,0.0120302,0.0003200,-0.0004203},
    EIRFunFF =             {1.1811735,-0.2541256,0.0729521},
    TConInMin =            273.15 + 18.33,
    TConInMax =            273.15 + 35,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2)),
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe = 1200*72873.52/35411.61,
   nomVal = Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -72873.52,
    COP_nominal =           4.26,
    SHR_nominal =           0.77,
    m_flow_nominal =        1.2*3.776),
    perCur=
       Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.9947501,-0.0138816,0.0013836,0.0028728,-0.0000586,-0.0004070},
    capFunFF =             {0.7729100,0.3275723,-0.1004823},
    EIRFunT =              {0.4914020,0.0298133,-0.0007899,-0.0052059,0.0006735,-0.0006127},
    EIRFunFF =             {1.1954441,-0.2809494,0.0855053},
    TConInMin =            273.15 + 29.44,
    TConInMax =            273.15 + 46.11,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2))})
"Lennox SCA240H4B" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Performance data for double speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox SCA240H4B,               !- Name
    CoolingCoilAvailSched,          !- Availability Schedule Name
    DXCoilAirInletNode,             !- Air Inlet Node Name
    DXCoilAirOutletNode,            !- Air Outlet Node Name
    ,                               !- Crankcase Heater Capacity {W}
    ,                               !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                              !- Number of Capacity Stages
    0,                              !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,     !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox SCA240H4B Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,     !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox SCA240H4B Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));
