within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed;
record Lennox_TCA060S2 =
  Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -18452.7,
    COP_nominal =           4.07,
    SHR_nominal =           0.75,
    m_flow_nominal =        1.2*0.944),
    perCur=
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.9274018,-0.0049893,0.0010446,0.0003500,-0.0000300,-0.0002957},
    capFunFF =             {0.7539683,0.3650794,-0.1190476},
    EIRFunT =              {0.5480534,0.0256216,-0.0006559,-0.0031147,0.0006074,-0.0006367},
    EIRFunFF =             {1.0120192,-0.0420673,0.0300481},
    TConInMin =            273.15 + 29.44,
    TConInMax =            273.15 + 46.11,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2))}) "Lennox TCA060S2" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Lennox TCA060S2,               !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    18452.7,                       !- Rated Total Cooling Capacity {W}
    0.75,                          !- Rated Sensible Heat Ratio
    4.07,                          !- Rated COP
    0.944,                         !- Rated Air Flow Rate {m3/s}
    ,                              !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    Lennox TCA060S2 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    Lennox TCA060S2 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Lennox TCA060S2 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    Lennox TCA060S2 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    Lennox TCA060S2 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
