within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record York_Sunline_DR060 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -17398.26,
    COP_nominal =           4.05,
    SHR_nominal =           0.69,
    m_flow_nominal =        1.2*0.944),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.4767927,-0.0614116,0.0027182,-0.0010838,-0.0000353,-0.0003531},
    capFunFF =             {0.9156325,0.0076960,0.0769601},
    EIRFunT =              {-0.2918107,0.0950527,-0.0026508,0.0070978,0.0005090,-0.0006143},
    EIRFunFF =             {0.9336732,0.2228647,-0.1628839},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 22.22,
    ffMin =                0.75,
    ffMax =                1.25))}) "York Sunline DR060" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Sunline DR060,               !- Name
    CoolingCoilAvailSched,            !- Availability Schedule Name
    17398.26,                         !- Rated Total Cooling Capacity {W}
    0.69,                             !- Rated Sensible Heat Ratio
    4.05,                             !- Rated COP
    0.944,                            !- Rated Air Flow Rate {m3/s}
    ,                                 !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,               !- Air Inlet Node Name
    DXCoilAirOutletNode,              !- Air Outlet Node Name
    York Sunline DR060 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Sunline DR060 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Sunline DR060 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Sunline DR060 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Sunline DR060 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
