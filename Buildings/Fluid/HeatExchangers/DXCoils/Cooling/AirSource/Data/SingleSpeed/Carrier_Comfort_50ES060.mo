within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record Carrier_Comfort_50ES060 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -17500.95,
    COP_nominal =           3.9,
    SHR_nominal =           0.78,
    m_flow_nominal =        1.2*0.944),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.6380187,-0.0747347,0.0029747,0.0015201,-0.0000519,-0.0004509},
    capFunFF =             {0.8185792,0.2831771,-0.1017563},
    EIRFunT =              {-0.2209648,0.1033303,-0.0030061,-0.0070657,0.0006322,-0.0002496},
    EIRFunFF =             {1.0380778,-0.2013868,0.1633090},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 22.22,
    ffMin =                0.875,
    ffMax =                1.125))}) "Carrier Comfort 50ES060" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Comfort 50ES060,              !- Name
    CoolingCoilAvailSched,                !- Availability Schedule Name
    17500.95,                             !- Rated Total Cooling Capacity {W}
    0.78,                                 !- Rated Sensible Heat Ratio
    3.9,                                  !- Rated COP
    0.944,                                !- Rated Air Flow Rate {m3/s}
    ,                                     !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                   !- Air Inlet Node Name
    DXCoilAirOutletNode,                  !- Air Outlet Node Name
    Carrier Comfort 50ES060 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Comfort 50ES060 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Comfort 50ES060 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Comfort 50ES060 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Comfort 50ES060 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
