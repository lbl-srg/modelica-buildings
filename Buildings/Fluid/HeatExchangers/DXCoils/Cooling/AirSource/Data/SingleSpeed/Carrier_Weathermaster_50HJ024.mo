within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record Carrier_Weathermaster_50HJ024 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -73517.9,
    COP_nominal =           3.73,
    SHR_nominal =           0.76,
    m_flow_nominal =        1.2*3.776),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.1345120,-0.0239764,0.0012836,0.0023642,-0.0000802,-0.0001980},
    capFunFF =             {0.7578828,0.3524189,-0.1092772},
    EIRFunT =              {0.3439210,0.0215041,-0.0006539,0.0073217,0.0003160,-0.0002297},
    EIRFunFF =             {1.2167653,-0.3411749,0.1233570},
    TConInMin =            273.15 + 15.56,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 12.22,
    TEvaInMax =            273.15 + 26.67,
    ffMin =                0.75,
    ffMax =                1.25))}) "Carrier Weathermaster 50HJ024" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Weathermaster 50HJ024,              !- Name
    CoolingCoilAvailSched,                      !- Availability Schedule Name
    73517.9,                                    !- Rated Total Cooling Capacity {W}
    0.76,                                       !- Rated Sensible Heat Ratio
    3.73,                                       !- Rated COP
    3.776,                                      !- Rated Air Flow Rate {m3/s}
    ,                                           !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                         !- Air Inlet Node Name
    DXCoilAirOutletNode,                        !- Air Outlet Node Name
    Carrier Weathermaster 50HJ024 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Weathermaster 50HJ024 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ024 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Weathermaster 50HJ024 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ024 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
