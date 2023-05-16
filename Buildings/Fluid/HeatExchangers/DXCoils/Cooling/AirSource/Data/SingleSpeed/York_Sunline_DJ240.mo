within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record York_Sunline_DJ240 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -73518,
    COP_nominal =           4.096,
    SHR_nominal =           0.75,
    m_flow_nominal =        1.2*3.776),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.3804089,-0.0801861,0.0033588,0.0118882,-0.0001339,-0.0005357},
    capFunFF =             {0.7894654,0.1996615,0.0111454},
    EIRFunT =              {-0.1635113,0.1222397,-0.0037107,-0.0070372,0.0005052,-0.0002069},
    EIRFunFF =             {1.5272381,-0.9652850,0.4418485},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 22.22,
    ffMin =                0.75,
    ffMax =                1.175))}) "York Sunline DJ240" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Sunline DJ240,               !- Name
    CoolingCoilAvailSched,            !- Availability Schedule Name
    73518,                            !- Rated Total Cooling Capacity {W}
    0.75,                             !- Rated Sensible Heat Ratio
    4.096,                            !- Rated COP
    3.776,                            !- Rated Air Flow Rate {m3/s}
    ,                                 !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,               !- Air Inlet Node Name
    DXCoilAirOutletNode,              !- Air Outlet Node Name
    York Sunline DJ240 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Sunline DJ240 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Sunline DJ240 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Sunline DJ240 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Sunline DJ240 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
