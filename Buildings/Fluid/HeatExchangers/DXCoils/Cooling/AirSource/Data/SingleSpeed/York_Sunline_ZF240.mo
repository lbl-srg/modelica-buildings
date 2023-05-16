within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record York_Sunline_ZF240 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -81807,
    COP_nominal =           3.59,
    SHR_nominal =           0.70,
    m_flow_nominal =        1.2*3.776),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.0477109,-0.0126686,0.0012838,0.0012381,-0.0000551,-0.0003875},
    capFunFF =             {0.6042146,0.6557209,-0.2667894},
    EIRFunT =              {0.4544209,0.0213827,-0.0007051,0.0028662,0.0004214,-0.0003177},
    EIRFunFF =             {1.4410769,-0.7566253,0.3239453},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 25,
    ffMin =                0.625,
    ffMax =                1.25))}) "York Sunline ZF240" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Sunline ZF240,               !- Name
    CoolingCoilAvailSched,            !- Availability Schedule Name
    81807,                            !- Rated Total Cooling Capacity {W}
    0.70,                             !- Rated Sensible Heat Ratio
    3.59,                             !- Rated COP
    3.776,                            !- Rated Air Flow Rate {m3/s}
    ,                                 !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,               !- Air Inlet Node Name
    DXCoilAirOutletNode,              !- Air Outlet Node Name
    York Sunline ZF240 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Sunline ZF240 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Sunline ZF240 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Sunline ZF240 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Sunline ZF240 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
