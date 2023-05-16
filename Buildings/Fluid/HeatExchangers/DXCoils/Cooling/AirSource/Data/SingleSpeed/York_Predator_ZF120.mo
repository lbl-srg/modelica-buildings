within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record York_Predator_ZF120 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -36905.4,
    COP_nominal =           4.06,
    SHR_nominal =           0.734,
    m_flow_nominal =        1.2*1.888),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.2083456,-0.0287633,0.0022322,0.0019731,-0.0000541,-0.0007392},
    capFunFF =             {0.6735828,0.4697959,-0.1469388},
    EIRFunT =              {0.4822073,0.0401530,-0.0015820,-0.0116025,0.0006758,-0.0001198},
    EIRFunFF =             {1.3074459,-0.4421330,0.1377204},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 25,
    ffMin =                0.625,
    ffMax =                1.25))}) "York Predator ZF120" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Predator ZF120,               !- Name
    CoolingCoilAvailSched,             !- Availability Schedule Name
    36905.4,                           !- Rated Total Cooling Capacity {W}
    0.734,                             !- Rated Sensible Heat Ratio
    4.06,                              !- Rated COP
    1.888,                             !- Rated Air Flow Rate {m3/s}
    ,                                  !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                !- Air Inlet Node Name
    DXCoilAirOutletNode,               !- Air Outlet Node Name
    York Predator ZF120 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Predator ZF120 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Predator ZF120 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Predator ZF120 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Predator ZF120 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));
