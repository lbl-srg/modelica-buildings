within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record Carrier_Centurion_50PG12 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -36788.24,
    COP_nominal =           4.05,
    SHR_nominal =           0.76,
    m_flow_nominal =        1.2*1.888),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.0013476,-0.0187754,0.0015312,0.0054931,-0.0000901,-0.0004408},
    capFunFF =             {0.6460191,0.5455414,-0.1910828},
    EIRFunT =              {0.3037085,0.0310288,-0.0009543,0.0053687,0.0004729,-0.0004469},
    EIRFunFF =             {1.3637624,-0.5775338,0.2130374},
    TConInMin =            273.15 + 15.56,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 12.22,
    TEvaInMax =            273.15 + 26.67,
    ffMin =                0.75,
    ffMax =                1.25))}) "Carrier Centurion 50PG12" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Centurion 50PG12,               !- Name
    CoolingCoilAvailSched,                  !- Availability Schedule Name
    36788.24,                               !- Rated Total Cooling Capacity {W}
    0.76,                                   !- Rated Sensible Heat Ratio
    4.05,                                   !- Rated COP
    1.888,                                  !- Rated Air Flow Rate {m3/s}
    ,                                       !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                     !- Air Inlet Node Name
    DXCoilAirOutletNode,                    !- Air Outlet Node Name
    Carrier Centurion 50PG12 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Centurion 50PG12 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Centurion 50PG12 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Centurion 50PG12 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Centurion 50PG12 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
