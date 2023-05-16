within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record Carrier_Centurion_50PG06 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -18276.96,
    COP_nominal =           4.15,
    SHR_nominal =           0.74,
    m_flow_nominal =        1.2*0.944),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.9953455,-0.0118418,0.0012277,0.0030246,-0.0000702,-0.0003685},
    capFunFF =             {0.7705358,0.2848007,-0.0580891},
    EIRFunT =              {0.3802131,0.0199468,-0.0006682,0.0058933,0.0004646,-0.0004072},
    EIRFunFF =             {1.3439758,-0.5111244,0.1732549},
    TConInMin =            273.15 + 15.56,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 12.22,
    TEvaInMax =            273.15 + 26.67,
    ffMin =                0.75,
    ffMax =                1.25))}) "Carrier Centurion 50PG06" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Centurion 50PG06,              !- Name
    CoolingCoilAvailSched,                 !- Availability Schedule Name
    18276.96,                              !- Rated Total Cooling Capacity {W}
    0.74,                                  !- Rated Sensible Heat Ratio
    4.15,                                  !- Rated COP
    0.944,                                 !- Rated Air Flow Rate {m3/s}
    ,                                      !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                    !- Air Inlet Node Name
    DXCoilAirOutletNode,                   !- Air Outlet Node Name
    Carrier Centurion 50PG06 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Centurion 50PG06 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Centurion 50PG06 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Centurion 50PG06 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Centurion 50PG06 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
