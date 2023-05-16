within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record Lennox_SCA060H4B =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -18452.7,
    COP_nominal =           4.48,
    SHR_nominal =           0.73,
    m_flow_nominal =        1.2*0.944),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.0671319,-0.0218036,0.0016875,0.0054500,-0.0000643,-0.0005786},
    capFunFF =             {0.8174603,0.2420635,-0.0595238},
    EIRFunT =              {0.4618717,0.0448432,-0.0012979,-0.0158459,0.0007680,-0.0003382},
    EIRFunFF =             {0.9342105,0.0986842,-0.0328947},
    TConInMin =            273.15 + 29.44,
    TConInMax =            273.15 + 46.11,
    TEvaInMin =            273.15 + 17.22,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.8,
    ffMax =                1.2))}) "Lennox SCA060H4B" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Lennox SCA060H4B,              !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    18452.7,                       !- Rated Total Cooling Capacity {W}
    0.73,                          !- Rated Sensible Heat Ratio
    4.48,                          !- Rated COP
    0.944,                         !- Rated Air Flow Rate {m3/s}
    ,                              !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    Lennox SCA060H4B CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Lennox SCA060H4B CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Lennox SCA060H4B EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Lennox SCA060H4B EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Lennox SCA060H4B PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
