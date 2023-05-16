within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record Carrier_Weathermaster_50HJ012 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -36846.82,
    COP_nominal =           3.71,
    SHR_nominal =           0.73,
    m_flow_nominal =        1.2*1.888),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.5878544,0.0247382,0.0001631,-0.0034960,-0.0000889,0.0001450},
    capFunFF =             {0.7232943,0.4292712,-0.1525863},
    EIRFunT =              {0.6445678,-0.0198276,0.0010284,0.0222812,0.0004996,-0.0015296},
    EIRFunFF =             {1.2158796,-0.3411366,0.1251095},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 16.67,
    TEvaInMax =            273.15 + 22.22,
    ffMin =                0.75,
    ffMax =                1.25))}) "Carrier Weathermaster 50HJ012" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Weathermaster 50HJ012,               !- Name
    CoolingCoilAvailSched,                       !- Availability Schedule Name
    36846.82,                                    !- Rated Total Cooling Capacity {W}
    0.73,                                        !- Rated Sensible Heat Ratio
    3.71,                                        !- Rated COP
    1.888,                                       !- Rated Air Flow Rate {m3/s}
    ,                                            !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                          !- Air Inlet Node Name
    DXCoilAirOutletNode,                         !- Air Outlet Node Name
    Carrier Weathermaster 50HJ012 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Weathermaster 50HJ012 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ012 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Weathermaster 50HJ012 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ012 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
