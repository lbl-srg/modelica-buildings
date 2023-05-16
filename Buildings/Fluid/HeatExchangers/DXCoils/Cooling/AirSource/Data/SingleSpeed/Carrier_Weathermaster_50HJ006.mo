within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record Carrier_Weathermaster_50HJ006 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -18687,
    COP_nominal =           3.9,
    SHR_nominal =           0.73,
    m_flow_nominal =        1.2*0.944),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.3116765,0.0622847,-0.0008633,-0.0066556,-0.0000462,0.0001349},
    capFunFF =             {0.6583072,0.5294956,-0.1869478},
    EIRFunT =              {1.0505234,-0.0653230,0.0021068,0.0235557,0.0004542,-0.0014092},
    EIRFunFF =             {1.3293472,-0.5218591,0.1918220},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 16.67,
    TEvaInMax =            273.15 + 22.22,
    ffMin =                0.75,
    ffMax =                1.25))}) "Carrier Weathermaster 50HJ006" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Weathermaster 50HJ006,              !- Name
    CoolingCoilAvailSched,                      !- Availability Schedule Name
    18687,                                      !- Rated Total Cooling Capacity {W}
    0.73,                                       !- Rated Sensible Heat Ratio
    3.9,                                        !- Rated COP
    0.944,                                      !- Rated Air Flow Rate {m3/s}
    ,                                           !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                         !- Air Inlet Node Name
    DXCoilAirOutletNode,                        !- Air Outlet Node Name
    Carrier Weathermaster 50HJ006 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Weathermaster 50HJ006 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ006 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Weathermaster 50HJ006 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ006 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
