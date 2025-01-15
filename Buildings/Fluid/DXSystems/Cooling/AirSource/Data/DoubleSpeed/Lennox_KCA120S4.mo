within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.DoubleSpeed;
record Lennox_KCA120S4 =
  Buildings.Fluid.DXSystems.Cooling.AirSource.Data.DoubleSpeed.Generic
    ( sta={
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1200,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-17193.23,
          COP_nominal=3.54,
          SHR_nominal=0.69,
          m_flow_nominal=1.2*1.888),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.6383427,0.0368605,-0.0002156,-0.0032619,-0.0000414,-0.0001587},
          capFunFF={0.6422487,0.5494037,-0.1916525},
          EIRFunT={0.6609961,-0.0173045,0.0003871,0.0121825,0.0003430,-0.0004676},
          EIRFunFF={1.3016695,-0.4659596,0.1642901},
          TConInMin=273.15 + 18.33,
          TConInMax=273.15 + 35,
          TEvaInMin=273.15 + 17.22,
          TEvaInMax=273.15 + 21.67,
          ffMin=0.8,
          ffMax=1.2)),
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1200*35235.87/17193.23,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-35235.87,
          COP_nominal=3.88,
          SHR_nominal=0.72,
          m_flow_nominal=1.2*1.888),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.6803326,0.0268925,0.0001473,0.0003186,-0.0000584,-0.0002929},
          capFunFF={0.6716542,0.4945968,-0.1662510},
          EIRFunT={0.7758738,-0.0051500,0.0002254,-0.0042810,0.0006657,-0.0006284},
          EIRFunFF={1.2812519,-0.4288495,0.1475977},
          TConInMin=273.15 + 29.44,
          TConInMax=273.15 + 46.11,
          TEvaInMin=273.15 + 17.22,
          TEvaInMax=273.15 + 21.67,
          ffMin=0.8,
          ffMax=1.2))})
"Lennox KCA120S4" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Performance data for double speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox KCA120S4,               !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    ,                              !- Crankcase Heater Capacity {W}
    ,                              !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                             !- Number of Capacity Stages
    0,                             !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox KCA120S4 Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox KCA120S4 Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));
