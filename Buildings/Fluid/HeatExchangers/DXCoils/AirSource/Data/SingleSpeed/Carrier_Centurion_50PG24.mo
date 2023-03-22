within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.SingleSpeed;
record Carrier_Centurion_50PG24 =
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -73810.8,
    COP_nominal =           3.95,
    SHR_nominal =           0.71,
    m_flow_nominal =        1.2*3.776),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.5781158,0.0405917,0.0000113,-0.0095022,0.0000001,-0.0000573},
    capFunFF =             {0.8328798,0.2403628,-0.0725624},
    EIRFunT =              {0.5909553,-0.0496529,0.0016569,0.0397786,0.0003938,-0.0016575},
    EIRFunFF =             {1.0440554,-0.0701720,0.0258826},
    TConInMin =            273.15 + 15.56,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 12.22,
    TEvaInMax =            273.15 + 26.67,
    ffMin =                0.75,
    ffMax =                1.25))}) "Carrier Centurion 50PG24" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Centurion 50PG24,              !- Name
    CoolingCoilAvailSched,                 !- Availability Schedule Name
    73810.8,                               !- Rated Total Cooling Capacity {W}
    0.71,                                  !- Rated Sensible Heat Ratio
    3.95,                                  !- Rated COP
    3.776,                                 !- Rated Air Flow Rate {m3/s}
    ,                                      !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                    !- Air Inlet Node Name
    DXCoilAirOutletNode,                   !- Air Outlet Node Name
    Carrier Centurion 50PG24 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Centurion 50PG24 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Centurion 50PG24 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Centurion 50PG24 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Centurion 50PG24 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
